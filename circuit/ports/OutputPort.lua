local class = require "core.class"
local Port = require "circuit.ports.Port"
local findIndex = require("utils.ListOperationsUtils").findIndex

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

function OutputPort:disconnect(wire)
    local i = findIndex(self.connections, wire)
    if i > 0 then
        table.remove(self.connections, i)
    end
end

return OutputPort