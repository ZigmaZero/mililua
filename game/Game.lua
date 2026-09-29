local class = "core.class"

---@class Game
---@field new fun(frontend: MiliastraFrontend): Game
local Game = class()
local CircuitEditor = require "game.CircuitEditor"
local CircuitBuilder = require "game.CircuitBuilder"
local ComponentPalette = require "game.ComponentPalette"
local HUDView = require "frontend.HUDView"
local LevelManager = require "puzzle.LevelManager"
local CircuitComponentType = require "circuit.components.CircuitComponentType"

---@param frontend MiliastraFrontend
function Game:init(frontend)
    self.frontend = frontend

    self.levelManager =
        LevelManager.new()

    self.currentLevel = nil
    self.circuit = nil

    self.editor = nil
    self.palette = nil
    self.hud = nil
end

---@param level Puzzle
function Game:loadLevel(level)
    self.currentLevel = level

    self.circuit = nil

    self.editor =
        CircuitEditor.new(
            self.circuit,
            self.frontend
        )

    local temp = CircuitBuilder:fromLevel(level)
    for index, value in ipairs(temp.inputNodes) do
        ---@cast value InputNode
        self.editor:createNode(value.type, -400, -200 + (150 * index), value.name)
    end
    for index, value in ipairs(temp.outputNodes) do
        ---@cast value OutputNode
        self.editor:createNode(value.type, 400, -200 + (150 * index), value.name)
    end

    self.hud =
        HUDView.new(self.frontend)

    self.palette = ComponentPalette.new(self.editor, self.frontend)

    for index, value in ipairs(level.allowedComponents) do
        self.palette:addComponentType(value)
    end

    self.hud:setLevelName(level.name)
    self.hud:setInfo(level.info)
    self.hud:setSpecs(level.specs)
end

function Game:testCircuit()
    local result =
        self.currentLevel:test(
            self.circuit
        )

    if result.success then
        self.hud:showSuccess()
    else
        self.hud:showFailure(result)
    end

    return result
end

return Game