local class = require "core.class"

---@class HUDView
---@field new fun(frontend): HUDView
local HUDView = class()

function HUDView:init(frontend)
    self.frontend = frontend
end

function HUDView:setLevelInfo(name, description)
    self.frontend:setText(
        "levelName",
        name
    )

    self.frontend:statusTextObject(
        "levelDescription",
        description
    )
end

function HUDView:setStatus(text)
    self.frontend:setText(
        "status",
        text
    )
end

function HUDView:showSuccess()
    self.frontend:setText(
        "status",
        "Circuit complete!"
    )
end

function HUDView:showFailure(result)
    self.frontend:setText(
        "status",
        "Output mismatch."
    )
end

return HUDView