local class = require "core.class"
local PortView = require "frontend.PortView"

local InputPortView = class(PortView)

function InputPortView:isOppositePort(port)
    return port.type == "OUTPUT"
end

return InputPortView