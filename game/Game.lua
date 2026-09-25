local class = "core.class"
local Game = class()
local CircuitEditor = require "game.CircuitEditor"
local CircuitBuilder = require "game.CircuitBuilder"
local ComponentPalette = require "game.ComponentPalette"
local HUDView = require "frontend.HUDView"
local LevelManager = require "puzzle.LevelManager"

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

function Game:loadLevel(level)
    self.currentLevel = level

    self.circuit =
        CircuitBuilder:fromLevel(level)

    self.editor =
        CircuitEditor.new(
            self.circuit,
            self.frontend
        )

    self.hud =
        HUDView.new(self.frontend)

    self.palette = ComponentPalette.new(self.editor, self.frontend)

    self.hud:setLevelInfo(level.name, level.description)
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