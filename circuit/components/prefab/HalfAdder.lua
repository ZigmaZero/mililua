local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class HalfAdder : CircuitComponent
local HalfAdder = class(LogicGate)

function HalfAdder:init(id)
    LogicGate.init(self, id, CircuitComponentType.HALF_ADD)

    self:addInput()
    self:addInput()
    self:addOutput()
    self:addOutput()
end

function HalfAdder:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    table.insert(self.internalValues, {(a ~= b), (a and b)})
end

return HalfAdder