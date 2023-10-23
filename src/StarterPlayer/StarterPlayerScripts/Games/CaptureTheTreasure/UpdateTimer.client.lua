-- Services =========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules ==========================================================

-- Variables ========================================================
local Player = Players.LocalPlayer
local EventsFolder = ReplicatedStorage.RemoteEvents.CaptureTheTreasure

-- Events ===========================================================
local UpdateTimer = EventsFolder:WaitForChild("UpdateTimer")

-- ==================================================================

UpdateTimer.OnClientEvent:Connect(function(time) 

    print("REMOTE TIME:", time)

end)
