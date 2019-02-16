local isDebug = true

local function PrintToDCS(msg)
    if isDebug == true then
        debugController:PrintToDCS(msg)
    end
end

--Mission setting
local attackingCoalition

--Coalitions parameters
local isRedHQDestroyed = false
local redDismoral = 0

local isBlueHQDestroyed = false
local buleDismoral = 0

--Zone Sets
--local capZoneRed
local internalSetZonesRed
local externalSetZoneRed
local farSetZonesRed
local resupSetZonesRed

--local capZoneBlue
local internalSetZonesBlue
local externalSetZoneBlue
local farSetZonesBlue
local resupSetZonesBlue

local capZoneUn
--Group Sets

local function SetZonesUn(zonePrefix)

    PrintToDCS("SetZonesUN Started")
    capZoneUn = SET_ZONE:New()
    capZoneUn:FilterPrefixes( { zonePrefix .. "_captureZone_un_capture" } )
    capZoneUn:FilterOnce()
    if capZoneUn:Count() == 0 then PrintToDCS("capZoneUn is nil!") end
    PrintToDCS("SetZonesUN Ended")

end

local function SetZonesRed(zonePrefix)

    PrintToDCS("SetZonesRed Started")
    --GH10_captureZone_red_far_1 example
    --capZoneRed = SET_ZONE:New()
    --capZoneRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_capture" } )
    --capZoneRed:FilterOnce()
    --if capZoneRed:Count() == 0 then PrintToDCS("capZoneRed is nil!") end

    internalSetZonesRed = SET_ZONE:New()
    internalSetZonesRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_internal" } )
    internalSetZonesRed:FilterOnce()
    if internalSetZonesRed:Count() == 0 then PrintToDCS("internalSetZonesRed is nil!") end

    externalSetZoneRed = SET_ZONE:New()
    externalSetZoneRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_external" } )
    externalSetZoneRed:FilterOnce()
    if externalSetZoneRed:Count() == 0 then PrintToDCS("externalSetZoneRed is nil!") end

    farSetZonesRed = SET_ZONE:New()
    farSetZonesRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_far" } )
    farSetZonesRed:FilterOnce()
    if farSetZonesRed:Count() == 0 then PrintToDCS("farSetZonesRed is nil!") end

    resupSetZonesRed = SET_ZONE:New()
    resupSetZonesRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_resup" } )
    resupSetZonesRed:FilterOnce()
    if resupSetZonesRed:Count() == 0 then PrintToDCS("resupSetZonesRed is nil!") end

    PrintToDCS("SetZonesRed Ended")
end

local function SetZonesBlue(zonePrefix)

    --GH10_captureZone_red_far_1 example

    PrintToDCS("SetZonesBlue Started")
    --capZoneBlue = SET_ZONE:New()
    --capZoneBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_capture" } )
    --capZoneBlue:FilterOnce()
    --if capZoneBlue:Count() == 0 then PrintToDCS("capZoneBlue is nil!") end

    internalSetZonesBlue = SET_ZONE:New()
    internalSetZonesBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_internal" } )
    internalSetZonesBlue:FilterOnce()
    if internalSetZonesBlue:Count() == 0 then PrintToDCS("internalSetZonesBlue is nil!") end

    externalSetZoneBlue = SET_ZONE:New()
    externalSetZoneBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_external" } )
    externalSetZoneBlue:FilterOnce()
    if externalSetZoneBlue:Count() == 0 then PrintToDCS("externalSetZoneBlue is nil!") end

    farSetZonesBlue = SET_ZONE:New()
    farSetZonesBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_far" } )
    farSetZonesBlue:FilterOnce()
    if farSetZonesBlue:Count() == 0 then PrintToDCS("farSetZonesBlue is nil!") end

    resupSetZonesBlue = SET_ZONE:New()
    resupSetZonesBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_resup" } )
    resupSetZonesBlue:FilterOnce()
    if resupSetZonesBlue:Count() == 0 then PrintToDCS("resupSetZonesBlue is nil!") end

    PrintToDCS("SetZonesBlue Ended")
end

--local function SetSpawners()

--end

function StartMission(zonePrefix)

    SetZonesUn(zonePrefix)
    SetZonesBlue(zonePrefix)
    SetZonesRed(zonePrefix)

end

StartMission("GH10")