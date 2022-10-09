AddEventHandler("playerConnecting",
    ---@param playerName string
    ---@param setKickReason fun(reason: string)
    ---@param deferrals { defer: fun(); done: fun(failureReason?: string); handover: fun(data: table); presentCard: fun(card: string | table, cb?: fun(data: any, rawData: string)); update: fun(message: string) }
    ---@param source string
    function(playerName, setKickReason, deferrals, source)
        local identifiers = GetPIdentifiers(GetPlayerIdentifiers(source))
    end)

AddEventHandler("playerJoining",
    ---@param source string
    ---@param oldID string
    function(source, oldID)

    end)

AddEventHandler('playerDropped',
    ---@param reason string
    function(reason)

    end)

---@param pIdentifiers table
function GetPIdentifiers(pIdentifiers)
    local identifiers = {}
    for _, v in pairs(pIdentifiers) do
        if string.match(v, "discord:") then
            identifiers.discord = string.sub(v, 8)
        elseif string.match(v, "fivem:") then
            identifiers.fivem = string.sub(v, 7)
        elseif string.match(v, "ip:") then
            identifiers.ip = string.sub(v, 3)
        elseif string.match(v, "license:") then
            identifiers.license = string.sub(v, 9)
        elseif string.match(v, "steam:") then
            identifiers.steam = string.sub(v, 7)
        end
    end
    return identifiers
end
