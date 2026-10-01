local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "mux",

    name = "Multiplexer",

    info = "Now that you know all the basic logic gates, let's get you started on some useful components. First up: the multiplexer.",

    specs = "The multiplexer takes two inputs and a SELECT bit. Depending on the SELECT, one of the inputs are chosen to be outputted.\n\nFor this stage, if SELECT is 0, then OUT = V0.\nIf SELECT is 1, then OUT = V1.\nUse the basic logic gates to solve this puzzle.",

    hintText = "If an input is not chosen by the SELECT bit, it can be treated as 0. You can then OR it with the input chosen by the SELECT bit. Now how do you make a bit 0 by a control bit?\n\nSome useful properties:\n1 OR X = 1\n0 AND X = 0\nY XOR Y = 0",

    inputs = {
        "V0",
        "V1",
        "SELECT"
    },

    outputs = {
        "OUT",
    },

    allowedComponents = {
        "NOT",
        "AND",
        "OR",
        "XOR",
    },

    tests = {
        {
            input = {
                [1] = {
                    V0 = false,
                    V1 = false,
                    SELECT = false,
                },
                [50] = {
                    V0 = true
                },
                [100] = {
                    V1 = true
                },
                [150] = {
                    V0 = false
                },
                [200] = {
                    SELECT = true
                },
                [250] = {
                    V0 = true
                },
                [300] = {
                    V1 = false
                },
                [350] = {
                    V0 = false
                },
                [400] = {
                    SELECT = false
                }
            },
            output = {
                [25] = {
                    OUT = false,
                },
                [75] = {
                    OUT = true,
                },
                [125] = {
                    OUT = true,
                },
                [175] = {
                    OUT = false,
                },
                [225] = {
                    OUT = true,
                },
                [275] = {
                    OUT = true,
                },
                [325] = {
                    OUT = false,
                },
                [375] = {
                    OUT = false,
                },
                [425] = {
                    OUT = false,
                }
            }
        }
    },

    simulationLimit = 500
})
return Level