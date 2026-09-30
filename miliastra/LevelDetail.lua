local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local M = {}

---@param level Puzzle
function M.setLevelDetail(levelDetailControl, level)
    local frontend = Global.getFrontend()
    frontend:setText("level_name", level.name)
    frontend:setText("level_info", level.info)
    local Btn = levelDetailControl:FindChild("ContainerControl/StartBtn")
    ---@cast Btn ClientUIPresetButtonControl
    Btn:RemoveAllCursorEventListeners()
    Btn:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
        Global.getGame().levelManager:loadLevel(level.id)
        uiRoot.switchPage("CircuitPage")
    end)
end

function OnEnable()
    local frontend = Global.getFrontend()
    local LevelName = script.object:FindChild("ContainerControl/LevelName")
    ---@cast LevelName ClientUITextBoxControl
    frontend:registerTextListener("level_name", LevelName)
    frontend:setText("level_name", "")
    local LevelInfo = script.object:FindChild("ContainerControl/LevelInfo")
    ---@cast LevelInfo ClientUITextBoxControl
    frontend:registerTextListener("level_info", LevelInfo)
    frontend:setText("level_info", "")
end

return M