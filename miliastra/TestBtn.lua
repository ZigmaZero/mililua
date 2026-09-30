local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

function OnStart()
    script.object:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
        local result = Global.getGame():testCircuit()
        if result.success then
            uiRoot.setPopup(true, "Puzzle completed!\nYou may tinker with the circuit some more or exit to play other levels.")
        else
            uiRoot.setPopup(true, "Verification failed...\nThis test can't tell you what went wrong, so if you're sure it should've worked, please notify the creator.")
        end
    end)
end