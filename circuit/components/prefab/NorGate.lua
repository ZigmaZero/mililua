local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class NorGate : LogicGate
local NorGate = class(LogicGate)

function NorGate:init(id)
    LogicGate.init(self, id, CircuitComponentType.NOR)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function NorGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    table.insert(self.internalValues, not (a or b))
end

return NorGate