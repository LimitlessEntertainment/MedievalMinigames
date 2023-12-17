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
local TEAM_NAMES = {"Civilians", "Knights"}

--Variables===========================================================================
local castle = game.Workspace.Revolt
local gameRunning = false
local scores = {} -- table to keep track of the score
local EventsFolder = ReplicatedStorage.RemoteEvents.Revolt

-- Other
local db = false
local civilianScore = 0
local knightScore = 0
local time = TIME_CONSTANT

-- Listeners =========================================================================
local Listeners = {}

--====================================================================================
local Revolt = {}

function Revolt.run() 
    -- Pre-game ops
    createTeams()
    assignTeams() 
    resetPlayers()
    armPlayers()
    initListeners()
    

    gameRunning = true

    while gameRunning do
        time -= 1
        task.wait(1)

        if time <= 0 then
            gameRunning = false
        end
    end

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
    local TEAM_NAMES = {"Civilians", "Knights"}

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

function armPlayers()
    local sword = ServerStorage.GameAssets.Revolt:WaitForChild("ClassicSword")
    local pitchfork = ServerStorage.GameAssets.Revolt:WaitForChild("Pitchfork")
    local players = Players:GetPlayers()
    for _, p in players do
        if(p.Team == TEAM_NAMES[0]) then
            pitchfork:Clone().Parent = p.Backpack
        else
            sword:Clone().Parent = p.Backpack
        end
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

function initListeners()
   
end

return Revolt