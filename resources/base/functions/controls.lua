--load(LoadResourceFile("base", "shared/controls_table.lua"), "shared/controls_table.lua")()

---@param id number
local function GetControlByID(id)
    return Controls[id + 1]
end

---@param key string
local function GetControlByKey(key)
    for _, value in ipairs(Controls) do
        if value.key == key then
            return value
        end
    end
end

---@param name string
local function GetControlByName(name)
    for _, value in ipairs(Controls) do
        if value.name == name then
            return value
        end
    end
end

local functions = {
    ID = GetControlByID,
    KEY = GetControlByKey,
    NAME = GetControlByName
}

---@param by 'ID' | 'KEY' | 'NAME'
---@param control number | string
function GetControl(by, control)
    assert(by == 'ID' or by == 'KEY' or by == 'NAME', '[INVALID ARG] by')
    local control_type = type(control)
    assert((control_type == "number" and 0 <= control and control <= 360) or control_type == "string",
        '[INVALID ARG] control')

    ---@type fun(control: number | string): number
    local func = functions[by]
    return func(control)
end
