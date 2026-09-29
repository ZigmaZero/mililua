local class = require("core.class")
local View = require("frontend.View")
local InputPortView = require("frontend.InputPortView")
local OutputPortView = require("frontend.OutputPortView")

---@class ComponentView
---@field new fun(component, frontend, reference, editor): ComponentView
local ComponentView = class(View)

---@param component CircuitComponent
---@param frontend MiliastraFrontend
---@param reference ClientControlType
---@param editor CircuitEditor
function ComponentView:init(component, frontend, reference, editor)
    View.init(self, frontend)

    self.component = component
    self.frontend = frontend
    self.referenceId = reference.id
    self.editor = editor

    self.inputPorts = {}
    self.outputPorts = {}

    self.dragging = false
    self.dragOffsetX = 0
    self.dragOffsetY = 0

    self:_createPortViews()
end

function ComponentView:_createPortViews()
    for i, port in ipairs(self.component.inputs) do
        local reference =
            self.frontend:getInputPortReference(
                game.GetClientUIControl(self.referenceId),
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
                game.GetClientUIControl(self.referenceId),
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

function ComponentView:destroy()
    for _, portView in pairs(self.inputPorts) do
        portView:destroy()
    end

    for _, portView in pairs(self.outputPorts) do
        portView:destroy()
    end

    self.frontend:destroyObject(game.GetClientUIControl(self.referenceId))
end

return ComponentView