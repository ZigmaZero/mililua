class = require "core.class"
Port = require "circuit.ports.Port"

---@class OutputPort : Port
---@field new fun(owner, index): OutputPort
local OutputPort = class(Port)

function OutputPort:init(owner, index)
    Port.init(self, owner, index)

    self.connections = {}
end

function OutputPort:connect(wire)
    table.insert(self.connections, wire)
end

return OutputPort