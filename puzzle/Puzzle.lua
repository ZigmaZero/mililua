local class = require "core.class"

---@class Puzzle
---@field new fun(definition): Puzzle
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

function Puzzle:outputsEqual(a, b)
    for key, value in pairs(a) do
        if b[key] ~= value then
            return false
        end
    end
    return true
end

---@param circuit Circuit
function Puzzle:test(circuit)
    for _, test in ipairs(self.tests) do
        circuit:setInputs(test.input)
        circuit:evaluate()

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