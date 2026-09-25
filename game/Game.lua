local class = "core.class"
local Game = class()
local CircuitBuilder = require "game.CircuitEditor"
local HUDView = require "frontend.HUDView"

function Game:init(frontend)
    self.frontend = frontend

    self.levelManager =
        LevelManager.new()

    self.currentLevel = nil
    self.circuit = nil

    self.editor = nil
    self.hud = nil
end

function Game:loadLevel(level)
    self.currentLevel = level

    self.circuit =
        CircuitBuilder:createPuzzleCircuit(level)

    self.editor =
        CircuitEditor.new(
            self.circuit,
            self.frontend
        )

    self.hud =
        HUDView.new(self.frontend)

    self.hud:setLevelName(level.name)
end