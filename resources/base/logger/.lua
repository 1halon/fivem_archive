Logger = {}

---@alias colors "white" | "red" | "green" | "yellow" | "blue" | "light_blue" | "purple" | "white2" | "orange" | "grey"
local colors = {
    white = "^0",
    red = "^1",
    green = "^2",
    yellow = "^3",
    blue = "^4",
    light_blue = "^5",
    purple = "^6",
    white2 = "^7",
    orange = "^8",
    blue2 = "^9",
}

---@param color colors
---@param prefix string
local function prefix(color, prefix)
    local code = colors[color or colors.white]

    return prefix and string.format("%s[%s]^0 ", code, prefix) or ""
end

---@param message string
---@param _prefix string
function Logger:error(message, _prefix)
    _prefix = prefix("red", _prefix)
    print(_prefix .. prefix("red", "ERROR") .. message)
end

---@param message string
---@param _prefix string
function Logger:info(message, _prefix)
    _prefix = prefix("light_blue", _prefix)
    print(_prefix .. message)
end

---@param message string
---@param _prefix string
---@param color colors
function Logger:log(message, _prefix, color)
    _prefix = prefix(color, _prefix)
    print(_prefix .. message)
end

---@param message string
---@param _prefix string
function Logger:success(message, _prefix)
    _prefix = prefix("red", _prefix)
    print(_prefix .. message)
end

---@param message string
---@param _prefix string
function Logger:warn(message, _prefix)
    _prefix = prefix("yellow", _prefix)
    print(_prefix .. message)
end
