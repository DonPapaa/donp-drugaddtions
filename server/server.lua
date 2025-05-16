
QBCore = exports['qb-core']:GetCoreObject()
isUseDrugs = {}

--Creation of usable items!
--------------------------
--      EDIT BELOW      --
--------------------------

QBCore.Functions.AddItems({
    ['heroin'] = {
        name = 'heroin',
        label = 'Heroin',
        weight = 10,
        type = 'item',
        image = 'water_bottle.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'Injectible Heroin'
    },
    ['narcan'] = {
        name = 'narcan',
        label = 'Narcan',
        weight = 10,
        type = 'item',
        image = 'narcan.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'Narcan'
    },
    ['coke_baggy'] = {
        name = 'coke_baggy',
        label = 'Cocaine',
        weight = 10,
        type = 'item',
        image = 'coke_baggy.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'Cocaine baggy'
    },
    ['lsd'] = {
        name = 'lsd',
        label = 'LSD',
        weight = 10,
        type = 'item',
        image = 'lsd.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'LSD Tab'
    },
    ['pcp'] = {
        name = 'pcp',
        label = 'PCP',
        weight = 10,
        type = 'item',
        image = 'pcp.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'PCP Tab'
    },
    ['shrooms'] = {
        name = 'shrooms',
        label = 'Shrooms',
        weight = 10,
        type = 'item',
        image = 'shrooms.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'Edible'
    },
    ['lean'] = {
        name = 'lean',
        label = 'Lean',
        weight = 10,
        type = 'item',
        image = 'lean.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'Lean'
    }
})

--Narcan
QBCore.Functions.CreateUseableItem("narcan", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:narcan", src, item.name)
end)

CreateThread(function()
    for k, v in pairs(Config.drugs) do
        QBCore.Functions.CreateUseableItem(v.code, function(source, item)
            TriggerClientEvent("consumables:client:fentanylCount", source, v.code)
            TriggerClientEvent('consumables:client:useDrug', source, v.code, v.progressText, v.animationA, v.animationB)
        end)  
    end
end)

--Net event checking whether a player is currently on cocaine. If yes, then you wont be able to use another bag! Not currently in use, switched for a client sided version, server side is better though and will be coming in the next update.
RegisterNetEvent("donp-drugs:server:isUseDrugs", function()
    isUseDrugs[source] = false
end)

--Not used quite yet.
RegisterNetEvent("donp-drugs:server:removeItem", function(item)
    local src = source
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "remove")
    TriggerEvent("QBCore:Server:RemoveItem", item, 1)
end)
