local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local btn = script.object
assert(script.object ~= nil)
assert(typeof(btn) == "ClientUIPresetButtonControl")

function OnStart()
    ---@cast btn ClientUIPresetButtonControl
    btn:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
        Global.getGame():exitLevel()
        uiRoot.switchPage("LevelPage")
    end)
end