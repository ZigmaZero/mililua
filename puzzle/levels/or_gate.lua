local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "or_gate",

    name = "OR Gate",

    info = "This level concerns the creation of an OR gate.",

    specs = "Make a circuit that provides the following behavior:\nA = 0, B = 0 --> OUT = 0\nAnything else --> OUT = 1",

    hintText = "The OR gate is true when either input is true.",

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
                    OUT = false
                },
                [75] = {
                    OUT = true
                },
                [125] = {
                    OUT = true
                },
                [175] = {
                    OUT = true
                }
            }
        }
    },

    simulationLimit = 200
})
return Level
