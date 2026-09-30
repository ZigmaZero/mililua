local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "introducing_components",

    name = "Introducing Components",

    info = "This level introduces the ability to create components.",

    specs = "For this level, you will need to use components to complete the task.\n\nClick the NAND component from the palette to the left to create it on the board. Right click these components to remove them.\n\nMake a circuit that provides the following behavior:\nA = 1, B = 1  --> OUT = 0\nAnything else --> OUT = 1",

    hintText = "Use the NAND gate to wire both inputs!",

    inputs = {
        "A",
        "B"
    },

    outputs = {
        "OUT"
    },

    allowedComponents = {
        "NAND"
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
                    OUT = true
                },
                [125] = {
                    OUT = false
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