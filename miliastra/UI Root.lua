local Global = require("miliastra.Global Script")

local page = nil
local root = script.object

assert(type(root) ~= "nil")

local M = {}
M.canSettle = false

---@param newPage "CircuitPage" | "LevelPage" | "TitlePage"
function M.switchPage(newPage)
    if page then
        root:GetChild(page):SetActive(false)
    end
    page = newPage
    root:GetChild(page):SetActive(true)
end

function M.setPopup(enable, text)
    root:GetChild("Popup"):SetActive(enable)
    root:FindChild("Popup/PopupBounds/PopupText").text = text
end

function OnInit()
    Global.initGame(root)
    M.switchPage("TitlePage")
    game.Tween(root, {}, 120):SetOnComplete(function ()
        M.canSettle = true
    end):Play()
end

return M