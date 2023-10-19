-- Services =========================================================
local DSS = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- Modules ==========================================================
local Inventory = require(game.ServerScriptService.Modules.Inventory)

-- Variables ========================================================
local PLAYER_DATA = DSS:GetDataStore("PLAYER_DATA")

-- ==================================================================

local Player = {}

Player.__index = Player

function Player.new(player_instance: Player)
    local self = {}
    setmetatable(self, Player)
    
    -- Set player properties
    self.Player = player_instance
    self._level = 1
    self._xp = 0
    self._health = 100

    -- Create inventory for player.
    self.Inventory = Inventory.new()

    -- Equipped items 
    self._EquippedItems = {
        ['head'] = nil,
        ['chest'] = nil,
        ['legs'] = nil,
        ['feet'] = nil,
        ['hands'] = nil,
        ['left_hand_item'] = nil,
        ['right_hand_item'] = nil
    }

    return self
end



function Player:getPlayer()
    return self.Player
end

function Player:loadSaveData()
    -- Get the player's key.
    local key = self.Player.Name .. ":" .. self.Player.UserId

    -- Request the player's data from the datastore.
    local data
    local success, err = pcall(function()
        data = PLAYER_DATA:GetAsync(key)
    end)

    if success then
        -- Set all the player's attributes accordingly
        self._level = data.level
        self._xp = data.xp
        self._EquippedItems = data.EquippedItems
        self.Inventory:setCoins(data.Inventory.coins)
        self.Inventory:setGems(data.Inventory.gems)
        self.Inventory:setItemCount(data.Inventory.items.length)
        self.Inventory:setTotalWeight(data.Inventory.total_weight)
        self.Inventory._items = data.Inventory.items
    else
        error(err)
        self:Kick("ERROR CODE: DS1\nYour datastore has failed to load.")
    end
end

function Player:saveData()
    -- Get the player's key.
    local key = "player_" .. self.Player.UserId

    local data = {
        level = self._level,
        xp = self._xp,
        EquippedItems = self._EquippedItems,
        Inventory = {
            coins = self.Inventory._coins,
            gems = self.Inventory._gems,
            items = self.Inventory._items
        }
    }

    -- Attempt to save data to datastore.
    local success, err = pcall(function()
        PLAYER_DATA:SetAsync(key, data)
    end)

    if success then
        return success
    else
        err(err)
    end
end

function Player:Kick(reason: string)
    self.Player:Kick(reason)
end

function Player:Leaving()
end

function Player:printTest()
    print("This function is working!")
end

function Player:GetCharacter()
    return self.Player.Character
end

function Player:AddAccessory(accessory: Accessory)
    local character = self:GetCharacter()
    return character.Humanoid:AddAccessory(accessory)
end

function Player:RemoveAccessory(name: string)
    local character = self:GetCharacter()
    local accessories = character.Humanoid:GetAccessories()
    for _, v in pairs(accessories) do
        if v.Name == name then
            v:Destroy()
        end
    end
end

function Player:HasAccessory(name: string)
    local character = self:GetCharacter()
    local accessories = character.Humanoid:GetAccessories()
    for _, v in pairs(accessories) do
        if v.Name == name then
            return true
        end
    end

    return false
end

return Player