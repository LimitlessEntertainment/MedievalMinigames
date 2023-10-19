-- Services =========================================================
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Modules ==========================================================
local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)

-- Variables ========================================================
local holdChest = ServerStorage:WaitForChild("HoldChest")
local Chest = game.Workspace.Chest
local Prompt = Chest.PickupChest
local depositArea = game.Workspace.DepositTreasure
local db = false

-- ==================================================================

depositArea.Touched:Connect(function(hit)
    if db or not hit.parent:FindFirstChild("Humanoid") then
        return
    else
        db = true

        -- Get the player from the hit.
        local player
        local plr = Players:GetPlayerFromCharacter(hit.parent)
        print("PLAYER", plr)
        if plr then
            player = PlayerManager.getPlayerByInstance(plr)
        else
            return
        end

        -- Check to make sure they actually had the chest.
        if not player:HasAccessory("HoldChest") then 
            task.wait(2)
            db = false
            return print("You dont have the chest.") 
        end

        -- Remove the accessory from the player's character. 
        player:RemoveAccessory("HoldChest")

        -- Add points to the team

        -- Make the chest visible again & enable the proximity prompt
        Chest.Transparency = 0
        Prompt.Enabled = true

        print("TREASURE DEPOSITED")


        task.wait(2)
        db = false
    end

end)