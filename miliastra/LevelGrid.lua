local Global = require("miliastra.Global Script")
local levelDetail = require("miliastra.LevelDetail")

function OnEnable()
    local levelManager = Global.getGame().levelManager
    local len = #levelManager.index_to_id
    script.object:RefreshItems(len, function (control, index)
        control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
            levelDetail.setLevelDetail(script.object -- LevelGrid
            .parent -- LevelSelect
            .parent -- LevelPage
            :GetChild("LevelDetail") -- LevelDetail
            , levelManager.levels[index + 1])
        end)
    end)
end