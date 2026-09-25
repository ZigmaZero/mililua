local class = require("core.class")

local HUDView = class()

function HUDView:init(frontend, game)
    self.frontend = frontend
    self.game = game
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

function HUDView:setInfo(text)
    self.frontend:setText(
        "info",
        text
    )
end

function HUDView:showSuccess()
    self:setStatus("Circuit complete!")
end

function HUDView:showFailure()
    self:setStatus("Circuit does not satisfy the requirements.")
end

function HUDView:bindTestButton(reference)
    self.frontend:onClick(
        reference,
        function()
            self:onTest()
        end
    )
end

function HUDView:onTest()
    self.game:testCircuit()
end

return HUDView