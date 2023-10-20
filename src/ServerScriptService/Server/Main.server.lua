-- Services =========================================================
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules ==========================================================
local PlayerManager = require(ServerScriptService.Modules.PlayerManager)
local Games = {CaptureTheTreasure = require(ServerScriptService.Modules.Games.CaptureTheTreasure)}

-- Constants ========================================================
local TIME_CONSTANT = 30

-- Variables ========================================================


-- Other


-- Listeners
local Listeners = {}

-- ==================================================================
-- Main loop
function Main()
    while true do
        -- Player voting
        print("VOTING")
        task.wait(10)

        -- Start the round
        Games.CaptureTheTreasure.run()

        print("Game over, waiting to start next round.")
        task.wait(20)
    end
end

Main()