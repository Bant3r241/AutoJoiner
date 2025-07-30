local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- The URL of your Discord webhook (where the Job ID is sent)
local webhookUrl = "https://discordapp.com/api/webhooks/1397903862089650338/khOV2JDnQiuyRD41WCeLLBPAlYydVHsJ5u3QtsC7mjXlQ7yUF4eridY8NSQXUQjyHlvw"

while true do
    -- Fetch the latest messages from the Discord webhook
    local success, content = pcall(function()
        return HttpService:GetAsync(webhookUrl)  -- Fetch the webhook content (raw JSON response)
    end)

    if success and content then
        -- Debugging: Print the raw fetched content
        print("[Debug] Fetched webhook content: " .. content)

        -- Check if the content is empty
        if content == "" then
            print("[Error] No content found from webhook.")
        else
            -- Decode JSON content
            local data = HttpService:JSONDecode(content)  -- Decode JSON response
            
            -- Debugging: Print the decoded data to inspect its structure
            print("[Debug] Decoded webhook data: ", HttpService:JSONEncode(data))  -- Print the entire decoded JSON

            -- Initialize jobId as nil
            local jobId = nil

            -- Loop through the embeds array to find the Job ID field
            for _, embed in pairs(data.embeds) do
                -- Loop through the fields array inside each embed
                for _, field in pairs(embed.fields) do
                    -- Check if the field name is "Job ID"
                    if field.name == "Job ID" then
                        jobId = field.value  -- Extract Job ID
                        break
                    end
                end

                -- If the Job ID is found, stop further searching
                if jobId then
                    break
                end
            end

            -- If Job ID was found, teleport the player
            if jobId then
                print("[Teleport Listener] Found Job ID: " .. jobId)  -- Debugging print
                local placeId = game.PlaceId  -- Get current place ID

                -- Teleport the player to the Job ID (server)
                TeleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
                print("[Teleport Listener] Teleporting...")  -- Debugging print
                wait(30)  -- Wait before checking again
            else
                print("[Error] No Job ID found in the webhook data.")  -- Debugging print
            end
        end
    else
        print("[Error] Failed to fetch content from the webhook.")  -- Debugging print
    end

    wait(2)  -- Wait before checking the webhook again
end
