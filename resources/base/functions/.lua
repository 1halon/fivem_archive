---@param resource string
---@param file string
---@return string
function LoadLuaFile(resource, file)
    local file_content = LoadResourceFile(resource, file)
    load(file_content, file)()
    return file_content
end
