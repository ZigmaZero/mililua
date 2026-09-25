local class = require("core.class")

local View = class()

function View:init(frontend)
    self.frontend = frontend
    self.listeners = {}
end

function View:on(event, callback)
    if not self.listeners[event] then
        self.listeners[event] = {}
    end

    table.insert(self.listeners[event], callback)
end

function View:emit(event, ...)
    local listeners = self.listeners[event]

    if not listeners then
        return
    end

    for _, callback in ipairs(listeners) do
        callback(self, ...)
    end
end

function View:clearListeners(event)
    self.listeners[event] = nil
end

return View