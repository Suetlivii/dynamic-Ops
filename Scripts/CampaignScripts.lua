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
    for i in ipairs(mainTasksContainer.allActiveTasks) do
        if mainTasksContainer.allActiveTasks[i] ~= nil then 
            tasksReportController:Debug("tasksReportController: trying to report task number " .. tostring(i))
            mainTasksContainer.allActiveTasks[i]:ReportTask("En")
        end
    end
end
--TasksReportController end


-------------------------------------------------------------------------------------------------------------------------------------------------
-- GenericTaskReports
-- GenericTaskReports contains some generic messages for tasks, each GenericTaskReports have language

-- .Brief = "Brief Default"
-- .MapMarkText = "Target"
-- .OnWin = "OnWin Default"
-- .OnLost = "OnLost Default"
-- .OnCanceled = "OnCanceled Default" 
-- .AfterWin = "AfterWin Default"
-- .AfterLose = "AfterLose Default"
-- .AfterCanceled = "AfterCanceled Default" 
-------------------------------------------------------------------------------------------------------------------------------------------------
GenericTaskReports = {}

function GenericTaskReports:New()
    newObj = 
    {
        reportsList = 
        {
            TaskName = "TASK NAME",
            Brief = "Brief Default",
            MapMarkText = "Target",
            OnWin = "Task completed.",
            OnLost = "Task failed.",
            OnCanceled = "Task canceled.",
            AfterWin = "Task completed.",
            AfterLose = "Task failed.",
            AfterCanceled = "Task canceled." 
        }
    }
    self.__index = self
    return setmetatable(newObj, self)
end
--GenericTaskReports END


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TaskLocalizationData
-- TaskLocalizationData contains all tasks reports with different languages 
-- En, Ru, De etc
-------------------------------------------------------------------------------------------------------------------------------------------------

TaskLocalizationData = {}

