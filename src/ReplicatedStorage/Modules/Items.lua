local Items = {
    -- Weapons =================================================================
    ['cool_sword'] = {
        name = "Cool Sword",
        description = "A very cool sword",
        class = 'Weapon',
        category = 'Short Sword',
        damage_type = 'Slashing',
        model = nil,
        weight = 10,
        attack_power = {
            Physical = 10
        },
        skills_required = {
            Strength = 10,
            Stealth = 100
        },
        skill_scaling = {
            Strength = 'D',
            Stealth = 'S'
        },
        enchantments = {}
    },
    -- TODO Need an enchanment manager/enchantment list to reference for each item.
    ['cool_sword_with_enchantment'] = {
        name = "Enchanted Cool Sword",
        description = "A very cool sword with an enchantment",
        class = 'Weapon',
        category = 'Long Sword',
        damage_type = 'Piercing',
        model = nil,
        weight = 10,
        attack_power = {
            Physical = 100
        },
        skills_required = {
            Strength = 100,
            Stealth = 1000
        },
        skill_scaling = {
            Strength = 'S++',
            Stealth = 'S+++'
        },
        enchantments = {'sharpness_1'}
    },
}





return Items