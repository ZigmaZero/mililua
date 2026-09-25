local CircuitComponentType = require "circuit.components.CircuitComponentType"
local class = "core.class"

local MiliastraFrontend = class()

function MiliastraFrontend:init()
end

---@param component CircuitComponent
---@return ClientControlType|nil
function MiliastraFrontend:createComponentVisual(component)
    local object = nil
    if component:getType() == CircuitComponentType.INPUT then

    end
    return object
end

---@param wire Wire
---@return ClientUIContainerControl|nil
function MiliastraFrontend:createWireVisual(wire)
    -- MiliLua-specific implementation
end

function MiliastraFrontend:setWireAttachments(objectlist, wire)
    -- MiliLua-specific implementation
end

function MiliastraFrontend:setPosition(object, x, y)
    -- MiliLua-specific implementation
end

function MiliastraFrontend:createPaletteEntry(name, onClick)
    
end

function MiliastraFrontend:setVisible(object, visible)
end

function MiliastraFrontend:setText(object, text)
end

---@param object ClientControlType
function MiliastraFrontend:destroyObject(object)
    game.DestroyClientUIControl(object)
end

return MiliastraFrontend