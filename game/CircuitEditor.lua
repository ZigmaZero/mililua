local class = require "core.class"
local ComponentView = require "frontend.ComponentView"
local WireView      = require "frontend.WireView"
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
    self.componentViews[component.id] = view
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

    table.insert(self.wireViews, WireView.new(wire, self.frontend))
    return wire
end

---@param wire Wire
function CircuitEditor:disconnect(wire)
    for index, view in ipairs(self.wireViews) do
        if view.wire.source == wire.source and view.wire.destination == wire.destination then
            wire:remove()
            view:destroy()
            table.remove(self.wireViews, index)
        end
    end
end

return CircuitEditor