local CircuitComponentType = require "circuit.components.CircuitComponentType"
local ControlDimensionsUtils = require "utils.ControlDimensionsUtils"
local class = require "core.class"

---@class MiliastraFrontend
---@field new fun(uiRoot): MiliastraFrontend
local MiliastraFrontend = class()

function MiliastraFrontend:init(uiRoot)
    self.uiRootId = uiRoot.id
    self.hoveringPort = nil
    self.textRegistry = {}
end

function MiliastraFrontend:getPortPosition(control)
    local x, y = control:GetChild("ImageControl"):GetAnchoredPosition()
    local ax, ay = control:GetAnchoredPosition()
    local bx, by = control.parent:GetAnchoredPosition()
    local cx, cy = control.parent.parent:GetAnchoredPosition()
    return x + ax + bx + cx, y + ay + by + cy
end

-- Set text

function MiliastraFrontend:setText(textKey, text)
    if not self.textRegistry[textKey] then
        self.textRegistry[textKey] = {
            text = text,
            observers = {}
        }
    else
        self.textRegistry[textKey].text = text
        for index, reference in ipairs(self.textRegistry[textKey].observers) do
            reference.text = self.textRegistry[textKey].text
        end
    end
end

---@param textKey string
---@param reference ClientUITextBoxControl | ClientUITextWindowControl
function MiliastraFrontend:registerTextListener(textKey, reference)
    if not self.textRegistry[textKey] then
        self.textRegistry[textKey] = {
            reference.text,
            observers = {
                reference
            }
        }
    else
        table.insert(self.textRegistry[textKey].observers, reference)
        reference.text = self.textRegistry[textKey].text
    end
end

-- Object Creation
---@param component CircuitComponent
---@param x number
---@param y number
---@return ClientUIContainerControl?
function MiliastraFrontend:createComponentVisual(component, x, y)
    -- TODO:
    -- Create the MiliLua UI object representing this component.
    local uiRoot = game.GetClientUIControl(self.uiRootId)
    assert(uiRoot ~= nil)
    local mask = uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    if not mask then
        return
    end
    local reference = game.InstantiateClientUIControl(1073742269, mask)
    ---@cast reference ClientUIContainerControl
    reference:GetChild("TextBoxControl").text = component:getType()

    -- Set object x, y
    reference:SetAnchoredPosition(x, y)

    -- Return the created MiliLua object.
    return reference
end

---@param wire Wire
function MiliastraFrontend:createWireVisual(sourcePortRef, destPortRef, wire)
    local uiRoot = game.GetClientUIControl(self.uiRootId)
    assert(uiRoot ~= nil)
    local mask = uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    if not mask then
        return
    end

    local reference = game.InstantiateClientUIControl(1073742639, mask)
    return self:updateWireVisual(sourcePortRef, destPortRef, wire, reference)
end

---@param sourcePortRef ClientControlType
---@param destPortRef ClientControlType
---@param wire Wire
---@param visual ClientControlType
---@return ClientControlType?
function MiliastraFrontend:updateWireVisual(sourcePortRef, destPortRef, wire, visual)
    local uiRoot = game.GetClientUIControl(self.uiRootId)
    assert(uiRoot ~= nil)
    local mask = uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    if not mask then
        return
    end
    -- calculates in mask anchor coordinates to prevent headaches
    local sourceX, sourceY = self:getPortPosition(sourcePortRef)
    local destX, destY = self:getPortPosition(destPortRef)
    local deltaX = destX - sourceX
    local deltaY = destY - sourceY

    visual.sizeDeltaX = math.abs(deltaX)
    visual.sizeDeltaY = math.abs(deltaY)

    local wireX = (sourceX + destX) / 2
    local wireY = (sourceY + destY) / 2
    local types = {
        "WireUpForwards",
        "WireUpBackwards",
        "WireDownForwards",
        "WireDownBackwards",
    }
    local selectedType
    if deltaY >= 0 then
        if deltaX >= 0 then
            selectedType = "WireUpForwards"
        else
            selectedType = "WireUpBackwards"
        end
    elseif deltaX >= 0 then
        selectedType = "WireDownForwards"
    else
        selectedType = "WireDownBackwards"
    end
    for _, type in ipairs(types) do
        visual:GetChild(type):SetVisible(type == selectedType)
    end

    -- Set object x, y
    visual:SetAnchoredPosition(wireX, wireY)

    return visual
end

-- Port references
---@param componentReference ClientUIContainerControl
---@param index number
function MiliastraFrontend:getInputPortReference(
    componentReference,
    index
)
    local grid = componentReference:GetChild("InputPins")
    if grid == nil then
        printerr("Cant find anything")
        return nil
    end
    for i, value in ipairs(grid:GetChildren()) do
        if grid:GetItemIndex(value) == index - 1 then
            return value
        end
    end
    printerr("Cant find anything")
    return nil
end

function MiliastraFrontend:getOutputPortReference(
    componentReference,
    index
)
    local grid = componentReference:GetChild("OutputPins")
    if grid == nil then
        printerr("Cant find anything")
        return nil
    end
    for i, value in ipairs(grid:GetChildren()) do
        if grid:GetItemIndex(value) == index - 1 then
            return value
        end
    end
    printerr("Cant find anything")
    return nil
end

