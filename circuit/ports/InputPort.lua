class = require "core.class"
Port = require "circuit.ports.Port"

---@class InputPort : Port
---@field new fun(owner, index): InputPort
local InputPort = class(Port)

---@param owner CircuitComponent
---@param index integer
function InputPort:init(owner, index)
    Port.init(self, owner, index)
    self.connection = nil
end

---@param wire Wire
function InputPort:connect(wire)
    self.connection = wire
end

---@return boolean
function InputPort:getValue()
    if not self.connection then
        return false -- TODO: is this self.value?
    end

    return self.connection:getValue()
end

return InputPort