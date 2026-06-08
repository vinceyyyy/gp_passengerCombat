local WEAPON_UNARMED = `WEAPON_UNARMED`
local combatThreadActive = false

function startPassengerCombatThread()
    if combatThreadActive then return end
    combatThreadActive = true

    Citizen.CreateThread(function()
        while combatThreadActive do
            local sleep = 1000 
            
            local playerPed = cache.ped
            local currentVeh = cache.vehicle
            local currentWeapon = cache.weapon

            if currentWeapon and currentWeapon ~= WEAPON_UNARMED and currentVeh then
                local isAiming = IsControlPressed(0, 25) -- right click
                local isBlindFiring = IsControlPressed(0, 69) -- left click
                local canShoot = false

                if Config.RequireAiming then
                    canShoot = isAiming
                else
                    canShoot = isAiming or isBlindFiring
                end
                
                if canShoot then
                    sleep = 5

                    local muzzleCoords = GetWeaponMuzzleCoords(playerPed)
                    local camRot = GetGameplayCamRot(2)
                    local direction = CameraRotationToVector(camRot)
                    local endCoords = muzzleCoords + (direction * Config.MaxDistance)
                    
                    local targetFound = false
                    local targetPedToHit = 0
                    local isFirstPerson = (GetFollowVehicleCamViewMode() == 4)
    
                    if not Config.FirstPersonOnly or (Config.FirstPersonOnly and isFirstPerson) then
                        local maxSeats = GetVehicleMaxNumberOfPassengers(currentVeh)
                        
                        for seat = -1, maxSeats - 1 do
                            local targetPed = GetPedInVehicleSeat(currentVeh, seat)
                            
                            if targetPed ~= 0 and targetPed ~= playerPed then
                                local headCoords = GetPedBoneCoords(targetPed, 31086, 0.0, 0.0, 0.0) 
                                local distToHead = GetDistancePointToLine(headCoords, muzzleCoords, endCoords)
    
                                if distToHead < Config.HeadshotRadius then
                                    targetFound = true
                                    targetPedToHit = targetPed
                                    break
                                end
                            end
                        end
                    end
    
                    -- Continuous shooting
                    if targetFound then
                        DisablePlayerFiring(PlayerId(), true) 
                        DisableControlAction(0, 24, true)
                        DisableControlAction(0, 69, true)
    
                        if IsDisabledControlPressed(0, 24) or IsDisabledControlJustPressed(0, 69) then
                            local hasAmmo, ammoInClip = GetAmmoInClip(playerPed, currentWeapon)
                            
                            if hasAmmo and ammoInClip > 0 then
                                SetPedShootsAtCoord(playerPed, endCoords.x, endCoords.y, endCoords.z, true)
                                
                                if GetResourceState('ox_inventory') == 'started' then
                                    TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', ammoInClip - 1)
                                end
                                
                                if IsPedAPlayer(targetPedToHit) then
                                    local targetPlayerId = NetworkGetPlayerIndexFromPed(targetPedToHit)
                                    local targetServerId = GetPlayerServerId(targetPlayerId)
                                    TriggerServerEvent("gp_passengerCombat:hitTarget", targetServerId)
                                else
                                    if GetEntityHealth(targetPedToHit) > 0 then
                                        ApplyDamageToPed(targetPedToHit, Config.Damage, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end 
            Citizen.Wait(sleep) 
        end 
    end)
end

lib.onCache('vehicle', function(vehicle)
    if vehicle then
        startPassengerCombatThread()
    else
        combatThreadActive = false
    end
end)

RegisterNetEvent("gp_passengerCombat:receiveDamage")
AddEventHandler("gp_passengerCombat:receiveDamage", function(damage)
    local myPed = cache.ped
    
    if GetPlayerInvincible(PlayerId()) or not GetEntityCanBeDamaged(myPed) then
        return
    end

    ApplyDamageToPed(myPed, damage, false)

    if not HasNamedPtfxAssetLoaded("core") then
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do Wait(0) end
    end

    UseParticleFxAssetNextCall("core")
    StartNetworkedParticleFxNonLoopedOnPedBone("blood_headshot", myPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 31086, 1.5, false, false, false)
    RemoveNamedPtfxAsset("core")
end)