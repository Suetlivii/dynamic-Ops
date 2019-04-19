-------------------------------
--CapGCIController controlls enemy aircrafts

DetectionSetGroup = SET_GROUP:New()

DetectionSetGroup:FilterPrefixes( { "AirdefenceRadarEwr" } )
DetectionSetGroup:FilterStart()


-- Setup the detection and group targets to a 30km range!
local Detection = DETECTION_AREAS:New( DetectionSetGroup, 20000 )

-- Setup the A2A dispatcher, and initialize it.
local A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )

--ABBorderZone = ZONE_POLYGON:New( "AB", GROUP:FindByName( "RedBorderPlane" ) )
ABBorderZone = mainSectorZonesManager:GetSectorZone(mainCampaignStateManager:GetFrontSectorID(coalition.side.RED))
--tasksReportController:Debug("CapGCIController: Squadron Cap Zone name is " .. ABBorderZone:GetName())
A2ADispatcher:SetBorderZone( ABBorderZone )

A2ADispatcher:SetSquadron( "mig29Sukhumi", AIRBASE.Caucasus.Sukhumi_Babushara, { "RedPlaneMilitaryFighterMig29s" }, 8 )
A2ADispatcher:SetSquadron( "su27Gudauta", AIRBASE.Caucasus.Gudauta, { "RedPlaneMilitaryFighterSu27" }, 4 )

A2ADispatcher:SetSquadronTakeoffFromParkingHot( "mig29Sukhumi" )
A2ADispatcher:SetSquadronTakeoffFromParkingHot( "su27Gudauta" )

A2ADispatcher:SetSquadronLandingAtEngineShutdown( "mig29Sukhumi" )
A2ADispatcher:SetSquadronLandingAtEngineShutdown( "su27Gudauta" )

A2ADispatcher:SetSquadronCap( "mig29Sukhumi", ABBorderZone, 600, 6500, 600, 800, 800, 1200, "RADIO" )
tasksReportController:Debug("CapGCIController: Squadron Cap Zone name is " .. ABBorderZone:GetName())
A2ADispatcher:SetSquadronCapInterval( "mig29Sukhumi", 3, 700, 900, 1 )

A2ADispatcher:SetSquadronGci( "su27Gudauta", 900, 1200 )
--A2ADispatcher:SetSquadronGci( "mig29Sukhumi", 900, 1200 )

A2ADispatcher:SetDefaultGrouping(2)

A2ADispatcher:SetDefaultOverhead(0.5)

A2ADispatcher:SetEngageRadius( 200000 )

A2ADispatcher:SetGciRadius( 300000 )