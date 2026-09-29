local class = "core.class"
local ComponentPalette = class()

---@param editor CircuitEditor
---@param frontend MiliastraFrontend
function ComponentPalette:init(editor, frontend)
    self.editor = editor
    self.frontend = frontend

    self.entries = {}
end

function ComponentPalette:refreshComponents(level)
    self.entries = level.allowedComponents
    self.frontend:createPalette(self.entries)
end

return ComponentPalette