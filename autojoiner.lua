local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- ✅ Replace with your ngrok URL
local apiUrl = "https://350bf1e33cca.ngrok-free.app/jobid"

while true do
    local success, response = pcall(function()
        return HttpService:GetAsync(apiUrl)
    end)

    if success and response then
        print("[Debug] Raw response: " .. response)

        local data
        local ok, err = pcall(function()
            data = HttpService:JSONDecode(response)
        end)

        if ok and data and data.jobId then
            local jobId = data.jobId
            print("[✅] Found Job ID:", jobId)

            -- Make sure there's a player to teleport
            local player = Players.LocalPlayer or Players:GetPlayers()[1]
            if player then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
                print("[🚀] Teleporting to Job ID:", jobId)
            else
                print("[⚠️] No local player found to teleport.")
            end

            wait(30)  -- Delay before checking again
        else
            print("[❌] Failed to parse job ID from API.")
        end
    else
        print("[❌] Failed to fetch Job ID. Error:", response)
    end

    wait(5)  -- Polling interval
end
