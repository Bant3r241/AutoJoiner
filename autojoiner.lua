-- teleport_listener.lua
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local jobIdFile = "C:\\temp\\jobid.txt"  -- Path where the job ID will be written by your Node.js script

while true do
    -- Check if jobid.txt exists and read it
    local success, content = pcall(function()
        local file = io.open(jobIdFile, "r")
        if file then
            local data = file:read("*all")
            file:close()
            return data
        end
        return nil
    end)

    if success and content and content ~= "" then
        print("[Teleport Listener] Found Job ID:", content)

        -- Teleport to the job id
        local placeId = game.PlaceId
        local jobId = content

        -- Clear the file after reading to avoid repeated teleport
        pcall(function()
            local file = io.open(jobIdFile, "w")
            if file then
                file:write("")
                file:close()
            end
        end)

        -- Teleport player to job
        TeleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
        print("[Teleport Listener] Teleporting...")

        wait(30)  -- Wait 30 seconds before next check to avoid multiple teleports
    else
        wait(2)  -- No job ID found, wait 2 seconds before checking again
    end
end
