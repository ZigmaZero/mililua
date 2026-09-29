local PaletteView = require "frontend.PaletteView"
local class = "core.class"
local ComponentPalette = class()

---@param editor CircuitEditor
---@param frontend MiliastraFrontend
function ComponentPalette:init(editor, frontend)
    self.editor = editor
    self.frontend = frontend

    self.entries = {}
    self.paletteViews = {}
end

function ComponentPalette:refreshComponents(level)
    self.entries = level.allowedComponents
    local paletteReferenceSequence = self.frontend:createPalette(self.entries, function (index)
        self.editor:createComponent(self.entries[index], 0, 0)
    end)

    if not paletteReferenceSequence then
        return
    end

    for index, value in ipairs(paletteReferenceSequence) do
        PaletteView.new(self.entries[index], self.frontend, value, self.editor)
    end
end

return ComponentPalette