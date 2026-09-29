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
    self.frontend:createPalette(self.entries, function (index)
        self.editor:createComponent(self.entries[index], 0, 0)
    end)
end

return ComponentPalette