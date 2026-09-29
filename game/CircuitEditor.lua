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
        reference:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag,
            function(eventData)
                local dx, dy = eventData:GetUIPosDelta()
                self.frontend:updatePosition(reference, dx, dy)
                local cx, cy = reference:GetAnchoredPosition()
                component:setPosition(cx, cy)
                self.frontend:setDragging(reference, true)
                --BRO WE ALSO NEED TO UPDATE WIRES
                for _, inputPort in ipairs(component.inputs) do
                    ---@cast inputPort InputPort
                    local wire = inputPort.connection
                    if not wire then
                        goto continue
                    end
                    local srcRef = wire.source:reference()
                    local dstRef = wire.destination:reference()
                    local wireVisual = wire:reference()
                    if srcRef and dstRef and wireVisual then
                        self.frontend:updateWireVisual(
                            srcRef, dstRef, wire, wireVisual
                        )
                    end
                    ::continue::
                end
                for _, outputPort in ipairs(component.outputs) do
                    ---@cast outputPort OutputPort
                    for _, wire in ipairs(outputPort.connections) do
                        local srcRef = wire.source:reference()
                        local dstRef = wire.destination:reference()
                        local wireVisual = wire:reference()
                        if srcRef and dstRef and wireVisual then
                            self.frontend:updateWireVisual(
                                srcRef, dstRef, wire, wireVisual
                            )
                        end
                    end
                end
                reference:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorDrag,
                    function(eventData)
                        dx, dy = eventData:GetUIPosDelta()
                        self.frontend:updatePosition(reference, dx, dy)
                        local cx, cy = reference:GetAnchoredPosition()
                        component:setPosition(cx, cy)
                        --BRO WE ALSO NEED TO UPDATE WIRES
                        for _, inputPort in ipairs(component.inputs) do
                            ---@cast inputPort InputPort
                            local wire = inputPort.connection
                            if not wire then
                                goto continue
                            end
                            local srcRef = wire.source:reference()
                            local dstRef = wire.destination:reference()
                            local wireVisual = wire:reference()
                            if srcRef and dstRef and wireVisual then
                                self.frontend:updateWireVisual(
                                    srcRef, dstRef, wire, wireVisual
                                )
                            end
                            ::continue::
                        end
                        for _, outputPort in ipairs(component.outputs) do
                            ---@cast outputPort OutputPort
                            for _, wire in ipairs(outputPort.connections) do
                                local srcRef = wire.source:reference()
                                local dstRef = wire.destination:reference()
                                local wireVisual = wire:reference()
                                if srcRef and dstRef and wireVisual then
                                    self.frontend:updateWireVisual(
                                        srcRef, dstRef, wire, wireVisual
                                    )
                                end
                            end
                        end
                    end)
                reference:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEndDrag,
                    function(eventData)
                        self.frontend:updatePosition(reference, 0, -15)
                        local cx, cy = reference:GetAnchoredPosition()
                        component:setPosition(cx, cy)

                        --BRO WE ALSO NEED TO UPDATE WIRES
                        for _, inputPort in ipairs(component.inputs) do
                            ---@cast inputPort InputPort
                            local wire = inputPort.connection
                            if not wire then
                                goto continue
                            end
                            local srcRef = wire.source:reference()
                            local dstRef = wire.destination:reference()
                            local wireVisual = wire:reference()
                            if srcRef and dstRef and wireVisual then
                                self.frontend:updateWireVisual(
                                    srcRef, dstRef, wire, wireVisual
                                )
                            end
                            ::continue::
                        end
                        for _, outputPort in ipairs(component.outputs) do
                            ---@cast outputPort OutputPort
                            for _, wire in ipairs(outputPort.connections) do
                                local srcRef = wire.source:reference()
                                local dstRef = wire.destination:reference()
                                local wireVisual = wire:reference()
                                if srcRef and dstRef and wireVisual then
                                    self.frontend:updateWireVisual(
                                        srcRef, dstRef, wire, wireVisual
                                    )
                                end
                            end
                        end

                        self.frontend:setDragging(
                            reference,
                            false
                        )
                    end)
            end)
        reference:GetChild("CursorEventArea"):AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyDown,
            function()
                reference:GetChild("CursorEventArea"):AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyUp,
                    function()
                        self:removeComponent(component)
                        return true
                    end)
                return true
            end)
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
        reference:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag,
            function(eventData)
                local dx, dy = eventData:GetUIPosDelta()
                self.frontend:updatePosition(reference, dx, dy)
                local cx, cy = reference:GetAnchoredPosition()
                component:setPosition(cx, cy)
                self.frontend:setDragging(reference, true)
                --BRO WE ALSO NEED TO UPDATE WIRES
                for _, inputPort in ipairs(component.inputs) do
                    ---@cast inputPort InputPort
                    local wire = inputPort.connection
                    if not wire then
                        goto continue
                    end
                    local srcRef = wire.source:reference()
                    local dstRef = wire.destination:reference()
                    local wireVisual = wire:reference()
                    if srcRef and dstRef and wireVisual then
                        self.frontend:updateWireVisual(
                            srcRef, dstRef, wire, wireVisual
                        )
                    end
                    ::continue::
                end
                for _, outputPort in ipairs(component.outputs) do
                    ---@cast outputPort OutputPort
                    for _, wire in ipairs(outputPort.connections) do
                        local srcRef = wire.source:reference()
                        local dstRef = wire.destination:reference()
                        local wireVisual = wire:reference()
                        if srcRef and dstRef and wireVisual then
                            self.frontend:updateWireVisual(
                                srcRef, dstRef, wire, wireVisual
                            )
                        end
                    end
                end
                reference:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorDrag,
                    function(eventData)
                        dx, dy = eventData:GetUIPosDelta()
                        self.frontend:updatePosition(reference, dx, dy)
                        local cx, cy = reference:GetAnchoredPosition()
                        component:setPosition(cx, cy)
                        --BRO WE ALSO NEED TO UPDATE WIRES
                        for _, inputPort in ipairs(component.inputs) do
                            ---@cast inputPort InputPort
                            local wire = inputPort.connection
                            if not wire then
                                goto continue
                            end
                            local srcRef = wire.source:reference()
                            local dstRef = wire.destination:reference()
                            local wireVisual = wire:reference()
                            if srcRef and dstRef and wireVisual then
                                self.frontend:updateWireVisual(
                                    srcRef, dstRef, wire, wireVisual
                                )
                            end
                            ::continue::
                        end
                        for _, outputPort in ipairs(component.outputs) do
                            ---@cast outputPort OutputPort
                            for _, wire in ipairs(outputPort.connections) do
                                local srcRef = wire.source:reference()
                                local dstRef = wire.destination:reference()
                                local wireVisual = wire:reference()
                                if srcRef and dstRef and wireVisual then
                                    self.frontend:updateWireVisual(
                                        srcRef, dstRef, wire, wireVisual
                                    )
                                end
                            end
                        end
                    end)
                reference:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEndDrag,
                    function(eventData)
                        self.frontend:updatePosition(reference, 0, -15)
                        local cx, cy = reference:GetAnchoredPosition()
                        component:setPosition(cx, cy)

                        --BRO WE ALSO NEED TO UPDATE WIRES
                        for _, inputPort in ipairs(component.inputs) do
                            ---@cast inputPort InputPort
                            local wire = inputPort.connection
                            if not wire then
                                goto continue
                            end
                            local srcRef = wire.source:reference()
                            local dstRef = wire.destination:reference()
                            local wireVisual = wire:reference()
                            if srcRef and dstRef and wireVisual then
                                self.frontend:updateWireVisual(
                                    srcRef, dstRef, wire, wireVisual
                                )
                            end
                            ::continue::
                        end
                        for _, outputPort in ipairs(component.outputs) do
                            ---@cast outputPort OutputPort
                            for _, wire in ipairs(outputPort.connections) do
                                local srcRef = wire.source:reference()
                                local dstRef = wire.destination:reference()
                                local wireVisual = wire:reference()
                                if srcRef and dstRef and wireVisual then
                                    self.frontend:updateWireVisual(
                                        srcRef, dstRef, wire, wireVisual
                                    )
                                end
                            end
                        end

                        self.frontend:setDragging(
                            reference,
                            false
                        )
                    end)
            end)
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
        reference:GetChild("CursorEventArea"):AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyDown,
            function()
                reference:GetChild("CursorEventArea"):AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyUp,
                    function()
                        self:removeWire(wire)
                        return true
                    end)
                return true
            end)
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
