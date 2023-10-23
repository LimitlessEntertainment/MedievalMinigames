-- Services =========================================================
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ServerStorage = game:GetService("ServerStorage")
local StarterPack = game:GetService("StarterPack")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules ==========================================================
local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)

-- Constants ========================================================
local TIME_CONSTANT = 240

-- Variables ========================================================
local RedHoldChest = ServerStorage.GameAssets.CaptureTheTreasure:WaitForChild("RedHoldChest")
local BlueHoldChest = ServerStorage.GameAssets.CaptureTheTreasure:WaitForChild("BlueHoldChest")
local EventsFolder = ReplicatedStorage.RemoteEvents.CaptureTheTreasure

-- Events
local UpdateTimer = EventsFolder:WaitForChild("UpdateTimer")
local UpdateScore = EventsFolder:WaitForChild("UpdateScore")
local TreasureDeposited = EventsFolder:WaitForChild("TreasureDeposited")


-- In-Map Chests
local RedChest = game.Workspace.RedChest
local RedPrompt = RedChest.PickupChest
local BlueChest = game.Workspace.BlueChest
local BluePrompt = BlueChest.PickupChest

-- Treasure deposit areas.
local BlueDeposit = game.Workspace.BlueDeposit
local RedDeposit = game.Workspace.RedDeposit

-- Other
local db = false
local redScore = 0
local blueScore = 0
local time = TIME_CONSTANT

-- Listeners
local Listeners = {}

-- ==================================================================
local CaptureTheTreasure = {}

function CaptureTheTreasure.run()
    -- Pre-game ops
    createTeams()
    assignTeams()
    initListeners()
    giveSwords()
    resetPlayers()


    -- During game ops
    while true do

        -- ROUND TIMER
        --print("TIME LEFT: ", time)
        UpdateTimer:FireAllClients(time)
        time -= 1
        task.wait(1)

        -- Ending conditions
        if blueScore >= 2 then
            print("BLUE WINS!!")
            break
        end

        if redScore >= 2 then
            print("RED WINS!!")
            break
        end

        if time <= 0 then
            if redScore == blueScore then
                print("TIE GAME!!")
            elseif blueScore == redScore then
                print("BLUE WINS!!")
            elseif redScore == blueScore then
                print("RED WINS!!")
            else
                print("TIME OUT!")
            end
            break
        end
    end

    -- Post-game ops
    print("Game over")
    print("RED SCORE: ", redScore)
    print("BLUE SCORE: ", blueScore)
    assignLobby()
    destroyTeams()
    disconnect()
    resetGame()
    resetPlayers()
end

function resetGame()
    redScore = 0
    blueScore = 0
    time = TIME_CONSTANT
    BluePrompt.Enabled = false
    RedPrompt.Enabled = false
    BlueChest.Transparency = 0
    RedChest.Transparency = 0
    StarterPack.ClassicSword:Destroy()
end

function giveSwords()
    local sword = ServerStorage.GameAssets.CaptureTheTreasure:WaitForChild("ClassicSword")
    local cSword = sword:Clone()
    cSword.Parent = StarterPack
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
    WinterTeam.TeamColor = BrickColor.new("Deep blue")
end

function destroyTeams()
    for _, v in pairs(Teams:GetTeams()) do
        if v ~= Teams.Lobby then
            v:Destroy()
        end
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

function assignLobby()
    local players = Players:GetPlayers()
    for _, v in pairs(players) do
        v.Team = Teams.Lobby
    end
end

function disconnect()
    for _, v in pairs(Listeners) do
        v:Disconnect()
    end
end

function resetPlayers()
    for _, v in(Players:GetPlayers()) do
        v:LoadCharacter()
    end
end

-- Event Listeners

