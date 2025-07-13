local QBCore = exports['qb-core']:GetCoreObject()

local function L(key)
    return Lang[Config.Locale][key] or ("[MISSING: " .. key .. "]")
end

RegisterServerEvent("batus:plate:attachFake", function(netId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local ent = NetworkGetEntityFromNetworkId(netId)
    local realPlate = GetVehicleNumberPlateText(ent)

    local function generateFakePlate()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local plate = ""
        for i = 1, 8 do
            local rand = math.random(1, #chars)
            plate = plate .. chars:sub(rand, rand)
        end
        return plate
    end

    local fakePlate = nil
    for _ = 1, 25 do
        local trial = generateFakePlate()
        local query = string.format(
            "SELECT %s FROM %s WHERE %s = ? OR %s = ?",
            Config.SQLInfo.plateColumn,
            Config.SQLInfo.vehiclesTable,
            Config.SQLInfo.plateColumn,
            Config.SQLInfo.fakePlateColumn
        )

        local result = SQLFetch(query, {trial, trial})
        if not result or not result[1] then
            fakePlate = trial
            break
        end
    end

    if not fakePlate then
        return TriggerClientEvent("QBCore:Notify", src, L("fakeplate_generation_failed"), "error")
    end

    local updateQuery = string.format(
        "UPDATE %s SET %s = ? WHERE %s = ?",
        Config.SQLInfo.vehiclesTable,
        Config.SQLInfo.fakePlateColumn,
        Config.SQLInfo.plateColumn
    )
    SQLExecute(updateQuery, {fakePlate, realPlate})

    if Player.Functions.RemoveItem(Config.Items.FakePlate, 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Items.FakePlate], 'remove')
        TriggerClientEvent("batus:plate:setFake", src, fakePlate)
        TriggerClientEvent("qb-vehiclekeys:client:AddKeys", src, fakePlate)
    else
        TriggerClientEvent("QBCore:Notify", src, L("fakeplate_not_found"), "error")
    end
end)


function SQLFetch(query, params)
    if Config.SQL == "oxmysql" then
        return exports.oxmysql:fetchSync(query, params)
    elseif Config.SQL == "ghmattimysql" then
        local result = nil
        exports.ghmattimysql:execute(query, params, function(res) result = res end)
        while result == nil do Wait(0) end
        return result
    elseif Config.SQL == "mysql-async" then
        local result = nil
        MySQL.Async.fetchAll(query, params, function(res) result = res end)
        while result == nil do Wait(0) end
        return result
    end
end

function SQLExecute(query, params)
    if Config.SQL == "oxmysql" then
        exports.oxmysql:execute(query, params)
    elseif Config.SQL == "ghmattimysql" then
        exports.ghmattimysql:execute(query, params)
    elseif Config.SQL == "mysql-async" then
        MySQL.Async.execute(query, params)
    end
end

local RESOURCE_NAME = "batus_fakeplate"
local CURRENT_VERSION = "1.0.0" 

Citizen.CreateThread(function()
    PerformHttpRequest("https://api.github.com/repos/shiinisback/batus_fakeplate/releases/latest", function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            local latestVersion = data.tag_name or "unknown"
            print("^2["..RESOURCE_NAME.."] Current Version: "..CURRENT_VERSION.." | Latest Version on GitHub: "..latestVersion.."^7")

            if latestVersion ~= CURRENT_VERSION then
                print("^1["..RESOURCE_NAME.."] Update available! Please check GitHub for the latest release.^7")
            else
                print("^3["..RESOURCE_NAME.."] You are running the latest version.^7")
            end
        else
            print("^1["..RESOURCE_NAME.."] Failed to fetch latest version info from GitHub. Status: "..tostring(statusCode).."^7")
        end
    end, "GET", "", {["User-Agent"] = "FiveM"})
end)
