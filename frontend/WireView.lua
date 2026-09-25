local class = require "core.class"

---@class WireView
---@field new fun(wire, frontend): WireView
local WireView = class()

---@param wire Wire
---@param frontend any
function WireView:init(wire, frontend)
    self.wire = wire
    self.frontend = frontend

    self.object = {}
end

function WireView:create()
    self.object =
        self.frontend:createWireVisual(
            self.wire
        )

    self:updatePosition()
end

function WireView:updatePosition()
    self.frontend:setWireAttachments(
        self.object,
        self.wire
    )
end

function WireView:destroy()
    for index, value in ipairs(self.object) do
        self.frontend:destroyObject(value)
    end

    self.object = {}
end

return WireView