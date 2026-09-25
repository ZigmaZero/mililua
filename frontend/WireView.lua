local class = require "core.class"

---@class WireView
---@field new fun(wire, frontend): WireView
local WireView = class()

---@param wire Wire
---@param frontend any
function WireView:init(wire, frontend)
    self.wire = wire
    self.frontend = frontend

    self.wireObjects = {}
end

function WireView:create()
    self.wireObjects =
        self.frontend:createWireVisual(
            self.wire
        )

    self:updatePosition()
end

function WireView:updatePosition()
    self.frontend:setWireAttachments(
        self.wireObjects,
        self.wire
    )
end

function WireView:destroy()
    for index, value in ipairs(self.wireObjects) do
        self.frontend:destroyObject(value)
    end

    self.wireObjects = {}
end

return WireView