local class = require "core.class"
local Wire = require "circuit.Wire"
local ComponentFactory = require "circuit.ComponentFactory"
local findIndex = require("utils.ListOperationsUtils").findIndex
local filterList = require("utils.ListOperationsUtils").filterList
local InputNode  = require("circuit.components.prefab.InputNode")
local OutputNode = require("circuit.components.prefab.OutputNode")

---@class Circuit
---@field new fun(): Circuit
local Circuit = class()

function Circuit:init()
    self.inputNodes = {}
    self.outputNodes = {}
    self.components = {}
    self.wires = {}
    self.nextComponentId = 1
end

function Circuit:addInputNode(name)
    local component = InputNode.new(self.nextComponentId, name)
    table.insert(self.inputNodes, component)
    self.nextComponentId = self.nextComponentId + 1
    return component
end

function Circuit:addOutputNode(name)
    local component = OutputNode.new(self.nextComponentId, name)
    table.insert(self.outputNodes, component)
    self.nextComponentId = self.nextComponentId + 1
    return component
end

function Circuit:setInput(name, value)
    local node = self.inputNodes[name]

    assert(
        node,
        "Unknown circuit input: " .. tostring(name)
    )

    node:setValue(value)
end

function Circuit:setInputs(values)
    for name, value in pairs(values) do
        self:setInput(name, value)
    end
end

function Circuit:getOutput(name)
    local node = self.outputNodes[name]

    assert(
        node,
        "Unknown circuit input: " .. tostring(name)
    )

    return node:getValue()
end

function Circuit:getOutputs()
    local values = {}

    for name, node in pairs(self.outputNodes) do
        values[name] = node:getValue()
    end

    return values
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
    local wire = Wire.new(self.nextComponentId, outputPort, inputPort)
    self.nextComponentId = self.nextComponentId + 1
    table.insert(self.wires, wire)
    return wire
end

function Circuit:removeComponent(component)
    local filter = {}
    for index, wire in ipairs(self.wires) do
        ---@cast wire Wire
        if wire.source.owner == component or wire.destination.owner == component then
            wire:remove()
            filter[index] = true
        end
    end

    self.wires = filterList(self.wires, filter)

    local component_index = findIndex(self.components, component)
    table.remove(self.components, component_index)
end

function Circuit:disconnect(wire)
    wire:remove()
    local wire_index = findIndex(self.wires, wire)
    table.remove(self.wires, wire_index)
end

function Circuit:evaluate()
    for _, component in ipairs(self.components) do
        component:evaluate()
    end

    for _, component in ipairs(self.components) do
        component:tick()
    end
end

return Circuit