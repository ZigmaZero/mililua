local class = "core.class"
local ComponentPalette = class()

function ComponentPalette:init(editor, frontend)
    self.editor = editor
    self.frontend = frontend

    self.entries = {}
end

function ComponentPalette:addComponentType(name)
    local entry =
        self.frontend:createPaletteEntry(name, function()
        self.editor:spawnComponent(name)
    end)

    table.insert(self.entries, entry)
end

return ComponentPalette