local Players = game:GetService("Players")
local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)

Players.PlayerAdded:Connect(function(player)
    -- Creates a new Player instance.
    PlayerManager.addPlayer(player)
    local plr = PlayerManager.getPlayerByInstance(player)
end)

