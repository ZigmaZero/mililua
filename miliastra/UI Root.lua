local Global = require("miliastra.Global Script")

local page = nil
local M = {}
M.thisScriptObject = nil
M.canSettle = false

---@param newPage "CircuitPage" | "LevelPage" | "TitlePage"
function M.switchPage(newPage)
    assert(M.thisScriptObject ~= nil)
    if page then
        M.thisScriptObject:GetChild(page):SetActive(false)
    end
    page = newPage
    local pageRef = M.thisScriptObject:GetChild(newPage)
    assert(pageRef ~= nil, newPage .. " is not in UI root")
    pageRef:SetActive(true)
end

function M.setPopup(enable, text)
    M.thisScriptObject:GetChild("Popup"):SetActive(enable)
    M.thisScriptObject:FindChild("Popup/PopupBounds/PopupText").text = text
end

function OnInit()
    M.thisScriptObject = script.object
    assert(M.thisScriptObject ~= nil)
    Global.initGame(M.thisScriptObject)
    M.switchPage("TitlePage")
    game.Tween(M.thisScriptObject, {}, 120):SetOnComplete(function ()
        M.canSettle = true
    end):Play()
end

return M