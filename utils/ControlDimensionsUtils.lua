--- ControlDimensionsUtils module
--- Dependencies: -

local public = {}

function public.getUnscaledWidth(control)
    if (control == nil) then
        local w, _ = game.GetUICanvasSize();
        return w;
    elseif (control.anchorMinX == control.anchorMaxX) then
        return control.sizeDeltaX;
    else
        return (public.getUnscaledWidth(control.parent) * (control.anchorMaxX - control.anchorMinX)) + control.sizeDeltaX;
    end
end

function public.getUnscaledMinWidth(control)
    if (control == nil) then
        return 0;
    else
        return public.getUnscaledWidth(control.parent) * control.anchorMinX;
    end
end

function public.getUnscaledMaxWidth(control)
    if (control == nil) then
        return public.getUnscaledWidth(nil);
    else
        return public.getUnscaledWidth(control.parent) * control.anchorMaxX;
    end
end

function public.getUnscaledHeight(control)
    if (control == nil) then
        local _, h = game.GetUICanvasSize();
        return h;
    elseif (control.anchorMinY == control.anchorMaxY) then
        return control.sizeDeltaY;
    else
        return (public.getUnscaledHeight(control.parent) * (control.anchorMaxY - control.anchorMinY)) + control.sizeDeltaY;
    end
end

function public.getUnscaledMinHeight(control)
    if (control == nil) then
        return 0;
    else
        return public.getUnscaledHeight(control.parent) * control.anchorMinY;
    end
end

function public.getUnscaledMaxHeight(control)
    if (control == nil) then
        return public.getUnscaledHeight(nil);
    else
        return public.getUnscaledHeight(control.parent) * control.anchorMaxY;
    end
end

return public