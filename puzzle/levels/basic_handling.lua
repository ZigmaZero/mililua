local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "basic_handling",

    name = "Welcome to Digital Logic Lab!",

    info = "This level introduces you to the basics of how to use the lab to play with circuits!",

    specs =
        "For each level in Digital Logic Lab, you are provided an objective to complete. "
    ..  "This can be anything small to large, from simple logic gates to a toy project!\n"
    ..  "\n"
    ..  "You are provided an IN node and an OUT node in the center of the screen. "
    ..  "You can drag on them to move them around freely.\n"
    ..  "Click on the ports (the little circle or triangle on the node) to select them. "
    ..  "Click on two ports of different types to join them together.\n\n"
    ..  "For this level, please wire the IN node's output to the OUT node's input and press the Verify button at the bottom right."
    ,
    hintText = "If you are stuck at a level, you may use a hint to get an idea of what to do.\nThis level's hint is the way to use hints.",

    inputs = {
        "IN",
    },

    outputs = {
        "OUT"
    },

    allowedComponents = {
        
    },

    tests = {
        {
            input = {
                [1] = {
                    IN = false,
                },
                [10] = {
                    IN = false,
                },
                [30] = {
                    IN = true
                }
            },
            output = {
                [20] = {
                    OUT = false
                },
                [40] = {
                    OUT = true
                }
            }
        }
    },

    simulationLimit = 50
})
return Level