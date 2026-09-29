local class = require "core.class"

---@class Game
---@field new fun(frontend: MiliastraFrontend): Game
local Game = class()
local CircuitEditor = require "game.CircuitEditor"
local LevelManager = require "puzzle.LevelManager"
local Circuit      = require "circuit.Circuit"

---@param frontend MiliastraFrontend
function Game:init(frontend)
    self.frontend = frontend

    self.levelManager =
        LevelManager.new()

    self.currentLevel = nil
    self.circuit = nil

    self.editor = nil
    self.palette = nil
end

---@param level Puzzle
function Game:loadLevel(level)
    self.currentLevel = level

    self.circuit = Circuit.new()
    for _, name in ipairs(level.inputs) do
        self.circuit:addInputNode(name)
    end

    for _, name in ipairs(level.outputs) do
        self.circuit:addOutputNode(name)
    end

    self.editor =
        CircuitEditor.new(
            self.circuit,
            self.frontend
        )
    for index, name in ipairs(level.inputs) do
        self.editor:createNode("INPUT", -400, -200 + (150 * index), name)
    end
    for index, name in ipairs(level.outputs) do
        self.editor:createNode("OUTPUT", -400, -200 + (150 * index), name)
    end

    print("Refreshing components with " .. #level.allowedComponents .. " entries")
    self.palette = level.allowedComponents
    print(#self.palette)
    local paletteReferenceSequence = self.frontend:createPalette(self.palette, function (index)
        self.editor:createComponent(self.palette[index], 0, 0)
    end)

    self.frontend:setText("level_name", level.name)
    self.frontend:setText("level_info", level.info)
    self.frontend:setText("level_specs", level.specs)
end

function Game:testCircuit()
    local result =
        self.currentLevel:test(
            self.circuit
        )

    -- TODO: show success?

    return result
end

function Game:exitLevel()
    self.currentLevel = nil
    self.circuit = nil

    self.editor = nil
    self.palette = nil

    -- screw it just clear the entire frontend
    self.frontend:cleanupCircuitPage()
end

return Game