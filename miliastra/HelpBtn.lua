local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

function OnStart()
    script.object:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
        uiRoot.setPopup(true, Global.getGame().currentLevel.hintText)
    end)
end