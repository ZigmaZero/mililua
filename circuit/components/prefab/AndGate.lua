local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"

---@class AndGate : CircuitComponent
local AndGate = class(LogicGate)

function AndGate:init(id)
    LogicGate.init(self, id)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function AndGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    self:getOutput(1):setValue(a and b)
end

return AndGate