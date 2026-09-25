local class = require "core.class"
local CircuitEditor = class()

function CircuitEditor:init(circuit, frontend)
    self.circuit = circuit
    self.frontend = frontend

    self.selected = nil

    self.componentViews = {}
    self.wireViews = {}
end

function CircuitEditor:selectComponent(component)
    self.selected = component
end

function CircuitEditor:moveComponent(component, x, y)
    component:setPosition(x, y)

    local view = self.componentViews[component.id]

    if view then
        view:updatePosition()
    end
end

function CircuitEditor:deleteComponent(component)
    self.circuit:removeComponent(component)

    local view = self.componentViews[component.id]

    if view then
        view:destroy()
        self.componentViews[component.id] = nil
    end
end

function CircuitEditor:connect(outputPort, inputPort)
    local wire =
        self.circuit:connect(
            outputPort,
            inputPort
        )

    self:createWireView(wire)

    return wire
end

return CircuitEditor