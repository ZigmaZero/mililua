local class = require "core.class"
local ComponentView = require "frontend.ComponentView"
local CircuitEditor = class()

---@param circuit Circuit
function CircuitEditor:init(circuit, frontend)
    self.circuit = circuit
    self.frontend = frontend

    self.selected = nil

    self.componentViews = {}
    self.wireViews = {}
end

function CircuitEditor:spawnComponent(name)
    local component = self.circuit:addComponent(name)
    local view = ComponentView.new(component, self.frontend)
    table.insert(self.componentViews, view)
    view:create()
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

    table.insert(self.wireViews, wire)
    return wire
end

return CircuitEditor