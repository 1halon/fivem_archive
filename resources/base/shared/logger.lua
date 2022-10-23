---@alias colors 'white' | 'red' | 'green' | 'yellow' | 'blue' | 'light_blue' | 'purple' | 'white2' | 'orange' | 'grey' | number
local colors = {
    [0] = '^0', -- white
    [1] = '^1', -- red
    [2] = '^2', -- green
    [3] = '^3', -- yellow
    [4] = '^4', -- blue
    [5] = '^5', -- light_blue
    [6] = '^6', -- purple
    [7] = '^7', -- white2
    [8] = '^8', -- orange
    [9] = '^9', -- blue2
    white = '^0',
    red = '^1',
    green = '^2',
    yellow = '^3',
    blue = '^4',
    light_blue = '^5',
    purple = '^6',
    white2 = '^7',
    orange = '^8',
    blue2 = '^9',
}

Logger = {
    colors = colors
}

---@param text string
---@param color colors | nil
function Logger.colorize(text, color)
    return string.format('%s%s%s ', colors[color or 'white'], text, colors.white) or text
end

---@param prefix string
---@param color colors | nil
---@alias prefix { color: colors, prefix: string }
function Logger.prefix(prefix, color)
    return Logger.colorize(string.format('[%s]', prefix), color)
end

---@param message string
---@vararg prefix
function Logger.log(message, ...)
    local out = ''
    local args = table.pack(...)
    if #args > 0 then
        for i = 1, args.n do
            ---@type { color: colors, prefix: string }
            local prefix = args[i]
            out = out .. Logger.prefix(prefix.prefix, prefix.color)
        end
    end
    out = out .. message

    print(out)
    return out
end

---@param message string
---@param ... prefix
function Logger.error(message, ...)
    return Logger.log(message, { color = "red", prefix = "ERROR" }, ...)
end

---@param message string
---@param ... prefix
function Logger.info(message, ...)
    return Logger.log(message, { color = "blue", prefix = "INFO" }, ...)
end

---@param message string
---@param ... prefix
function Logger.success(message, ...)
    return Logger.log(message, { color = "green", prefix = "SUCCESS" }, ...)
end

---@param message string
---@param ... prefix
function Logger.verbose(message, ...)
    return Logger.log(message, { color = "purple", prefix = "VERBOSE" }, ...)
end

---@param message string
---@param ... prefix
function Logger.warn(message, ...)
    return Logger.log(message, { color = "yellow", prefix = "WARNING" }, ...)
end

Logger.info("INITIALIZED", { color = "yellow", prefix = "LOGGER" })
