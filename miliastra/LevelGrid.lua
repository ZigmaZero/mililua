local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")
local levelDetail = require("miliastra.LevelDetail")

local levelGrid = script.object
assert(type(levelGrid) ~= "nil")
assert(typeof(levelGrid) ~= "ClientUIGridScrollerControl")

function OnEnable()
    local levelManager = Global.getGame().levelManager
    local len = #levelManager.index_to_id
    levelGrid:RefreshItems(len, function (control, index)
        control:AddCursorEventListener(Enum.CursorEventType.CursorClick, function (eventData)
            levelDetail.setLevelDetail(levelManager.levels[index + 1])
        end)
    end)
end