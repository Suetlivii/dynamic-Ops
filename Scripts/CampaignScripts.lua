-----------------------------------------------------------------------------------------------------------------------------------------------
--Controller that print messages to DCS
--Dependencies: Moose, mainTasksContainer
-----------------------------------------------------------------------------------------------------------------------------------------------

--TasksReportController
TasksReportController = {}

function TasksReportController:New()
    newObj = 
    {
        isDebugMode = false,
        defaultLanguage = en,
        clientsLanguages = 
        {
            clientName = "en"
        }
    }
    self.__index = self
    return setmetatable(newObj, self)
end

----------------------------------
--"ClassName:" .. self.ObjectName .. ":"
function TasksReportController:Debug(msgString)
    if self.isDebugMode == true then
        newDebugMessage = MESSAGE:New(tostring(msgString .. "\n"), 10, "DEBUG", false):ToAll()
    end
end

function TasksReportController:ReportToAll(msgString)
    newDebugMessage = MESSAGE:New(tostring(msgString), 45, false):ToAll()
end

function TasksReportController:ReportAllTasks()
    for i in ipairs(mainTasksContainer.allTasks) do
        if mainTasksContainer.allTasks[i] ~= nil then 
            tasksReportController:Debug("tasksReportController: trying to report task number " .. tostring(i))
            mainTasksContainer.allTasks[i]:ReportTask("En")
        end
    end
end
--TasksReportController end


------------------------------------------------------------------------------------------------------------------------------------------------
--Controlling Campaign State
--Main Data Class
--Dependencies: Nothing
------------------------------------------------------------------------------------------------------------------------------------------------

--CampaignStateContainer
CampaignStateContainer = {}

