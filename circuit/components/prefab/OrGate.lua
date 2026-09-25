local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"

---@class OrGate : LogicGate
local OrGate = class(LogicGate)

function OrGate:init(id)
    LogicGate.init(self, id)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function OrGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    self:getOutput(1):setValue(a or b)
end

return OrGate