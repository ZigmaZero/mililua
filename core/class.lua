-- class.lua

local function class(base)
    local cls = {}
    cls.__index = cls

    if base then
        setmetatable(cls, {
            __index = base
        })
    end

    function cls.new(...)
        local obj = setmetatable({}, cls)

        if obj.init then
            obj:init(...)
        end

        return obj
    end

    return cls
end

return class