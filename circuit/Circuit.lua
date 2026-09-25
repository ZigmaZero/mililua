local class = require "core.class"
local Wire = require "circuit.Wire"
local ComponentFactory = require "circuit.ComponentFactory"

---@class Circuit
---@field new fun(): Circuit
local Circuit = class()

function Circuit:init()
    self.components = {}
    self.wires = {}
    self.nextComponentId = 1
end

---@param componentType string
---@return CircuitComponent
function Circuit:addComponent(componentType)
    local component = ComponentFactory:create(componentType, self.nextComponentId)

    self.nextComponentId = self.nextComponentId + 1

    table.insert(self.components, component)

    return component
end

---@param outputPort OutputPort
---@param inputPort InputPort
---@return Wire
function Circuit:connect(outputPort, inputPort)
    local wire = Wire.new(outputPort, inputPort)

    table.insert(self.wires, wire)
    return wire
end

function Circuit:removeComponent(component)
    -- TODO: remove associated wires first, then remove component
end

function Circuit:evaluate()
    -- TODO: switch to front-to-back evaluation or dependency-aware evaluation
    for _, component in ipairs(self.components) do
        component:evaluate()
    end
end