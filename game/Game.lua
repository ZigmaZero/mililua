local class = "core.class"

---@class Game
---@field new fun(frontend: MiliastraFrontend): Game
local Game = class()
local CircuitEditor = require "game.CircuitEditor"
local ComponentPalette = require "game.ComponentPalette"
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

    self.palette = ComponentPalette.new(self.editor, self.frontend)
    self.palette:refreshComponents(level.allowedComponents)

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

return Game