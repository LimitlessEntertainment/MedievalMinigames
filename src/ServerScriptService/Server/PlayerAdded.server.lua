local Players = game:GetService("Players")
local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)
local CaptureTheTreasure = require(game.ServerScriptService.Modules.Games.CaptureTheTreasure)

Players.PlayerAdded:Connect(function(player)
    -- Creates a new Player instance.
    local plr = PlayerManager.addPlayer(player)
end)

