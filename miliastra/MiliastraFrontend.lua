local CircuitComponentType = require "circuit.components.CircuitComponentType"
local ControlDimensionsUtils = require "utils.ControlDimensionsUtils"
local class = "core.class"

---@class MiliastraFrontend
local MiliastraFrontend = class()

function MiliastraFrontend:init(uiRoot)
    self.uiRoot = uiRoot

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

function MiliastraFrontend:createComponentVisual(component)
    -- TODO:
    -- Create the MiliLua UI object representing this component.
    -- Select the visual based on component:getType().
    -- Parent it to the appropriate UI root/container.
    -- Return the created MiliLua object.
end

function MiliastraFrontend:createWireVisual(wire)
    -- TODO:
    -- Create the MiliLua object(s) used to render a permanent wire.
    -- Return the reference object.
end

function MiliastraFrontend:createTemporaryWireVisual(
    port,
    x,
    y
)
    -- TODO:
    -- Create a temporary wire visual beginning at the port.
    -- Return the reference object.
end

-- Port references 
function MiliastraFrontend:getInputPortReference(
    componentReference,
    index
)
    -- TODO:
    -- Return the MiliLua object representing
    -- the specified input socket.
end

function MiliastraFrontend:getOutputPortReference(
    componentReference,
    index
)
    -- TODO:
    -- Return the MiliLua object representing
    -- the specified output socket.
end

---@param object ClientControlType
---@param callback fun(x: number, y: number)
function MiliastraFrontend:onClick(
    object,
    callback
)
    object:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
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
    object:AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag, function (eventData)
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
    object:AddCursorEventListener(Enum.CursorEventType.CursorDrag, function (eventData)
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
    object:AddCursorEventListener(Enum.CursorEventType.CursorEndDrag, function (eventData)
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
    object:AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyDown, function ()
        object:AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyUp, function ()
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
    -- TODO:
    -- Determine which InputPortView/OutputPortView
    -- is currently underneath the cursor.
    --
    -- Return the associated logical Port,
    -- or nil if no port is hovered.
end