local class = require("core.class")
local View = require("frontend.View")

---@class PortView
---@field new fun(port: Port, componentView: ComponentView, frontend: MiliastraFrontend, reference: ClientControlType): PortView
local PortView = class(View)

---@param port Port
---@param componentView ComponentView
---@param frontend MiliastraFrontend
---@param reference ClientControlType
function PortView:init(port, componentView, frontend, reference)
    View.init(self, frontend)

    self.port = port
    self.frontend = frontend
    self.componentView = componentView
    self.referenceId = reference.id

    self.wireView = nil
end

function PortView:isOppositePort(port)
    return false
end

function PortView:destroy()
    self.frontend:destroyObject(
        game.GetClientUIControl(self.referenceId)
    )
end

return PortView