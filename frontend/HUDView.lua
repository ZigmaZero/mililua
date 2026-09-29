local class = require("core.class")

---@class HUDView
---@field new fun(frontend: MiliastraFrontend): HUDView
local HUDView = class()

---@param frontend MiliastraFrontend
---@param game Game
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
        "level_info",
        text
    )
end

function HUDView:setSpecs(text)
    self.frontend:setText(
        "specs",
        text
    )
end

function HUDView:showSuccess()
    self:setStatus("Circuit complete!")
end

function HUDView:showFailure(result)
    self:setStatus("Circuit does not satisfy the requirements.")
end

function HUDView:bindTestButton(reference)
    self.frontend:onClick(
        reference,
        function(x, y)
            self:onTest()
        end
    )
end

function HUDView:onTest()
    self.game:testCircuit()
end

return HUDView