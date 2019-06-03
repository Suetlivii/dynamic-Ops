Debug = Debuger:New(isDebugMode)
Debug:Log("Main Initialization")

MarkController = MarkCommandController:New()

if isDebugMode == true then 
    MarkController:SetExplosion()
    MarkController:SetSpawn()
end

BlueCombatScoreManager = CombatScoreManager:New(UnitsCost)

BlueCombatScoreManager:StartScoring()


anchorZone = ZONE:New("ga:cl<2>")

blueGenericZoneManager = GenericZoneManager:New(2, anchorZone:GetPointVec2())
blueGenericZoneManager:SetGenericZones("gz:")
blueGenericZoneManager:UpdateZonesCoalitions(400000, FrontlineDepth)

mainGroupSpawnersConfigurator = GroupSpawnersConfigurator:New(GroupSpawnersConfig)
mainGroupSpawnersConfigurator:UpdateZones(blueGenericZoneManager.blueRearZoneNamesList, blueGenericZoneManager.blueFrontLineZoneNamesList, blueGenericZoneManager.redRearZoneNamesList, blueGenericZoneManager.redFrontLineZoneNamesList)
mainGroupSpawnersConfigurator:InitializeSpawners()