local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class NandGate : CircuitComponent
local NandGate = class(LogicGate)

function NandGate:init(id)
    LogicGate.init(self, id, CircuitComponentType.NAND)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function NandGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    table.insert(self.internalValues, not (a and b))
end

return NandGate