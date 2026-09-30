local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "xnor_gate",

    name = "XNOR Gate",

    info = "This level concerns the creation of an XNOR gate.",

    specs = "No, we're not giving you the XOR. Too easy.\n\nMake a circuit that provides the following behavior:\nA = 0, B = 0 --> OUT = 1\nA = 1, B = 1 --> OUT = 1\nAnything else --> OUT = 0",

    hintText = "The XNOR gate is true when both inputs have the same value.",

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
        "OR",
        "NOR"
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
                    OUT = true
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
