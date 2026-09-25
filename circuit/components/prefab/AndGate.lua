local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class AndGate : CircuitComponent
local AndGate = class(LogicGate)

function AndGate:init(id)
    LogicGate.init(self, id, CircuitComponentType.AND)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function AndGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    table.insert(self.internalValues, a and b)
end

return AndGate