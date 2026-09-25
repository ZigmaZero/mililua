local class = require "core.class"

---@class ComponentView
---@field new fun(component, frontend): ComponentView
local ComponentView = class()

function ComponentView:init(component, frontend)
    self.component = component
    self.frontend = frontend

    self.object = nil
end

function ComponentView:create()
    self.object =
        self.frontend:createComponentVisual(
            self.component
        )

    self:updatePosition()
end

function ComponentView:updatePosition()
    local x, y =
        self.component:getPosition()

    self.frontend:setPosition(
        self.object,
        x,
        y
    )
end

function ComponentView:destroy()
    self.frontend:destroyObject(self.object)

    self.object = nil
end