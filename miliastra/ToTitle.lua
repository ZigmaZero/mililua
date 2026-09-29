local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local btn = script.object
assert(type(btn) ~= "nil")
assert(typeof(btn) == "ClientUIPresetButtonControl")

function OnStart()
    btn:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
        uiRoot.switchPage("TitlePage")
    end)
end