-- Services ==========================================================================
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Teams = game:GetService("Teams")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules ===========================================================================
local PlayerManager = require(ServerScriptService.Modules.PlayerManager)

-- Constants==========================================================================
local TIME_CONSTANT = 300 -- for a 5-minute round
local SCORE_TO_WIN = 50 -- points needed to win
local TEAM_COLORS = {BrickColor.new("Bright red"), BrickColor.new("Bright blue")}
local TEAM_NAMES = {"Red Team", "Blue Team"}

--Variables===========================================================================
local hill = game.Workspace.Hill 
local gameRunning = false
local scores = {} -- table to keep track of the score
local time = TIME_CONSTANT
local EventsFolder = ReplicatedStorage.RemoteEvents.CaptureTheTreasure

-- Events
-- TODO UPDATE THESE TO THE EVENTS FOR THIS MINIGAME
local UpdateTimer = EventsFolder:WaitForChild("UpdateTimer")
local UpdateScore = EventsFolder:WaitForChild("UpdateScore")
local TreasureDeposited = EventsFolder:WaitForChild("TreasureDeposited")

-- Listeners =========================================================================
local Listeners = {}

--====================================================================================
local KingOfTheHill = {}

function KingOfTheHill.run() 
    -- Pre-game ops
    createTeams()
    assignTeams()
    resetPlayers()
    initListeners()

    gameRunning = true -- when the game starts
    print("Game has started")

    -- During game ops
    while gameRunning do
        time -= 1 -- Decrease the remaining time by a second
       --print("Time LEFT: ", time) -- prints the time left
        task.wait(1) -- runs the loop every 1 sec 

        local currentOccupant = nil

        for _, player in pairs(Players:GetPlayers()) do
            if isPlayerOnHill(player) then
                currentOccupant = player
                break
            end
        end

        if currentOccupant then
            scores[currentOccupant.UserId] = (scores[currentOccupant.UserId] or 0) + 1
            if scores[currentOccupant.UserId] >= SCORE_TO_WIN then
                gameRunning = false
                print(currentOccupant.Name .. " Wins")
            end
        end

        if time <= 0 then
            gameRunning = false
            print("Ran outta time on godddd")
        end
    end

    -- Post Game ops
    postGameCleanup()
end

function postGameCleanup()
    assignLobby()
    destroyTeams()
    disconnectListeners()
    resetPlayers()
    resetVars()
end

function resetVars()
    scores = {}
    time = TIME_CONSTANT
end

function createTeams()
    local TEAM_COLORS = {BrickColor.new("Bright red"), BrickColor.new("Bright blue")}
    local TEAM_NAMES = {"Red Team", "Blue Team"}

    for i, teamName in ipairs(TEAM_NAMES) do
        local team = Instance.new("Team")
        team.Name = teamName
        team.TeamColor = TEAM_COLORS[i]
        team.AutoAssignable = false
        team.Parent = Teams
    end
end

function destroyTeams()
    for _, team in pairs(Teams:GetChildren()) do
        team:Destroy()
    end     
end

function assignTeams()
    local players = Players:GetPlayers()
    for i, player in ipairs(players) do
        local teamIndex = (i % #TEAM_NAMES) + 1
        player.Team = Teams:FindFirstChild(TEAM_NAMES[teamIndex])
    end
end

function assignLobby()
    for _, player in pairs(Players:GetPlayers()) do
        player.Team = nil -- Assuming there's no specific 'Lobby' team, we're setting it to nil.
    end
end

function resetPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        player:LoadCharacter()
    end
end

function disconnectListeners()
    for _, listener in pairs(Listeners) do
        listener:Disconnect()
    end
    Listeners = {}
end

function isPlayerOnHill(player)
    local playerPosition = player.Character.HumanoidRootPart.Position
    local hillPosition = hill.Position
    local hillSize = hill.Size 

    return
        playerPosition.X >= hillPosition.X - hillSize.X / 2 and
        playerPosition.X <= hillPosition.X + hillSize.X / 2 and
        playerPosition.Z >= hillPosition.Z - hillSize.Z / 2 and
        playerPosition.Z <= hillPosition.Z + hillSize.Z / 2 and
        playerPosition.Y >= hillPosition.Y - hillSize.Y / 2 and
        playerPosition.Y <= hillPosition.Y + hillSize.Y / 2
end

function initListeners()
    table.insert(Listeners, hill.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player and isPlayerOnHill(player) then
            scores[player.UserId] = (scores[player.UserId] or 0) + 1
        end
    end))
end

return KingOfTheHill