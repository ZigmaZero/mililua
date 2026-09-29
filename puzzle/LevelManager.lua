local class = require "core.class"
local Levels = require "puzzle.Levels"

---@class LevelManager
---@field new fun() : LevelManager
local LevelManager = class()

function LevelManager:init()
    self.index_to_id = {}
    self.id_to_index = {}
    self.levels = {}
    self.completed_ids = {}
    self.currentLevel = nil
    for index, value in ipairs(Levels) do
        self:addLevel(value)
    end
end

function LevelManager:addLevel(level)
    self.index_to_id[#self.index_to_id+1] = level.id
    self.id_to_index[level.id] = #self.index_to_id
    self.levels[#self.levels+1] = level
end

---@return Puzzle
function LevelManager:getLevel(id)
    return self.levels[self.id_to_index[id]]
end

function LevelManager:setAsComplete(id)
    self.completed_ids[id] = true
end

function LevelManager:loadLevel(id)
    local level = self:getLevel(id)

    assert(level, "Unknown level: " .. tostring(id))

    self.currentLevel = level

    return level
end

return LevelManager