local current_version = GetConvar("version")
PerformHttpRequest(
    GetConvar("version_check"),
    function(status, body, headers)
        if tonumber(status) == 200 then
            local data = json.encode(body)
            if data then
                local latest_version = data.tag_name
                if current_version ~= latest_version then
                    print(("halon-fivem isn't up to date! Please update to version %s"):format(latest_version))
                end
            end
        end
    end,
    "GET",
    nil,
    {["User-Agent"] = ("halon-fivem-%s"):format(current_version)}
)
