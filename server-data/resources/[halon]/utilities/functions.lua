function DrawHelp(opts, p1)
    BeginTextCommandDisplayHelp(opts.label or "STRING")
    if type(p1) == "function" then
        p1()
    end
    EndTextCommandDisplayHelp(0, false, opts.beep or false, opts.duration or -1)
end

function DrawText(opts, p1)
    BeginTextCommandDisplayText(opts.label or "STRING")
    SetTextColour(255, 255, 255, 255)
    SetTextScale(1.0, 0.5)
    --SetTextCentre(true)
    --SetTextJustification(0)
    if type(p1) == "function" then
        p1()
    end
    EndTextCommandDisplayText(opts.x and (opts.x + 0.0) or 0.0, opts.y and (opts.y + 0.0) or 0.0)
end

function DrawText2(opts, p1)
    BeginTextCommandPrint(opts.label or "STRING")
    if type(p1) == "function" then
        p1()
    end
    EndTextCommandPrint(opts.duration or 5000, true)
end

function FeedPostTicker(type, opts, pedID)
    BeginTextCommandThefeedPost(opts.label or "STRING")
    AddTextComponentSubstringPlayerName(opts.text)
    if type == "MESSAGE_TEXT" or type == "STATS" then
        Citizen.CreateThread(
            function()
                local headshot = RegisterPedheadshot(pedID or PlayerPedId())
                while not IsPedheadshotReady(headshot) or not IsPedheadshotValid(headshot) do
                    Citizen.Wait(0)
                end
                local txd = GetPedheadshotTxdString(headshot)
                if type == "MESSAGE_TEXT" then
                    post =
                        EndTextCommandThefeedPostMessagetext(
                        txd,
                        txd,
                        false,
                        0,
                        GetPlayerName(PlayerId()),
                        "New Message"
                    )
                elseif type == "STATS" then
                    post = EndTextCommandThefeedPostStats(opts.text, 14, opts.newStats, opts.oldStats, false, txd, txd)
                end
                EndTextCommandThefeedPostTicker(opts.blink or false, opts.showInBrief or false)
                UnregisterPedheadshot(headshot)
            end
        )
    elseif type == "NOTIFICATION" then
        post = EndTextCommandThefeedPostTicker(opts.blink or false, opts.showInBrief or false)
    end
    if opts.timeout then
        Citizen.CreateThread(
            function()
                while true do
                    if post then
                        Citizen.Wait(opts.timeout * 1000)
                        ThefeedRemoveItem(post)
                        break
                    else
                        Citizen.Wait(0)
                    end
                end
            end
        )
    end
    return post
end

function GetControlKey(key)
    local keys = {
        ["PAGEUP"] = 10,
        ["PAGEDOWN"] = 11,
        ["LEFT ALT"] = 19,
        ["LEFT SHIFT"] = 21,
        ["SPACEBAR"] = 22,
        ["F"] = 23
    }
    return keys[key]
end

function GetClosestPlayer(radius)
    local dists = GetNearbyPlayers(radius)
    return dists[#dists]
end

function GetNearbyPlayers(radius)
    local player, ped, players = PlayerId(), PlayerPedId(), GetActivePlayers()
    local coords = GetEntityCoords(ped)
    local dists = {}
    for _, _player in ipairs(players) do
        local player_ped = GetPlayerPed(_player)
        local dist = Vdist2(coords, GetEntityCoords(player_ped))
        if _player == player or dist > radius then
            return
        end
        dists[#dists + 1] = {ped = player_ped, dist = dist}
    end
    table.sort(
        dists,
        function(a, b)
            return a.dist < b.dist
        end
    )
    return dists
end

function LoadAnimDict(animDict)
    if DoesAnimDictExist(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end
    end
    return animDict
end

function LoadModel(model)
    local hash = GetHashKey(model)
    LoadModelWithHash(hash)
    return hash, model
end

function LoadModelWithHash(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    return hash
end

exports("DrawHelp", DrawHelp)
exports("DrawText", DrawText)
exports("FeedPostTicker", FeedPostTicker)
exports("GetControlKey", GetControlKey)
exports("GetClosestPlayer", GetClosestPlayer)
exports("GetNearbyPlayers", GetNearbyPlayers)
exports("LoadAnimDict", LoadAnimDict)
exports("LoadModel", LoadModel)
