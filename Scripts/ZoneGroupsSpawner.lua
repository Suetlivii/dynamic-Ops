----------
--Controller that spawns all groups at mission start
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

function ZoneGroupsSpawner:SpawnAllGroups()

end

function ZoneGroupsSpawner:SpawnGroup(zoneFullName)

end

function ZoneGroupsSpawner:AddZoneGroupToState(zoneFullName)

end
--ZoneGroupSpawner end

zoneGroupsSpawner = ZoneGroupsSpawner:New()
zoneGroupsSpawner:FindAllOnStartZones()