function CampaignStateContainer:New()
    newObj = 
    {
        globalCampaignID = "noID",
        isFirstLaunch = true,
        sessionsPlayed = 0,
        missionsCompleted = 0,
        missionsFailed = 0,
        missionsCanceled = 0,
        activeSector = 4,
        allSectorStates = {},
        allGroupStates = {},
        allZoneGroupStates = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end
--CampaignStateContainer end

-------------------------------------------------------------------------------------------------------------------------------------------------
--CampaignStateManager 
--Dependencies: CampaignStateContainer
-------------------------------------------------------------------------------------------------------------------------------------------------

CampaignStateManager = {}

function CampaignStateManager:New(_campaignStateContainer)
    newObj = 
    {
        managedCampaignStateContainer = _campaignStateContainer
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function CampaignStateManager:GetFrontSectorID(_coalition)

    local redFrontsectorID = 0
    local blueFrontsectorID = 0

    if self.managedCampaignStateContainer ~= nil then 

        for i in ipairs(self.managedCampaignStateContainer.allSectorStates) do
            
            if self.managedCampaignStateContainer.allSectorStates[i].sectorCoalition ~= self.managedCampaignStateContainer.allSectorStates[i+1].sectorCoalition then
                redFrontsectorID = self.managedCampaignStateContainer.allSectorStates[i].sectorID
                blueFrontsectorID = self.managedCampaignStateContainer.allSectorStates[i+1].sectorID

                tasksReportController:Debug("CampaignStateManager:GetFronsectorID: Red is " .. redFrontsectorID .. " Blue is " .. blueFrontsectorID)

                break
            end

        end

        if _coalition == coalition.side.RED then 
            return redFrontsectorID
        end
    
        if _coalition == coalition.side.BLUE then 
            return blueFrontsectorID
        end

    end

end


-----------------------------------------------------------------------------------------------------------------------------------------------
--SectorState contains sector information, list of all SectorStates stored in CampaignStateContainer.allSectorStates
--Dependencies: Nothing
-----------------------------------------------------------------------------------------------------------------------------------------------
--SectorState
SectorState = {}

function SectorState:New(_sectorID, _sectorCoalition, _requiredMissionCount)
    newObj = 
    {
        sectorID = _sectorID,
        sectorCoalition = _sectorCoalition,
        requiredMissionCount = _requiredMissionCount,
        missionsProgress
    }
    self.__index = self
    return setmetatable(newObj, self)
end

--SectorState end

-------------------------------------------------------------------------------------------------------------------------------------------------
--TasksContainer - contains all tasks, start random task at mission start
--Dependencies: Nothing
-------------------------------------------------------------------------------------------------------------------------------------------------

TasksContainer = {}

function TasksContainer:New()
    newObj = 
    {
        allTasks = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TasksContainer:StartRandomTask()
    
end

function TasksContainer:StartTaskByName(taskName)

end

function TasksContainer:AddNewTask(newTaskController)
    table.insert(self.allTasks, newTaskController)
end
----------------

-------------------------------------------------------------------------------------------------------------------------------------------------
--TaskController - starting and controlling tasks progress, contains task brifieng
--Dependencies: tasksReportController object, mainTasksContainer object 
-------------------------------------------------------------------------------------------------------------------------------------------------

TaskController = {}

function TaskController:New()
    newObj = 
    {
        taskName = "default task name",
        localizedReport = {},
        taskCoalition = "",
        isFailCounts = true,
        taskDifficulty = 1
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TaskController:AddTaskToContainer(task)
    mainTasksContainer:AddNewTask(task)
    tasksReportController:Debug("TaskController:" .. task.taskName .. ": " .. " added.")
end

function TaskController:StartTask()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default StartTask(). You have to overload method.")
end

function TaskController:ReportTask(language)
    if self == nil then 
        tasksReportController:Debug("TaskController: task is nill")
    end

    if self.localizedReport[language] ~= nil and self.localizedReport[language] ~= "" then 
        tasksReportController:ReportToAll( self.localizedReport[language] )
    else
        tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "nil or empty message on ReportTask")
    end
end

function TaskController:FinishTaskWin()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default FinishTaskWin(). You have to overload method.")
end

function TaskController:FinishTaskLose()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default FinishTaskLose(). You have to overload method.")
end

function TaskController:CancelTask()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default CancelTask(). You have to overload method.")
end

------------------------------------------------------------------------------------------------------------------------------------------------
--Utility that parse zone dcs full name and makes it easy to check zone parameters
--Dependencies: Nothing
------------------------------------------------------------------------------------------------------------------------------------------------

--ZoneNameParser
ZoneNameParser = {}

function ZoneNameParser:New()
    newObj = 
    {
        sectorNumber = -1,
        spawnType = "",
        zonePrefix = "",
        groupPrefix = "",
        zoneNumber = -1
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function ZoneNameParser:Parse(zoneFullName)
    self.sectorNumber = string.match(zoneFullName, "s<(%d+)>")
    self.spawnType = string.match(zoneFullName, "st<(%a+)>")
    self.zonePrefix = string.match(zoneFullName, "zp<(%a+)>")
    self.groupPrefix = string.match(zoneFullName, "gp<(%a+)>")
    self.zoneNumber = string.match(zoneFullName, "nm<(%d+)>")
end

function ZoneNameParser:GetZoneFullPrefix()
    --s<SectorNumber>st<SpawnType>zp<ZonePrefix>gp<GroupPrefix>nm<ZoneNumber>
    local fullPrefix = string.format("s<%s>st<%s>zp<%s>gp<%s>", self.sectorNumber, self.spawnType, self.zonePrefix, self.groupPrefix)
    return fullPrefix
end

function ZoneNameParser:GetZoneFullName()
    local fullName = string.format("s<%s>st<%s>zp<%s>gp<%s>nm<%s>", self.sectorNumber, self.spawnType, self.zonePrefix, self.groupPrefix, self.zoneNumber)
    return fullName
end
--ZoneNameParser end

-------------------------------------------------------------------------------------------------------------------------------------------------
--Utility that parse dcs late activate groups full name and makes it easy to check groups parameters
--Dependencies: Nothing
-------------------------------------------------------------------------------------------------------------------------------------------------

--LAGroupNameParser
--s<>cl<>st<>gn<>nm<>
LAGroupNameParser = {}

function LAGroupNameParser:New()
    newObj = 
    {
        sectorNumber = 0,
        coalition = "no",
        spawnType = "no",
        groupName = "no",
        groupNumber = 0
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function LAGroupNameParser:Parse(laGroupFullName)
    self.sectorNumber = string.match(laGroupFullName, "s<(%d+)>")
    self.coalition = string.match(laGroupFullName, "cl<(%a+)>")
    self.spawnType = string.match(laGroupFullName, "st<(%a+)>")
    self.groupName = string.match(laGroupFullName, "gn<(%a+)>")
    self.groupNumber = string.match(laGroupFullName, "nm<(%d+)>")
end

function LAGroupNameParser:GetLAGroupFullPrefix()
    --s<SectorNumber>st<SpawnType>zp<ZonePrefix>gp<GroupPrefix>nm<ZoneNumber>
    local fullPrefix = string.format("s<%s>cl<%s>st<%s>gn<%s>", self.sectorNumber, self.coalition, self.spawnType, self.groupName)
    return fullPrefix
end

function LAGroupNameParser:GetLAGroupFullName()
    local fullName = string.format("s<%s>cl<%s>st<%s>gn<%s>nm<%s>", self.sectorNumber, self.coalition, self.spawnType, self.groupName, self.groupNumber)
    return fullName
end
--LAGroupNameParser end


-------------------------------------------------------------------------------------------------------------------------------------------------
--Controller that spawns all groups at mission start
--Dependencies: Moose, ZoneNameParser class, mainCampaignStateContainer object
-------------------------------------------------------------------------------------------------------------------------------------------------

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


-----------------------------------------------------------------------------------------------------------------------------------------------
--INITIALIZATION
-----------------------------------------------------------------------------------------------------------------------------------------------
tasksReportController = TasksReportController:New()

tasksReportController.isDebugMode = true

function ReportTasksCommand()

    tasksReportController:ReportAllTasks()
    tasksReportController:Debug("Report Task Pressed")

end

MenuTasks = MENU_MISSION:New("Tasks")
MenuStatusShow = MENU_MISSION_COMMAND:New("Report Task", MenuTasks, ReportTasksCommand)

mainTasksContainer = TasksContainer:New()
