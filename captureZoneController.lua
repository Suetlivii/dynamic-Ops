--Mission setting
local attackingCoalition

--Coalitions parameters
local isRedHQDestroyed = false
local redDismoral = 0

local isBlueHQDestroyed = false
local buleDismoral = 0

--Zone Sets
local capZoneRed
local internalSetZonesRed
local externalSetZoneRed
local farSetZonesRed
local resupSetZonesRed

local capZoneBlue
local internalSetZonesBlue
local externalSetZoneBlue
local farSetZonesBlue
local resupSetZonesBlue

--Group Sets
local 

function StartMission(zonePrefix)



    
end

local function SetZonesRed(zonePrefix)

    --GH10_captureZone_red_far_1 example
    capZoneRed = SET_ZONE:New()
    capZoneRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_capture" } )
    capZoneRed:FilterOnce()

    internalSetZonesRed = SET_ZONE:New()
    internalSetZonesRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_internal" } )
    internalSetZonesRed:FilterOnce()

    externalSetZoneRed = SET_ZONE:New()
    externalSetZoneRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_external" } )
    externalSetZoneRed:FilterOnce()

    farSetZonesRed = SET_ZONE:New()
    farSetZonesRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_far" } )
    farSetZonesRed:FilterOnce()

    resupSetZonesRed = SET_ZONE:New()
    resupSetZonesRed:FilterPrefixes( { zonePrefix .. "_captureZone_red_resup" } )
    resupSetZonesRed:FilterOnce()

end

local function SetZonesBlue(zonePrefix)

    --GH10_captureZone_red_far_1 example
    capZoneBlue = SET_ZONE:New()
    capZoneBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_capture" } )
    capZoneBlue:FilterOnce()

    internalSetZonesBlue = SET_ZONE:New()
    internalSetZonesBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_internal" } )
    internalSetZonesBlue:FilterOnce()

    externalSetZoneBlue = SET_ZONE:New()
    externalSetZoneBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_external" } )
    externalSetZoneBlue:FilterOnce()

    farSetZonesBlue = SET_ZONE:New()
    farSetZonesBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_far" } )
    farSetZonesBlue:FilterOnce()

    resupSetZonesBlue = SET_ZONE:New()
    resupSetZonesBlue:FilterPrefixes( { zonePrefix .. "_captureZone_blue_resup" } )
    resupSetZonesBlue:FilterOnce()

end

local function SetSpawners()



end