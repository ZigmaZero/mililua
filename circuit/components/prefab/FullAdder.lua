local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class FullAdder : CircuitComponent
local FullAdder = class(LogicGate)

function FullAdder:init(id)
    LogicGate.init(self, id, CircuitComponentType.HALF_ADD)

    self:addInput()
    self:addInput()
    self:addInput()
    self:addOutput()
    self:addOutput()

    self.propagationTime = 3
end

function FullAdder:evaluate()
    local a = self:getInput(1):getValue() and 1 or 0
    local b = self:getInput(2):getValue() and 1 or 0
    local c = self:getInput(3):getValue() and 1 or 0

    local s = a+b+c
    local h = s % 1 == 1
    local n = s > 1
    
    table.insert(self.internalValues, {h, n})
end

return FullAdder