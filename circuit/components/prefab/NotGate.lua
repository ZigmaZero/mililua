local class = require "core.class"
local LogicGate = require "circuit.components.LogicGate"

---@class NotGate : LogicGate
local NotGate = class(LogicGate)

function NotGate:init(id)
    LogicGate.init(self, id)

    self:addInput()
    self:addOutput()
end

function NotGate:evaluate()
    self:getOutput(1):setValue(
        not self:getInput(1):getValue()
    )
end

return NotGate