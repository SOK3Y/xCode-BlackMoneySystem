local Cooldown = {}

ESX.RegisterServerCallback('xCode-BlackMoneySystem:BuyItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= tonumber(Config.Item.ItemPrice) then
        xPlayer.removeMoney(tonumber(Config.Item.ItemPrice))
        xPlayer.addInventoryItem(Config.Item.ItemName, 1)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('xCode-BlackMoneySystem:PutAncientCoin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if Cooldown[source] and (os.time() - Cooldown[source]) < Config.Cooldown then
        cb(false)
        return
    end
    
    local item = xPlayer.getInventoryItem(Config.Item.ItemName)
    if item.count > 0 then
        xPlayer.removeInventoryItem(Config.Item.ItemName, 1)
        Cooldown[source] = os.time()
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('xCode-BlackMoneySystem:StartLaundry', function(source, cb, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = tonumber(args)

    if not amount or amount <= 0 then
        cb(false, "Unknown amount")
        return
    end

    if xPlayer.getAccount('black_money').money >= amount then
        cb(true)
        xPlayer.removeAccountMoney('black_money', amount)

        Citizen.CreateThread(function()
            Citizen.Wait(Config.LaundryTime)
            xPlayer.addMoney(amount)
        end)
    else
        cb(false, "Player does not have enough money")
    end
end)
