local class = require "core.class"

---@class Wire
---@field new fun(source, destination): Wire
local Wire = class()

---@param source InputPort
---@param destination InputPort
function Wire:init(source, destination)
    self.source = source
    self.destination = destination

    source:connect(self)
    destination:connect(self)
end

function Wire:remove()
    self.source:disconnect(self)
    self.destination:disconnect(self)
end

function Wire:getValue()
    return self.source:getValue()
end

return Wire