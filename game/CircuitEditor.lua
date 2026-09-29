local class = require "core.class"
local ComponentView = require "frontend.ComponentView"
local WireView      = require "frontend.WireView"
---@class CircuitEditor
---@field new fun(circuit: Circuit, frontend: MiliastraFrontend): CircuitEditor
local CircuitEditor = class()

---@param circuit Circuit
---@param frontend MiliastraFrontend
function CircuitEditor:init(circuit, frontend)
    self.circuit = circuit
    self.frontend = frontend

    self.componentViews = {}
    self.wireViews = {}

    self.temporaryWireViews = {}
end

function CircuitEditor:createComponent(
    componentType,
    x,
    y
)
    local component =
        self.circuit:addComponent(componentType)

    component:setPosition(x, y)

    local reference =
        self.frontend:createComponentVisual(
            component,
            x,
            y
        )

    local view =
        ComponentView.new(
            component,
            self.frontend,
            reference,
            self
        )

    self.componentViews[component.id] = view

    return view
end

function CircuitEditor:removeComponent(component)
    local view =
        self.componentViews[component.id]

    if view then
        view:destroy()
        self.componentViews[component.id] = nil
    end

    self.circuit:removeComponent(component)
end

function CircuitEditor:createNode(componentType, x, y, name)
    local ref = nil
    if componentType == "INPUT" then
        ref = self.circuit:addInputNode(name)
    else
        ref = self.circuit:addOutputNode(name)
    end

    ref:setPosition(x, y)

    local reference =
        self.frontend:createComponentVisual(
            ref,
            x,
            y
        )

    local view =
        ComponentView:new(
            ref,
            self.frontend,
            reference,
            self
        )

    self.componentViews[ref.id] = view

    return view
end

---@param source Port
---@param destination Port
function CircuitEditor:connectPorts(
    source,
    destination
)
    if not self:isOppositePortPair(
        source,
        destination
    ) then
        return nil
    end

    local output = source
    local input = destination

    if source.type == "INPUT" then
        output, input = input, output
    end

    ---@cast output OutputPort
    ---@cast input InputPort
    local wire =
        self.circuit:connect(
            output,
            input
        )

    local sourceRef = self.componentViews[source.owner.id].reference
    local destRef = self.componentViews[destination.owner.id].reference

    local reference =
        self.frontend:createWireVisual(
            sourceRef,
            destRef,
            wire
        )

    local view =
        WireView:new(
            wire,
            self.frontend,
            reference,
            self
        )

    self.wireViews[wire.id] = view

    return wire
end

function CircuitEditor:isOppositePortPair(a, b)
    return (
        a.type == "OUTPUT" and
        b.type == "INPUT"
    ) or (
        a.type == "INPUT" and
        b.type == "OUTPUT"
    )
end

---@param port Port
---@param x any
---@param y any
---@return table
function CircuitEditor:createTemporaryWire(
    port,
    x,
    y
)
    local portRef = self.componentViews[port.owner.id].reference
    local reference =
        self.frontend:createTemporaryWireVisual(
            portRef,
            port.index,
            x,
            y
        )

    local view =
        WireView:new(
            nil,
            self.frontend,
            reference,
            self
        )

    table.insert(
        self.temporaryWireViews,
        view
    )

    return view
end

function CircuitEditor:destroyTemporaryWire(
    wireView
)
    wireView:destroy()

    for i, view in ipairs(
        self.temporaryWireViews
    ) do
        if view == wireView then
            table.remove(
                self.temporaryWireViews,
                i
            )

            break
        end
    end
end

return CircuitEditor