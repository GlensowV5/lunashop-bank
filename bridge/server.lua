local Framework = nil
math = lib.math

if Config.core == 'qb' then
    Framework = exports['qb-core']:GetCoreObject()
    function GetPlayerName(id)
        local src = source
        if id then
            local Player = Framework.Functions.GetPlayer(id)
            local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
            return name
        else
            local Player = Framework.Functions.GetPlayer(src)
            local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
            return name
        end
    end
elseif Config.core == 'esx' then
    Framework = exports['es_extended']:getSharedObject()
    lib.callback.register('lunashop-bank:server:getmoneyesx', function(source)
        local src = source
        local xPlayer = Framework.GetPlayerFromId(src)
        local money = xPlayer.getMoney()
        return money
    end)
    lib.callback.register('lunashop-bank:server:getbankesx', function(source)
        local src = source
        local xPlayer = Framework.GetPlayerFromId(src)
        local money = xPlayer.getAccount('bank').money
        return money
    end)
    function GetPlayerName(id)
        local src = source
        if id then
            local xPlayer = Framework.GetPlayerFromId(id)
            local name = xPlayer.getName()
            return name
        else
            local xPlayer = Framework.GetPlayerFromId(src)
            local name = xPlayer.getName()
            return name
        end
    end
end

RegisterNetEvent('lunashop-bank:server:withdraw', function(amount)
    local src = source
    if Config.core == 'qb' then
        local Player = Framework.Functions.GetPlayer(src)
        Player.Functions.RemoveMoney('bank', amount, 'bank withdrawal')
        Player.Functions.AddMoney('cash', amount, 'bank withdrawal')
    elseif Config.core == 'esx' then
        local Player = Framework.GetPlayerFromId(src)
        Player.removeAccountMoney('bank', amount)
        Player.addMoney(amount)
    end
end)

RegisterNetEvent('lunashop-bank:server:deposit', function(amount)
    local src = source
    if Config.core == 'qb' then
        local Player = Framework.Functions.GetPlayer(src)
        Player.Functions.RemoveMoney('cash', amount, 'bank deposit')
        Player.Functions.AddMoney('bank', amount, 'bank deposit')
    elseif Config.core == 'esx' then
        local Player = Framework.GetPlayerFromId(src)
        Player.removeMoney(amount)
        Player.addAccountMoney('bank', amount)
    end
end)

RegisterNetEvent('lunashop-bank:server:sendtoplayer', function(id, amount)
    local src = source
    local checkplayer = GetPlayerPed(id)
    if checkplayer ~= 0 then
        if Config.core == 'qb' then
            local Player = Framework.Functions.GetPlayer(src)
            local xPlayer = Framework.Functions.GetPlayer(id)
            Player.Functions.RemoveMoney('bank', amount, 'money transfer')
            xPlayer.Functions.AddMoney('bank', amount, 'money transfer')
            local data = {
                id = 'send_success',
                type = 'success',
                title = 'Success',
                description = 'You have successfully send money $'..math.groupdigits(amount)..' to '..GetPlayerName(id),
                showDuration = Config.notifyOptions['showDuration'],
                position = Config.notifyOptions['position'],
            }
            TriggerClientEvent('ox_lib:notify', src, data)
            local xdata = {
                id = 'send_success',
                type = 'success',
                title = 'Success',
                description = 'You received $'..math.groupdigits(amount)..' from '..GetPlayerName(src),
                showDuration = Config.notifyOptions['showDuration'],
                position = Config.notifyOptions['position'],
            }
            TriggerClientEvent('ox_lib:notify', id, xdata)
        elseif Config.core == 'esx' then
            local Player = Framework.GetPlayerFromId(src)
            local xPlayer = Framework.GetPlayerFromId(id)
            Player.removeAccountMoney('bank', amount)
            xPlayer.addAccountMoney('bank', amount)
            local data = {
                id = 'send_success',
                type = 'success',
                title = 'Success',
                description = 'You have successfully send money $'..math.groupdigits(amount)..' to '..GetPlayerName(id),
                showDuration = Config.notifyOptions['showDuration'],
                position = Config.notifyOptions['position'],
            }
            TriggerClientEvent('ox_lib:notify', src, data)
            local xdata = {
                id = 'send_successx',
                type = 'success',
                title = 'Success',
                description = 'You received $'..math.groupdigits(amount)..' from '..GetPlayerName(src),
                showDuration = Config.notifyOptions['showDuration'],
                position = Config.notifyOptions['position'],
            }
            TriggerClientEvent('ox_lib:notify', id, xdata)
        end
    else
        local data = {
            title = 'Error',
            description = 'Player is not online or wrong id',
            type = 'error',
            showDuration = Config.notifyOptions['showDuration'],
            position = Config.notifyOptions['position'],
        }
        TriggerClientEvent('ox_lib:notify', src, data)
    end
end)