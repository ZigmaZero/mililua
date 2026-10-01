local Puzzle = require "puzzle.Puzzle"
local Level = Puzzle.new({
    id = "demux",

    name = "Demultiplexer",

    info = "The multiplexer has a twin: the demultiplexer! Instead of selecting from multiple inputs into a single input, it takes one input and sends it to multiple outputs!",

    specs = "No, you can't just take the input and give it to both outputs.\n\nThe multiplexer chooses an output to provide the input to. The other output obtains the default value, which in this case is 0.\nUse the basic logic gates to solve this problem.",

    hintText = "You have two outputs, but this is really similar to the multiplexer.\nUse the same mechanism you use to zero an input. You can also zero an output the same way.",

    inputs = {
        "IN",
        "SELECT"
    },

    outputs = {
        "O0",
        "O1"
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
                    IN = false,
                    SELECT = false,
                },
                [50] = {
                    IN = true
                },
                [100] = {
                    SELECT = true
                },
                [150] = {
                    IN = false
                }
            },
            output = {
                [25] = {
                    O0 = false,
                    O1 = false
                },
                [75] = {
                    O0 = true,
                    O1 = false
                },
                [125] = {
                    O0 = false,
                    O1 = true,
                },
                [175] = {
                    O0 = false,
                    O1 = false
                }
            }
        }
    },

    simulationLimit = 200
})
return Level