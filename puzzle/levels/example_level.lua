local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "and_gate",

    name = "AND Gate",

    info = "Example of an AND Gate level",

    specs = "Make the output be ON when both inputs are ON!",

    hintText = "Use the AND gate to wire both inputs!",

    inputs = {
        "A",
        "B"
    },

    outputs = {
        "OUT"
    },

    allowedComponents = {
        "AND"
    },

    tests = {
        {
            input = {
                [1] = {
                    A = false,
                    B = false,
                },
                [100] = {
                    A = true
                },
                [300] = {
                    B = true
                }
            },
            output = {
                [200] = {
                    OUT = false
                },
                [400] = {
                    OUT = true
                }
            }
        }
    },

    simulationLimit = 500
})
return Level