local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- The URL of your Discord webhook (where the Job ID is sent)
local webhookUrl = "https://discordapp.com/api/webhooks/1397903862089650338/khOV2JDnQiuyRD41WCeLLBPAlYydVHsJ5u3QtsC7mjXlQ7yUF4eridY8NSQXUQjyHlvw"

while true do
    -- Fetch the latest messages from the Discord webhook
    local success, content = pcall(function()
        return HttpService:GetAsync(webhookUrl)  -- Fetch the webhook content (JSON response)
    end)

    -- Debugging: Print the raw fetched content
    print("[Debug] Fetched webhook content:", content)

    if success and content and content ~= "" then
        -- Parse the JSON content from the webhook
        local data = HttpService:JSONDecode(content)  -- Decode the JSON response
        
        -- Loop through the embeds to find the Job ID
        local jobId = nil
        for _, embed in pairs(data.embeds) do
            -- Loop through fields inside the embed
            for _, field in pairs(embed.fields) do
                if field.name == "Job ID" then
                    jobId = field.value  -- Extract Job ID from the embed field
                    break
                end
            end

            -- If we found the Job ID, stop looking further
            if jobId then
                break
            end
        end

        -- If Job ID was found, teleport the player
        if jobId then
            print("[Teleport Listener] Found Job ID:", jobId)  -- Debugging print
            local placeId = game.PlaceId  -- Get current place ID

            -- Teleport to the Job ID (server)
            TeleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
            print("[Teleport Listener] Teleporting...")  -- Debugging print
            wait(30)  -- Wait 30 seconds before the next check to avoid multiple teleports
        else
            print("[Teleport Listener] No Job ID found in the embeds.")  -- Debugging print
        end
    else
        print("[Teleport Listener] Failed to fetch or no content from the webhook.")  -- Debugging print
    end

    wait(2)  -- Wait before checking the webhook again
end
