local class = require "core.class"
local CircuitComponent = require "circuit.components.CircuitComponent"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class InputNode : CircuitComponent
---@field new fun(id, name): InputNode
local InputNode = class(CircuitComponent)

function InputNode:init(id, name)
    CircuitComponent.init(self, id, CircuitComponentType.INPUT)

    self.name = name

    self:addOutput()
end

function InputNode:setValue(value)
    self:getOutput(1):setValue(value)
end

return InputNode