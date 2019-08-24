-----------------------------------------------------------------------------------------------------------------------------------------------
--GroupZoneRespawner respawning group in random zone after group birth
-----------------------------------------------------------------------------------------------------------------------------------------------

GroupZoneRespawner = {}

function GroupZoneRespawner:New()
    newObj = 
    {
        zoneSet = nil,
        respawnedUnitsNames = {},
        singleUnitTeleported = false
    }
    self.__index = self
    return setmetatable(newObj, self)
end

----PUBLIC
function GroupZoneRespawner:StartRespawning(_groupPrefix, _zonePrefix, _respawnAlt)

    self:SetZones(_zonePrefix)

    OnBirthHandler = EVENTHANDLER:New()
    OnBirthHandler:HandleEvent(EVENTS.Birth)

    local thisObj = self
    function OnBirthHandler:OnEventBirth( EventData )
        if string.find(EventData.IniUnitName, _groupPrefix) ~= nil then 
            Debug:Log("GroupZoneRespawner:StartRespawning() found unit named " .. EventData.IniUnitName)
            if thisObj.zoneSet ~= nil then 
              local rndZone = thisObj:GetRandomZone()

              if thisObj:CheckUnitName(EventData.IniUnitName) == false then
                thisObj:TeleportUnitToZone(EventData.IniUnitName, rndZone, _respawnAlt)
                Debug:Log("GroupZoneRespawner:StartRespawning() respawnin unit " .. EventData.IniUnitName)
              end
            end
        end
    end
end

function GroupZoneRespawner:SetZones(_zonePrefix)
    self.zoneSet = SET_ZONE:New()
    self.zoneSet:FilterPrefixes(_zonePrefix):FilterStart()
    Debug:Log("GroupZoneRespawner:SetZones() set_zone is done")
end

----PRIVATE
function GroupZoneRespawner:GetRandomZone()
    if self.zoneSet ~= nil then 
        return self.zoneSet:GetRandomZone()
    end
end

function GroupZoneRespawner:CheckUnitName(_name)
    for i in ipairs(self.respawnedUnitsNames) do 
        if self.respawnedUnitsNames[i] == _name then 
            return true
        end
    end
    return false
end

function GroupZoneRespawner:AddUnitName(_name)
    table.insert( self.respawnedUnitsNames, _name )
end

function GroupZoneRespawner:TeleportUnitToZone(_unitName, _zone, _alt)

    local zoneVec2 = _zone:GetVec2()
    local respawnCoord = COORDINATE:NewFromVec2(zoneVec2, _alt)
    local unitToTeleport = UNIT:FindByName(_unitName)
    self:AddUnitName(_unitName)
    if self.singleUnitTeleported == false then 
        unitToTeleport:ReSpawnAt(respawnCoord, 350)
        self.singleUnitTeleported = true
    end
end