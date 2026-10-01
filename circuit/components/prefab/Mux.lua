local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@class Mux : CircuitComponent
local Mux = class(LogicGate)

function Mux:init(id)
    LogicGate.init(self, id, CircuitComponentType.MUX)

    self:addInput()
    self:addInput()
    self:addInput()
    self:addOutput()
end

function Mux:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()
    local select = self:getInput(3):getValue()

    table.insert(self.internalValues, {select and b or a})
end

return Mux