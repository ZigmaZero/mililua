local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "and_gate",

    name = "AND Gate",

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
                A = false,
                B = false
            },

            output = {
                OUT = false
            }
        },

        {
            input = {
                A = false,
                B = true
            },

            output = {
                OUT = false
            }
        },

        {
            input = {
                A = true,
                B = false
            },

            output = {
                OUT = false
            }
        },

        {
            input = {
                A = true,
                B = true
            },

            output = {
                OUT = true
            }
        }
    }
})
return Level