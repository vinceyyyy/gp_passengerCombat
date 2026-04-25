RegisterNetEvent("gp_passengerCombat:hitTarget")
AddEventHandler("gp_passengerCombat:hitTarget", function(targetServerId)
    local src = source
    local shooterPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetServerId)

    if not DoesEntityExist(shooterPed) or not DoesEntityExist(targetPed) then
        print("Shooter or target ped don't exist!")
        return
    end

    if GetEntityHealth(shooterPed) <= 0 then
        print("Shooter ped has less than 0 hp!")
        return
    end

    local shooterVeh = GetVehiclePedIsIn(shooterPed)
    local targetVeh = GetVehiclePedIsIn(targetPed)

    if shooterVeh ~= 0 and targetVeh ~= 0 and shooterVeh == targetVeh then
        TriggerClientEvent("gp_passengerCombat:receiveDamage", targetServerId, Config.Damage)
    else
        print("Player ID " .. src .. " tried to kill from outside a vehicle or not the same vehicle.")
    end
end)