-- A2GConfigExample =
-- {
--     groupPrefix = "su25Red",
--     spawnedGroupNamePrefix = "BAI:",
--     airbaseName = "Kobuleti",
--     minAlt = 2000,
--     maxAlt = 5000
-- }

A2GController = {}

function A2GController:New(_config)
    newObj = 
    {
        a2gConfig = _config,
        combatZoneName = nil,
        patrolZoneName = nil,
        baiZone = nil
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function A2GController:SetZones(_combatZoneName, _patrolZoneName)
    if _combatZoneName ~= nil and _combatZoneName ~= "" then 
        self.combatZoneName = _combatZoneName
    end 
    if _patrolZoneName ~= nil and _patrolZoneName ~= "" then 
        self.patrolZoneName = _patrolZoneName
    end 
end

function A2GController:GetRandomGroup()
    local groupsInRangeList = {}

    for i in ipairs(self.a2gConfig) do 

        local airbaseCoord = AIRBASE:FindByName(self.a2gConfig[i].airbaseName):GetPointVec2()

        if self:CheckPosFromFrontline()
    end

end

function A2GController:CheckPosFromFrontline(_posCoord, _anchorCoord, frontlineDistance, _minDist, _maxDist)
    
    local anchorCoord = ZONE:FindByName(_frontlineAnchorZoneName):GetPointVec2()
    local distanceFromAnchor = AIRBASE:FindByName(_airbaseName):GetPointVec2():Get2DDistance(anchorCoord)

    return true
end

function A2GController:SpawnBAIGroup(_LAgroup, _airBaseName)

    if self.patrolZoneName == nil then 
        Debug:Log("A2GController:SpawnBAIGroup() patrolZoneName is nil, impossible to start BAI")
        return nil 
    end

    if self.combatZoneName == nil then 
        Debug:Log("A2GController:SpawnBAIGroup() combatZoneName is nil, impossible to start BAI")
        return nil 
    end

    local patrolZone = ZONE:New(self.patrolZoneName)
    local combatZone = ZONE:New(self.combatZoneName)

    local baiController = AI_BAI_ZONE:New( patrolZone, 500, 4000, 400, 1000, combatZone )

    if _LAgroup ~= nil and _airBaseName ~= nil then
        local groupSpawn = SPAWN:New(_LAgroup)
        local spawnedGroup = groupSpawn:SpawnAtAirbase( AIRBASE:FindByName(_airBaseName), SPAWN.Takeoff.Hot )
    end

    baiController:SetControllable( spawnedGroup )
    baiController:__Start( 1 )
    baiController:__Engage( 3 )

end

function A2GController:StartBAI(_minSpawnLimit, _maxSpawnLimit, _groupsLimitPerTime)

end