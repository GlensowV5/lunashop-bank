local Framework = nil

if Config.core == 'qb' then
    Framework = exports['qb-core']:GetCoreObject()
    function GetPlayerCash()
        local Player = Framework.Functions.GetPlayerData()
        return Player.money['cash']
    end
    function GetPlayerBank()
        local Player = Framework.Functions.GetPlayerData()
        return Player.money['bank']
    end
elseif Config.core == 'esx' then
    Framework = exports['es_extended']:getSharedObject()
    function GetPlayerCash()
        lib.callback('lunashop-bank:server:getmoneyesx', false, function(cash)
            if cash then
                return cash
            end
        end)
    end
    function GetPlayerBank()
        lib.callback('lunashop-bank:server:getbankesx', false, function(bank)
            if bank then
                return bank
            end
        end)
    end
end