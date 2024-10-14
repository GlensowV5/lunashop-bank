math = lib.math

local function depositMenu()
    local input = lib.inputDialog('Dialog title', {
        {type = 'number', label = 'Deposit Amount', description = 'Please enter the deposit amount.', icon = 'wallet', min = 1, max = GetPlayerCash()},
    })
    if input then
        if input[1] then
            if input[1] <= GetPlayerCash() then
                TriggerServerEvent('lunashop-bank:server:deposit', tonumber(input[1]))
                lib.notify({
                    id = 'deposit_success',
                    type = 'success',
                    title = 'Success',
                    description = 'You have successfully deposited $'..math.groupdigits(input[1]),
                    showDuration = Config.notifyOptions['showDuration'],
                    position = Config.notifyOptions['position'],
                })
            else
                lib.notify({
                    id = 'deposit_failed',
                    type = 'error',
                    title = 'Error',
                    description = "You can't do this!",
                    showDuration = Config.notifyOptions['showDuration'],
                    position = Config.notifyOptions['position'],
                })
            end
        else
            lib.notify({
                id = 'deposit_failed',
                type = 'error',
                title = 'Error',
                description = "You can't do this!",
                showDuration = Config.notifyOptions['showDuration'],
                position = Config.notifyOptions['position'],
            })
        end
    end
end

local function withdrawMenu()
    local input = lib.inputDialog('Dialog title', {
        {type = 'number', label = 'Withdraw Amount', description = 'Please enter the withdraw amount.', icon = 'money-bill', min = 1, max = GetPlayerBank()},
    })
    if input then
        if input[1] then
            if input[1] <= GetPlayerBank() then
                TriggerServerEvent('lunashop-bank:server:withdraw', input[1])
                lib.notify({
                    id = 'withdraw_success',
                    type = 'success',
                    title = 'Success',
                    description = 'You have successfully withdrawn $'..math.groupdigits(input[1]),
                    showDuration = Config.notifyOptions['showDuration'],
                    position = Config.notifyOptions['position'],
                })
            else
                lib.notify({
                    id = 'withdraw_failed',
                    type = 'error',
                    title = 'Error',
                    description = "You can't do this!",
                    showDuration = Config.notifyOptions['showDuration'],
                    position = Config.notifyOptions['position'],
                })
            end
        else
            lib.notify({
                id = 'withdraw_failed',
                type = 'error',
                title = 'Error',
                description = "You can't do this!",
                showDuration = Config.notifyOptions['showDuration'],
                position = Config.notifyOptions['position'],
            })
        end
    end
end

local function sendMenu()
    local input = lib.inputDialog('Dialog title', {
        {type = 'number', label = 'Player ID', description = 'Enter a player id for send the money.', icon = 'share'},
        {type = 'number', label = 'Withdraw Amount', description = 'Please enter the withdraw amount.', icon = 'money-bill', min = 1, max = GetPlayerBank()},
    })
    if input then
        print(GetPlayerName(input[1]))
        if input[1] then
            if input[2] then
                if input[2] <= GetPlayerBank() then
                    TriggerServerEvent('lunashop-bank:server:sendtoplayer', input[1], input[2])
                else
                    lib.notify({
                        id = 'send_failed',
                        type = 'error',
                        title = 'Error',
                        description = "You can't do this!",
                        showDuration = Config.notifyOptions['showDuration'],
                        position = Config.notifyOptions['position'],
                    })
                end
            else
                lib.notify({
                    id = 'send_failed',
                    type = 'error',
                    title = 'Error',
                    description = "You can't do this!",
                    showDuration = Config.notifyOptions['showDuration'],
                    position = Config.notifyOptions['position'],
                })
            end
        else
            lib.notify({
                id = 'send_failed',
                type = 'error',
                title = 'Error',
                description = "You can't do this!",
                showDuration = Config.notifyOptions['showDuration'],
                position = Config.notifyOptions['position'],
            })
        end
    end
end

