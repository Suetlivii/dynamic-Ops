-----------------------------------------------------------------------------------------------------------------------------------------------
-- GroupSpawner
-----------------------------------------------------------------------------------------------------------------------------------------------

GroupSpawner = {}

function GroupSpawner:New(_groupNamePrefix, _unitsLimit, _spawnedGroupPrefix, _spawnSheduleTime)
    newObj = 
    {
        groupNamePrefix = _groupNamePrefix,
        unitsLimit = _unitsLimit,
        spawnedGroupPrefix = _spawnedGroupPrefix,
        spawnSheduleTime = _spawnSheduleTime,
        spawnZones = {},
        mooseSpawn = nil
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function GroupSpawner:SetSpawnZones(_zoneNamesList)
    for i in ipairs(_zoneNamesList) do 
        table.insert(self.spawnZones, ZONE:New(_zoneNamesList[i]))
    end
    
    if self.mooseSpawn ~= nil then 
        mooseSpawn.SpawnZoneTable = self.spawnZones
    end
end

function GroupSpawner:StartSpawn()
    if #self.spawnZones > 0 then 
        self.mooseSpawn = SPAWN:New(self.groupNamePrefix)
        :InitLimit(self.unitsLimit, 0)
        :InitRandomizeZones(self.spawnZones)
        :InitHeading(0, 360)
        :SpawnScheduled( self.spawnSheduleTime, .1 )
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

    if #self.matchList == 0 and #self.mgrsList == 0 then 
        Debug:Log("ZonePlacementFilter:FilterZoneNamesList() no mgrs and match words, filter is empty, returning original list")
        return _zoneNamesList
    end

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

    if #self.matchList == 0 then 
        return true
    end

    for i in ipairs(self.matchList) do 
        Debug:Log("ZonePlacementFilter:FilterMatchWord() filtering zone " .. _name .. " for match word " .. self.matchList[i])
        if string.match(_name, self.matchList[i]) ~= nil then 
            return true
        end
    end
    return false
end

function ZonePlacementFilter:FilterMGRS(_name)

    if #self.mgrsList == 0 then 
        return true
    end

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


-----------------------------------------------------------------------------------------------------------------------------------------------
-- GroupSpawnerConfig example
-----------------------------------------------------------------------------------------------------------------------------------------------

-- RedMotoInfantryFrontline = 
-- {
--     coalition = 1,
--     groupNamePrefix = "RedInf1",
--     unitsLimit = 23,
--     spawnedGroupPrefix = "redFlg",
--     spawnSheduleTime = 30,
--     mgrs = 
--     {
--         "GH31", "GH11", "GH21" 
--     },
--     zoneType = 
--     {
--         "town", "forest", "road"
--     },
--     frontDepth = 
--     {
--         "front", "rear"
--     }
-- }

-----------------------------------------------------------------------------------------------------------------------------------------------
-- GroupSpawnersConfigurator
-----------------------------------------------------------------------------------------------------------------------------------------------

GroupSpawnersConfigurator = {}

function GroupSpawnersConfigurator:New(_configsList)
    newObj = 
    {
        configsList = _configsList,
        spawners = {},
        blueRearZoneNamesList = {},
        blueFrontLineZoneNamesList = {},
        redRearZoneNamesList = {},
        redFrontLineZoneNamesList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function GroupSpawnersConfigurator:InitializeSpawners()
    Debug:Log("GroupSpawnersConfigurator:InitializeSpawners() attempt to start spawning for configs count " .. #self.configsList)
    for i in ipairs(self.configsList) do 

        local newSpawner = GroupSpawner:New(self.configsList[i].groupNamePrefix, self.configsList[i].unitsLimit, self.configsList[i].spawnedGroupPrefix, self.configsList[i].spawnSheduleTime)    
        self:UpdateSpawnerZones(newSpawner, self.configsList[i])
        table.insert( self.spawners, newSpawner )
        Debug:Log("GroupSpawnersConfigurator:InitializeSpawners() initialized spawner for groupNamePrefix " .. newSpawner.groupNamePrefix)
    end

    self:StartSpawners()
end

function GroupSpawnersConfigurator:CheckPropertyExist(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function GroupSpawnersConfigurator:AddRangeToList(_addTo, _addThis)
    for i in ipairs(_addThis) do 
        table.insert( _addTo, _addThis[i] )
    end
end

function GroupSpawnersConfigurator:UpdateSpawnerZones(_spawner, _config)

    Debug:Log("GroupSpawnersConfigurator:UpdateSpawnerZones() attempt to update zones for spawner groupNamePrefix " .. _spawner.groupNamePrefix)
    Debug:Log("GroupSpawnersConfigurator:UpdateSpawnerZones() given config groupNamePrefix is " .. _config.groupNamePrefix)
    local frontZones = nil
    local rearZones = nil

    if _config.coalition == 1 then 
        frontZones = self.redFrontLineZoneNamesList
        rearZones = self.redRearZoneNamesList
    else
        frontZones = self.blueFrontLineZoneNamesList
        rearZones = self.blueRearZoneNamesList
    end

    local zoneSummary = {}
    if self:CheckPropertyExist(_config.frontDepth, "front") == true then 
        self:AddRangeToList(zoneSummary, frontZones )
        Debug:Log("GroupSpawnersConfigurator:UpdateSpawnerZones() this spawner has front property, adding zones. Summary zones for this is " .. #zoneSummary)
    end
    if self:CheckPropertyExist(_config.frontDepth, "rear") == true then 
        self:AddRangeToList(zoneSummary, rearZones )
        Debug:Log("GroupSpawnersConfigurator:UpdateSpawnerZones() this spawner has rear property, adding zones. Summary zones for this is " .. #zoneSummary)
    end
    if self:CheckPropertyExist(_config.frontDepth, "any") == true then 
        self:AddRangeToList(zoneSummary, rearZones )
        self:AddRangeToList(zoneSummary, frontZones )
        Debug:Log("GroupSpawnersConfigurator:UpdateSpawnerZones() this spawner has any property, adding zones. Summary zones for this is " .. #zoneSummary)
    end

    local zoneFilter = ZonePlacementFilter:New(_config.zoneType, _config.mgrs)
    local zoneSummaryFiltered = zoneFilter:FilterZoneNamesList(zoneSummary)
    Debug:Log("GroupSpawnersConfigurator:UpdateSpawnerZones() after filtering zone count is  " .. #zoneSummaryFiltered)

    if #zoneSummaryFiltered > 0 then 
        _spawner:SetSpawnZones(zoneSummaryFiltered)
    end

end

function GroupSpawnersConfigurator:UpdateSpawnersZones()
    for i in ipairs(self.configsList) do 

        if self.spawners[i] ~= nil then 
            self:UpdateSpawnerZones(self.spawners[i], self.configsList[i])
        end

    end
end

function GroupSpawnersConfigurator:StartSpawners()
    for i in ipairs(self.spawners) do 
        self.spawners[i]:StartSpawn()
    end
end

function GroupSpawnersConfigurator:UpdateZones(_blueRearZoneNamesList, _blueFrontLineZoneNamesList, _redRearZoneNamesList, _redFrontLineZoneNamesList)
    self.blueRearZoneNamesList = _blueRearZoneNamesList
    self.blueFrontLineZoneNamesList = _blueFrontLineZoneNamesList
    self.redRearZoneNamesList = _redRearZoneNamesList
    self.redFrontLineZoneNamesList = _redFrontLineZoneNamesList

    self:UpdateSpawnersZones()
end