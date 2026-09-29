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

    self:_bindListeners()
end

function PaletteView:_bindListeners()
    self.frontend:onClick(
        game.GetClientUIControl(self.referenceId),
        function(x, y)
            self:onClick()
        end
    )

    self.frontend:onDragStart(
        game.GetClientUIControl(self.referenceId),
        function(x, y)
            self:onDragStart(x, y)
        end
    )

    self.frontend:onDrag(
        game.GetClientUIControl(self.referenceId),
        function(x, y)
            self:onDrag(x, y)
        end
    )

    self.frontend:onDragEnd(
        game.GetClientUIControl(self.referenceId),
        function(x, y)
            self:onDragEnd(x, y)
        end
    )
end

function PaletteView:onClick()
    self.editor:createComponent(
        self.componentType,
        0,
        0
    )
end

function PaletteView:onDragStart(x, y)
    self.draggedComponent =
        self.editor:createComponent(
            self.componentType,
            0,
            0
        )

    self.draggedComponent:onDragStart(
        x,
        y
    )
end

function PaletteView:onDrag(x, y)
    if not self.draggedComponent then
        return
    end

    self.draggedComponent:onDrag(x, y)
end

function PaletteView:onDragEnd(x, y)
    if not self.draggedComponent then
        return
    end

    self.draggedComponent:onDragEnd(x, y)

    self.draggedComponent = nil
end

function PaletteView:destroy()
    self.frontend:destroyObject(self.reference)
end

return PaletteView