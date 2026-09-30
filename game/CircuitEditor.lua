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

    self.sourcePort = nil
    self.destinationPort = nil
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
    local sourcePort = self.sourcePort
    local destinationPort = self.destinationPort
    self.sourcePort = nil
    self.destinationPort = nil

    if not sourcePort or not destinationPort then
        return
    end

    local sourceRef = sourcePort:reference()
    local destRef = destinationPort:reference()
    if not sourceRef then
        return
    end

    sourceRef:GetChild("VFX"):SetVisible(false)

    if not destRef then
        return
    end

    if not self:isOppositePortPair(sourcePort, destinationPort) then
        return
    end

    local inputPort = sourcePort.type == "in" and sourcePort or destinationPort
    ---@cast inputPort InputPort
    if inputPort.connection then
        self.frontend:destroyObject(inputPort.connection:reference())
        self.circuit:disconnect(inputPort.connection)
    end

    local wire = self:connectPorts(sourcePort, destinationPort)
end

function CircuitEditor:registerPortListeners(component, reference, inOut, count)
    local pinGroup = inOut == "in" and "InputPins" or "OutputPins"
    local pinsRef = reference:GetChild(pinGroup)
    for i = 1, 3 do
        local childName = "Pin" .. i
        local control = pinsRef:GetChild(childName)
        control:SetVisible(i <= count)
        if i <= count then
            local port = component[inOut == "in" and "inputs" or "outputs"][i]
            port:setReference(control)
            local cursorEventArea = control:GetChild("CursorEventArea")
            cursorEventArea:AddCursorEventListener(
                Enum.CursorEventType.CursorClick,
                function()
                    if not self.sourcePort then
                        self.sourcePort = port
                        control:GetChild("VFX"):SetVisible(true)
                        return
                    end
                    self.destinationPort = port
                    self:finishPortDrag()
                end
            )
        end
    end
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
    local control = component:reference()
    if not control then
        return
    end
    game.DestroyClientUIControl(control)
end

function CircuitEditor:removeWire(wire)
    self.wireViews[wire.id] = nil
    self.circuit:disconnect(wire)
    local control = wire:reference()
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
        -- Since this is a Input/Output node, we have to say what the name is
        reference:GetChild("TextBoxControl").text = name

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

function CircuitEditor:wireRecursiveRegisterDeleteListener(control, keyup, keydown)
    if not control then
        return
    end
    for _, value in ipairs(control:GetChildren()) do
        if typeof(value) == "ClientUIImageControl" and value.name == "Wire" then
            ---@cast value ClientUIImageControl
            -- make cursoreventarea
            local cea = game.InstantiateClientUIControl(1073741967, control)
            cea:SetAnchoredPosition(value:GetAnchoredPosition())
            cea:SetAnchorMax(value:GetAnchorMax())
            cea:SetAnchorMin(value:GetAnchorMin())
            cea:SetLocalRotation(value:GetLocalRotation())
            cea:SetLocalScale(value:GetLocalScale())
            cea:SetPivot(value:GetPivot())
            cea:SetSizeDelta(value:GetSizeDelta())
            cea:AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyUp, keyup)
            cea:AddKeyEventListener(Enum.KeyEventType.KeyboardSprintKeyDown, keydown)
        end
        self:wireRecursiveRegisterDeleteListener(value, keyup, keydown)
    end
end

function CircuitEditor:wireRegisterDeleteListener(control, callback)
    local deleteRequested = false
    self:wireRecursiveRegisterDeleteListener(control,
        function()
            deleteRequested = true
            return true
        end,
        function()
            if deleteRequested then
                deleteRequested = false
                callback()
            end
            return true
        end
    )
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

    local outputRef = output:reference()
    local inputRef = input:reference()

    local reference =
        self.frontend:createWireVisual(
            outputRef,
            inputRef,
            wire
        )

    wire:setReference(reference)

    if reference then
        self:wireRegisterDeleteListener(
            reference,
            function()
                self:removeWire(wire)
            end
        )
    end

    self.wireViews[wire.id] = wire

    -- just... start jiggling the components slightly.
    self:moveComponent(source.owner, source.owner:reference(), 0, 0)
    self:moveComponent(destination.owner, destination.owner:reference(), 0, 0)

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
