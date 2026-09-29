local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local btn = script.object

function OnStart()
    script.object:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
        uiRoot.setPopup(false, "")
    end)
end