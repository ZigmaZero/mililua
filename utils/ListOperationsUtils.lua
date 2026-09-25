local public = {}

---@return integer
function public.findIndex(list, element)
    for i,v in ipairs(list) do
        if v == element then
            return i
        end
    end
    return 0
end

return public