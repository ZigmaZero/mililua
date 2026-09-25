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