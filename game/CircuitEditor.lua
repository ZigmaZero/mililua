local class = require "core.class"
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

function CircuitEditor:updateComponentWires(component)
    for _, inputPort in ipairs(component.inputs) do
        ---@cast inputPort InputPort
        local wire = inputPort.connection
        if wire then
            local sourceReference = wire.source:reference()
            local destinationReference = wire.destination:reference()
            local wireReference = wire:reference()
            if sourceReference and destinationReference and wireReference then
                self.frontend:updateWireVisual(
                    sourceReference,
                    destinationReference,
                    wire,
                    wireReference
                )
            end
        end
    end

    for _, outputPort in ipairs(component.outputs) do
        ---@cast outputPort OutputPort
        for _, wire in ipairs(outputPort.connections) do
            local sourceReference = wire.source:reference()
            local destinationReference = wire.destination:reference()
            local wireReference = wire:reference()
            if sourceReference and destinationReference and wireReference then
                self.frontend:updateWireVisual(
                    sourceReference,
                    destinationReference,
                    wire,
                    wireReference
                )
            end
        end
    end
end

function CircuitEditor:moveComponent(component, reference, dx, dy)
    self.frontend:updatePosition(reference, dx, dy)
    local x, y = reference:GetAnchoredPosition()
    component:setPosition(x, y)
    self:updateComponentWires(component)
end

function CircuitEditor:registerDeleteListener(control, callback)
    local deleteRequested = false

    control:AddKeyEventListener(
        Enum.KeyEventType.KeyboardSprintKeyDown,
        function()
            deleteRequested = true
            return true
        end
    )

    control:AddKeyEventListener(
        Enum.KeyEventType.KeyboardSprintKeyUp,
        function()
            if deleteRequested then
                deleteRequested = false
                callback()
            end
            return true
        end
    )
end

function CircuitEditor:registerComponentListeners(component, reference)
    local cursorEventArea = reference:GetChild("CursorEventArea")

    cursorEventArea:AddCursorEventListener(
        Enum.CursorEventType.CursorBeginDrag,
        function(eventData)
            local dx, dy = eventData:GetUIPosDelta()
            self:moveComponent(component, reference, dx, dy)
            self.frontend:setDragging(reference, true)
        end
    )

    cursorEventArea:AddCursorEventListener(
        Enum.CursorEventType.CursorDrag,
        function(eventData)
            local dx, dy = eventData:GetUIPosDelta()
            self:moveComponent(component, reference, dx, dy)
        end
    )

    cursorEventArea:AddCursorEventListener(
        Enum.CursorEventType.CursorEndDrag,
        function()
            self:moveComponent(component, reference, 0, -15)
            self.frontend:setDragging(reference, false)
        end
    )
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

    component:setReference(reference)

    if reference then
        self:registerComponentListeners(component, reference)
        self:registerDeleteListener(
            reference:GetChild("CursorEventArea"),
            function()
                self:removeComponent(component)
            end
        )
    end

    self.componentViews[component.id] = component

    return component
end

function CircuitEditor:removeComponent(component)
    self.componentViews[component.id] = nil
    self.circuit:removeComponent(component)
    local control = game.GetClientUIControl(component.referenceId)
    if not control then
        return
    end
    game.DestroyClientUIControl(control)
end

function CircuitEditor:removeWire(wire)
    self.wireViews[wire.id] = nil
    self.circuit:disconnect(wire)
    local control = game.GetClientUIControl(wire.referenceId)
    if not control then
        return
    end
    game.DestroyClientUIControl(control)
end

function CircuitEditor:createNode(componentType, x, y, name)
    local component = nil
    if componentType == "INPUT" then
        component = self.circuit:addInputNode(name)
    else
        component = self.circuit:addOutputNode(name)
    end

    component:setPosition(x, y)

    local reference =
        self.frontend:createComponentVisual(
            component,
            x,
            y
        )

    component:setReference(reference)

    if reference then
        self:registerComponentListeners(component, reference)
    end

    self.componentViews[component.id] = component

    return component
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

    wire:setReference(reference)

    if reference then
        self:registerDeleteListener(
            reference:GetChild("CursorEventArea"),
            function()
                self:removeWire(wire)
            end
        )
    end

    self.wireViews[wire.id] = wire
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

return CircuitEditor
