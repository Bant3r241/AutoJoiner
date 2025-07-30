local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- URL where the Job ID is stored (replace with the correct URL)
local jobIdUrl = ""C:\Users\bobby\OneDrive\Desktop\V2 Faster Hope\jobid.txt""  -- Replace with your actual URL

while true do
    -- Fetch Job ID from the remote server (Job ID file)
    local success, content = pcall(function()
        return HttpService:GetAsync(jobIdUrl)  -- Fetch the Job ID from the server
    end)

    -- Debugging: Print out the raw response content
    print("[Debug] Content fetched from URL:", content)  -- Debugging print to show raw response

    if success and content and content ~= "" then
        print("[Teleport Listener] Found Job ID:", content)  -- Debugging print

        -- Teleport to the job id
        local placeId = game.PlaceId
        local jobId = content

        -- Teleport player to job
        TeleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
        print("[Teleport Listener] Teleporting...")  -- Debugging print

        wait(30)  -- Wait 30 seconds before the next check to avoid multiple teleports
    else
        print("[Teleport Listener] No Job ID found or failed to fetch content.")  -- Debugging print
        wait(2)  -- Wait 2 seconds before checking again
    end
end
