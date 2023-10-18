-- Services =========================================================

-- Modules ==========================================================
local Player = require(game.ServerScriptService.Modules.Player)

-- Variables ========================================================

-- ==================================================================
local PlayerManager = {}

function PlayerManager.addPlayer(player: Player)
    local newPlayer = Player.new(player)
    PlayerManager[player.Name] = newPlayer
    return newPlayer
end

function PlayerManager.removePlayer(player: Player)
    PlayerManager[player.Name] = nil
end

function PlayerManager.getPlayerByName(name: string)
    if PlayerManager[name] ~= nil then
        return PlayerManager[name]
    else
        return nil
    end
end

function PlayerManager.getPlayerByInstance(player_instance: Player)
    if PlayerManager[player_instance.Name] ~= nil then
        return PlayerManager[player_instance.Name]
    else
        return nil
    end
end

return PlayerManager