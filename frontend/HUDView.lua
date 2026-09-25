local class = require "core.class"

---@class HUDView
---@field new fun(frontend): HUDView
local HUDView = class()

function HUDView:init(frontend)
    self.frontend = frontend
    self.levelNameObject = nil
    self.levelDescriptionObject = nil
    self.statusTextObject = nil
end

function HUDView:setLevelInfo(name, description)
    self.frontend:setText(
        self.levelNameObject,
        name
    )

    self.frontend:statusTextObject(
        self.levelDescriptionObject,
        description
    )
end

function HUDView:setStatus(text)
    self.frontend:setText(
        self.statusTextObject,
        text
    )
end

function HUDView:showSuccess()
    self.frontend:setText(
        self.statusTextObject,
        "Circuit complete!"
    )
end

function HUDView:showFailure(result)
    self.frontend:setText(
        self.statusTextObject,
        "Output mismatch."
    )
end

return HUDView