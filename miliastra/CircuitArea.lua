local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

local area = script.object
assert(area ~= nil)

function OnEnable()
    Global.getGame():loadLevel(Global.getGame().levelManager.currentLevel)

    local mask = area:GetChild("Mask")
end