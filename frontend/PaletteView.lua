local class = require("core.class")
local View = require("frontend.View")

local PaletteView = class(View)

function PaletteView:init(componentType, frontend, reference, editor)
    View.init(self, frontend)

    self.componentType = componentType
    self.reference = reference
    self.editor = editor

    self.draggedComponent = nil

    self:_bindListeners()
end

function PaletteView:_bindListeners()
    self.frontend:onClick(
        self.reference,
        function(x, y)
            self:onClick()
        end
    )

    self.frontend:onDragStart(
        self.reference,
        function(x, y)
            self:onDragStart(x, y)
        end
    )

    self.frontend:onDrag(
        self.reference,
        function(x, y)
            self:onDrag(x, y)
        end
    )

    self.frontend:onDragEnd(
        self.reference,
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

return PaletteView