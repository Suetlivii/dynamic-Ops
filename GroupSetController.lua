local isDebug = true

local function PrintToDCS(msg)
    if isDebug == true then
        debugController:PrintToDCS(msg)
    end
end
--group Sets red

redInfUnmounted = nil
redInfUnarmed = nil
redInfLight = nil
redInfMed = nil
redInfHeavy = nil

redVehicleUnarmed = nil 
redVehicleLight = nil
redVehicleMed = nil
redVehicleHeavy = nil

redAawGuns = nil
redAawModern = nil
redAawIr = nil
redAawRadar = nil

redSamShort = nil
redSamMed = nil
redSamLong = nil

redSuppTrack = nil

--group Sets Blue

blueInfUnmounted = nil
blueInfUnarmed = nil
blueInfLight = nil
blueInfMed = nil
blueInfHeavy = nil

blueVehicleUnarmed = nil 
blueVehicleLight = nil
blueVehicleMed = nil
blueVehicleHeavy = nil

blueAawGuns = nil
blueAawModern = nil
blueAawIr = nil
blueAawRadar = nil

blueSamShort = nil
blueSamMed = nil
blueSamLong = nil

blueSuppTrack = nil

local function SetRedGroups()
    PrintToDCS("SetRedGroups Started")

    redInfUnmounted = SET_GROUP:New()
    redInfUnmounted:FilterPrefixes( { "redInfUnmounted" } )
    redInfUnmounted:FilterOnce()
    if redInfUnmounted:Count() == 0 then PrintToDCS("redInfUnmounted is nil!") end

    redInfUnarmed = SET_GROUP:New()
    redInfUnarmed:FilterPrefixes( { "redInfUnarmed" } )
    redInfUnarmed:FilterOnce()
    if redInfUnarmed:Count() == 0 then PrintToDCS("redInfUnarmed is nil!") end

    redInfLight = SET_GROUP:New()
    redInfLight:FilterPrefixes( { "redInfLight" } )
    redInfLight:FilterOnce()
    if redInfLight:Count() == 0 then PrintToDCS("redInfLight is nil!") end

    redInfMed = SET_GROUP:New()
    redInfMed:FilterPrefixes( { "redInfMed" } )
    redInfMed:FilterOnce()
    if redInfMed:Count() == 0 then PrintToDCS("redInfMed is nil!") end

    redInfHeavy = SET_GROUP:New()
    redInfHeavy:FilterPrefixes( { "redInfHeavy" } )
    redInfHeavy:FilterOnce()
    if redInfHeavy:Count() == 0 then PrintToDCS("redInfHeavy is nil!") end

    redVehicleUnarmed = SET_GROUP:New()
    redVehicleUnarmed:FilterPrefixes( { "redVehicleUnarmed" } )
    redVehicleUnarmed:FilterOnce()
    if redVehicleUnarmed:Count() == 0 then PrintToDCS("redVehicleUnarmed is nil!") end

    redVehicleLight = SET_GROUP:New()
    redVehicleLight:FilterPrefixes( { "redVehicleLight" } )
    redVehicleLight:FilterOnce()
    if redVehicleLight:Count() == 0 then PrintToDCS("redVehicleLight is nil!") end

    redVehicleMed = SET_GROUP:New()
    redVehicleMed:FilterPrefixes( { "redVehicleMed" } )
    redVehicleMed:FilterOnce()
    if redVehicleMed:Count() == 0 then PrintToDCS("redVehicleMed is nil!") end

    redVehicleHeavy = SET_GROUP:New()
    redVehicleHeavy:FilterPrefixes( { "redVehicleHeavy" } )
    redVehicleHeavy:FilterOnce()
    if redVehicleHeavy:Count() == 0 then PrintToDCS("redVehicleHeavy is nil!") end

    redAawGuns = SET_GROUP:New()
    redAawGuns:FilterPrefixes( { "redAawGuns" } )
    redAawGuns:FilterOnce()
    if redAawGuns:Count() == 0 then PrintToDCS("redAawGuns is nil!") end

    redAawModern = SET_GROUP:New()
    redAawModern:FilterPrefixes( { "redAawModern" } )
    redAawModern:FilterOnce()
    if redAawModern:Count() == 0 then PrintToDCS("redAawModern is nil!") end

    redAawIr = SET_GROUP:New()
    redAawIr:FilterPrefixes( { "redAawIr" } )
    redAawIr:FilterOnce()
    if redAawIr:Count() == 0 then PrintToDCS("redAawIr is nil!") end

    redAawRadar = SET_GROUP:New()
    redAawRadar:FilterPrefixes( { "redAawRadar" } )
    redAawRadar:FilterOnce()
    if redAawRadar:Count() == 0 then PrintToDCS("redAawRadar is nil!") end

    redSamShort = SET_GROUP:New()
    redSamShort:FilterPrefixes( { "redSamShort" } )
    redSamShort:FilterOnce()
    if redSamShort:Count() == 0 then PrintToDCS("redSamShort is nil!") end

    redSamMed = SET_GROUP:New()
    redSamMed:FilterPrefixes( { "redSamMed" } )
    redSamMed:FilterOnce()
    if redSamMed:Count() == 0 then PrintToDCS("redSamMed is nil!") end

    redSamLong = SET_GROUP:New()
    redSamLong:FilterPrefixes( { "redSamLong" } )
    redSamLong:FilterOnce()
    if redSamLong:Count() == 0 then PrintToDCS("redSamLong is nil!") end

    redSuppTrack = SET_GROUP:New()
    redSuppTrack:FilterPrefixes( { "redSuppTrack" } )
    redSuppTrack:FilterOnce()
    if redSuppTrack:Count() == 0 then PrintToDCS("redSuppTrack is nil!") end

    PrintToDCS("SetRedGroups Finished")

