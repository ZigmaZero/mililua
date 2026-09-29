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

    self.activePort = nil
    self.hoveringPort = nil
    self.temporaryWireView = nil
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

function CircuitEditor:getPortPosition(control)
    local ax, ay = control:GetAnchoredPosition()
    local bx, by = control.parent:GetAnchoredPosition()
    local cx, cy = control.parent.parent:GetAnchoredPosition()
    return ax + bx + cx, ay + by + cy
end

function CircuitEditor:getComponentPort(portData)
    local component = self.componentViews[portData.id]
    if not component then
        return nil, nil, nil
    end

    if portData.inOut == "out" then
        return component, component.outputs[portData.port], component:reference()
    end

    return component, component.inputs[portData.port], component:reference()
end

function CircuitEditor:finishPortDrag()
    local sourceData = self.activePort
    local destinationData = self.hoveringPort
    self.activePort = nil

    if not sourceData or not destinationData then
        self.temporaryWireView = nil
        return
    end

    local _, sourcePort, sourceReference = self:getComponentPort(sourceData)
    local _, destinationPort, destinationReference = self:getComponentPort(destinationData)
    if not sourcePort or not destinationPort then
        self.temporaryWireView = nil
        return
    end

    if not self:isOppositePortPair(sourcePort, destinationPort) then
        self.temporaryWireView = nil
        return
    end

    local wire = self:connectPorts(sourcePort, destinationPort)
    if wire and sourceReference and destinationReference then
        self.temporaryWireView = nil
    end
end

function CircuitEditor:registerPortListeners(component, reference, inOut, count)
    local pinGroup = inOut == "in" and "InputPins" or "OutputPins"
    reference:GetChild(pinGroup):RefreshItems(count, function(control, index)
        local portIndex = index + 1
        local cursorEventArea = control:GetChild("CursorEventArea")

        cursorEventArea:AddCursorEventListener(
            Enum.CursorEventType.CursorEnter,
            function()
                self.hoveringPort = {
                    id = component.id,
                    inOut = inOut,
                    port = portIndex
                }
            end
        )

        cursorEventArea:AddCursorEventListener(
            Enum.CursorEventType.CursorExit,
            function()
                self.hoveringPort = nil
            end
        )

        cursorEventArea:AddCursorEventListener(
            Enum.CursorEventType.CursorBeginDrag,
            function(eventData)
                self.activePort = {
                    id = component.id,
                    inOut = inOut,
                    port = portIndex
                }
                local x, y = self:getPortPosition(control)
                local dx, dy = eventData:GetUIPos()
                local visual = self.frontend:createTemporaryWireVisual(
                    reference,
                    portIndex,
                    x + dx,
                    y + dy
                )
                self.temporaryWireView = visual and visual.id or nil
            end
        )

        cursorEventArea:AddCursorEventListener(
            Enum.CursorEventType.CursorDrag,
            function(eventData)
                if not self.activePort or not self.temporaryWireView then
                    return
                end
                local x, y = self:getPortPosition(control)
                local dx, dy = eventData:GetUIPosDelta()
                local visual = game.GetClientUIControl(self.temporaryWireView)
                if visual then
                    self.frontend:updateTemporaryWireVisual(
                        reference,
                        self.activePort.port,
                        x + dx,
                        y + dy,
                        visual
                    )
                end
            end
        )

        cursorEventArea:AddCursorEventListener(
            Enum.CursorEventType.CursorEndDrag,
            function()
                self:finishPortDrag()
            end
        )
    end)
    end

