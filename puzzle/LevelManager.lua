local class = require "core.class"

---@class LevelManager
local LevelManager = class()

function LevelManager:init()
    self.levels = {}
    self.currentLevel = nil
end

function LevelManager:addLevel(level)
    self.levels[level.id] = level
end

function LevelManager:getLevel(id)
    return self.levels[id]
end

function LevelManager:loadLevel(id)
    local level = self:getLevel(id)

    assert(level, "Unknown level: " .. tostring(id))

    self.currentLevel = level

    return level
end