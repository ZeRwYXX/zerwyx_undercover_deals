local selling = false
local currentPed = nil
local currentBlip = nil

function GetOnlineCops(callback)
    local onlineCops = 0

    for _, job in ipairs(Config.JobsAllowed) do
        local xPlayers = ESX.GetExtendedPlayers('job', job)
        onlineCops = onlineCops + #xPlayers
    end

    callback(onlineCops)
end

function nbCops(callback)
    ESX.TriggerServerCallback('sell_drugs:getCopsCount', function(copsCount)
        callback(copsCount)
    end)
end

RegisterCommand(Config.StartCmd, function()
    local playerPed = PlayerPedId()

    if selling then
        SendNotification("Une vente est déjà en cours.", "warning")
        return
    end

    if Config.needCops and Config.needCops > 0 then
        nbCops(function(cops)
            if cops >= Config.needCops then
                ESX.TriggerServerCallback('sell_drugs:getPlayerInventory', function(inventory)
                    local foundDrug = false

                    for _, drug in pairs(Config.Drugs) do
                        local playerItem = GetItemFromInventory(inventory, drug.name)

                        if playerItem then
                            foundDrug = true
                            SendNotification("Voici la localisation du client ! N'hésitez pas à refuser si l'accès est trop risqué.", "warning")

                            StartSelling(playerPed, drug)
                            break
                        end
                    end

                    if not foundDrug then
                        SendNotification("Vous n'avez pas de drogue sur vous.", "warning")
                    end
                end)
            else
                SendNotification("Pas assez de policiers en ligne pour commencer la vente.", "warning")
            end
        end)
    else
        ESX.TriggerServerCallback('sell_drugs:getPlayerInventory', function(inventory)
            local foundDrug = false

            for _, drug in pairs(Config.Drugs) do
                local playerItem = GetItemFromInventory(inventory, drug.name)

                if playerItem then
                    foundDrug = true
                    StartSelling(playerPed, drug)
                    break
                end
            end

            if not foundDrug then
                SendNotification("Vous n'avez pas de drogue sur vous.", "warning")
            end
        end)
    end
end, false)

function GetItemFromInventory(inventory, itemName)
    for i = 1, #inventory, 1 do
        local item = inventory[i]
        if item.name == itemName then
            return item
        end
    end
    return nil
end

RegisterCommand(Config.StopCmd, function()
    selling = false
    RemoveBlip(currentBlip)
end, false)

function StartSelling(playerPed, drug)
    selling = true

    ESX.TriggerServerCallback('sell_drugs:getPlayerInventory', function(inventory)
        local drugToSell = nil

        -- Recherche la première drogue trouvée dans l'inventaire du joueur
        for _, drug in ipairs(Config.Drugs) do
            if GetItemFromInventory(inventory, drug.name) then
                drugToSell = drug
                break 
            end
        end

        if drugToSell then
            local pedCoords = GetEntityCoords(playerPed)
            local spawnCoords = GetRandomSpawnPoint(pedCoords, Config.SpawnRadius)

            if spawnCoords then
                local pedHash = GetHashKey(GetRandomPedModel())
                RequestModel(pedHash)
                while not HasModelLoaded(pedHash) do
                    Wait(0)
                end

                currentPed = CreatePed(4, pedHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)

                if Config.PedAutoMove == false then
                    local randomAction = math.random(1, 4)

                    if randomAction == 1 then
                        PlayPedAnimation(currentPed, "amb@world_human_smoking@male@male_a@base", "base")
                    elseif randomAction == 2 then
                        PlayPedAnimation(currentPed, "cellphone@self", "self_talking")
                    elseif randomAction == 3 then
                        PlayPedAnimation(currentPed, "amb@world_human_aa_coffee@idle_a", "idle_a")
                    elseif randomAction == 4 then
                        PlayPedAnimation(currentPed, "amb@world_human_stand_mobile@male@text@base", "base")
                    end
                else
                    TaskGoToEntity(currentPed, playerPed, -1, 1.0, 1.0, 1073741824, 0)
                end

                currentBlip = AddBlipForEntity(currentPed)
                SetBlipSprite(currentBlip, Config.BlipSettings.sprite)
                SetBlipColour(currentBlip, Config.BlipSettings.color)
                SetBlipScale(currentBlip, Config.BlipSettings.scale)
                SetBlipAsShortRange(currentBlip, false)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.BlipSettings.text)
                EndTextCommandSetBlipName(currentBlip)

                if Config.Target then
                    exports.ox_target:addEntity(currentPed, {
                        {
                            name = "sell_drug",
                            label = "Vendre la drogue",
                            icon = "fas fa-cannabis",
                            onSelect = function()
                                StartSellingAnimation(currentPed)
                                SellDrug(drugToSell)
                            end,
                            canInteract = function(entity)
                                return true
                            end
                        }
                    })
                else
                    local notificationShown = false

                    while true do
                        local playerCoords = GetEntityCoords(playerPed)
                        local pedCoords = GetEntityCoords(currentPed)

                        if #(playerCoords - pedCoords) < 3.0 then
                            if not notificationShown then
                                SendNotification("Appuyez sur [E] pour vendre de la drogue", "success")
                                notificationShown = true
                            end

                            if IsControlJustReleased(0, 38) then
                                if IsPedInAnyVehicle(playerPed, false) then
                                    SendNotification("Vous devez sortir de votre véhicule pour vendre de la drogue.", "error")
                                    selling = false
                                    RemoveBlip(currentBlip)
                                else
                                    StartSellingAnimation(currentPed)

                                    if math.random(1, 10) <= Config.Lucky then
                                        PNJCallPolice(currentPed, playerPed)
                                        selling = false
                                        RemoveBlip(currentBlip)
                                    else
                                        SellDrug(drugToSell)
                                    end

                                    break
                                end
                            end
                        end

                        Wait(0)
                    end
                end
            else
                SendNotification("Impossible de trouver un point de spawn valide.", "error")
            end
        else
            SendNotification("Vous n'avez pas de drogue sur vous.", "warning")
        end
    end)
