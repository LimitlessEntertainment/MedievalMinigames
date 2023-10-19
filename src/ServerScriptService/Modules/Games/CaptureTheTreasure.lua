-- Services =========================================================
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ServerStorage = game:GetService("ServerStorage")

-- Modules ==========================================================
local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)

-- Variables ========================================================
local holdChest = ServerStorage:WaitForChild("HoldChest")
local Chest = game.Workspace.Chest
local Prompt = Chest.PickupChest
local depositArea = game.Workspace.DepositTreasure
local db = false
local redScore = 0
local blueScore = 0

-- ==================================================================
local CaptureTheTreasure = {}

function CaptureTheTreasure.run()
    createTeams()
    assignTeams()
    initListeners()

    while(redScore < 2 and blueScore < 2) do
        print("Still playing")
        task.wait(2)
    end
    print("Game over")
end

function createTeams()
    -- Create the teams
    local DragonTeam = Instance.new("Team", Teams)
    DragonTeam.Name = "Dragonhold"
    DragonTeam.AutoAssignable = false
    DragonTeam.TeamColor = BrickColor.new("Bright red")

    local WinterTeam = Instance.new("Team", Teams)
    WinterTeam.Name = "Winterhold"
    WinterTeam.AutoAssignable = false
    WinterTeam.TeamColor = BrickColor.new("Dove blue")
end

function destroyTeams()
    for _, v in pairs(Teams:GetTeams()) do
        v:Destroy()
    end
end

function assignTeams()
    local players = Players:GetPlayers()
    for i, v in pairs(players) do
        if(i % 2 == 0) then
            v.Team = Teams:FindFirstChild("Dragonhold")
        else
            v.Team = Teams:FindFirstChild("Winterhold")
        end
    end
end

-- Event Listeners

-- Listener for the prompt on the treasure chest.
function initListeners()
    Prompt.Enabled = true

    Prompt.Triggered:Connect(function(plr)
        -- Make sure the chest has not already been picked up.
        if Chest.Transparency > 0.8 then return error("Chest has already been picked up.") end 

        -- Pick the chest up.
        local player = PlayerManager.getPlayerByInstance(plr)
        Chest.Transparency = 0.9
        Prompt.Enabled = false
        player:AddAccessory(holdChest:Clone())
    end)

    -- Listener for the deposit area (currently only one)
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
            redScore += 1


            task.wait(2)
            db = false
        end

    end)
end





return CaptureTheTreasure