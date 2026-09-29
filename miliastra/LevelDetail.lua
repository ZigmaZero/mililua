local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local control = script.object
assert(type(control) ~= "nil")

local M = {}

---@param level Puzzle
function M.setLevelDetail(level)
    local frontend = Global.getFrontend()
    frontend:setText("level_name", level.name)
    frontend:setText("level_info", level.info)
    local Btn = control:FindChild("ContainerControl/StartBtn")
    ---@cast Btn ClientUIPresetButtonControl
    Btn:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
        Global.getGame().levelManager:loadLevel(level.id)
        uiRoot.switchPage("CircuitPage")
    end)
end

function OnEnable()
    local frontend = Global.getFrontend()

    local LevelName = control:FindChild("ContainerControl/LevelName")
    ---@cast LevelName ClientUITextBoxControl
    frontend:registerTextListener("level_name", LevelName)
    frontend:setText("level_name", "")
    local LevelInfo = control:FindChild("ContainerControl/LevelInfo")
    ---@cast LevelInfo ClientUITextBoxControl
    frontend:registerTextListener("level_info", LevelInfo)
    frontend:setText("level_name", "")
end

return M