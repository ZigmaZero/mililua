local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"

---@class XorGate : LogicGate
local XorGate = class(LogicGate)

function XorGate:init(id)
    LogicGate.init(self, id)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function XorGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    table.insert(self.internalValues, ((not a) and b) or (a and (not b)))
end

return XorGate