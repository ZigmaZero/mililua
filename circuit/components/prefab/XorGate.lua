local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class XorGate : LogicGate
local XorGate = class(LogicGate)

function XorGate:init(id)
    LogicGate.init(self, id, CircuitComponentType.XOR)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function XorGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    table.insert(self.internalValues, {a ~= b})
end

return XorGate