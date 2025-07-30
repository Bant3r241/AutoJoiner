local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local apiUrl = "https://350bf1e33cca.ngrok-free.app/jobid"

while true do
    local success, response = pcall(function()
        return HttpService:GetAsync(apiUrl)
    end)

    if success and response then
        print("[Debug] Raw response: " .. response)

        local data
        local ok = pcall(function()
            data = HttpService:JSONDecode(response)
        end)

        if ok and data and data.jobId then
            local jobId = data.jobId
            print("[✅] Found Job ID:", jobId)

            local player = Players:GetPlayers()[1]  -- Get the first player in the game

            if player then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
                print("[🚀] Teleporting player:", player.Name)
            else
                print("[⚠️] No players currently in game.")
            end

            wait(30)  -- Wait before checking again
        else
            print("[❌] Could not parse valid Job ID.")
        end
    else
        warn("[❌] HTTP request failed:", response)
    end

    wait(5)
end
