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

    self:_bindListeners()
end

function PortView:_bindListeners()
    self.frontend:onDragStart(
        game.GetClientUIControl(self.referenceId),
        function(x, y)
            self:onDragStart(x, y)
        end
    )

    self.frontend:onDrag(
        game.GetClientUIControl(self.referenceId),
        function(x, y)
            self:onDrag(x, y)
        end
    )

    self.frontend:onDragEnd(
        game.GetClientUIControl(self.referenceId),
        function(x, y)
            self:onDragEnd(x, y)
        end
    )
end

function PortView:onDragStart(x, y)
    self.wireView =
        self.componentView.editor:createTemporaryWire(
            self.port,
            x,
            y
        )
end

function PortView:onDrag(x, y)
    if not self.wireView then
        return
    end

    self.wireView:setCursorPosition(self, x, y)
end

function PortView:onDragEnd(x, y)
    if not self.wireView then
        return
    end

    local target =
        self.frontend:getHoveredPort(
            x,
            y
        )

    if target and self:isOppositePort(target) then
        self.componentView.editor:connectPorts(
            self.port,
            target
        )
    end

    self.componentView.editor:destroyTemporaryWire(
        self.wireView
    )

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