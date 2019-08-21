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
        redPatrolZone = nil,
        bluePatrolZone = nil,
        baiZone = nil,
        anchorZoneName = nil,
        frontlineDistance = nil,
        minDist = nil,
        maxDist = nil,
        baiControllersList = {},
        groupSpawners = {},
        activeGroupsCount = 0
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

function A2GController:SetZones(_combatZone, _redPatrolZone, _bluePatrolZone)
    if _combatZone ~= nil then 
        self.combatZone = _combatZone
    end 
    if _redPatrolZone ~= nil then 
        self.redPatrolZone = _redPatrolZone
    end 
    if _bluePatrolZone ~= nil then 
        self.bluePatrolZone = _bluePatrolZone
    end
end

function A2GController:GetRandomGroup()
    local groupsInRangeList = {}

    for i in ipairs(self.a2gConfig) do 
        if self.frontlineDistance ~= nil and self.anchorZoneName ~= nil then 
            if self:CheckPosFromFrontline(nil, nil, self.frontlineDistance, self.minDist, self.maxDist) == true then 
                table.insert(groupsInRangeList, self.a2gConfig[i])
            end
        else
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

function A2GController:SpawnBAIGroup(_LAgroup, _airBaseName, _attackDelay, _minAlt, _maxAlt)

    if self.bluePatrolZone == nil then 
        Debug:Log("A2GController:SpawnBAIGroup() bluePatrolZone is nil, impossible to start BAI")
        return nil 
    end

    if self.redPatrolZone == nil then 
        Debug:Log("A2GController:SpawnBAIGroup() redPatrolZone is nil, impossible to start BAI")
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


    Debug:Log("A2GController:SpawnBAIGroup() combat zone radius is " .. self.combatZone:GetRadius())

    if GROUP:FindByName(_LAgroup):GetCoalition() == 1 then 
        table.insert( self.baiControllersList, AI_CAS_ZONE:New( self.redPatrolZone, _minAlt, _maxAlt, 400, 1000, self.combatZone ) )
    end

    if GROUP:FindByName(_LAgroup):GetCoalition() == 2 then 
        table.insert( self.baiControllersList, AI_CAS_ZONE:New( self.bluePatrolZone, _minAlt, _maxAlt, 400, 1000, self.combatZone ) )
    end

    globalAttackDelayTemp = _attackDelay

    if _LAgroup ~= nil and _airBaseName ~= nil then
        table.insert( self.groupSpawners, SPAWN:NewWithAlias(_LAgroup, "BAI:" .. #self.groupSpawners))
        self.groupSpawners[#self.groupSpawners]
        :OnSpawnGroup(
            function( SpawnGroup )
                self:InitializeBai(SpawnGroup, self.baiControllersList[#self.baiControllersList], globalAttackDelayTemp) 
            end 
        )
        local spawnedGroup = self.groupSpawners[#self.groupSpawners]:SpawnAtAirbase( AIRBASE:FindByName(_airBaseName), SPAWN.Takeoff.Hot )

        Debug:Log("A2GController:SpawnBAIGroup() new spawner created, spawner number " .. #self.groupSpawners)
    end
end

function A2GController:DecreaseActiveGroupsCount()
    if self.activeGroupsCount > 0 then 
        self.activeGroupsCount = self.activeGroupsCount - 1
        Debug:Log("A2GController:DecreaseActiveGroupsCount() currently active groups is " .. self.activeGroupsCount)
    end
end

function A2GController:InitializeBai(_group, baiController, attackDelay)
    baiController:SetControllable( _group ) 
    baiController:__Start( 1 )
    Debug:Log("A2GController:SpawnBAIGroup() attack delay is " .. attackDelay)
    baiController:__Engage( tonumber(attackDelay), 650, 600)
    Debug:Log("A2GController:SpawnBAIGroup() BAI started for group " .. _group:GetName())

    local thisObj = self
    function baiController:OnAfterRTB( Controllable, From, Event, To )
        Debug:Log("A2GController:SpawnBAIGroup() BAI group after RTB ")
        thisObj:DecreaseActiveGroupsCount()
    end
end

function A2GController:StartBAI(_spawnTime, _spawnTimeRnd, _groupsLimitPerTime)
    local selfObj = self

    Check, CheckScheduleID = SCHEDULER:New(nil,
    function()
        if self.activeGroupsCount < _groupsLimitPerTime then
            local config = selfObj:GetRandomGroup()
            if config ~= nil then 
                selfObj:SpawnBAIGroup(config.groupPrefix, config.airbaseName, config.attackDelay, config.minAlt, config.maxAlt)
                self.activeGroupsCount = self.activeGroupsCount + 1
            end
        end
    end, {}, _spawnTime, _spawnTime, _spawnTimeRnd )
end