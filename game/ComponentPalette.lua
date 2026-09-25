local class = "core.class"
local ComponentPalette = class()

function ComponentPalette:init(editor, frontend)
    self.editor = editor
    self.frontend = frontend

    self.entries = {}
end

function ComponentPalette:addComponentType(name)
    local entry =
        self.frontend:createPaletteEntry(name)

    entry:onClick(function()
        self.editor:spawnComponent(name)
    end)

    table.insert(self.entries, entry)
end