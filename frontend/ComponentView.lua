local class = require("core.class")
local View = require("frontend.View")
local InputPortView = require("frontend.InputPortView")
local OutputPortView = require("frontend.OutputPortView")

local ComponentView = class(View)

function ComponentView:init(component, frontend, reference, editor)
    View.init(self, frontend)

    self.component = component
    self.reference = reference
    self.editor = editor

    self.inputPorts = {}
    self.outputPorts = {}

    self.dragging = false
    self.dragOffsetX = 0
    self.dragOffsetY = 0

    self:_createPortViews()
    self:_bindListeners()
end

function ComponentView:_createPortViews()
    for i, port in ipairs(self.component.inputs) do
        local reference =
            self.frontend:getInputPortReference(
                self.reference,
                i
            )

        self.inputPorts[i] =
            InputPortView:new(
                port,
                self,
                self.frontend,
                reference
            )
    end

    for i, port in ipairs(self.component.outputs) do
        local reference =
            self.frontend:getOutputPortReference(
                self.reference,
                i
            )

        self.outputPorts[i] =
            OutputPortView:new(
                port,
                self,
                self.frontend,
                reference
            )
    end
end

function ComponentView:_bindListeners()
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

    self.frontend:onRMB(
        self.reference,
        function()
            self:onRMB()
        end
    )
end

function ComponentView:onDragStart(x, y)
    self.dragging = true

    local componentX, componentY =
        self.component:getPosition()

    self.dragOffsetX = componentX - x
    self.dragOffsetY = componentY - y

    self.frontend:setDragging(
        self.reference,
        true
    )
end

function ComponentView:onDrag(x, y)
    if not self.dragging then
        return
    end

    self.component:setPosition(
        x + self.dragOffsetX,
        y + self.dragOffsetY
    )

    self.frontend:setPosition(
        self.reference,
        self.component.x,
        self.component.y
    )
end

function ComponentView:onDragEnd(x, y)
    if not self.dragging then
        return
    end

    self.dragging = false

    local finalX, finalY =
        self.frontend:getDropPosition(
            self.reference,
            x,
            y
        )

    self.component:setPosition(
        finalX,
        finalY
    )

    self.frontend:setPosition(
        self.reference,
        finalX,
        finalY
    )

    self.frontend:setDragging(
        self.reference,
        false
    )
end

function ComponentView:onRMB()
    self.editor:removeComponent(
        self.component
    )
end

function ComponentView:destroy()
    for _, portView in pairs(self.inputPorts) do
        portView:destroy()
    end

    for _, portView in pairs(self.outputPorts) do
        portView:destroy()
    end

    self.frontend:destroyObject(self.reference)
end

return ComponentView