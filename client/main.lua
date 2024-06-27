local SpawnedPed = nil
local SpawnedObject = nil
local Step = 1

Citizen.CreateThread(function()
    lib.requestAnimDict('amb@world_human_drinking@coffee@male@idle_a', 500)
    lib.requestModel(GetHashKey(Config.SpawnedPed.Model), 500)
    
    SpawnedPed = CreatePed(4, GetHashKey(Config.SpawnedPed.Model), Config.SpawnedPed.Coords[1], Config.SpawnedPed.Coords[2], Config.SpawnedPed.Coords[3]-1.0, Config.SpawnedPed.Coords[4], false, true)
    FreezeEntityPosition(SpawnedPed, true)
    SetEntityInvincible(SpawnedPed, true)
    SetBlockingOfNonTemporaryEvents(SpawnedPed, true)
    
    local entity = CreateObject(`p_amb_coffeecup_01`, GetEntityCoords(SpawnedPed), false)
    AttachEntityToEntity(entity, SpawnedPed, GetPedBoneIndex(SpawnedPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, false, 0, true)
    TaskPlayAnim(SpawnedPed, "amb@world_human_drinking@coffee@male@idle_a", "idle_c", 8.0, -8.0, -1, 1, 0.0, false, false, false)
    exports.ox_target:addLocalEntity(SpawnedPed, {
        {
            icon = 'fas fa-cube',
            label = 'Purchase Item',
            onSelect = function()
                ESX.TriggerServerCallback('xCode-BlackMoneySystem:BuyItem', function(cb)
                    local myMoney = exports['ox_inventory']:Search('count', 'money')
                    if cb then
                        ESX.ShowNotification('Purchased an Antique Coin for $'..Config.Item.ItemPrice)
                    else
                        ESX.ShowNotification('You can\'t afford it! (missing $'..(Config.Item.ItemPrice - myMoney)..')')
                    end
                end)
            end,
            canInteract = function()
                return true
            end,
            distance = 2.0
        },
    })
    
    SpawnedObject = CreateObject(Config.Object.Model, Config.Object.Coords[1], Config.Object.Coords[2], Config.Object.Coords[3]-1.0, Config.Object.Coords[4], false, false)
    FreezeEntityPosition(SpawnedObject, true)
    exports.ox_target:addLocalEntity(SpawnedObject, {
        {
            icon = 'fas fa-coin',
            label = 'Insert Coin',
            items = Config.Item.ItemName,
            onSelect = function()
                ESX.TriggerServerCallback('xCode-BlackMoneySystem:PutAncientCoin', function(cb) 
                    if cb then
                        Step = 2
                        ShowNotification('Inserted the ancient coin', 'success')
                    else
                        ShowNotification('You cannot do this right now!', 'error')
                    end
                end)
            end,
            canInteract = function()
                return Step == 1
            end,
            distance = 2.0
        },
        {
            icon = 'fas fa-money-bill',
            label = 'Insert Cash',
            onSelect = function()
                SendNUIMessage({ action = 'show' })
                SetNuiFocus(true, true)
                RegisterNUICallback("result", function(data, cb)
                    local amount = tonumber(data.result)
                    if amount and amount ~= '' then
                        if amount >= Config.InputMoney[1] and amount <= Config.InputMoney[2] then
                            ESX.TriggerServerCallback('xCode-BlackMoneySystem:StartLaundry', function(cb, args)
                                if cb then
                                    ShowNotification('Money laundering in progress, wait 3 minutes!', 'success')
                                    ClearPedTasks(cache.ped)
                                    if lib.progressBar({
                                        duration = Config.LaundryTime,
                                        label = 'Laundering dirty money',
                                        useWhileDead = false,
                                        canCancel = false,
                                        disable = {
                                            car = true,
                                        },
                                    }) then
                                        Step = 1
                                    end
                                else
                                    ShowNotification('You do not have enough money!', 'error')
                                end
                            end, amount)
                        else
                            ShowNotification('You can launder from $'..Config.InputMoney[1]..' to $'..Config.InputMoney[2]..'!', 'error')
                        end
                    else
                        ShowNotification('Enter a valid amount!', 'error')
                    end
                    RegisterNUICallback("close", function(data, cb) 
                        SetNuiFocus(false, false)
                    end)
                    cb('ok')
                end)
            end,
            canInteract = function()
                return Step == 2
            end,
            distance = 2.0
        },
    })
end)

-- Function to show notifications
ShowNotification = function(description, type)
    lib.notify({
        title = 'Notification',
        description = description,
        type = type or 'inform'
    })
end
