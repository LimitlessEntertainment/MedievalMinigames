-- Services =========================================================
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Modules ==========================================================
local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)

-- Variables ========================================================
local holdChest = ServerStorage:WaitForChild("HoldChest")
local Chest = game.Workspace.Chest
local Prompt = Chest.PickupChest

-- ==================================================================


Prompt.Triggered:Connect(function(plr)
    -- Make sure the chest has not already been picked up.
    if Chest.Transparency > 0.8 then return error("Chest has already been picked up.") end 

    -- Pick the chest up.
    local player = PlayerManager.getPlayerByInstance(plr)
    Chest.Transparency = 0.9
    Prompt.Enabled = false
    player:AddAccessory(holdChest:Clone())
end)