function TaskLocalizationData:New()
    newObj = 
    {
        taskName,
        genericTaskReportsList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

--TaskLocalizationData end


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TaskReportsData
--taskLocalizationDatasList[taskName].genericTaskReportsList[language].report
-------------------------------------------------------------------------------------------------------------------------------------------------

TaskReportsData = {}

function TaskReportsData:New()
    newObj = 
    {
        taskLocalizationDatasList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TaskReportsData:GetReport(_taskName, _language, _report)
    if self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList[_report] ~= nil 
    and self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList[_report] ~= "" then
        tasksReportController:Debug("TaskReportsData:GetReport(): taskName = " .. _taskName .. " language = " .. _language .. " report = " .. _report)
        local returnReport = self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList[_report]

        if self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList["TaskName"] ~= nil
        and self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList["TaskName"] ~= "" then
            returnReport = self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList["TaskName"] .. "\n" .. returnReport
        end
        return returnReport
    end
end

function TaskReportsData:AddNewTaskLocalization(_taskName, _taskLocalizationData)
    if _taskLocalizationData ~= nil then 
        self.taskLocalizationDatasList[_taskName] = _taskLocalizationData
    end
end

MainTaskReportsData = TaskReportsData:New()
--TaskReportsData END

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
        defaultCampaignCoalition = coalition.side.BLUE,
        isDifferentCoalitionReceiveTasks = false,
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

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -- GameSessionSettings
-- -- 
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- GameSessionSettings = {}

-- function GameSessionSettings:New()
--     newObj = 
--     {
--         clientsCount = 0
--     }
--     self.__index = self
--     return setmetatable(newObj, self)
-- end

-------------------------------------------------------------------------------------------------------------------------------------------------
--TasksContainer - contains all tasks, start random task at mission start
--Dependencies: Nothing
-------------------------------------------------------------------------------------------------------------------------------------------------

TasksContainer = {}

function TasksContainer:New()
    newObj = 
    {
        allTasks = {},
        allActiveTasks = {}
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

function TasksContainer:AddNewActiveTask(newTaskController)
    table.insert(self.allActiveTasks, newTaskController)
end
----------------

-------------------------------------------------------------------------------------------------------------------------------------------------
-- TaskConfig
-- Task Config need to customize task
-- Every Task Contains one task config
-------------------------------------------------------------------------------------------------------------------------------------------------
TaskConfig = {}

function TaskConfig:New()
    newObj = 
    {
        taskName = "Default Task Config",
        taskCoalition = coalition.side.BLUE,
        taskDifficulty = 1,
        isFailCounts = true,
        taskSpawnedNumber = nil
    }
    self.__index = self
    return setmetatable(newObj, self)
end
--TaskConfig END


-------------------------------------------------------------------------------------------------------------------------------------------------
--TaskController - starting and controlling tasks progress, contains task brifieng
--Dependencies: tasksReportController object, mainTasksContainer object 
-------------------------------------------------------------------------------------------------------------------------------------------------

TaskController = {}

function TaskController:New()
    newObj = 
    {
        taskConfig = nil,
        taskCurrentMessage = "Brief",
        isCompleted = false
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TaskController:AddTaskToContainer(task)
    mainTasksContainer:AddNewTask(task)
    tasksReportController:Debug("TaskController:" .. task.taskConfig.taskName .. ": " .. " added.")
end

function TaskController:StartTask(_taskCoalition)
    tasksReportController:Debug("TaskController:" .. self.taskConfig.taskName .. ": " .. "default StartTask(). You have to overload method.")
end

function TaskController:ReportTask(_language)
    if self.taskConfig ~= nil then 
        tasksReportController:ReportToAll( MainTaskReportsData:GetReport(self.taskConfig.taskName, _language, self.taskCurrentMessage) )
    else
        tasksReportController:Debug("TaskController:ReportTask(): taskConfig is null" )
    end
end

function TaskController:FinishTask()
    
end

function TaskController:FinishTaskWin()
    tasksReportController:Debug("TaskController:" .. self.taskConfig.taskName .. ": " .. "default FinishTaskWin(). You have to overload method.")
end

function TaskController:FinishTaskLose()
    tasksReportController:Debug("TaskController:" .. self.taskConfig.taskName .. ": " .. "default FinishTaskLose(). You have to overload method.")
end

function TaskController:CancelTask()
    tasksReportController:Debug("TaskController:" .. self.taskConfig.taskName .. ": " .. "default CancelTask(). You have to overload method.")
end


------------------------------------------------------------------------------------------------------------------------------------------------
--Utility that parse zone dcs full name and makes it easy to check zone parameters
--Dependencies: Nothing
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- Generic Strike Task 
------------------------------------------------------------------------------------------------------------------------------------------------

GenericStrikeTaskStartConfig = {}

function GenericStrikeTaskStartConfig:New()
    newObj = 
    {
        LAGroupName = "Default",
        GroupRandomizeProbability = 0,
        minLifePercent = 0.5,
        MarkText = "Defaul",
        sectorOffset = 0 
    }
    self.__index = self
    return setmetatable(newObj, self)
end

GenericStrikeTask = TaskController:New()

GenericDefaultTaskStartConfig = GenericStrikeTaskStartConfig:New()

GenericStrikeTask.startConfig = GenericDefaultTaskStartConfig

GenericStrikeTaskTaskConfig = TaskConfig:New()

GenericStrikeTask.taskConfig = GenericStrikeTaskTaskConfig

function GenericStrikeTask:StartTask(_taskCoalition)
    
    local enemyCoalition = 1 
    local onStartUnitsCount = 0

    if _taskCoalition == 1 then enemyCoalition = 2 end

    local frontSectorID = mainCampaignStateManager:GetFrontSectorID(enemyCoalition)
    local sectorWithOffset = frontSectorID + self.sectorOffset

    if sectorWithOffset < 1 then 
        sectorWithOffset = 1
    end

    if sectorWithOffset > #mainCampaignStateContainer.allSectorStates
        sectorWithOffset = #mainCampaignStateContainer.allSectorStates
    then

    local groupName = LAGroupNameParser:GetRandomGroupByNameByCoalitionInSector(self.startConfig.LAGroupName, enemyCoalition, sectorWithOffset)
    tasksReportController:Debug("Attempt to start task. LAGroupName = " .. self.startConfig.LAGroupName .. " taskColaition = " .. self.taskConfig.taskCoalition .. " sector = " .. frontSectorID)

    local targetGroupSpawn = SPAWN:NewWithAlias( groupName, self.startConfig.LAGroupName )
    targetGroup = targetGroupSpawn:ReSpawn()

    local groupRandomizer = GroupRandomizer:New()
    groupRandomizer:RandomizeGroup(targetGroup, self.startConfig.GroupRandomizeProbability)

    onStartUnitsCount = #targetGroup:GetUnits()
    local minLifePercent = self.startConfig.minLifePercent

    local thisTask = self

    thisTask.taskCurrentMessage = "Brief"
    thisTask.isCompleted = false

    targetGroup:HandleEvent(EVENTS.Hit)

    function targetGroup:OnEventHit( EventData )
        --self:FinishTaskWin()
        local minUnitsCount = math.ceil( onStartUnitsCount * minLifePercent )
        tasksReportController:Debug("HIT! UnitsCount is " .. #targetGroup:GetUnits() .. " minUnitsCount is " .. minUnitsCount)
        if thisTask.isCompleted == false and #targetGroup:GetUnits() <= minUnitsCount then 
            thisTask.isCompleted = true
            thisTask.taskCurrentMessage = "OnWin"
            thisTask:ReportTask("En")
            if mainMissionStarter ~= nil then
                mainMissionStarter:StartRandomTask()
            end
        end
    end

    local targetCoord = targetGroup:GetCoordinate()
    local markID = targetCoord:MarkToCoalitionBlue( self.startConfig.MarkText, true)

    self:ReportTask("En")

end
-------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------
--  ZoneNameParser
-------------------------------------------------------------------------------------------------------------------------------------------------
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
--SectorZonesManager
--
-------------------------------------------------------------------------------------------------------------------------------------------------

SectorZonesManager = {}

function SectorZonesManager:New()
    newObj = 
    {
        sectorZones = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function SectorZonesManager:InitializeZones()
    local tempSetGroup = SET_GROUP:New():FilterPrefixes("s<"):FilterOnce()
    local tempSetNames = tempSetGroup:GetSetNames()

    for i in ipairs(tempSetNames) do 
        if string.match( tempSetNames[i], "SectorZone" ) then 
            local sectorZoneNumber = string.match(tempSetNames[i], "s<(%d+)>")
            local sectorZoneName = "s<" .. sectorZoneNumber .. ">st<SectorZone>"
            --self.sectorZones[sectorZoneNumber] = ZONE_POLYGON:New( sectorZoneName, GROUP:FindByName( sectorZoneName ) )
            table.insert( self.sectorZones , ZONE_POLYGON:New( sectorZoneName, GROUP:FindByName( sectorZoneName ) ) )
            tasksReportController:Debug("SectorZonesManager:InitializeZones(): initialized SectorZone with name " .. sectorZoneName)
        end
    end

end

function SectorZonesManager:GetSectorZone(_sectorNumber)
    local returnZone
    for i in ipairs(self.sectorZones) do 
        local parsedSectorNumber = string.match(self.sectorZones[i]:GetName(), "s<(%d+)>")

        if tonumber(_sectorNumber) == tonumber(parsedSectorNumber) then 
            returnZone = self.sectorZones[i]
            break
        end

    end

    if returnZone ~= nil then 
        tasksReportController:Debug("SectorZonesManager:GetSectorZone: retrun zone with name " .. returnZone:GetName())
        return returnZone
    else
        tasksReportController:Debug("SectorZonesManager:GetSectorZone: sectorZone with id " .. _sectorNumber .. " is nil")
    end
end
--end SectorZonesManager

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

function LAGroupNameParser:GetRandomGroupByNameByCoalitionInSector(_groupName, _coalition, _sectorID)

    local allLAGroupsSet = SET_GROUP:New():FilterPrefixes("s<"):FilterOnce()
    local allLAGroupsNames = allLAGroupsSet:GetSetNames()

    local allFoundGroupsNames = {}

    for i in ipairs(allLAGroupsNames) do
        if string.match(allLAGroupsNames[i], _groupName) and string.match(allLAGroupsNames[i], "s<" .. _sectorID .. ">") and string.match(allLAGroupsNames[i], "cl<" .. _coalition .. ">") then
            tasksReportController:Debug("LAGroupNameParser:GetRandomGroupByNameInSector: found group " .. allLAGroupsNames[i])
            table.insert( allFoundGroupsNames, allLAGroupsNames[i])
        end
    end

    if #allFoundGroupsNames > 0 then 
        local rndID = math.random( 1, #allFoundGroupsNames)
        return allFoundGroupsNames[rndID]
    else
        tasksReportController:Debug("LAGroupNameParser:GetRandomGroupByNameInSector(): No groups with name and sector found!")
        return nil
    end

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
        if string.match(onStartZonesList[i], "OnStart") == nil then
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
        local newSpawn = SPAWN:NewWithAlias( groupToSpawnSet:GetRandom():GetName(), tempZoneNameParser.groupPrefix .. ":" .. tempZoneNameParser.zonePrefix):InitLimit(999, 999):SpawnInZone(zoneToSpawnSet:GetRandomZone())
    end

end

function ZoneGroupsSpawner:SpawnGroup(zoneFullName)

end

function ZoneGroupsSpawner:AddZoneGroupToState(zoneFullName)

end
--ZoneGroupSpawner end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- GroupRandomizer 
-- Randomize Group with some probability
-----------------------------------------------------------------------------------------------------------------------------------------------

GroupRandomizer = {}

function GroupRandomizer:New()
    newObj = 
    {
        
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function GroupRandomizer:RandomizeGroup(_group, _probability)
    local unitsList = _group:GetUnits()

    if _probability == 0 then 
        tasksReportController:Debug("GroupRandomizer:RandomizeGroup(): Probability = 0, return")
        return nil
    end

    if #unitsList > 0 and _probability > 0 then
        for i in ipairs(unitsList) do 
            local rnd = math.random(0, 1)
            if _probability <= rnd and i > 1 then 
                unitsList[i]:Destroy()
            end
        end
    else
        tasksReportController:Debug("GroupRandomizer:RandomizeGroup(): Units list is nill or zero units")
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
--INITIALIZATION
-----------------------------------------------------------------------------------------------------------------------------------------------
tasksReportController = TasksReportController:New()

tasksReportController.isDebugMode = false

function ReportTasksCommand()
    tasksReportController:ReportAllTasks()
    tasksReportController:Debug("Report Task Pressed")
end

MenuTasks = MENU_MISSION:New("Tasks")
MenuStatusShow = MENU_MISSION_COMMAND:New("Report Task", MenuTasks, ReportTasksCommand)

mainTasksContainer = TasksContainer:New()

