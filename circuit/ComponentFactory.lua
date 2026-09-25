local ComponentFactory = {
    types = {}
}

function ComponentFactory:register(name, constructor)
    self.types[name] = constructor
end

function ComponentFactory:create(name, id)
    local constructor = self.types[name]

    assert(
        constructor,
        "Unknown component: " .. tostring(name)
    )

    return constructor:new(id)
end

return ComponentFactory