local class = require("core.class")
local View = require("frontend.View")

local PaletteView = class(View)

---@param componentType string
---@param frontend MiliastraFrontend
---@param reference ClientControlType
---@param editor CircuitEditor
function PaletteView:init(componentType, frontend, reference, editor)
    View.init(self, frontend)

    self.componentType = componentType
    self.frontend = frontend
    self.referenceId = reference.id
    self.editor = editor

    self.draggedComponent = nil
end

function PaletteView:destroy()
    self.frontend:destroyObject(self.reference)
end

return PaletteView