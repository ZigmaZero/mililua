local CircuitComponentType = require "circuit.components.CircuitComponentType"
local ControlDimensionsUtils = require "utils.ControlDimensionsUtils"
local class = "core.class"

---@class MiliastraFrontend
---@field new fun(uiRoot): MiliastraFrontend
local MiliastraFrontend = class()

function MiliastraFrontend:init(uiRoot)
    self.uiRoot = uiRoot
    self.hoveringPort = nil
    self.textRegistry = {}
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
    local mask = self.uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    if not mask then
        return
    end
    local reference = game.InstantiateClientUIControl(1073742269, mask)
    -- Select the visual based on component:getType().
    ---@cast reference ClientUIContainerControl
    reference:GetChild("TextBoxControl").text = component:getType()
    local inputs = #component.inputs
    reference:GetChild("InputPins"):RefreshItems(inputs, function(control, index)
        control:AddCursorEventListener(Enum.CursorEventType.CursorEnter, function(eventData)
            self.hoveringPort = {
                id = reference.id,
                inOut = "in",
                port = index + 1
            }
        end)
        control:AddCursorEventListener(Enum.CursorEventType.CursorExit, function(eventData)
            self.hoveringPort = nil
        end)
    end)
    local outputs = #component.outputs
    reference:GetChild("OutputPins"):RefreshItems(outputs, function(control, index)
        control:AddCursorEventListener(Enum.CursorEventType.CursorEnter, function(eventData)
            self.hoveringPort = {
                id = reference.id,
                inOut = "out",
                port = index + 1
            }
        end)
        control:AddCursorEventListener(Enum.CursorEventType.CursorExit, function(eventData)
            self.hoveringPort = nil
        end)
    end)
    -- Set object x, y
    local maskMidX = (ControlDimensionsUtils.getUnscaledMaxWidth(mask) + ControlDimensionsUtils.getUnscaledMinWidth(mask))/2
    local maskMidY = (ControlDimensionsUtils.getUnscaledMaxHeight(mask) + ControlDimensionsUtils.getUnscaledMinHeight(mask))/2
    reference:SetAnchoredPosition(x - maskMidX, y - maskMidY)

    -- Return the created MiliLua object.
    return reference
end

---@param wire Wire
function MiliastraFrontend:createWireVisual(sourceRef, destRef, wire)
    local mask = self.uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    if not mask then
        return
    end

    local reference = game.InstantiateClientUIControl(1073742354, mask)
    return self:updateWireVisual(sourceRef, destRef, wire, reference)
end

---@param sourceRef ClientControlType
---@param destRef ClientControlType
---@param wire Wire
---@param visual ClientControlType
---@return ClientControlType?
function MiliastraFrontend:updateWireVisual(sourceRef, destRef, wire, visual)
    local mask = self.uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    if not mask then
        return
    end
    local srcPortIdx = wire.source.index
    local dstPortIdx = wire.destination.index
    local sourceCtrl = self:getOutputPortReference(sourceRef, srcPortIdx)
    local destCtrl = self:getOutputPortReference(destRef, dstPortIdx)

    if not sourceCtrl or not destCtrl then
        return visual
    end
    ---@cast sourceCtrl ClientControlType
    ---@cast destCtrl ClientControlType
    local sourceX = (ControlDimensionsUtils.getUnscaledMaxWidth(sourceCtrl) + ControlDimensionsUtils.getUnscaledMinWidth(sourceCtrl))/2
    local sourceY = (ControlDimensionsUtils.getUnscaledMaxHeight(sourceCtrl) + ControlDimensionsUtils.getUnscaledMinHeight(sourceCtrl))/2
    local destX = (ControlDimensionsUtils.getUnscaledMaxWidth(destCtrl) + ControlDimensionsUtils.getUnscaledMinWidth(destCtrl))/2
    local destY = (ControlDimensionsUtils.getUnscaledMaxHeight(destCtrl) + ControlDimensionsUtils.getUnscaledMinHeight(destCtrl))/2

    local deltaX = destX - sourceX
    local deltaY = destY - sourceY
    local wireX = (sourceX + destX) / 2
    local wireY = (sourceY + destY) / 2
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

