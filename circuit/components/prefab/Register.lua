local class = require "core.class"
local CircuitComponent = require "circuit.components.CircuitComponent"

---@class Register : CircuitComponent
---@field new fun(id): Register
local Register = class(CircuitComponent)

function Register:init(id)
    CircuitComponent.init(self, id)

    self:addInput()   -- data
    self:addInput()   -- clock

    self:addOutput()

    self.propagationTime = 4
    self.lastClockTick = false
    self.value = false
end

function Register:evaluate()
    local clock = self:getInput(2):getValue()

    if clock and not self.lastClockTick then
        self.value = self:getInput(1):getValue()
    end
    self.lastClockTick = clock

    table.insert(self.internalValues, self.value)
end

return Register