end


function GetRandomSpawnPoint(playerCoords, radius)
    local attempts = 0
    while attempts < 10 do
        local xOffset = math.random(-radius, radius)
        local yOffset = math.random(-radius, radius)
        local zOffset = 1000.0

        local spawnCoords = vector3(playerCoords.x + xOffset, playerCoords.y + yOffset, zOffset)

        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z, false)

        if foundGround then
            spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)

            if groundZ > 0 and IsValidSpawnPoint(spawnCoords) then
                return spawnCoords
            end
        end

        attempts = attempts + 1
    end

    return nil
end

function IsValidSpawnPoint(coords)
    local zoneType = GetNameOfZone(coords.x, coords.y, coords.z)

    if zoneType ~= "OCEAN" and zoneType ~= "WATER" then
        return true
    else
        return false
    end
end

function PlayPedAnimation(ped, dict, anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end

function PNJCallPolice(ped, playerPed)
    SendNotification("Le PNJ s'enfuit et appelle la police!", "error")
    TaskReactAndFleePed(ped, playerPed)

    TriggerServerEvent("notify:police", GetEntityCoords(ped), Config.RadiusLSPD)

    selling = false
    RemoveBlip(currentBlip)
end

RegisterNetEvent('sendCustomNotification')
AddEventHandler('sendCustomNotification', function(message, notificationType)
    SendNotification(message, notificationType)
end)

function SellDrug(drug)
    local desiredQuantity = math.random(drug.minSell, drug.maxSell)
    local pricePerUnit = math.random(drug.minPrice, drug.maxPrice)
    local totalPrice = pricePerUnit * desiredQuantity

    SendNotification("Merci à toi! Je t'en prends " .. desiredQuantity .. " Pour " .. totalPrice .. "$", "success")

    TriggerServerEvent("drug:sell", drug, desiredQuantity, totalPrice, Config.PaymentType)

    StartSelling(PlayerPedId(), Config.Drugs[1])

    RemoveBlip(currentBlip)
    PNJLeave(currentPed)
end

RegisterNetEvent('notifyPoliceBlip')
AddEventHandler('notifyPoliceBlip', function(coords, radius)
    local blipRadius = AddBlipForRadius(coords.x, coords.y, coords.z, radius)
    SetBlipColour(blipRadius, 1)
    SetBlipAlpha(blipRadius, 128)

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Point de vente signalé")
    EndTextCommandSetBlipName(blip)

    Wait(5 * 60 * 1000)
    RemoveBlip(blipRadius)
    selling = false
    RemoveBlip(blip)
end)

function StartSellingAnimation(ped)
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8.0, 3000, 0, 0, false, false, false)
    TaskPlayAnim(ped, "mp_common", "givetake1_a", 8.0, -8.0, 3000, 0, 0, false, false, false)

    Wait(3000)
end

function SendNotification(message, type)
    SendNUIMessage({
        action = "showNotification",
        message = message,
        type = type
    })
end

function ShowHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function IsSafeSpawnPoint(coords)
    local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)

    if foundGround then
        return groundZ > 0
    else
        return false
    end
end

function GetRandomPedModel()
    if not Config.Peds then
        local randomPeds = {
            "a_m_m_farmer_01",
            "a_m_y_beach_01",
            "a_f_y_hipster_01",
            "u_m_y_baygor",
            "s_m_m_autoshop_01"
        }
        local randomIndex = math.random(#randomPeds)
        return randomPeds[randomIndex]
    else
        if type(Config.Peds) == "table" and #Config.Peds > 0 then
            local pedIndex = math.random(#Config.Peds)
            return Config.Peds[pedIndex].name
        else
            return "a_m_m_bevhills_02"
        end
    end
end

function PNJLeave(ped)
    if DoesEntityExist(ped) then
        local randomCoords = GetRandomPointOnMap()
        TaskGoToCoordAnyMeans(ped, randomCoords.x, randomCoords.y, randomCoords.z, 1.0, 0, 0, 786603, 0)

        Wait(100000)
        DeletePed(ped)
    end
end

function GetRandomPointOnMap()
    local x = math.random(-3000, 3000)
    local y = math.random(-3000, 3000)
    local z = 32.0
    return vector3(x, y, z)
end