function MiliastraFrontend:createTemporaryWireVisual(
    sourceRef,
    portIdx,
    x,
    y
)
    local mask = self.uiRoot:FindChild("CircuitPage/CircuitArea/Mask")
    if not mask then
        return
    end
    local visual = game.InstantiateClientUIControl(1073742354, mask)
    local sourceCtrl = self:getOutputPortReference(sourceRef, portIdx)
    if not sourceCtrl then
        return visual
    end
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

---@param object ClientControlType
---@param callback fun(x: number, y: number)
function MiliastraFrontend:onClick(
    object,
    callback
)
    object:AddCursorEventListener(Enum.CursorEventType.CursorClick, function(eventData)
        local x, y = eventData:GetPressUIPos()
        callback(x, y)
    end)
end

---@param object ClientControlType
---@param callback fun(x: number, y: number)
function MiliastraFrontend:onDragStart(
    object,
    callback
)
    object:AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag, function(eventData)
        local x, y = eventData:GetUIPos()
        callback(x, y)
    end)
end

---@param object ClientControlType
---@param callback fun(x: number, y: number)
function MiliastraFrontend:onDrag(
    object,
    callback
)
    object:AddCursorEventListener(Enum.CursorEventType.CursorDrag, function(eventData)
        local x, y = eventData:GetUIPos()
        if eventData.dragging then
            callback(x, y)
        end
    end)
end

---@param object ClientControlType
---@param callback fun(x: number, y: number)
function MiliastraFrontend:onDragEnd(
    object,
    callback
)
    object:AddCursorEventListener(Enum.CursorEventType.CursorEndDrag, function(eventData)
        local x, y = eventData:GetUIPos()
        callback(x, y)
    end)
end

---@param object ClientControlType
---@param callback fun(x: number, y: number)
function MiliastraFrontend:onRMB(
    object,
    callback
)
    object:AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyDown, function()
        object:AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyUp, function()
            local x, y = game.GetCursorUIPos()
            callback(x, y)
            return true
        end)
        return true
    end)
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

---@param object ClientControlType
---@param dragging boolean
function MiliastraFrontend:setDragging(
    object,
    dragging
)
    if dragging then
        object:SetAsLastSibling()
    else
        object:SetAsFirstSibling()
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
    object,
    x,
    y
)
    -- TODO:
    -- Move the free end of a temporary wire
    -- to the specified cursor position.
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

function MiliastraFrontend:createPalette(entries)
    local grid = self.uiRoot:FindChild("CircuitPage/PaletteArea/GridScrollerControl")
    if not grid then
        return
    end

    local ComponentTypeToInOutCount = {
        AND = {2, 1},
        OR = {2, 1},
        NOT = {1, 1},
        XOR = {2, 1},
        NAND = {2, 1},
        NOR = {2, 1},
        XNOR = {2, 1},
        REGISTER = {2, 1},
        INPUT = {0, 1},
        OUTPUT = {1, 0},
        DELAY = {1, 1},
    }

    ---@cast grid ClientUIGridScrollerControl
    grid:RefreshItems(#entries, function(control, index)
        local container = control:GetChild("ContainerControl")
        if not container then
            return
        end
        local reference = game.InstantiateClientUIControl(1073742269, container)
        reference:GetChild("TextBoxControl").text = entries[index + 1]
        local inputs = ComponentTypeToInOutCount[entries[index + 1]][1]
        reference:GetChild("InputPins"):RefreshItems(inputs, function(control, index)
        end)
        local outputs = ComponentTypeToInOutCount[entries[index + 1]][2]
        reference:GetChild("OutputPins"):RefreshItems(outputs, function(control, index)
        end)
    end)
end

return MiliastraFrontend
