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

---@param list any[]
---@param filterIndices table<integer, boolean>
---@return any[] filtered
function public.filterList(list, filterIndices)
    local filtered = {}
    for i,v in ipairs(list) do
        if not filterIndices[i] then
            table.insert(filtered, v)
        end
    end
    return filtered
end

return public