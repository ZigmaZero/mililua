local Circuit = require "circuit.Circuit"

local CircuitBuilder = {}

function CircuitBuilder:fromLevel(level)
    local circuit = Circuit:new()

    for _, name in ipairs(level.inputs) do
        circuit:addInputNode(name)
    end

    for _, name in ipairs(level.outputs) do
        circuit:addOutputNode(name)
    end

    return circuit
end

return CircuitBuilder