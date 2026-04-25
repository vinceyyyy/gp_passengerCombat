
function GetDistancePointToLine(point, lineStart, lineEnd)
    local AB = vector3(lineEnd.x - lineStart.x, lineEnd.y - lineStart.y, lineEnd.z - lineStart.z)
    local AP = vector3(point.x - lineStart.x, point.y - lineStart.y, point.z - lineStart.z)

    -- Dot Product
    local dotAP_AB = (AP.x * AB.x) + (AP.y * AB.y) + (AP.z * AB.z)
    local ab2 = (AB.x * AB.x) + (AB.y * AB.y) + (AB.z * AB.z)
    
    -- Next point on line (0 = Start, 1 = Ende)
    local t = dotAP_AB / ab2

    -- Avoid hitting someone behind you
    if t < 0.0 then t = 0.0 end
    if t > 1.0 then t = 1.0 end

    -- Coordinates of closest point from head to ray
    local closestPoint = vector3(
        lineStart.x + t * AB.x,
        lineStart.y + t * AB.y,
        lineStart.z + t * AB.z
    )

    -- Distance
    return #(point - closestPoint)
end

-- Exact position of weapon muzzle
function GetWeaponMuzzleCoords(ped)
    local weaponEntity = GetCurrentPedWeaponEntityIndex(ped)
    if DoesEntityExist(weaponEntity) then
        local boneIndex = GetEntityBoneIndexByName(weaponEntity, "gun_muzzle")
        if boneIndex ~= -1 then
            return GetWorldPositionOfEntityBone(weaponEntity, boneIndex)
        end
    end
    -- Player's right hand as fallback
    return GetPedBoneCoords(ped, 24806, 0.0, 0.0, 0.0)
end

-- (Camera) rotation to vector3
function CameraRotationToVector(rotation)
    local radZ = math.rad(rotation.z)
    local radX = math.rad(rotation.x)
    local num = math.abs(math.cos(radX))
    
    return vector3(
        -math.sin(radZ) * num,
        math.cos(radZ) * num,
        math.sin(radX)
    )
end