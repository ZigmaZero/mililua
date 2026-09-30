local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "half_adder",

    name = "Half Adder",

    info = "We now move on from basic logic gates to arithmatic!\nYour first task is to replicate a very essential building block of arithmatic operations: the half adder!",

    specs = "Hey there! Since you made it here, I hope that the earlier puzzles didn't bore you too much?\n\nNow for this section, I'd like a half adder made. The half adder has the following behavior:\nInputs: (A, B)\nOutputs: (Q, C)\n\n(0, 0) -> (0, 0)\n(0, 1) -> (1, 0)\n(1, 0) -> (1, 0)\n(1, 1) -> (0, 1)\n\nIn layman's terms, Q is the result of A + B in binary, where C is the carry digit!",

    hintText = "You have two outputs this time. If you separate (A, B)'s effects on Q and their effects on C, they should resemble some logic gates we already know.\nTake a refresher on them with the previous levels at any time!",

    inputs = {
        "A",
        "B"
    },

    outputs = {
        "Q",
        "C"
    },

    allowedComponents = {
        "NOT",
        "AND",
        "OR",
        "XOR"
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
                }
            }
        }
    },

    simulationLimit = 200
})
return Level