local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

function OnEnable()
    Global.getGame():loadLevel(Global.getGame().levelManager.currentLevel)
end