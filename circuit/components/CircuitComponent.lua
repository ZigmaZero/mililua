local class = require "core.class"
local InputPort = require "circuit.ports.InputPort"
local OutputPort = require "circuit.ports.OutputPort"

---@class CircuitComponent
---@field id integer
---@field new fun(id): CircuitComponent
local CircuitComponent = class()

---@param id integer
---@param type string
function CircuitComponent:init(id, type)
    self.id = id
    self.type = type

    self.x = 0
    self.y = 0
    self.propagationTime = 1
    self.internalValues = {}

    self.inputs = {}
    self.outputs = {}

    self.enabled = true
end

function CircuitComponent:getType()
    return self.type
end

function CircuitComponent:addInput()
    local port = InputPort.new(self, #self.inputs + 1)
    table.insert(self.inputs, port)

    return port
end

function CircuitComponent:addOutput()
    local port = OutputPort.new(self, #self.outputs + 1)
    table.insert(self.outputs, port)

    return port
end

---@param index integer
---@return InputPort
function CircuitComponent:getInput(index)
    return self.inputs[index]
end

---@param index integer
---@return OutputPort
function CircuitComponent:getOutput(index)
    return self.outputs[index]
end

function CircuitComponent:setPosition(x, y)
    self.x = x
    self.y = y
end

function CircuitComponent:getPosition()
    return self.x, self.y
end

function CircuitComponent.evaluate()
    error("CircuitComponent:evaluate() must be overridden")
end

function CircuitComponent:tick()
    if #self.internalValues >= self.propagationTime then
        self:getOutput(1):setValue(self.internalValues[1])
        table.remove(self.internalValues, 1)
    end
end

return CircuitComponent