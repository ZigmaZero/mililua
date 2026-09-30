local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "nor_gate",

    name = "NOR Gate",

    info = "This level concerns the creation of a NOR gate.",

    specs = "Make a circuit that provides the following behavior:\nA = 0, B = 0 --> OUT = 1\nAnything else --> OUT = 0",

    hintText = "The NOR gate is an OR gate followed by a NOT gate.",

    inputs = {
        "A",
        "B"
    },

    outputs = {
        "OUT"
    },

    allowedComponents = {
        "NOT",
        "AND",
        "NAND",
        "OR"
    },

    tests = {
        {
            input = {
                [1] = {
                    A = false,
                    B = false,
                },
                [50] = {
                    A = true
                },
                [100] = {
                    B = true
                },
                [150] = {
                    A = false
                }
            },
            output = {
                [25] = {
                    OUT = true
                },
                [75] = {
                    OUT = false
                },
                [125] = {
                    OUT = false
                },
                [175] = {
                    OUT = false
                }
            }
        }
    },

    simulationLimit = 200
})
return Level
