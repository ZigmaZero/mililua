local Global = require("miliastra.Global Script")
local uiRoot = require("miliastra.UI Root")

function OnEnable()
    local frontend = Global.getFrontend()
    frontend:registerTextListener("level_name", script.object)
end