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
    local minRedZoneOffset = 999999
    local minBlueZoneOffset = 999999

    for k, v in pairs(_genericZonesList) do 

        if minCombatZoneOffset > math.abs( _frontlineDistance - v ) then 
            self.frontlineZoneName = k
            minCombatZoneOffset = math.abs( _frontlineDistance - v )
        end

        if self.coalition == 1 then 
            if v < _frontlineDistance then 
                if minRedZoneOffset > math.abs( _frontlineDistance - self.patrolZoneOffset - v ) then 
                    self.redPatrolZoneName = k
                    minRedZoneOffset = math.abs( _frontlineDistance - self.patrolZoneOffset - v )
                end
            else
                if minBlueZoneOffset > math.abs( _frontlineDistance + self.patrolZoneOffset - v ) then 
                    self.bluePatrolZoneName = k
                    minBlueZoneOffset = math.abs( _frontlineDistance + self.patrolZoneOffset - v )
                end
            end
        end

        if self.coalition == 2 then 
            if v < _frontlineDistance then 
                if minBlueZoneOffset > math.abs( _frontlineDistance - self.patrolZoneOffset - v ) then 
                    self.bluePatrolZoneName = k
                    minBlueZoneOffset = math.abs( _frontlineDistance - self.patrolZoneOffset - v )
                end
            else
                if minRedZoneOffset > math.abs( _frontlineDistance + self.patrolZoneOffset - v ) then 
                    self.redPatrolZoneName = k
                    minRedZoneOffset = math.abs( _frontlineDistance + self.patrolZoneOffset - v )
                end
            end
        end

    end

    Debug:Log("FrontlineCombatAndPatrolZonesManager:UpdateZones() updated zones, frontline zone is " .. self.frontlineZoneName .. " red patrol is " .. self.redPatrolZoneName .. " blue patrol is " .. self.bluePatrolZoneName)

end