-- A2GConfigExample =
-- {
--     groupPrefix = "su25Red",
--     spawnedGroupNamePrefix = "BAI:",
--     airbaseName = "Kobuleti",
--     minAlt = 2000,
--     maxAlt = 5000,
--     minDistance = 40000,
--     maxDistance = 100000
-- }

A2GController = {}

function A2GController:New(_config)
    newObj = 
    {
        a2gConfig = _config,
        combatZone = nil,
        patrolZone = nil,
        baiZone = nil,
        anchorZoneName = nil,
        frontlineDistance = nil,
        minDist = nil,
        maxDist = nil,
        baiControllersList = {},
        groupSpawners = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function A2GController:SetFrontline(_anchorZoneName, _frontlineDistance)
    if ZONE:New(_anchorZoneName) ~= nil then 
        self.anchorZoneName = _anchorZoneName
        self.frontlineDistance = _frontlineDistance
        Debug:Log("A2GController:SetFrontline() frontline settings set")
    else 
        Debug:Log("A2GController:SetFrontline() no anchor zone found")
    end
end

function A2GController:SetZones(_combatZone, _patrolZone)
    if _combatZone ~= nil then 
        self.combatZone = _combatZone
    end 
    if _patrolZone ~= nil then 
        self.patrolZone = _patrolZone
    end 
end

function A2GController:GetRandomGroup()
    local groupsInRangeList = {}

    for i in ipairs(self.a2gConfig) do 
        if self:CheckPosFromFrontline(nil, nil, self.frontlineDistance, self.minDist, self.maxDist) == true then 
            table.insert(groupsInRangeList, self.a2gConfig[i])
        end
    end

    if #groupsInRangeList < 1 then 
        Debug:Log("A2GController:GetRandomGroup() no group to choose")
    else
        local rnd = math.random(1, #groupsInRangeList)
        return groupsInRangeList[rnd]
    end

end

function A2GController:CheckPosFromFrontline(_posCoord, _anchorCoord, frontlineDistance, _minDist, _maxDist)
    Debug:Log("A2GController:CheckPosFromFrontline() pos is in zone, returning true")
    return true
end

function A2GController:SpawnBAIGroup(_LAgroup, _airBaseName)

    if self.patrolZone == nil then 
        Debug:Log("A2GController:SpawnBAIGroup() patrolZoneName is nil, impossible to start BAI")
        return nil 
    end

    if self.combatZone == nil then 
        Debug:Log("A2GController:SpawnBAIGroup() combatZoneName is nil, impossible to start BAI")
        return nil 
    end

    if AIRBASE:FindByName(_airBaseName):GetCoalition() ~= GROUP:FindByName(_LAgroup):GetCoalition() then 
        Debug:Log("A2GController:SpawnBAIGroup() group coalition is not equal airbasae coalition")
        return nil
    end


    Debug:Log("A2GController:SpawnBAIGroup() combat zone radius is " .. self.combatZone:GetRadius() .. " patrol zone radius is " .. self.patrolZone:GetRadius())

    table.insert( self.baiControllersList, AI_CAS_ZONE:New( self.patrolZone, 500, 4000, 400, 1000, self.combatZone ) )

    if _LAgroup ~= nil and _airBaseName ~= nil then
        table.insert( self.groupSpawners, SPAWN:NewWithAlias(_LAgroup, "BAI:" .. #self.groupSpawners))
        self.groupSpawners[#self.groupSpawners]
        :OnSpawnGroup(
            function( SpawnGroup )
                self:InitializeBai(SpawnGroup, self.baiControllersList[#self.baiControllersList])
            end 
        )
        local spawnedGroup = self.groupSpawners[#self.groupSpawners]:SpawnAtAirbase( AIRBASE:FindByName(_airBaseName), SPAWN.Takeoff.Hot )
        Debug:Log("A2GController:SpawnBAIGroup() new spawner created, spawner number " .. #self.groupSpawners)
    end
end

function A2GController:InitializeBai(_group, baiController)
    baiController:SetControllable( _group ) 
    baiController:__Start( 1 )
    baiController:__Engage( 60, 650, 600)
    Debug:Log("A2GController:SpawnBAIGroup() BAI started for group " .. _group:GetName())
end

function A2GController:StartBAI(_spawnTime, _spawnTimeRnd, _groupsLimitPerTime)
    local selfObj = self

    Check, CheckScheduleID = SCHEDULER:New(nil,
    function()
        if #self.baiControllersList < _groupsLimitPerTime then
            local config = selfObj:GetRandomGroup()
            if config ~= nil then 
                selfObj:SpawnBAIGroup(config.groupPrefix, config.airbaseName)
            end
        end
    end, {}, 5, _spawnTime, _spawnTimeRnd )
end