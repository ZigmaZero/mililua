local CircuitComponentType = require "circuit.components.CircuitComponentType"
local class = "core.class"

local MiliastraFrontend = class()

function MiliastraFrontend:init(uiRoot)
    self.uiRoot = uiRoot
end

-- Object Creation

function MiliastraFrontend:createComponentVisual(component)
    -- TODO:
    -- Create the MiliLua UI object representing this component.
    -- Select the visual based on component:getType().
    -- Parent it to the appropriate UI root/container.
    -- Return the created MiliLua object.
end

function MiliastraFrontend:createWireVisual(wire)
    -- TODO:
    -- Create the MiliLua object(s) used to render a permanent wire.
    -- Return the reference object.
end

function MiliastraFrontend:createTemporaryWireVisual(
    port,
    x,
    y
)
    -- TODO:
    -- Create a temporary wire visual beginning at the port.
    -- Return the reference object.
end

-- Port references 
function MiliastraFrontend:getInputPortReference(
    componentReference,
    index
)
    -- TODO:
    -- Return the MiliLua object representing
    -- the specified input socket.
end

function MiliastraFrontend:getOutputPortReference(
    componentReference,
    index
)
    -- TODO:
    -- Return the MiliLua object representing
    -- the specified output socket.
end

-- Event registration

function MiliastraFrontend:onClick(
    object,
    callback
)
    -- TODO:
    -- Register a MiliLua click listener on object.
end

function MiliastraFrontend:onDragStart(
    object,
    callback
)
    -- TODO:
    -- Register the MiliLua drag-start listener.
end

function MiliastraFrontend:onDrag(
    object,
    callback
)
    -- TODO:
    -- Register the MiliLua drag listener.
    -- Pass cursor coordinates to callback.
end

function MiliastraFrontend:onDragEnd(
    object,
    callback
)
    -- TODO:
    -- Register the MiliLua drag-end listener.
end

function MiliastraFrontend:onRMB(
    object,
    callback
)
    -- TODO:
    -- Register the right-mouse-button listener.
    -- This also registers for shift due to the
    -- Miliastra restriction.
end

-- Object manipulation

function MiliastraFrontend:setPosition(
    object,
    x,
    y
)
    -- TODO:
    -- Set the position of the MiliLua object.
end

function MiliastraFrontend:setDragging(
    object,
    dragging
)
    -- TODO:
    -- Apply any visual state needed while dragging.
end

function MiliastraFrontend:getDropPosition(
    object,
    cursorX,
    cursorY
)
    -- TODO:
    -- Calculate the final position using the
    -- required distance from the cursor center.
    return cursorX, cursorY
end

function MiliastraFrontend:setWireEndPosition(
    object,
    x,
    y
)
    -- TODO:
    -- Move the free end of a temporary wire
    -- to the specified cursor position.
end

function MiliastraFrontend:destroyObject(object)
    -- TODO:
    -- Destroy/remove the associated MiliLua object.
end

-- Port hit testing

function MiliastraFrontend:getHoveredPort(
    x,
    y
)
    -- TODO:
    -- Determine which InputPortView/OutputPortView
    -- is currently underneath the cursor.
    --
    -- Return the associated logical Port,
    -- or nil if no port is hovered.
end