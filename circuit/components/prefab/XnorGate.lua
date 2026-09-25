local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"

---@class XnorGate : LogicGate
local XnorGate = class(LogicGate)

function XnorGate:init(id)
    LogicGate.init(self, id)

    self:addInput()
    self:addInput()
    self:addOutput()
end

function XnorGate:evaluate()
    local a = self:getInput(1):getValue()
    local b = self:getInput(2):getValue()

    table.insert(self.internalValues, ((not a) or b) and (a or (not b)))
end

return XnorGate