-- Object manipulation
---@param object ClientControlType
---@param x number
---@param y number
function MiliastraFrontend:setPosition(
    object,
    x,
    y
)
    local h0 = ControlDimensionsUtils.getUnscaledMinHeight(object.parent)
    local h1 = ControlDimensionsUtils.getUnscaledMaxHeight(object.parent)
    local w0 = ControlDimensionsUtils.getUnscaledMinWidth(object.parent)
    local w1 = ControlDimensionsUtils.getUnscaledMaxWidth(object.parent)
    local anchorHeight = (h1 + h0) / 2
    local anchorWidth = (w1 + w0) / 2
    object:SetAnchoredPosition(x - anchorWidth, y - anchorHeight)
end

-- Object manipulation
---@param object ClientControlType
---@param dx number
---@param dy number
function MiliastraFrontend:updatePosition(
    object,
    dx,
    dy
)
    local x, y = object:GetAnchoredPosition()
    object:SetAnchoredPosition(x + dx, y + dy)
end

---@param object ClientControlType
---@param dragging boolean
function MiliastraFrontend:setDragging(
    object,
    dragging
)
    if dragging then
        object:SetAsLastSibling()
    else
        -- nothing
    end
end

---@param object ClientControlType
---@param cursorX number
---@param cursorY number
---@return number landingX
---@return number landingY
function MiliastraFrontend:getDropPosition(
    object,
    cursorX,
    cursorY
)
    return cursorX, cursorY - 15
end

function MiliastraFrontend:setWireEndPosition(
    portReference,
    wireReference,
    x,
    y
)
    local sourceCtrl = portReference
    local visual = wireReference
    local uiRoot = game.GetClientUIControl(self.uiRootId)
    assert(uiRoot ~= nil)
    local mask = uiRoot:FindChild("CircuitPage/CircuitArea/Mask")

    local sourceX = (ControlDimensionsUtils.getUnscaledMaxWidth(sourceCtrl) + ControlDimensionsUtils.getUnscaledMinWidth(sourceCtrl))/2
    local sourceY = (ControlDimensionsUtils.getUnscaledMaxHeight(sourceCtrl) + ControlDimensionsUtils.getUnscaledMinHeight(sourceCtrl))/2
    
    local deltaX = x - sourceX
    local deltaY = y - sourceY
    local wireX = (sourceX + x) / 2
    local wireY = (sourceY + y) / 2
    local wireSizeDelta = math.sqrt(deltaX * deltaX + deltaY * deltaY)
    local wireRotation = math.deg(math.atan(deltaY, deltaX))

    visual.sizeDeltaX = wireSizeDelta

    -- Set object x, y
    local maskMidX = (ControlDimensionsUtils.getUnscaledMaxWidth(mask) + ControlDimensionsUtils.getUnscaledMinWidth(mask))/2
    local maskMidY = (ControlDimensionsUtils.getUnscaledMaxHeight(mask) + ControlDimensionsUtils.getUnscaledMinHeight(mask))/2
    visual:SetAnchoredPosition(wireX - maskMidX, wireY - maskMidY)
    visual:SetLocalRotation(0, 0, wireRotation)

    return visual
end

function MiliastraFrontend:destroyObject(object)
    game.DestroyClientUIControl(object)
end

-- Port hit testing

function MiliastraFrontend:getHoveredPort(
    x,
    y
)
    return self.hoveringPort
end

-- Palette Entry

function MiliastraFrontend:createPalette(entries, callback)
    local uiRoot = game.GetClientUIControl(self.uiRootId)
    assert(uiRoot ~= nil)
    local grid = uiRoot:FindChild("CircuitPage/PaletteArea/GridScrollerControl")
    if not grid then
        return
    end

    local ComponentTypeToInOutCount = require "circuit.components.CircuitComponentInOutCount"

    ---@cast grid ClientUIGridScrollerControl
    grid:RefreshItems(#entries, function(control, index)
        local container = control:GetChild("ContainerControl")
        if not container then
            return
        end
        local reference = game.InstantiateClientUIControl(1073742269, container)
        reference:GetChild("TextBoxControl").text = entries[index + 1]
        local inputs = ComponentTypeToInOutCount[entries[index + 1]][1]
        for i = 1, 3 do
            reference:GetChild("InputPins"):GetChild("Pin" .. i):SetVisible(i <= inputs)
        end
        local outputs = ComponentTypeToInOutCount[entries[index + 1]][2]
        for i = 1, 3 do
            reference:GetChild("OutputPins"):GetChild("Pin" .. i):SetVisible(i <= outputs)
        end

        control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
            callback(index+1)
        end)
    end)

    local retval = {}
    for index, value in ipairs(grid:GetChildren()) do
        retval[grid:GetItemIndex(value) + 1] = value
    end

    return retval
end

function MiliastraFrontend:cleanupCircuitPage()
    -- nuke it
    local uiRoot = game.GetClientUIControl(self.uiRootId)
    assert(uiRoot ~= nil)
    uiRoot:FindChild("CircuitPage/PaletteArea/GridScrollerControl"):RefreshItems(0, function(control, index)
        -- nothing
    end)
    local mask = uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    assert(mask ~= nil)
    for index, value in ipairs(mask:GetChildren()) do
        game.DestroyClientUIControl(value)
    end
end

return MiliastraFrontend
