class = require "core.class"

---@class Port
---@field new fun(owner, index): Port
local Port = class()

---@param owner CircuitComponent
---@param index integer
function Port:init(owner, index)
    self.owner = owner
    self.index = index
    self.value = false
end

---@return boolean
function Port:getValue()
    return self.value
end

---@param value boolean
function Port:setValue(value)
    self.value = value and true or false
end

return Port