-- Services =========================================================
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules ==========================================================
local PlayerManager = require(ServerScriptService.Modules.PlayerManager)

-- Games
local Games = {
    Revolt = require(ServerScriptService.Modules.Games.Revolt)
}

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

        -- Start the round for whatever was picked.
        print("PLAY REVOLT")
        Games.Revolt.run()

        print("Game over, waiting to start next round.")
        task.wait(20)
    end
end

Main()