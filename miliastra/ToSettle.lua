local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

function OnEnable()
    print("Okay, that's enough of this")
    script.object:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
            game.ServerSignal("settle"):SendSignal()
        end)
end