end

local function SetBlueGroups()

    PrintToDCS("SetBlueGroups Started")

    blueInfUnmounted = SET_GROUP:New()
    blueInfUnmounted:FilterPrefixes( { "blueInfUnmounted" } )
    blueInfUnmounted:FilterOnce()
    if blueInfUnmounted:Count() == 0 then PrintToDCS("blueInfUnmounted is nil!") end

    blueInfUnarmed = SET_GROUP:New()
    blueInfUnarmed:FilterPrefixes( { "blueInfUnarmed" } )
    blueInfUnarmed:FilterOnce()
    if blueInfUnarmed:Count() == 0 then PrintToDCS("blueInfUnarmed is nil!") end

    blueInfLight = SET_GROUP:New()
    blueInfLight:FilterPrefixes( { "blueInfLight" } )
    blueInfLight:FilterOnce()
    if blueInfLight:Count() == 0 then PrintToDCS("blueInfLight is nil!") end

    blueInfMed = SET_GROUP:New()
    blueInfMed:FilterPrefixes( { "blueInfMed" } )
    blueInfMed:FilterOnce()
    if blueInfMed:Count() == 0 then PrintToDCS("blueInfMed is nil!") end

    blueInfHeavy = SET_GROUP:New()
    blueInfHeavy:FilterPrefixes( { "blueInfHeavy" } )
    blueInfHeavy:FilterOnce()
    if blueInfHeavy:Count() == 0 then PrintToDCS("blueInfHeavy is nil!") end

    blueVehicleUnarmed = SET_GROUP:New()
    blueVehicleUnarmed:FilterPrefixes( { "blueVehicleUnarmed" } )
    blueVehicleUnarmed:FilterOnce()
    if blueVehicleUnarmed:Count() == 0 then PrintToDCS("blueVehicleUnarmed is nil!") end

    blueVehicleLight = SET_GROUP:New()
    blueVehicleLight:FilterPrefixes( { "blueVehicleLight" } )
    blueVehicleLight:FilterOnce()
    if blueVehicleLight:Count() == 0 then PrintToDCS("blueVehicleLight is nil!") end

    blueVehicleMed = SET_GROUP:New()
    blueVehicleMed:FilterPrefixes( { "blueVehicleMed" } )
    blueVehicleMed:FilterOnce()
    if blueVehicleMed:Count() == 0 then PrintToDCS("blueVehicleMed is nil!") end

    blueVehicleHeavy = SET_GROUP:New()
    blueVehicleHeavy:FilterPrefixes( { "blueVehicleHeavy" } )
    blueVehicleHeavy:FilterOnce()
    if blueVehicleHeavy:Count() == 0 then PrintToDCS("blueVehicleHeavy is nil!") end

    blueAawGuns = SET_GROUP:New()
    blueAawGuns:FilterPrefixes( { "blueAawGuns" } )
    blueAawGuns:FilterOnce()
    if blueAawGuns:Count() == 0 then PrintToDCS("blueAawGuns is nil!") end

    blueAawModern = SET_GROUP:New()
    blueAawModern:FilterPrefixes( { "blueAawModern" } )
    blueAawModern:FilterOnce()
    if blueAawModern:Count() == 0 then PrintToDCS("blueAawModern is nil!") end

    blueAawIr = SET_GROUP:New()
    blueAawIr:FilterPrefixes( { "blueAawIr" } )
    blueAawIr:FilterOnce()
    if blueAawIr:Count() == 0 then PrintToDCS("blueAawIr is nil!") end

    blueAawRadar = SET_GROUP:New()
    blueAawRadar:FilterPrefixes( { "blueAawRadar" } )
    blueAawRadar:FilterOnce()
    if blueAawRadar:Count() == 0 then PrintToDCS("blueAawRadar is nil!") end

    blueSamShort = SET_GROUP:New()
    blueSamShort:FilterPrefixes( { "blueSamShort" } )
    blueSamShort:FilterOnce()
    if blueSamShort:Count() == 0 then PrintToDCS("blueSamShort is nil!") end

    blueSamMed = SET_GROUP:New()
    blueSamMed:FilterPrefixes( { "blueSamMed" } )
    blueSamMed:FilterOnce()
    if blueSamMed:Count() == 0 then PrintToDCS("blueSamMed is nil!") end

    blueSamLong = SET_GROUP:New()
    blueSamLong:FilterPrefixes( { "blueSamLong" } )
    blueSamLong:FilterOnce()
    if blueSamLong:Count() == 0 then PrintToDCS("blueSamLong is nil!") end

    blueSuppTrack = SET_GROUP:New()
    blueSuppTrack:FilterPrefixes( { "blueSuppTrack" } )
    blueSuppTrack:FilterOnce()
    if blueSuppTrack:Count() == 0 then PrintToDCS("blueSuppTrack is nil!") end

    PrintToDCS("SetBlueGroups Finished")

end

local function SetGroups()

    SetRedGroups()
    SetBlueGroups()

end

SetGroups()