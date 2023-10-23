-- Services =========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules ==========================================================

-- Variables ========================================================
local Player = Players.LocalPlayer
local EventsFolder = ReplicatedStorage.RemoteEvents.CaptureTheTreasure

-- Events ===========================================================
local TreasureDeposited = EventsFolder:WaitForChild("TreasureDeposited")

-- ==================================================================

TreasureDeposited.OnClientEvent:Connect(function() 

    print("REMOTE: YOU HAVE DEPOSITED THE TREASURE!!!")

end)