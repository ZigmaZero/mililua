local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local btn = script.object

function OnEnable()
    if uiRoot.canSettle then
        script.object:GetChild("ImageControl"):SetVisible(false)
        script.object.interactable = true
        script.object:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
            game.ServerSignal("settle"):SendSignal()
        end)
    end
end