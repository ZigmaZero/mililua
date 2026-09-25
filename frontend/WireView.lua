local class = require("core.class")
local View = require("frontend.View")

local WireView = class(View)

function WireView:init(wire, frontend, reference, editor)
    View.init(self, frontend)

    self.wire = wire
    self.reference = reference
    self.editor = editor

    self:_bindListeners()
end

function WireView:_bindListeners()
    self.frontend:onRMB(
        self.reference,
        function()
            self:onRemove()
        end
    )

    self.frontend:onShift(
        self.reference,
        function()
            self:onRemove()
        end
    )
end

function WireView:setCursorPosition(x, y)
    self.frontend:setWireEndPosition(
        self.reference,
        x,
        y
    )
end

function WireView:onRemove()
    self.editor:removeWire(self.wire)
end

function WireView:destroy()
    self.frontend:destroyObject(
        self.reference
    )
end

return WireView