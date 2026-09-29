local ComponentFactory = {
    types = {
        AND = require "circuit.components.prefab.AndGate",
        OR = require "circuit.components.prefab.OrGate",
        NOT = require "circuit.components.prefab.NotGate",
        XOR = require "circuit.components.prefab.XorGate",
        NAND = require "circuit.components.prefab.NandGate",
        NOR = require "circuit.components.prefab.NorGate",
        XNOR = require "circuit.components.prefab.XnorGate",
        REGISTER = require "circuit.components.prefab.Register",
        INPUT = require "circuit.components.prefab.InputNode",
        OUTPUT = require "circuit.components.prefab.OutputNode",
        DELAY = require "circuit.components.prefab.Delay",
    }
}

function ComponentFactory:register(name, constructor)
    self.types[name] = constructor
end

function ComponentFactory:create(name, id)
    local constructor = self.types[name]

    assert(
        constructor,
        "Unknown component: " .. tostring(name)
    )

    return constructor.new(id)
end

return ComponentFactory