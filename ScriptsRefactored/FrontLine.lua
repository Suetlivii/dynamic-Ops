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
        if v <= _frontLineDistance then 
            if v >= (_frontLineDistance - _frontLineDepth) then 
                if self.coalition == 2 then 
                    table.insert( self.blueFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueFrontLineZoneNamesList")
                else
                    table.insert( self.redFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redFrontLineZoneNamesList")
                end
            else
                if self.coalition == 2 then 
                    table.insert( self.blueRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueRearZoneNamesList")
                else 
                    table.insert( self.redRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redRearZoneNamesList")
                end
            end
        end

        if v > _frontLineDistance then 
            if v < (_frontLineDistance + _frontLineDepth) then 
                if self.coalition == 2 then 
                    table.insert( self.redFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redFrontLineZoneNamesList")
                else 
                    table.insert( self.blueFrontLineZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueFrontLineZoneNamesList")
                end
            else
                if coalition == 2 then 
                    table.insert( self.redRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to redRearZoneNamesList")
                else 
                    table.insert( self.blueRearZoneNamesList, k )
                    Debug:Log("GenericZoneManager:UpdateZonesCoalitions() zone " .. k .. "added to blueRearZoneNamesList")
                end
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------
-- ZonePlacementFilter
-----------------------------------------------------------------------------------------------------------------------------------------------
ZonePlacementFilter = {}

function ZonePlacementFilter:New(_matchList, _mgrsList)
    newObj = 
    {
        matchList = _matchList,
        mgrsList = _mgrsList
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function ZonePlacementFilter:FilterZoneNamesList(_zoneNamesList)
    local tempZoneList = {}
    for i in ipairs(_zoneNamesList) do 
        if self:FilterMatchWord(_zoneNamesList[i]) == true and self:FilterMGRS(_zoneNamesList[i]) == true then 
            table.insert( tempZoneList, _zoneNamesList[i] )
            Debug:Log("ZonePlacementFilter:FilterZoneNamesList() adding zone to list " .. _zoneNamesList[i])
        end
    end
    Debug:Log("ZonePlacementFilter:FilterZoneNamesList() returning zone with count " .. #tempZoneList)
    return tempZoneList
end

function ZonePlacementFilter:FilterMatchWord(_name)
    for i in ipairs(self.matchList) do 
        Debug:Log("ZonePlacementFilter:FilterMatchWord() filtering zone " .. _name .. " for match word " .. self.matchList[i])
        if string.match(_name, self.matchList[i]) ~= nil then 
            return true
        end
    end
    return false
end

function ZonePlacementFilter:FilterMGRS(_name)
    local tempZone = ZONE:New(_name)
    local coord = COORDINATE:NewFromVec2(tempZone:GetVec2()):ToStringMGRS()
    --MGRS, 37T GH 28000 23375
    local mgrsString = string.sub( coord, 11, 11 ) .. string.sub( coord, 12, 12 ) .. string.sub( coord, 14, 14 ) .. string.sub( coord, 20, 20 ) 
    for i in ipairs(self.mgrsList) do 
        Debug:Log("ZonePlacementFilter:FilterMatchWord() filtering zone mgrs " .. mgrsString .. " for mgrs " .. self.mgrsList[i])
        if mgrsString == self.mgrsList[i] then 
            return true
        end
    end
    return false
end

function ZonePlacementFilter:FilterDistanceFromAnchorLessThan()

end
-----------------------------------------------------------------------------------------------------------------------------------------------