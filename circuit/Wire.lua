local class = require "core.class"

---@class Wire
---@field new fun(id: integer, source: OutputPort, destination: InputPort): Wire
local Wire = class()

---@param source OutputPort
---@param destination InputPort
function Wire:init(id, source, destination)
    self.id = id
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