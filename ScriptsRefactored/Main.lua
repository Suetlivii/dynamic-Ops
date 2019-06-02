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

testZoneFilter = ZonePlacementFilter:New( {"forest"}, {"GH32"} )

testGroupSpawner = GroupSpawner:New("RedInf", 30, "fg:", 1)
testGroupSpawner:SetSpawnZones(testZoneFilter:FilterZoneNamesList(blueGenericZoneManager.allEnemyFrontZonesList))
testGroupSpawner:StartSpawn()