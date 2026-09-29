local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local btn = script.object
assert(type(btn) ~= "nil")
assert(typeof(btn) == "ClientUIPresetButtonControl")

function OnEnable()
    if uiRoot.canSettle then
        btn:GetChild("ImageControl"):SetVisible(false)
        btn.interactable = true
        btn:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
            game.ServerSignal("settle"):SendSignal()
        end)
    end
end