local class = require("core.class")
local View = require("frontend.View")

local WireView = class(View)

---@param wire Wire
---@param frontend MiliastraFrontend
---@param reference ClientControlType
---@param editor CircuitEditor
function WireView:init(wire, frontend, reference, editor)
    View.init(self, frontend)
    self.frontend = frontend
    self.wire = wire
    self.referenceId = reference.id
    self.editor = editor

    self:_bindListeners()
end

---@param portView PortView
---@param x any
---@param y any
function WireView:setCursorPosition(portView, x, y)
    self.frontend:setWireEndPosition(
        game.GetClientUIControl(portView.referenceId),
        game.GetClientUIControl(self.referenceId),
        x,
        y
    )
end

function WireView:destroy()
    self.frontend:destroyObject(
        self.reference
    )
    self.editor:removeWire(self)
end

return WireView