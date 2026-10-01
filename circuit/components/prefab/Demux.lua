local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class Demux : CircuitComponent
local Demux = class(LogicGate)

function Demux:init(id)
    LogicGate.init(self, id, CircuitComponentType.MUX)

    self:addInput()
    self:addInput()
    self:addOutput()
    self:addOutput()

    self.propagationTime = 3
end

function Demux:evaluate()
    local input = self:getInput(1):getValue()
    local select = self:getInput(2):getValue()

    table.insert(self.internalValues, {select and 0 or input, select and input or 0})
end

return Demux