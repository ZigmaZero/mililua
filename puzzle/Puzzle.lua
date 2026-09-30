local class = require "core.class"

---@class Puzzle
---@field new fun(definition): Puzzle
local Puzzle = class()

function Puzzle:init(definition)
    self.id = definition.id
    self.name = definition.name
    self.info = definition.info
    self.specs = definition.specs
    self.hintText = definition.hintText

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
    for testIndex, test in ipairs(self.tests) do
        print("Running puzzle test " .. testIndex)
        local outputTimeline = {}
        for i = 1, self.simulationLimit do
            if test.input[i] then
                print("Timestamp " .. i .. " input changes:")
                for name, value in pairs(test.input[i]) do
                    print("  " .. name .. " = " .. tostring(value))
                end
                circuit:setInputs(test.input[i])
            end
            circuit:evaluate()
            local outputs = circuit:getOutputs()
            outputTimeline[i] = outputs

            print("Timestamp " .. i .. " outputs:")
            for name, value in pairs(outputs) do
                print("  " .. name .. " = " .. tostring(value))
            end

            if test.output[i] then
                print("Timestamp " .. i .. " expected outputs:")
                for name, value in pairs(test.output[i]) do
                    print("  " .. name .. " = " .. tostring(value))
                end
            end
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