function CircuitEditor:registerComponentPortListeners(component, reference)
    self:registerPortListeners(component, reference, "in", #component.inputs)
    self:registerPortListeners(component, reference, "out", #component.outputs)
end

function CircuitEditor:createComponent(componentType, x, y)
    local component = self.circuit:addComponent(componentType)
    component:setPosition(x, y)

    local reference = self.frontend:createComponentVisual(component, x, y)
    component:setReference(reference)

    if reference then
        self:registerComponentListeners(component, reference)
        self:registerDeleteListener(
            reference:GetChild("CursorEventArea"),
            function()
                self:removeComponent(component)
            end
        )
        self:registerComponentPortListeners(component, reference)
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
    local component
    if componentType == "INPUT" then
        component = self.circuit:addInputNode(name)
    else
        component = self.circuit:addOutputNode(name)
    end

    component:setPosition(x, y)
    local reference = self.frontend:createComponentVisual(component, x, y)
    component:setReference(reference)

    if reference then
        self:registerComponentListeners(component, reference)
        self:registerDeleteListener(
            reference:GetChild("CursorEventArea"),
            function()
                self:removeComponent(component)
            end
        )
        self:registerComponentPortListeners(component, reference)
    end

    self.componentViews[component.id] = component
    return component
end

--[[
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

        self:registerPortListeners(component, reference, "in", #component.inputs)
        self:registerPortListeners(component, reference, "out", #component.outputs)
        local inputs = #component.inputs
        reference:GetChild("InputPins"):RefreshItems(inputs, function(control, index)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEnter,
                function(eventData)
                    self.hoveringPort = {
                        id = component.id,
                        inOut = "in",
                        port = index + 1
                    }
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorExit,
                function(eventData)
                    self.hoveringPort = nil
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag,
                function(eventData)
                    self.activePort = {
                        id = component.id,
                        inOut = "in",
                        port = index + 1
                    }
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- make temporaryWireView
                    local dx, dy = eventData:GetUIPos()
                    self.temporaryWireView = self.frontend:createTemporaryWireVisual(reference, self.activePort.port,
                        ex + dx, ey + dy).id
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorDrag,
                function(eventData)
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- update temporaryWireView
                    local dx, dy = eventData:GetUIPosDelta()
                    self.frontend:updateTemporaryWireVisual(reference, self.activePort.port, ex + dx, ey + dy, game.GetClientUIControl(self.temporaryWireView))
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEndDrag,
                function(eventData)
                    local sourceData = self.activePort
                    local sourceComponent = self.componentViews[sourceData.id]
                    ---@cast sourceComponent CircuitComponent
                    local sourceRef = sourceComponent:reference()
                    local sourcePort = nil
                    if sourceData.inOut == "out" then
                        sourcePort = sourceComponent.outputs[sourceData.port]
                    else
                        sourcePort = sourceComponent.inputs[sourceData.port]
                    end
                    local destData = self.hoveringPort
                    local destComponent = self.componentViews[destData.id]
                    local destRef = destComponent:reference()
                    local destPort = nil
                    if destData.inOut == "out" then
                        destPort = sourceComponent.outputs[destData.port]
                    else
                        destPort = sourceComponent.inputs[destData.port]
                    end

                    if not self:isOppositePortPair(sourcePort, destPort) then return end

                    local wire = nil
                    if sourcePort.type == "out" then
                        wire = self.circuit:connect(sourcePort, destPort)
                    else
                        wire = self.circuit:connect(destPort, sourcePort)
                    end

                    self.frontend:createWireVisual(sourceRef, destRef, wire)

                    self.temporaryWireView = nil
                end)
        end)
        local outputs = #component.outputs
        reference:GetChild("OutputPins"):RefreshItems(outputs, function(control, index)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEnter,
                function(eventData)
                    self.hoveringPort = {
                        id = reference.id,
                        inOut = "out",
                        port = index + 1
                    }
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorExit,
                function(eventData)
                    self.hoveringPort = nil
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag,
                function(eventData)
                    self.activePort = {
                        id = component.id,
                        inOut = "out",
                        port = index + 1
                    }
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- make temporaryWireView
                    local dx, dy = eventData:GetUIPos()
                    self.temporaryWireView = self.frontend:createTemporaryWireVisual(reference, self.activePort.port,
                        ex + dx, ey + dy).id
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorDrag,
                function(eventData)
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- update temporaryWireView
                    local dx, dy = eventData:GetUIPosDelta()
                    self.frontend:updateTemporaryWireVisual(reference, self.activePort.port, ex + dx, ey + dy, game.GetClientUIControl(self.temporaryWireView))
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEndDrag,
                function(eventData)
                    local sourceData = self.activePort
                    local sourceComponent = self.componentViews[sourceData.id]
                    ---@cast sourceComponent CircuitComponent
                    local sourceRef = sourceComponent:reference()
                    local sourcePort = nil
                    if sourceData.inOut == "out" then
                        sourcePort = sourceComponent.outputs[sourceData.port]
                    else
                        sourcePort = sourceComponent.inputs[sourceData.port]
                    end
                    local destData = self.hoveringPort
                    local destComponent = self.componentViews[destData.id]
                    local destRef = destComponent:reference()
                    local destPort = nil
                    if destData.inOut == "out" then
                        destPort = sourceComponent.outputs[destData.port]
                    else
                        destPort = sourceComponent.inputs[destData.port]
                    end

                    if not self:isOppositePortPair(sourcePort, destPort) then return end

                    local wire = nil
                    if sourcePort.type == "out" then
                        wire = self.circuit:connect(sourcePort, destPort)
                    else
                        wire = self.circuit:connect(destPort, sourcePort)
                    end

                    self.frontend:createWireVisual(sourceRef, destRef, wire)

                    self.temporaryWireView = nil
                end)
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
        self:registerComponentListeners(component, reference)

        local inputs = #component.inputs
        reference:GetChild("InputPins"):RefreshItems(inputs, function(control, index)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEnter,
                function(eventData)
                    self.hoveringPort = {
                        id = component.id,
                        inOut = "in",
                        port = index + 1
                    }
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorExit,
                function(eventData)
                    self.hoveringPort = nil
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag,
                function(eventData)
                    self.activePort = {
                        id = component.id,
                        inOut = "in",
                        port = index + 1
                    }
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- make temporaryWireView
                    local dx, dy = eventData:GetUIPos()
                    self.temporaryWireView = self.frontend:createTemporaryWireVisual(reference, self.activePort.port,
                        ex + dx, ey + dy).id
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorDrag,
                function(eventData)
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- update temporaryWireView
                    local dx, dy = eventData:GetUIPosDelta()
                    self.frontend:updateTemporaryWireVisual(reference, self.activePort.port, ex + dx, ey + dy, game.GetClientUIControl(self.temporaryWireView))
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEndDrag,
                function(eventData)
                    local sourceData = self.activePort
                    local sourceComponent = self.componentViews[sourceData.id]
                    ---@cast sourceComponent CircuitComponent
                    local sourceRef = sourceComponent:reference()
                    local sourcePort = nil
                    if sourceData.inOut == "out" then
                        sourcePort = sourceComponent.outputs[sourceData.port]
                    else
                        sourcePort = sourceComponent.inputs[sourceData.port]
                    end
                    local destData = self.hoveringPort
                    local destComponent = self.componentViews[destData.id]
                    local destRef = destComponent:reference()
                    local destPort = nil
                    if destData.inOut == "out" then
                        destPort = sourceComponent.outputs[destData.port]
                    else
                        destPort = sourceComponent.inputs[destData.port]
                    end

                    if not self:isOppositePortPair(sourcePort, destPort) then return end

                    local wire = nil
                    if sourcePort.type == "out" then
                        wire = self.circuit:connect(sourcePort, destPort)
                    else
                        wire = self.circuit:connect(destPort, sourcePort)
                    end

                    self.frontend:createWireVisual(sourceRef, destRef, wire)

                    self.temporaryWireView = nil
                end)
        end)
        local outputs = #component.outputs
        reference:GetChild("OutputPins"):RefreshItems(outputs, function(control, index)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEnter,
                function(eventData)
                    self.hoveringPort = {
                        id = reference.id,
                        inOut = "out",
                        port = index + 1
                    }
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorExit,
                function(eventData)
                    self.hoveringPort = nil
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorBeginDrag,
                function(eventData)
                    self.activePort = {
                        id = component.id,
                        inOut = "out",
                        port = index + 1
                    }
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- make temporaryWireView
                    local dx, dy = eventData:GetUIPos()
                    self.temporaryWireView = self.frontend:createTemporaryWireVisual(reference, self.activePort.port,
                        ex + dx, ey + dy).id
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorDrag,
                function(eventData)
                    local ax, ay = control:GetAnchoredPosition()             -- Anchor to GridScroller
                    local bx, by = control.parent:GetAnchoredPosition()      -- Anchor to CircuitComponent
                    local cx, cy = control.parent.parent:GetAnchoredPosition() -- Anchor to CircuitArea
                    -- = Position relative to CircuitArea
                    local ex = ax + bx + cx
                    local ey = ay + by + cy
                    -- update temporaryWireView
                    local dx, dy = eventData:GetUIPosDelta()
                    self.frontend:updateTemporaryWireVisual(reference, self.activePort.port, ex + dx, ey + dy, game.GetClientUIControl(self.temporaryWireView))
                end)
            control:GetChild("CursorEventArea"):AddCursorEventListener(Enum.CursorEventType.CursorEndDrag,
                function(eventData)
                    local sourceData = self.activePort
                    local sourceComponent = self.componentViews[sourceData.id]
                    ---@cast sourceComponent CircuitComponent
                    local sourceRef = sourceComponent:reference()
                    local sourcePort = nil
                    if sourceData.inOut == "out" then
                        sourcePort = sourceComponent.outputs[sourceData.port]
                    else
                        sourcePort = sourceComponent.inputs[sourceData.port]
                    end
                    local destData = self.hoveringPort
                    local destComponent = self.componentViews[destData.id]
                    local destRef = destComponent:reference()
                    local destPort = nil
                    if destData.inOut == "out" then
                        destPort = sourceComponent.outputs[destData.port]
                    else
                        destPort = sourceComponent.inputs[destData.port]
                    end

                    if not self:isOppositePortPair(sourcePort, destPort) then return end

                    local wire = nil
                    if sourcePort.type == "out" then
                        wire = self.circuit:connect(sourcePort, destPort)
                    else
                        wire = self.circuit:connect(destPort, sourcePort)
                    end

                    self.frontend:createWireVisual(sourceRef, destRef, wire)

                    self.temporaryWireView = nil
                end)
        end)
    end

    self.componentViews[component.id] = component

    return component
end
]]

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

    if source.type == "in" then
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
        a.type == "out" and
        b.type == "in"
    ) or (
        a.type == "in" and
        b.type == "out"
    )
end

return CircuitEditor
