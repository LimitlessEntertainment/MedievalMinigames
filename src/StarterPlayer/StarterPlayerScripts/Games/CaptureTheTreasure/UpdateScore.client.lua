-- Services =========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules ==========================================================

-- Variables ========================================================
local Player = Players.LocalPlayer
local EventsFolder = ReplicatedStorage.RemoteEvents.CaptureTheTreasure

-- Events ===========================================================
local UpdateScore = EventsFolder:WaitForChild("UpdateScore")

-- ==================================================================

UpdateScore.OnClientEvent:Connect(function(redScore, blueScore)

    print("REMOTE RED SCORE: ", redScore)
    print("REMOTE BLUE SCORE: ", blueScore)

end)

