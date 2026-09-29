local MiliastraFrontend = require("frontend.MiliastraFrontend")
local Game = require("game.Game")

---@type MiliastraFrontend?
local frontend = nil
---@type Game?
local game = nil
local uiRootId = 0

local M = {}

function M.initGame(uiRoot)
    frontend = MiliastraFrontend.new(uiRoot)
    game = Game.new(frontend)
end

function M.getFrontend()
    return frontend
end

function M.getGame()
    return game
end

function M.setUiRootId(id)
    uiRootId = id
end

function M.getUiRootId()
    return uiRootId
end

return M