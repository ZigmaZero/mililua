local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "and_gate",

    name = "AND Gate",

    info = "This level concerns the creation of an AND gate.",

    specs = "Make a circuit that provides the following behavior:\nA = 1, B = 1 --> OUT = 1\nAnything else --> OUT = 0",

    hintText = "Doesn't this look familiar to the NAND gate...?",

    inputs = {
        "A",
        "B"
    },

    outputs = {
        "OUT"
    },

    allowedComponents = {
        "NAND",
        "NOT"
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