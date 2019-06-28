-----------------------------------------------------------------------------------------------------------------------------------------------
-- CombatScoreManager
-----------------------------------------------------------------------------------------------------------------------------------------------
CombatScoreManager = {}

function CombatScoreManager:New(_unitScoreConfig)
    newObj = 
    {
        unitScoreCostConfigsList = _unitScoreConfig,
        lastHitsList = {},
        onUnitKilledEvent = {}
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function CombatScoreManager:HandleOnUnitKilledEvent(_newListener)
    table.insert( self.onUnitKilledEvent, _newListener )
end

function CombatScoreManager:InvokeOnUnitKilled(_coalition, _score)
    for i in ipairs(self.onUnitKilledEvent) do 
        self.onUnitKilledEvent[i]:OnUnitKilled(_coalition, _score)
    end
end

function CombatScoreManager:AddHitData(_iniGroupName, _tgtUnitName)
    self.lastHitsList[_tgtUnitName] = _iniGroupName
end

function CombatScoreManager:GetKillInitiator(_unitName)
    if self.lastHitsList[_unitName] ~= nil then 
        local killer = self.lastHitsList[_unitName]
        self.lastHitsList[_unitName] = nil 
        return killer
    end
end

function CombatScoreManager:GetUnitScoreCost(_unitName)
    if self.unitScoreCostConfigsList[_unitName] ~= nil then 
        Debug:Log("CombatScoreManager:GetUnitScoreCost() found group " .. _unitName)
        return self.unitScoreCostConfigsList[_unitName]
    else
        Debug:Log("CombatScoreManager:GetUnitScoreCost() no unit cost found " .. _unitName)
        return nil
    end
end

function CombatScoreManager:MessageToKillerGroup(_groupName, _score)
    group = GROUP:FindByName(_groupName)
    if group ~= nil then 
        local msg = "+" .. _score
        MESSAGE:New(tostring(msg), 10, false):ToGroup(group)
    end
end

function CombatScoreManager:StartScoring()
    local DeadEventHandler = EVENTHANDLER:New()
    DeadEventHandler:HandleEvent(EVENTS.Dead)

    local HitEventHandler = EVENTHANDLER:New()
    HitEventHandler:HandleEvent(EVENTS.Hit)

    local thisObj = self

    function HitEventHandler:OnEventHit(EventData)
        thisObj:AddHitData(EventData.IniGroupName, EventData.TgtUnitName)
    end

    function DeadEventHandler:OnEventDead(EventData)
        local killerName = thisObj:GetKillInitiator(EventData.IniUnitName)
        if killerName ~= nil then 
            local score = thisObj:GetUnitScoreCost(EventData.IniTypeName)
            thisObj:MessageToKillerGroup(killerName, score)

            local killerCoalition = 1

            if EventData.IniCoalition == 1 then killerCoalition = 2 end

            thisObj:InvokeOnUnitKilled(killerCoalition, score)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------
-- GenericZoneManager
-----------------------------------------------------------------------------------------------------------------------------------------------
GenericZoneManager = {}

function GenericZoneManager:New(_coalition, _frontLineAnchorCoord)
    newObj = 
    {
        coalition = _coalition,
        allGenericZonesList = {},
        blueRearZoneNamesList = {},
        blueFrontLineZoneNamesList = {},
        redRearZoneNamesList = {},
        redFrontLineZoneNamesList = {},
        frontLineAnchorCoord = _frontLineAnchorCoord
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function GenericZoneManager:SetGenericZones(_genericZonePrefix)
    local tempList = SET_ZONE:New():FilterPrefixes( _genericZonePrefix ):FilterOnce()
    local tempNamesList = tempList:GetSetNames()

    for i in ipairs(tempNamesList) do 
        local distance = self:GetDistanceToZone(tempNamesList[i])
        self.allGenericZonesList[tempNamesList[i]] = distance
    end

end

function GenericZoneManager:GetDistanceToZone(_zoneName)
    local tempZone = ZONE:New(_zoneName)
    return self.frontLineAnchorCoord:Get2DDistance(tempZone:GetPointVec2())
end

function GenericZoneManager:UpdateZonesCoalitions(_frontLineDistance, _frontLineDepth)
    self.blueRearZoneNamesList = {}
    self.redRearZoneNamesList = {}
    self.blueFrontLineZoneNamesList = {}
    self.redFrontLineZoneNamesList = {}

    for k, v in pairs(self.allGenericZonesList) do 

        Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. " distance is " .. v)

        if self.coalition == 1 then 

            if v <= _frontLineDistance then 
                if v <= (_frontLineDistance - _frontLineDepth) then 
                    table.insert( self.redRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redRearZoneNamesList")
                else
                    table.insert( self.redFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redFrontLineZoneNamesList")
                end
            else
                if v >= (_frontLineDistance + _frontLineDepth) then 
                    table.insert( self.blueRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueRearZoneNamesList")
                else
                    table.insert( self.blueFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueFrontLineZoneNamesList")
                end
            end

        end

        if self.coalition == 2 then 

            if v <= _frontLineDistance then 
                if v <= (_frontLineDistance - _frontLineDepth) then 
                    table.insert( self.blueRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueRearZoneNamesList")
                else
                    table.insert( self.blueFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueFrontLineZoneNamesList")
                end
            else
                if v >= (_frontLineDistance + _frontLineDepth) then 
                    table.insert( self.redRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redRearZoneNamesList")
                else
                    table.insert( self.redFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redFrontLineZoneNamesList")
                end
            end

        end

    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------------------------------------------------------------
-- FrontlineCombatAndPatrolZonesManager
-----------------------------------------------------------------------------------------------------------------------------------------------

FrontlineCombatAndPatrolZonesManager = {}

function FrontlineCombatAndPatrolZonesManager:New(_coalition, _zoneRadius, _patrolZoneOffset)
    newObj = 
    {
        coalition = _coalition,
        zoneRadius = _zoneRadius,
        patrolZoneOffset = _patrolZoneOffset,
        bluePatrolZoneName = nil,
        redPatrolZoneName = nil,
        frontlineZoneName = nil,
        bluePatrolZone = nil,
        redPatrolZone = nil,
        frontlineZone = nil
    }
    self.__index = self
    return setmetatable(newObj, self) 
end

function FrontlineCombatAndPatrolZonesManager:UpdateZones(_frontlineDistance, _genericZonesList)

    local minCombatZoneOffset = 999999
    local minFriendlyZoneOffset = 999999
    local minEnemyZoneOffset = 999999

    local friendlyZone = nil
    local friendlyZoneName = nil
    local enemyZone = nil
    local enemyZoneName = nil

    for k, v in pairs(_genericZonesList) do 
        if minCombatZoneOffset > math.abs( _frontlineDistance - v ) then 
            self.frontlineZoneName = k
            minCombatZoneOffset = math.abs( _frontlineDistance - v )
        end

        if v < _frontlineDistance then 
            if minFriendlyZoneOffset > math.abs( _frontlineDistance - self.patrolZoneOffset - v ) then 
                friendlyZoneName = k
                minFriendlyZoneOffset = math.abs( _frontlineDistance - self.patrolZoneOffset - v )
            end
        else
            if minEnemyZoneOffset > math.abs( _frontlineDistance + self.patrolZoneOffset - v ) then 
                enemyZoneName = k
                minEnemyZoneOffset = math.abs( _frontlineDistance + self.patrolZoneOffset - v )
            end
        end
    end

    if self.coalition == 1 then 
        self.redPatrolZoneName = friendlyZoneName
        self.bluePatrolZoneName = enemyZoneName
    else
        self.bluePatrolZoneName = friendlyZoneName
        self.redPatrolZoneName = enemyZoneName
    end

    if self.frontlineZone == nil then 
        self.frontlineZone = ZONE_RADIUS:New("FrontLineCombatZone", ZONE:New(self.frontlineZoneName):GetVec2(), self.zoneRadius)
        --self.frontlineZone = ZONE:New("FrontLineCombatZone")
        --self.frontlineZone:SetVec2(ZONE:New(self.frontlineZoneName):GetVec2())
        self.frontlineZoneName = self.frontlineZone:GetName()
    else
        self.frontlineZone:SetVec2(ZONE:New(self.frontlineZoneName):GetVec2())
    end

    if self.redPatrolZone == nil then 
        self.redPatrolZone = ZONE_RADIUS:New("RedPatrolZone", ZONE:New(self.redPatrolZoneName):GetVec2(), self.zoneRadius)
        --self.redPatrolZone = ZONE:New("RedPatrolZone")
        --self.redPatrolZone:SetVec2(ZONE:New(self.redPatrolZoneName):GetVec2())
        self.redPatrolZoneName = self.redPatrolZone:GetName()
    else
        self.redPatrolZone:SetVec2(ZONE:New(self.redPatrolZoneName):GetVec2())
    end

    if self.bluePatrolZone == nil then 
        self.bluePatrolZone = ZONE_RADIUS:New("BluePatrolZone", ZONE:New(self.bluePatrolZoneName):GetVec2(), self.zoneRadius)
        --self.bluePatrolZone = ZONE:New("BluePatrolZone")
        --self.bluePatrolZone:SetVec2(ZONE:New(self.bluePatrolZoneName):GetVec2())
        self.bluePatrolZoneName = self.bluePatrolZone:GetName()
    else
        self.bluePatrolZone:SetVec2(ZONE:New(self.bluePatrolZoneName):GetVec2())
    end

    Debug:Log("FrontlineCombatAndPatrolZonesManager:UpdateZones() updated zones, frontline zone vec2 is " .. self.frontlineZone:GetVec2().x .. " red patrol is " .. self.redPatrolZone:GetVec2().x .. " blue patrol is " .. self.bluePatrolZone:GetVec2().x)

end