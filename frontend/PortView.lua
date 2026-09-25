local class = require("core.class")
local View = require("frontend.View")

local PortView = class(View)

function PortView:init(port, componentView, frontend, reference)
    View.init(self, frontend)

    self.port = port
    self.componentView = componentView
    self.reference = reference

    self.wireView = nil

    self:_bindListeners()
end

function PortView:_bindListeners()
    self.frontend:onDragStart(
        self.reference,
        function(x, y)
            self:onDragStart(x, y)
        end
    )

    self.frontend:onDrag(
        self.reference,
        function(x, y)
            self:onDrag(x, y)
        end
    )

    self.frontend:onDragEnd(
        self.reference,
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

    self.wireView:setCursorPosition(x, y)
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
        self.reference
    )
end

return PortView