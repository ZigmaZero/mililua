local class = require "core.class"
local PortView = require "frontend.PortView"

local OutputPortView = class(PortView)

function OutputPortView:isOppositePort(port)
    return port.type == "INPUT"
end

return OutputPortView