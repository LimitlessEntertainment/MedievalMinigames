-- Services =========================================================

-- Modules ==========================================================
local Player = require(game.ServerScriptService.Modules.Player)

-- Variables ========================================================

-- ==================================================================
local PlayerManager = {}

function PlayerManager.addPlayer(player)
    local newPlayer = Player.new(player)
    PlayerManager[player.Name] = newPlayer
    return newPlayer
end

function PlayerManager.removePlayer(player)
    PlayerManager[player.Name] = nil
end

function PlayerManager.getPlayerByName(name)
    if PlayerManager[name] ~= nil then
        return PlayerManager[name]
    else
        return nil
    end
end

function PlayerManager.getPlayerByInstance(player_instance)
    if PlayerManager[player_instance.Name] ~= nil then
        return PlayerManager[player_instance.Name]
    else
        return nil
    end
end

return PlayerManager