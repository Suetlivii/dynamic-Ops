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
    PrintToDCS("SetRedGroupsStarted")

    redInfUnmounted = SET_GROUP:New()
    redInfUnmounted:FilterPrefixes( { "redInfUnmounted" } )
    redInfUnmounted:FilterOnce()

    redInfUnarmed = SET_GROUP:New()
    redInfUnarmed:FilterPrefixes( { "redInfUnarmed" } )
    redInfUnarmed:FilterOnce()

    redInfLight = SET_GROUP:New()
    redInfLight:FilterPrefixes( { "redInfLight" } )
    redInfLight:FilterOnce()

    redInfMed = SET_GROUP:New()
    redInfMed:FilterPrefixes( { "redInfMed" } )
    redInfMed:FilterOnce()

    redInfHeavy = SET_GROUP:New()
    redInfHeavy:FilterPrefixes( { "redInfHeavy" } )
    redInfHeavy:FilterOnce()

    redVehicleUnarmed = SET_GROUP:New()
    redVehicleUnarmed:FilterPrefixes( { "redVehicleUnarmed" } )
    redVehicleUnarmed:FilterOnce()

    redVehicleLight = SET_GROUP:New()
    redVehicleLight:FilterPrefixes( { "redVehicleLight" } )
    redVehicleLight:FilterOnce()

    redVehicleMed = SET_GROUP:New()
    redVehicleMed:FilterPrefixes( { "redVehicleMed" } )
    redVehicleMed:FilterOnce()

    redVehicleHeavy = SET_GROUP:New()
    redVehicleHeavy:FilterPrefixes( { "redVehicleHeavy" } )
    redVehicleHeavy:FilterOnce()

    redAawGuns = SET_GROUP:New()
    redAawGuns:FilterPrefixes( { "redAawGuns" } )
    redAawGuns:FilterOnce()

    redAawModern = SET_GROUP:New()
    redAawModern:FilterPrefixes( { "redAawModern" } )
    redAawModern:FilterOnce()

    redAawIr = SET_GROUP:New()
    redAawIr:FilterPrefixes( { "redAawIr" } )
    redAawIr:FilterOnce()

    redAawRadar = SET_GROUP:New()
    redAawRadar:FilterPrefixes( { "redAawRadar" } )
    redAawRadar:FilterOnce()

    redSamShort = SET_GROUP:New()
    redSamShort:FilterPrefixes( { "redSamShort" } )
    redSamShort:FilterOnce()

    redSamMed = SET_GROUP:New()
    redSamMed:FilterPrefixes( { "redSamMed" } )
    redSamMed:FilterOnce()

    redSamLong = SET_GROUP:New()
    redSamLong:FilterPrefixes( { "redSamLong" } )
    redSamLong:FilterOnce()

    redSuppTrack = SET_GROUP:New()
    redSuppTrack:FilterPrefixes( { "redSuppTrack" } )
    redSuppTrack:FilterOnce()

end

local function SetBlueGroups()
    
    blueInfUnmounted = SET_GROUP:New()
    blueInfUnmounted:FilterPrefixes( { "blueInfUnmounted" } )
    blueInfUnmounted:FilterOnce()

    blueInfUnarmed = SET_GROUP:New()
    blueInfUnarmed:FilterPrefixes( { "blueInfUnarmed" } )
    blueInfUnarmed:FilterOnce()

    blueInfLight = SET_GROUP:New()
    blueInfLight:FilterPrefixes( { "blueInfLight" } )
    blueInfLight:FilterOnce()

    blueInfMed = SET_GROUP:New()
    blueInfMed:FilterPrefixes( { "blueInfMed" } )
    blueInfMed:FilterOnce()

    blueInfHeavy = SET_GROUP:New()
    blueInfHeavy:FilterPrefixes( { "blueInfHeavy" } )
    blueInfHeavy:FilterOnce()

    blueVehicleUnarmed = SET_GROUP:New()
    blueVehicleUnarmed:FilterPrefixes( { "blueVehicleUnarmed" } )
    blueVehicleUnarmed:FilterOnce()

    blueVehicleLight = SET_GROUP:New()
    blueVehicleLight:FilterPrefixes( { "blueVehicleLight" } )
    blueVehicleLight:FilterOnce()

    blueVehicleMed = SET_GROUP:New()
    blueVehicleMed:FilterPrefixes( { "blueVehicleMed" } )
    blueVehicleMed:FilterOnce()

    blueVehicleHeavy = SET_GROUP:New()
    blueVehicleHeavy:FilterPrefixes( { "blueVehicleHeavy" } )
    blueVehicleHeavy:FilterOnce()

    blueAawGuns = SET_GROUP:New()
    blueAawGuns:FilterPrefixes( { "blueAawGuns" } )
    blueAawGuns:FilterOnce()

    blueAawModern = SET_GROUP:New()
    blueAawModern:FilterPrefixes( { "blueAawModern" } )
    blueAawModern:FilterOnce()

    blueAawIr = SET_GROUP:New()
    blueAawIr:FilterPrefixes( { "blueAawIr" } )
    blueAawIr:FilterOnce()

    blueAawRadar = SET_GROUP:New()
    blueAawRadar:FilterPrefixes( { "blueAawRadar" } )
    blueAawRadar:FilterOnce()

    blueSamShort = SET_GROUP:New()
    blueSamShort:FilterPrefixes( { "blueSamShort" } )
    blueSamShort:FilterOnce()

    blueSamMed = SET_GROUP:New()
    blueSamMed:FilterPrefixes( { "blueSamMed" } )
    blueSamMed:FilterOnce()

    blueSamLong = SET_GROUP:New()
    blueSamLong:FilterPrefixes( { "blueSamLong" } )
    blueSamLong:FilterOnce()

    blueSuppTrack = SET_GROUP:New()
    blueSuppTrack:FilterPrefixes( { "blueSuppTrack" } )
    blueSuppTrack:FilterOnce()

end

local function SetGroups()

    SetRedGroups()
    SetBlueGroups()

end

SetGroups()