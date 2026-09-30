local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "full_adder",

    name = "Full Adder",

    info = "Okay, fine, the half adder kinda sucks. How about the REAL stuff, the full adder?",

    specs = "The half adder can handle adding two numbers, but it can't take a carry unit! Make the full adder, which also adds the two inputs with a third input! You still have two outputs Q and C.",

    hintText = "Yes, there's the input C and output C. Chaining full adders allow you to take the output C to be the next full adder's C.\n\nOh, actual hints? ...Um, well, can't we just use the half adder to add the third input, too?",

    inputs = {
        "A",
        "B",
        "C"
    },

    outputs = {
        "Q",
        "C"
    },

    allowedComponents = {
        "NOT",
        "AND",
        "OR",
        "XOR",
        "HALF_ADD"
    },

    tests = {
        {
            input = {
                [1] = {
                    A = false,
                    B = false,
                    C = false,
                },
                [50] = {
                    A = true
                },
                [100] = {
                    B = true
                },
                [150] = {
                    A = false
                },
                [200] = {
                    C = true
                },
                [250] = {
                    A = true
                },
                [300] = {
                    B = false
                },
                [350] = {
                    A = false
                },
                [400] = {
                    C = false
                }
            },
            output = {
                [25] = {
                    Q = false,
                    C = false
                },
                [75] = {
                    Q = true,
                    C = false
                },
                [125] = {
                    Q = false,
                    C = true,
                },
                [175] = {
                    Q = true,
                    C = false
                },
                [225] = {
                    Q = false,
                    C = true
                },
                [275] = {
                    Q = true,
                    C = true
                },
                [325] = {
                    Q = false,
                    C = true,
                },
                [375] = {
                    Q = true,
                    C = false
                },
                [425] = {
                    Q = false,
                    C = false
                }
            }
        }
    },

    simulationLimit = 500
})
return Level