Citizen.CreateThread(function()
    function OpenBank()
        Wait(100)
        lib.registerContext({
            id = 'manage_menu',
            title = 'Los Santos Bank',
            canClose = false,
            menu = "mainmenu",
            options = {
              {
                title = 'Manage',
                description = 'You can deposit or withdraw money from your bank.',
                icon = 'gear',
                menu = "mainmenu",
                arrow = false,
              },
              {
                title = 'Deposit',
                description = 'If you want deposit money from your bank click here.',
                icon = 'wallet',
                onSelect = function()
                    depositMenu()
                end,
                arrow = true,
              },
              {
                title = 'Withdraw',
                description = 'If you want withdraw money from your bank click here.',
                icon = 'money-bill',
                onSelect = function()
                    withdrawMenu()
                end,
                arrow = true,
              },
              {
                title = 'Send Money',
                description = 'If you want send money to any player click here.',
                icon = 'share',
                onSelect = function()
                    sendMenu()
                end,
                arrow = true,
              },
              {
                title = 'Back',
                description = 'Back to main menu.',
                icon = 'left-long',
                arrow = false,
                onSelect = function()
                    lib.hideContext("manage_menu")
                    OpenBank()
                end
              },
              {
                title = 'Close',
                description = 'Close and exit from bank.',
                icon = 'ban',
                arrow = false,
                onSelect = function()
                    lib.hideContext("manage_menu")
                end
              },
            }
          })
        lib.registerContext({
            id = 'bank_menu',
            title = 'Los Santos Bank',
            canClose = true,
            menu = "mainmenu",
            options = {
              {
                title = 'Your Details',
                description = '🏦 Bank ⇢ $'..math.groupdigits(GetPlayerBank(), ".").."\n💰 Cash ⇢ $"..math.groupdigits(GetPlayerCash(), "."),
                icon = 'vault',
                arrow = false,
                onSelect = function()
                    lib.hideContext("bank_menu")
                    OpenBank()
                end
              },
              {
                title = 'Manage Your Account',
                description = 'You can deposit, withdraw or send money from your bank.',
                icon = 'gear',
                menu = "manage_menu",
                arrow = true,
              },
--[[ LATER               {
                title = 'Invoices',
                description = 'You can manage your invoices.',
                icon = 'file-invoice-dollar',
                menu = "invoicemenu",
                arrow = true,
              }, ]]
              {
                title = 'Close',
                description = 'Close and exit from bank.',
                icon = 'ban',
                arrow = false,
                onSelect = function()
                    lib.hideContext("bank_menu")
                end
              },
            }
          })
          lib.showContext("bank_menu")
    end
end)

--[[ CreateThread(function()
    for i = 1, #Config.locations do
        local blip = AddBlipForCoord(Config.locations[i])
        SetBlipSprite(blip, Config.blipInfo.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.blipInfo.scale)
        SetBlipColour(blip, Config.blipInfo.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(tostring(Config.blipInfo.name))
        EndTextCommandSetBlipName(blip)
    end
end) ]]

if Config.useTarget then
    if Config.target == 'qb' then
        CreateThread(function()
            for i = 1, #Config.locations do
                exports['qb-target']:AddCircleZone('bank_' .. i, Config.locations[i], 1.0, {
                    name = 'bank_' .. i,
                    useZ = true,
                    debugPoly = false,
                }, {
                    options = {
                        {
                            icon = 'fas fa-university',
                            label = 'Open Bank',
                            action = function()
                                OpenBank()
                            end,
                        }
                    },
                    distance = 1.5
                })
            end
        end)

        CreateThread(function()
            for i = 1, #Config.atmModels do
                local atmModel = Config.atmModels[i]
                exports['qb-target']:AddTargetModel(atmModel, {
                    options = {
                        {
                            icon = 'fas fa-university',
                            label = 'Open ATM',
                            item = 'bank_card',
                            action = function()
                                OpenATM()
                            end,
                        }
                    },
                    distance = 1.5
                })
            end
        end)
    elseif Config.target == 'ox' then
        CreateThread(function()
            for i = 1, #Config.locations do
                local data = {
                    coords = Config.locations[i],
                    radius = 1.5,
                    options = {
                        {
                            icon = 'fas fa-university',
                            label = 'Open Bank',
                            onSelect = function()
                                OpenBank()
                            end
                        }
                    }
                }
                exports.ox_target:addSphereZone(data)
            end
        end)

        CreateThread(function()
            for i = 1, #Config.atmModels do
                local atmModel = Config.atmModels[i]
                local data = {
                    {
                        icon = 'fas fa-university',
                        label = 'Open Bank',
                        distance = 1.5,
                        onSelect = function()
                            OpenBank()
                        end
                    }
                }
                exports.ox_target:addModel(atmModel, data)
            end
        end)
    end
end

if not Config.useTarget then
    CreateThread(function()
        for i = 1, #Config.locations do
            local zone = CircleZone:Create(Config.locations[i], 3.0, {
                name = 'bank_' .. i,
                debugPoly = false,
            })
            zones[#zones + 1] = zone
        end

        local combo = ComboZone:Create(zones, {
            name = 'bank_combo',
            debugPoly = false,
        })

        combo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                exports['qb-core']:DrawText('Open Bank')
                CreateThread(function()
                    while isPointInside do
                        Wait(0)
                        if IsControlJustPressed(0, 38) then
                            OpenBank()
                            break
                        end
                    end
                end)
            else
                exports['qb-core']:HideText()
            end
        end)
    end)
end
