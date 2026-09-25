local class = require "core.class"
local CircuitComponent = require "circuit.components.CircuitComponent"

---@class OutputNode : CircuitComponent
local OutputNode = class(CircuitComponent)

function OutputNode:init(id, name)
    CircuitComponent.init(self, id)

    self.name = name

    self:addInput()
end

function OutputNode:getValue()
    return self:getInput(1):getValue()
end