-- Listener for the prompt on the treasure chest.
function initListeners()
    RedPrompt.Enabled = true
    BluePrompt.Enabled = true

    Listeners = {
    RedPrompt.Triggered:Connect(function(plr)
        -- Make sure the chest has not already been picked up.
        if RedChest.Transparency > 0.8 then return error("Chest has already been picked up.") end 
        if plr.Team == Teams.Dragonhold then return error("Player cannot pick up their own team's chest.") end

        -- Pick the chest up.
        local player = PlayerManager.getPlayerByInstance(plr)
        RedChest.Transparency = 0.9
        RedPrompt.Enabled = false
        player:AddAccessory(RedHoldChest:Clone())

        -- Add a listener to the player holding the chest to check if they die with it.
        local redEvent
        redEvent = player:GetCharacter().Humanoid.Died:Connect(function()
            print("ENTERED HERE LOL")
            RedPrompt.Enabled = true
            RedChest.Transparency = 0
            redEvent:Disconnect()
        end)
    end),

    BluePrompt.Triggered:Connect(function(plr)
        -- Make sure the chest has not already been picked up.
        if BlueChest.Transparency > 0.8 then return error("Chest has already been picked up.") end 
        if plr.Team == Teams.Winterhold then return error("Player cannot pick up their own team's chest.") end

        -- Pick the chest up.
        local player = PlayerManager.getPlayerByInstance(plr)
        BlueChest.Transparency = 0.9
        BluePrompt.Enabled = false
        player:AddAccessory(BlueHoldChest:Clone())

        -- Add a listener to the player holding the chest to check if they die with it.
        local blueEvent
        blueEvent = player:GetCharacter().Humanoid.Died:Connect(function()
            BluePrompt.Enabled = true
            BlueChest.Transparency = 0
            blueEvent:Disconnect()
        end)
    end),

    -- Listener for the deposit area (currently only one)
    RedDeposit.Touched:Connect(function(hit)
       
        -- Make sure it is not a part hitting the area.
        if db or not hit.parent:FindFirstChild("Humanoid") then
            return
        else
            db = true
            -- Get the player from the hit.
            local player
            local plr = Players:GetPlayerFromCharacter(hit.parent)
            if plr then
                player = PlayerManager.getPlayerByInstance(plr)
            else
                return
            end

            -- Make sure they're on the right team.
            if not plr.Team == Teams.Dragonhold then return error("You are not on the blue team!") end

            -- Check to make sure they actually had the chest.
            if not player:HasAccessory("BlueHoldChest") then 
                task.wait(2)
                db = false
                return print("You dont have the chest.") 
            end

            -- Remove the accessory from the player's character. 
            player:RemoveAccessory("BlueHoldChest")


            -- Add points to the team
            print("TREASURE DEPOSITED")
            redScore += 1
            UpdateScore:FireAllClients(redScore, blueScore)

            -- Tell the player they deposited it (remote event needed)
            TreasureDeposited:FireClient(plr)

            -- Make the chest visible again & enable the proximity prompt
            BlueChest.Transparency = 0
            BluePrompt.Enabled = true

            task.wait(2)
            db = false
        end

    end),

    -- Blue deposit area.
    BlueDeposit.Touched:Connect(function(hit)
       
        -- Make sure it is not a part hitting the area.
        if db or not hit.parent:FindFirstChild("Humanoid") then
            return
        else
            db = true
            -- Get the player from the hit.
            local player
            local plr = Players:GetPlayerFromCharacter(hit.parent)
            if plr then
                player = PlayerManager.getPlayerByInstance(plr)
            else
                return
            end

            -- Make sure they're on the right team.
            if not plr.Team == Teams.Winterhold then return error("You are not on the blue team!") end

            -- Check to make sure they actually had the chest.
            if not player:HasAccessory("RedHoldChest") then 
                task.wait(2)
                db = false
                return print("You dont have the chest.") 
            end

            -- Remove the accessory from the player's character. 
            player:RemoveAccessory("RedHoldChest")

            -- Add points to the team
            print("TREASURE DEPOSITED")
            blueScore += 1
            UpdateScore:FireAllClients(redScore, blueScore)

            -- Tell the player they deposited it (remote event needed)
            TreasureDeposited:FireClient(plr)

            -- Make the chest visible again & enable the proximity prompt
            RedChest.Transparency = 0
            RedPrompt.Enabled = true




            task.wait(2)
            db = false
        end

    end)}
end





return CaptureTheTreasure