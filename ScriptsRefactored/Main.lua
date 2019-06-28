Debug = Debuger:New(isDebugMode)
Debug:Log("Main Initialization")

MarkController = MarkCommandController:New()

if isDebugMode == true then 
    MarkController:SetExplosion()
    MarkController:SetSpawn()
end

BlueCombatScoreManager = CombatScoreManager:New(UnitsCost)

BlueCombatScoreManager:StartScoring()


anchorZone = ZONE:New(FrontlineAnchorZoneName)

blueGenericZoneManager = GenericZoneManager:New(FrontLineAnchorCoalition, anchorZone:GetPointVec2())
blueGenericZoneManager:SetGenericZones(GenericZonePrefix)
blueGenericZoneManager:UpdateZonesCoalitions(DefaultFrontlineDistance, FrontlineDepth)

mainGroupSpawnersConfigurator = GroupSpawnersConfigurator:New(GroupSpawnersConfig)
mainGroupSpawnersConfigurator:UpdateZones(blueGenericZoneManager.blueRearZoneNamesList, blueGenericZoneManager.blueFrontLineZoneNamesList, blueGenericZoneManager.redRearZoneNamesList, blueGenericZoneManager.redFrontLineZoneNamesList)
mainGroupSpawnersConfigurator:InitializeSpawners()

mainFrontlineCombatAndPatrolZonesManager = FrontlineCombatAndPatrolZonesManager:New(FrontLineAnchorCoalition, FrontlineCombatZoneRadius, FrontlinePatrolZoneOffset)
mainFrontlineCombatAndPatrolZonesManager:UpdateZones(DefaultFrontlineDistance, blueGenericZoneManager.allGenericZonesList)

mainA2AController = A2AController:New()
mainA2AController:SetFrontlineAnchor(FrontlineAnchorZoneName)
mainA2AController:SetFrontlineDistance(DefaultFrontlineDistance)
mainA2AController:SetDispatcher(EWRPrefix, DefaultDetectionRange, DefaultEngageRadius, DefaultGciRadius, mainFrontlineCombatAndPatrolZonesManager.frontlineZone)

mainA2AConfigurator = A2AConfigurator:New()
mainA2AConfigurator:SetA2AConfigs(A2AConfig)
mainA2AConfigurator:SetController(mainA2AController)

mainA2GController = A2GController:New(A2GConfigs)
mainA2GController:SetFrontline(FrontlineAnchorZoneName, DefaultFrontlineDistance)
mainA2GController:SetZones(mainFrontlineCombatAndPatrolZonesManager.frontlineZone, mainFrontlineCombatAndPatrolZonesManager.redPatrolZone)
mainA2GController:StartBAI(600, 0.5, 2)