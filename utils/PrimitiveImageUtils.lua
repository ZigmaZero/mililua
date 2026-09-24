--- PrimitiveImageUtils module
--- Dependencies: ControlDimensionsUtils

---CONFIG: Template ID of 1x1 Circle Image ClientControl with default settings here
local BASIC_CIRCLE_IMAGE = 1073744698
local ELEMENT_SIZE = 14
local BASE64_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function decode_base64(data)
    if #data % 4 ~= 0 then
        error("Invalid Base64 data length")
    end

    local output = {}
    for offset = 1, #data, 4 do
        local first = string.sub(data, offset, offset)
        local second = string.sub(data, offset + 1, offset + 1)
        local third = string.sub(data, offset + 2, offset + 2)
        local fourth = string.sub(data, offset + 3, offset + 3)
        local value1 = string.find(BASE64_ALPHABET, first, 1, true)
        local value2 = string.find(BASE64_ALPHABET, second, 1, true)
        local value3 = third == "=" and 1 or string.find(BASE64_ALPHABET, third, 1, true)
        local value4 = fourth == "=" and 1 or string.find(BASE64_ALPHABET, fourth, 1, true)

        if value1 == nil or value2 == nil or value3 == nil or value4 == nil then
            error("Invalid Base64 character")
        end

        value1 = value1 - 1
        value2 = value2 - 1
        value3 = value3 - 1
        value4 = value4 - 1

        output[#output + 1] = string.char(value1 * 4 + math.floor(value2 / 16))
        if third ~= "=" then
            output[#output + 1] = string.char((value2 % 16) * 16 + math.floor(value3 / 4))
        end
        if fourth ~= "=" then
            output[#output + 1] = string.char((value3 % 4) * 64 + value4)
        end
    end

    return table.concat(output)
end

local function read_uint16(data, offset)
    local high, low = string.byte(data, offset, offset + 1)
    return high * 256 + low
end

local function read_uint32(data, offset)
    local byte1, byte2, byte3, byte4 = string.byte(data, offset, offset + 3)
    return ((byte1 * 256 + byte2) * 256 + byte3) * 256 + byte4
end

local function read_signed_uint16(data, offset)
    local value = read_uint16(data, offset)
    if value >= 32768 then
        return value - 65536
    end
    return value
end

local function decode_draw_data(drawTable)
    local meta = decode_base64(drawTable.meta)
    local elements = decode_base64(drawTable.elements)
    local width = read_uint32(meta, 1)
    local height = read_uint32(meta, 5)
    local decoded_elements = {}

    for offset = 1, #elements, ELEMENT_SIZE do
        local x = read_signed_uint16(elements, offset) * 4 / 65535 * width
        local y = read_signed_uint16(elements, offset + 2) * 4 / 65535 * height
        local rx = read_signed_uint16(elements, offset + 4) * 4 / 65535 * width
        local ry = read_signed_uint16(elements, offset + 6) * 4 / 65535 * height
        local rotation = read_uint16(elements, offset + 8) * 360 / 65535
        local color = read_uint32(elements, offset + 10)

        decoded_elements[#decoded_elements + 1] = {
            x,
            y,
            rx,
            ry,
            rotation,
            color,
        }
    end

    return width, height, decoded_elements
end

local module = {}

---draws the image under the parent. please ensure the parent actually has a mask to cover the edges.
---@param parent ClientControlType
---@param target_width number
---@param target_height number
function module.DrawImage(parent, drawTable, target_width, target_height)
    local width, height, elements = decode_draw_data(drawTable)
    local scale_x = 1.0
    if type(target_width) == "number" then
        scale_x = target_width / width
    end
    local scale_y = 1.0
    if type(target_height) == "number" then
        scale_y = target_height / height
    end

    -- check current children and remove any non-images
    for index, value in ipairs(parent:GetChildren()) do
        if typeof(value) ~= "ClientUIImageControl" then
            game.DestroyClientUIControl(value)
        end
    end

    while #parent:GetChildren() < #elements do
        local circle = game.InstantiateClientUIControl(BASIC_CIRCLE_IMAGE, parent)
        if (type(circle) == "nil") then
            printerr("FATAL ERROR: Unable to instantiate basic circle image control, please check configured control template id")
            return
        end
    end

    for index, circle in ipairs(parent:GetChildren()) do
        ---@cast circle ClientUIImageControl
        local value = elements[index]
        circle.anchoredPositionX = value[1] * scale_x
        circle.anchoredPositionY = value[2] * scale_y
        circle.localScaleX = value[3] * 2 * scale_x
        circle.localScaleY = value[4] * 2 * scale_y
        circle.localRotationZ = value[5]
        circle.imageColor = value[6]
    end
end

module.imageReferenceTable = {}

---Draw the control before setting I guess
function module.SetImageReference(refId, drawData)
    module.imageReferenceTable[refId] = drawData
    return module.imageReferenceTable[refId]
end

---Copies the imageref and reinstantiates its children
function module.GetImageReference(refId)
    return module.imageReferenceTable[refId]
end

---Ez function for just doing everything haphazardly in this library
function module.RegisterAndDrawImage(parent, drawData, refId, target_width, target_height)
    if module.imageReferenceTable[refId] == nil then
        module.imageReferenceTable[refId] = drawData
    end
    module.DrawImage(parent, drawData, target_width, target_height)
end

return module