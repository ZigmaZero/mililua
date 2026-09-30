local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "not_gate",

    name = "NOT Gate",

    info = "You're on your own from now. Good luck!\n\nThis level concerns the creation of a NOT gate.",

    specs = "Make a circuit that provides the following behavior:\nIN = 1 OUT = 0\nIN = 0 --> OUT = 1",

    hintText = "Use the NAND gate to wire the same input twice.",

    inputs = {
        "IN"
    },

    outputs = {
        "OUT"
    },

    allowedComponents = {
        "NAND"
    },

    tests = {
        {
            input = {
                [1] = {
                    IN = false,
                },
                [50] = {
                    IN = true,
                },
                [100] = {
                    IN = false,
                },
            },
            output = {
                [25] = {
                    OUT = true
                },
                [75] = {
                    OUT = false
                },
                [125] = {
                    OUT = true
                },
            }
        }
    },

    simulationLimit = 150
})
return Level