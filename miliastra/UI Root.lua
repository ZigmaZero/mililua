local Global = require("miliastra.Global Script")

local page = nil
local M = {}

---@param newPage "CircuitPage" | "LevelPage" | "TitlePage"
function M.switchPage(newPage)
    local uiRoot = game.GetClientUIControl(Global.getUiRootId())
    assert(uiRoot ~= nil)
    if page then
        uiRoot:GetChild(page):SetActive(false)
    end
    page = newPage
    local pageRef = uiRoot:GetChild(newPage)
    assert(pageRef ~= nil, newPage .. " is not in UI root")
    pageRef:SetActive(true)
end

function M.allowSettle()
    script.object:FindChild("TitlePage/ToSettle"):SetActive(true)
end

function M.setPopup(enable, text)
    local uiRoot = game.GetClientUIControl(Global.getUiRootId())
    assert(uiRoot ~= nil)
    uiRoot:GetChild("Popup"):SetActive(enable)
    uiRoot:FindChild("Popup/PopupBounds/PopupText").text = text
end

function OnInit()
    Global.setUiRootId(script.object.id)
    assert(Global.getUiRootId() ~= 0)
    Global.initGame(script.object)
    M.switchPage("TitlePage")
    game.Tween(script.object, {}, 120):SetOnComplete(function ()
        print("Toggling settle")
        M.allowSettle()
    end):Play()
end

return M