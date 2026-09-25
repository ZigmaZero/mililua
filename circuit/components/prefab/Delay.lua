local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class Delay : CircuitComponent
local Delay = class(LogicGate)

function Delay:init(id)
    LogicGate.init(self, id, CircuitComponentType.DELAY)

    self:addInput()
    self:addOutput()
end

function Delay:evaluate()
    local a = self:getInput(1):getValue()

    table.insert(self.internalValues, a)
end

return Delay