local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "and_gate",

    name = "AND Gate",

    info = "Example of an AND Gate level",

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
        input = {
            [4] = {
                A = true
            },
            [24] = {
                B = true
            }
        },
        output = {
            [20] = {
                O = false
            },
            [40] = {
                O = true
            }
        }
    },

    simulationLimit = 100
})
return Level