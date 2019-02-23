DetectionSetGroup = SET_GROUP:New()
DetectionSetGroup:FilterPrefixes( { "RU EWR" } )
DetectionSetGroup:FilterStart()


-- Setup the detection and group targets to a 30km range!
local Detection = DETECTION_AREAS:New( DetectionSetGroup, 20000 )

-- Setup the A2A dispatcher, and initialize it.
local A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )

A2ADispatcher:SetDefaultGrouping(2)

A2ADispatcher:SetDefaultOverhead(2)

A2ADispatcher:SetEngageRadius( 130000 )

A2ADispatcher:SetGciRadius( 200000 )

ABBorderZone = ZONE_POLYGON:New( "AB", GROUP:FindByName( "borderPlane" ) )
A2ADispatcher:SetBorderZone( ABBorderZone )

A2ADispatcher:SetSquadron( "mig23Gudauta", AIRBASE.Caucasus.Gudauta, { "RU mig23" }, 12 )
A2ADispatcher:SetSquadron( "mig29Gudauta", AIRBASE.Caucasus.Gudauta, { "RU mig29" }, 10 )

A2ADispatcher:SetSquadronTakeoffFromParkingHot( "mig23Gudauta" )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "mig29Gudauta" )

A2ADispatcher:SetSquadronLandingAtEngineShutdown( "mig23Gudauta" )
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "mig29Gudauta" )

RUcapZone = ZONE:New( "redCapZone")
A2ADispatcher:SetSquadronCap( "mig23Gudauta", RUcapZone, 600, 6500, 600, 800, 800, 1200, "RADIO" )
A2ADispatcher:SetSquadronCapInterval( "mig23Gudauta", 3, 30, 60, 1 )

A2ADispatcher:SetSquadronGci( "mig23Gudauta", 900, 1200 )
A2ADispatcher:SetSquadronGci( "mig29Gudauta", 900, 1200 )
