local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class NotGate : LogicGate
local NotGate = class(LogicGate)

function NotGate:init(id)
    LogicGate.init(self, id, CircuitComponentType.NOT)

    self:addInput()
    self:addOutput()
end

function NotGate:evaluate()
    local a = self:getInput(1):getValue()

    table.insert(self.internalValues, not a)
end

return NotGate