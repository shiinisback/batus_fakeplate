local QBCore = exports['qb-core']:GetCoreObject()
local removedPlates = {}
local L = function(key) return Lang[Config.Locale][key] or key end

function HasItem(item)
    if Config.Inventory == "ox" then
        return (exports.ox_inventory:Search('count', item) or 0) > 0
    elseif Config.Inventory == "qb" then
        local items = QBCore.Functions.GetPlayerData().items
        for _, v in pairs(items) do
            if v.name == item then return true end
        end
        return false
    end
end

function ShowProgress(label, duration, cb)
    if Config.Progress == "qbcore" then
        QBCore.Functions.Progressbar("fakeplate_action", label, duration, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 49,
        }, {}, {}, function()
            ClearPedTasks(PlayerPedId())
            cb(true)
        end, function()
            ClearPedTasks(PlayerPedId())
            cb(false)
        end)
    elseif Config.Progress == "progressbar" then
        exports['progressbar']:Progress({
            name = "fakeplate_action",
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                flags = 49,
            },
        }, function(cancelled)
            ClearPedTasks(PlayerPedId())
            cb(not cancelled)
        end)
    end
end

RegisterNetEvent('batus:client:attachFakePlate', function(vehicle)
    if removedPlates[vehicle] then
        return TriggerEvent("QBCore:Notify", L("already_has_fake"), "error")
    end

    if not HasItem(Config.Items.FakePlate) then
        return TriggerEvent("QBCore:Notify", L("no_fake_item"), "error")
    end

    if not HasItem(Config.Items.Lockpick) then
        return TriggerEvent("QBCore:Notify", L("no_lockpick"), "error")
    end

    ShowProgress(L("installing"), 4000, function(success)
        if success then
            local netId = VehToNet(vehicle)
            TriggerServerEvent("batus:plate:attachFake", netId)
            removedPlates[vehicle] = true
        else
            TriggerEvent("QBCore:Notify", L("cancelled"), "error")
        end
    end)
end)

RegisterNetEvent("batus:plate:setFake", function(fakePlate)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then vehicle = GetVehiclePedIsIn(ped, true) end
    if vehicle == 0 then return end

    Entity(vehicle).state:set("realplate", GetVehicleNumberPlateText(vehicle), true)
    Entity(vehicle).state:set("fakeplate", fakePlate, true)
    SetVehicleNumberPlateText(vehicle, fakePlate)
    TriggerEvent("QBCore:Notify", L("fake_attached") .. fakePlate, "success")
end)

RegisterNetEvent("batus:client:removeFakePlate", function(vehicle)
    if not removedPlates[vehicle] then
        return TriggerEvent("QBCore:Notify", L("no_fake_attached"), "error")
    end

    if not HasItem(Config.Items.Lockpick) then
        return TriggerEvent("QBCore:Notify", L("no_lockpick"), "error")
    end

    ShowProgress(L("removing"), 4000, function(success)
        if success then
            local realPlate = Entity(vehicle).state.realplate or ""
            SetVehicleNumberPlateText(vehicle, realPlate)
            Entity(vehicle).state:set("fakeplate", nil, true)
            removedPlates[vehicle] = nil
            TriggerEvent("QBCore:Notify", L("fake_removed"), "success")
        else
            TriggerEvent("QBCore:Notify", L("cancelled"), "error")
        end
    end)
end)

CreateThread(function()
    if Config.Target == "qb" then
        exports['qb-target']:AddGlobalVehicle({
            options = {
                {
                    label = L("target_attach"),
                    icon = "fas fa-mask",
                    action = function(entity)
                        TriggerEvent("batus:client:attachFakePlate", entity)
                    end,
                    canInteract = function(entity)
                        return not removedPlates[entity]
                    end
                },
                {
                    label = L("target_remove"),
                    icon = "fas fa-mask",
                    action = function(entity)
                        TriggerEvent("batus:client:removeFakePlate", entity)
                    end,
                    canInteract = function(entity)
                        return removedPlates[entity]
                    end
                }
            },
            distance = 2.5
        })
    elseif Config.Target == "ox" then
        exports['ox_target']:addGlobalVehicle({
            {
                label = L("target_attach"),
                icon = "fas fa-mask",
                onSelect = function(data)
                    TriggerEvent("batus:client:attachFakePlate", data.entity)
                end,
                canInteract = function(entity)
                    return not removedPlates[entity]
                end
            },
            {
                label = L("target_remove"),
                icon = "fas fa-mask",
                onSelect = function(data)
                    TriggerEvent("batus:client:removeFakePlate", data.entity)
                end,
                canInteract = function(entity)
                    return removedPlates[entity]
                end
            }
        })
    end
end)
