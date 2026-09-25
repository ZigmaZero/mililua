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

    self.simulationLimit = definition.simulationLimit
end

function Puzzle:outputSatisfies(timeline, expected)
    for timestamp, req in pairs(expected) do
        local snapshot = timeline[timestamp]
        for name, value in pairs(req) do
            if snapshot[name] ~= value then
                return false
            end
        end
    end
    return true
end


---@param circuit Circuit
function Puzzle:test(circuit)
    for _, test in ipairs(self.tests) do
        local outputTimeline = {}
        for i = 1, self.simulationLimit do
            if test.input[i] then
                circuit:setInputs(test.input[i])
            end
            circuit:evaluate()
            outputTimeline[i] = circuit:getOutputs()
        end

        if not self:outputSatisfies(
            outputTimeline,
            test.output
        ) then
            return {
                success = false,
                test = test,
                actual = outputTimeline,
                expected = test.output
            }
        end
    end

    return {
        success = true
    }
end

return Puzzle