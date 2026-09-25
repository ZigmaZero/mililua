local class = require "core.class"

---@class Puzzle
---@field new fun(): Puzzle
local Puzzle = class()

function Puzzle:init(definition)
    self.id = definition.id
    self.name = definition.name

    self.inputs = definition.inputs
    self.outputs = definition.outputs

    self.allowedComponents =
        definition.allowedComponents

    self.tests =
        definition.tests
end

function Puzzle:test(circuit)
    for _, test in ipairs(self.tests) do
        circuit:setInputs(test.input)
        circuit:simulate()

        local actual = circuit:getOutputs()

        if not self:outputsEqual(
            actual,
            test.output
        ) then
            return {
                success = false,
                test = test,
                actual = actual,
                expected = test.output
            }
        end
    end

    return {
        success = true
    }
end

return Puzzle