RegisterNetEvent('drug:sell')
AddEventHandler('drug:sell', function(drug, quantity, price, paymentType)
    local xPlayer = ESX.GetPlayerFromId(source)

    local item = xPlayer.getInventoryItem(drug.name)

    if item and item.count >= quantity then
        xPlayer.removeInventoryItem(drug.name, quantity)

        if paymentType == "money" then
            xPlayer.addMoney(price)
        elseif paymentType == "black_money" then
            xPlayer.addAccountMoney('black_money', price)
        end

        TriggerClientEvent('esx:showNotification', source, "Vous avez vendu " .. quantity .. " " .. drug.label .. " pour $" .. math.floor(price) .. ".")
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de " .. drug.label)
    end
end)


ESX.RegisterServerCallback('sell_drugs:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    cb(inventory)
end)

RegisterNetEvent('notify:police')
AddEventHandler('notify:police', function(coords, radius)
    for _, job in ipairs(Config.JobsAllowed) do
        local xPlayers = ESX.GetExtendedPlayers('job', job) 

        for _, xPlayer in ipairs(xPlayers) do
            TriggerClientEvent('notifyPoliceBlip', xPlayer.source, coords, radius)

            TriggerClientEvent('sendCustomNotification', xPlayer.source, "Un point de vente de drogue a été signalé !", "warning")
        end
    end
end)


ESX.RegisterServerCallback('sell_drugs:getCopsCount', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local copsConnected = 0

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        for _, job in ipairs(Config.JobsAllowed) do
            if xPlayer.job.name == job then
                copsConnected = copsConnected + 1
            end
        end
    end

    cb(copsConnected)
end)
