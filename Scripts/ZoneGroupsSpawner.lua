----------
--Controller that spawns all groups at mission start
--Dependencies: Moose, ZoneNameParser class, mainCampaignStateContainer object
----------

--ZoneGroupSpawner 
ZoneGroupsSpawner = {}

function ZoneGroupsSpawner:New()
    newObj = 
    {
        
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function ZoneGroupsSpawner:FindAllOnStartZones()
    local onStartZones = SET_ZONE:New():FilterPrefixes("s<"):FilterOnce()
    local onStartZonesList = onStartZones:GetSetNames()

    for i in ipairs(onStartZonesList) do 
        if string.find(onStartZonesList[i], "OnStart") == nil then
            --tasksReportController:Debug("removing " .. onStartZonesList[i])
            table.remove(onStartZonesList, i)
        end
    end

    return onStartZonesList
end

function FindInTable(table, objToFind)
    for i in ipairs(table) do
        if table[i] == objToFind then 
            return true
        end
    end
    return false
end

function ZoneGroupsSpawner:SpawnAllGroups()

    local unicZonesList = {}
    local zonesOnStart = ZoneGroupsSpawner:FindAllOnStartZones()

    for i in ipairs(zonesOnStart) do 
        
        local tempZoneNameParser = ZoneNameParser:New()
        tempZoneNameParser:Parse(zonesOnStart[i])

        if FindInTable(unicZonesList, tempZoneNameParser:GetZoneFullPrefix()) == false then
            table.insert(unicZonesList, tempZoneNameParser:GetZoneFullPrefix())
        end

    end

    for i in ipairs(unicZonesList) do 

        local tempZoneNameParser = ZoneNameParser:New()
        tempZoneNameParser:Parse(unicZonesList[i])
        --tasksReportController:Debug(tempZoneNameParser:GetZoneFullPrefix())
        local zoneToSpawnSet = SET_ZONE:New():FilterPrefixes(tempZoneNameParser:GetZoneFullPrefix()):FilterOnce()

        local spawnCoalition = mainCampaignStateContainer.allSectorStates[tonumber(tempZoneNameParser.sectorNumber)].sectorCoalition

        local spawnCoalitionString 

        if spawnCoalition == coalition.side.RED then spawnCoalitionString = "Red" end
        if spawnCoalition == coalition.side.BLUE then spawnCoalitionString = "Blue" end

        --tasksReportController:Debug(tempZoneNameParser.sectorNumber)
        local groupToSpawnSet = SET_GROUP:New():FilterPrefixes(spawnCoalitionString .. tempZoneNameParser.groupPrefix):FilterOnce()
        local newSpawn = SPAWN:NewWithAlias( groupToSpawnSet:GetRandom():GetName(), tempZoneNameParser:GetZoneFullPrefix()):InitLimit(999, 999):SpawnInZone(zoneToSpawnSet:GetRandomZone())
    end

end

function ZoneGroupsSpawner:SpawnGroup(zoneFullName)

end

function ZoneGroupsSpawner:AddZoneGroupToState(zoneFullName)

end
--ZoneGroupSpawner end

