-- Note: Money does not have a carry weight.

-- Services ========================================================
-- N/A

-- Modules =========================================================
local Items = require(game.ReplicatedStorage.Modules.Items)
local EventHandler = require(game.ReplicatedStorage.Modules.EventHandler)

-- Variables =======================================================
-- N/A

-- =================================================================



local Inventory = {}
Inventory.__index = Inventory

function Inventory.new()
---@diagnostic disable-next-line: undefined-global
    self = {}
    setmetatable(self, Inventory)

    -- Money
    self._coins = 0
    self._gems = 0

    -- Items
    self._items = {}
    
    return self
end

-- Grab the whole inventory.
function Inventory:getInventory()
    -- Just returning the basics, no need to return the functions.
    return {
        ['coins'] = self._coins,
        ['gems'] = self._gems,
        ['items'] = self._items
    }
end

-- Inventory stats getters

-- Money Getters
function Inventory:getCoins()
    return self._coins
end

function Inventory:getGems()
    return self._gems
end

-- Money setters
function Inventory:setCoins(amount)
    self._coins = amount
end

function Inventory:addCoins(amount)
    self._coins += amount
end

function Inventory:setGems(amount)
    self._gems = amount
end

function Inventory:addGems(amount)
    self._gems += amount
end

function Inventory:removeGems(amount)
    self._gems -= amount
end

function Inventory:removeCoins(amount)
    self._coins -= amount
end

-- Item handling
function Inventory:hasItem(item_id)
    if self._items[item_id] ~= nil then 
        return true 
    else
        return false
    end
end

function Inventory:getItem(item_id)
    if self:hasItem(item_id) then
        return self._items[item_id]
    else
        -- Returns nil if the item is not found in the Player's inventory.
        return nil
    end
end

function Inventory:getAllItems()
    return self._items
end

function Inventory:addItem(item_id, amount)
    if Items[item_id] ~= nil then
        if self:hasItem(item_id) then
            self._items[item_id].amount += amount
        else
            self._items[item_id] = {amount = amount}
        end
        -- Fire event to tell the client that the inventory has been updated.
        EventHandler.ItemAdded = {[item_id] = {amount = self._items[item_id].amount}}
    else
        return error("This item id does not exist.")
    end
end

function Inventory:removeItem(item_id, amount)
    if Items[item_id] ~= nil then                              
        if amount > self._items[item_id].amount then
            return error("Attempt to remove " .. amount .. " " .. item_id .. " from inventory unsuccessful: Amount to remove exceeds current amount.")
            else if self._items[item_id].amount - amount == 0 then
                self._items[item_id] = nil
            else
                self._items[item_id].amount -= amount
            end
        end
    else
        return error("This item id does not exist.")
    end
end

-- Event listeners


return Inventory