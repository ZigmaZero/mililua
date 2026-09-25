local class = require "core.class"
local HUDView = class()

function HUDView:init(frontend)
    self.frontend = frontend
end

function HUDView:setLevelName(name)
    self.frontend:setText(
        "level_name",
        name
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