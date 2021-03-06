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
        BASE:E(tostring(msgString))
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


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TasksContainer
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
        taskSpawnedNumber = nil, --
        playerVehicleType = "All" --Rw (rotary wing), Fw (fixed wing), Ca (combanied arms), All (all units)
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
        isCompleted = false,
        mapMarksList = {}
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
-- MapMark
--
------------------------------------------------------------------------------------------------------------------------------------------------
MapMark = {}

function MapMark:New()
    newObj = 
    {
        markCoalition = nil,
        markID = nil,
        destroyGroup = nil
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function MapMark:CreateMark(_coalition, _textString, _vec2Coords)
    if _coalition ~= nil and _textString ~= nil and _vec2Coords ~= nil then

        if _coalition == coalition.side.RED then 
            local markID = _vec2Coords:MarkToCoalitionRed( _textString, true)
            self.markID = markID
        end

        if _coalition == coalition.side.BLUE then 
            local markID = _vec2Coords:MarkToCoalitionBlue( _textString, true)
            self.markID = markID
        end

    end
end

function MapMark:Destroy()
    if self.markID ~= nil then 
        COORDINATE:RemoveMark(self.markID)
    end
end

function MapMark:SetDestroyGroup(_group)
    _group:HandleEvent(EVENTS.Dead)
    function _group:OnEventDead( EventData )
        self:Destroy()
    end
end
--MapMark
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
    local sectorWithOffset = frontSectorID + tonumber(self.startConfig.sectorOffset)

    if sectorWithOffset < 1 then 
        sectorWithOffset = 1
    end

    if sectorWithOffset > #mainCampaignStateContainer.allSectorStates then
        sectorWithOffset = #mainCampaignStateContainer.allSectorStates
    end

    local groupName = LAGroupNameParser:GetRandomGroupByNameByCoalitionInSector(self.startConfig.LAGroupName, enemyCoalition, sectorWithOffset)
    tasksReportController:Debug("Attempt to start task. LAGroupName = " .. self.startConfig.LAGroupName .. " taskColaition = " .. self.taskConfig.taskCoalition .. " sector = " .. frontSectorID)

    local targetGroupSpawn = SPAWN:NewWithAlias( groupName, self.startConfig.LAGroupName )
    targetGroup = targetGroupSpawn:ReSpawn()

    local groupRandomizer = GroupRandomizer:New()
    local unitsCount = groupRandomizer:RandomizeGroup(targetGroup, self.startConfig.GroupRandomizeProbability)

    -- onStartUnitsCount = self.startConfig.minLifePercent * self.startConfig.GroupRandomizeProbability
    -- local minLifePercent = self.startConfig.minLifePercent

    local thisTask = self

    thisTask.taskCurrentMessage = "Brief"
    thisTask.isCompleted = false
    --thisTask.minUnitsCountPercent = math.ceil( thisTask.minUnitsCountPercent * #targetGroup:GetUnits() )
    local minUnitsCount = math.ceil( thisTask.startConfig.minLifePercent * unitsCount )

    local targetCoord = targetGroup:GetCoordinate()
    local targetMapMark = MapMark:New()
    targetMapMark:CreateMark(_taskCoalition, self.startConfig.MarkText, targetCoord)
    table.insert(self.mapMarksList, targetMapMark)

    targetGroup:HandleEvent(EVENTS.Dead)
    function targetGroup:OnEventDead( EventData )
        --self:FinishTaskWin()
        
        tasksReportController:Debug("HIT! UnitsCount is " .. #targetGroup:GetUnits() .. " minUnitsCount is " .. minUnitsCount)
        if thisTask.isCompleted == false and #targetGroup:GetUnits() <= minUnitsCount then 
            thisTask.isCompleted = true
            thisTask.taskCurrentMessage = "OnWin"
            thisTask:ReportTask("En")

            for i in ipairs(thisTask.mapMarksList) do 
                if thisTask.mapMarksList[i] ~= nil then 
                    thisTask.mapMarksList[i]:Destroy()
                end
            end

            if mainMissionStarter ~= nil then
                mainMissionStarter:StartRandomTask()
            end
        end
    end

    thisTask:ReportTask("En")

end
-------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------
-- Generic Zone Parser
--
-------------------------------------------------------------------------------------------------------------------------------------------------

GenericZoneParser = {}

function GenericZoneParser:New()
    newObj = 
    {
        sectorID = nil, -- s<1>
        mgrs = nil, -- mg<gh56>
        type = nil, -- tp<forest> (forest, field, town, road)
        frontLine = nil, -- fl<1> (1 - left side, 2 - right side)
        frontDistance = nil -- fd<1> (1 * 5nm, 3 = 15nm)
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function GenericZoneParser:Parse(zoneFullName)
    self.sectorID = string.match(zoneFullName, "s<(%d+)>")
    self.mgrs = string.match(zoneFullName, "mg<(%a+)>")
    self.type = string.match(zoneFullName, "tp<(%a+)>")
    self.frontLine = string.match(zoneFullName, "fl<(%d+)>")
    self.frontDistance = string.match(zoneFullName, "fd<(%d+)>")
end

-------------------------------------------------------------------------------------------------------------------------------------------------
-- GenericZoneSetParser
--
-------------------------------------------------------------------------------------------------------------------------------------------------

GenericZoneSetParser = {}

function GenericZoneSetParser:New()
    newObj = 
    {
        setList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function GenericZoneSetParser:SetNew()
    self.setList = SET_ZONE:New():FilterPrefixes("gz:"):FilterOnce()
end

function GenericZoneSetParser:AddToSet(_setProperty, _value)
    local tempSet = SET_ZONE:New():FilterPrefixes("gz"):FilterOnce()
    local tempSetNames = tempSet:GetSetNames()
    local property = _setProperty .. "<" .. _value .. ">"
    tasksReportController:Debug("Adding zone with prop " .. property)
    for i in ipairs(tempSetNames) do 
        if string.match(tempSetNames[i], property) ~= nil then 
            tasksReportController:Debug("Insert zone " .. tempSetNames[i])
            table.insert( self.setList, tempSetNames[i]) 
        end
    end
end

function GenericZoneSetParser:FilterSet(_setProperty, _value)
    local tempSet = self.setList
    local property = _setProperty .. "<" .. _value .. ">"
    for i in ipairs(tempSet) do 
        if string.match(tempSet[i], property) == nil then
            table.remove( self.setList, tempSet[i] )
        end
    end
end

function GenericZoneSetParser:GetRandomZoneName()
    if self.setList ~= nil or #self.setList ~= 0 then 
        local rnd = math.random(1, #self.setList)
        return self.setList[rnd]
    else
        return nil
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------
--  ZoneNameParser
-- Properties:
--  sectorNumber
--  spawnType 
--  zonePrefix
--  groupPrefix
--  zoneNumber
--  
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

    if _probability == 1 then 
        tasksReportController:Debug("GroupRandomizer:RandomizeGroup(): Probability = 1, return")
        return #unitsList
    end

    if #unitsList > 0 and _probability > 0 then
        local destroyedCount = 0
        for i in ipairs(unitsList) do 
            local rnd = math.random(0, 1)
            if _probability <= rnd and i > 1 then 
                unitsList[i]:Destroy()
                destroyedCount = destroyedCount + 1
            end
        end
        return #unitsList - destroyedCount
    else
        tasksReportController:Debug("GroupRandomizer:RandomizeGroup(): Units list is nill or zero units")
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- MarkCommandController
--
-----------------------------------------------------------------------------------------------------------------------------------------------

MarkCommandController = {}

function MarkCommandController:New()
    newObj = 
    {
        
    }
    self.__index = self
    return setmetatable(newObj, self)   
end

function MarkCommandController:SetExplosion()
    MarkRemovedEventHandler = EVENTHANDLER:New()
    MarkRemovedEventHandler:HandleEvent(EVENTS.MarkRemoved)
    function MarkRemovedEventHandler:OnEventMarkRemoved(EventData)
        if EventData.text:lower():find("-exp") then
            --tasksReportController:Debug("MarkCommandController:SetExplosion(): text is  " .. EventData.text)
            local markText = string.match(EventData.text, "-exp<(%d+)>")
            local vec3 = {y=EventData.pos.y, x=EventData.pos.z, z=EventData.pos.x}
            --tasksReportController:Debug("MarkCommandController:SetExplosion(): exp force is " .. markText)
            local coord = COORDINATE:NewFromVec3(vec3):Explosion(tonumber(markText))
        end 
    end
end

function MarkCommandController:SetSpawn()
    MarkRemovedEventHandler = EVENTHANDLER:New()
    MarkRemovedEventHandler:HandleEvent(EVENTS.MarkRemoved)
    function MarkRemovedEventHandler:OnEventMarkRemoved(EventData)
        if EventData.text:lower():find("-spawn") then
            --tasksReportController:Debug("MarkCommandController:SetExplosion(): text is  " .. EventData.text)
            local markText = string.match(EventData.text, "-spawn<(%a+)>")
            local vec3 = {y=EventData.pos.y, x=EventData.pos.z, z=EventData.pos.x}
            local coord = COORDINATE:NewFromVec3(vec3)
            --tasksReportController:Debug("MarkCommandController:SetExplosion(): exp force is " .. markText)
            local spawn = SPAWN:New(markText):SpawnFromVec2(coord:GetVec2())
        end 
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------
-- FrontLineHandler

--object front distance
-- frontline = 1
-- far = 2
-----------------------------------------------------------------------------------------------------------------------------------------------
FrontLineHandler = {}

function FrontLineHandler:New(_coalition, _minRange, _maxRange, _defaultFrontlineRange, _defaultFrontDeep)
    newObj = 
    {
        acnhorZone = nil,
        anchorEndZone = nil,
        managerCoalition = _coalition,
        minRange = _minRange,
        maxRange = _maxRange,
        defaultFrontlineRange = _defaultFrontlineRange,
        currentFrontlineRange = _defaultFrontlineRange,
        defaultFrontDeep = _defaultFrontDeep,
        currentFrontDeep = _defaultFrontDeep,
        onFrontlineChangedListeners = {}
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function FrontLineHandler:AddOnFrontlineChangeListener(_listener, _functionName)
    self.onFrontlineChangedListeners[_listener] = _functionName
end

function FrontLineHandler:RemoveOnFrontlineChangeListener(_listener)
    table.remove( self.onFrontlineChangedListeners, _listener )
end

function FrontLineHandler:InvokeOnFrontlineChanged()
    for k, v in pairs(self.onFrontlineChangedListeners) do 
        local funcName = tostring(v)
        k[funcName](k)
    end
end

function FrontLineHandler:MoveFrontline(_moveDistance)
    self.currentFrontlineRange = self.currentFrontlineRange + _moveDistance

    self:InvokeOnFrontlineChanged()
end

function FrontLineHandler:SetAnchors(_anchorZoneName, _anchorEndZoneName)
    self.acnhorZone = ZONE:New(_anchorZoneName)
    self.anchorEndZone = ZONE:New(_anchorEndZoneName)
end

function FrontLineHandler:GetDistanceToZone(_zoneName)
    local tempZone = ZONE:New(_zoneName) 
    return self.acnhorZone:GetPointVec2():Get2DDistance(tempZone:GetPointVec2())
end

function FrontLineHandler:GetZoneCoalition(_zoneName, _distance)
    local tempZone = ZONE:New(_zoneName)
    local distance

    if _distance == nil then 
        distance = self:GetDistanceToZone(_zoneName)
    else
        distance = _distance
    end

    local enemyCoalition = 1

    if self.managerCoalition == 1 then enemyCoalition = 2 end 
    if self.managerCoalition == 2 then enemyCoalition = 1 end 

    if distance >= self.currentFrontlineRange then 
        return enemyCoalition
    else
        return self.managerCoalition
    end
end

function FrontLineHandler:GetIsZoneAtFrontline(_zoneName, _distance)
    local tempZone = ZONE:New(_zoneName)
    local distance

    if _distance == nil then 
        distance = self:GetDistanceToZone(_zoneName)
    else
        distance = _distance
    end

    if distance <= (self.currentFrontlineRange + self.currentFrontDeep) and distance >= (self.currentFrontlineRange - self.currentFrontDeep) then
        return true
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------
-- GenericZoneManager
-----------------------------------------------------------------------------------------------------------------------------------------------
GenericZoneManager = {}

function GenericZoneManager:New(_coalition, _frontlineHandler)
    newObj = 
    {
        coalition = _coalition,
        allGenericZonesList = {},
        allFriendlyZonesList = {},
        allFriendlyFrontZonesList = {},
        allEnemyZonesList = {},
        allEnemyFrontZonesList = {},
        frontlineHandler = _frontlineHandler
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function GenericZoneManager:SetGenericZones(_genericZonePrefix)
    local tempList = SET_ZONE:New():FilterPrefixes( _genericZonePrefix ):FilterOnce()
    local tempNamesList = tempList:GetSetNames()

    for i in ipairs(tempNamesList) do 
        local distance = self.frontlineHandler:GetDistanceToZone(tempNamesList[i])

        self.allGenericZonesList[tempNamesList[i]] = distance
        tasksReportController:Debug("GenericZoneManager:SetGenericZones(): Added zone " .. tempNamesList[i] .. " distance = " .. self.allGenericZonesList[tempNamesList[i]])
    end

end

function GenericZoneManager:UpdateZonesCoalitions()
    self.allFriendlyZonesList = {}
    self.allEnemyZonesList = {}
    self.allFriendlyFrontZonesList = {}
    self.allEnemyFrontZonesList = {}

    for k, v in pairs(self.allGenericZonesList) do 
        if self.coalition == self.frontlineHandler:GetZoneCoalition(k, v) then 
            table.insert( self.allFriendlyZonesList, k )

            if self.frontlineHandler:GetIsZoneAtFrontline(k, v) == true then 
                table.insert( self.allFriendlyFrontZonesList, k )
                tasksReportController:Debug("GenericZoneManager:UpdateZonesCoalitions(): zone named " .. k .. " is added to allFriendlyFrontZonesList")
            end

            tasksReportController:Debug("GenericZoneManager:UpdateZonesCoalitions(): zone named " .. k .. " is added to friendlyZonesList")
        else
            table.insert( self.allEnemyZonesList, k )

            if self.frontlineHandler:GetIsZoneAtFrontline(k, v) == true then 
                table.insert( self.allEnemyFrontZonesList, k )
                tasksReportController:Debug("GenericZoneManager:UpdateZonesCoalitions(): zone named " .. k .. " is added to allEnemyFrontZonesList")
            end

            tasksReportController:Debug("GenericZoneManager:UpdateZonesCoalitions(): zone named " .. k .. " is added to enemyZonesList")
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------
-- CombatScoreUnitsConfig
-----------------------------------------------------------------------------------------------------------------------------------------------

CombatScoreUnitsConfig = {}

function CombatScoreUnitsConfig:New()
    newObj = 
    {
        configName = "",
        unitsScoreCost = {}
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function CombatScoreUnitsConfig:GetUnitScoreCost(_unitName)
    if self.unitsScoreCost[_unitName] ~= nil then 
        return self.unitsScoreCost[_unitName]
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------
-- CombatScoreManager
-----------------------------------------------------------------------------------------------------------------------------------------------
CombatScoreManager = {}

function CombatScoreManager:New(_coalition, _neededScore, _currentScore)
    newObj = 
    {
        coalition = _coalition,
        neededScore = _neededScore,
        currentScore = _currentScore,
        unitScoreCostConfigsList = {},
        lastHitsList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)  
end

function CombatScoreManager:AddUnitsScoreConfig(_newConfig)
    table.insert( self.unitScoreCostConfigsList, _newConfig )
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
    for i in ipairs(self.unitScoreCostConfigsList) do 
        if self.unitScoreCostConfigsList[i]:GetUnitScoreCost(_unitName) ~= nil then
            tasksReportController:Debug("CombatScoreManager:GetUnitScoreCost(): found unitType with score " .. self.unitScoreCostConfigsList[i]:GetUnitScoreCost(_unitName))
            return self.unitScoreCostConfigsList[i]:GetUnitScoreCost(_unitName)
        else
            tasksReportController:Debug("CombatScoreManager:GetUnitScoreCost(): nothing found, return nil")
            return nil
        end
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

    tasksReportController:Debug("Test config value is " .. self:GetUnitScoreCost("Tu-22M3"))

    function HitEventHandler:OnEventHit(EventData)
        thisObj:AddHitData(EventData.IniGroupName, EventData.TgtUnitName)
    end

    function DeadEventHandler:OnEventDead(EventData)
        local killerName = thisObj:GetKillInitiator(EventData.IniUnitName)
        if killerName ~= nil then 
            local score = thisObj:GetUnitScoreCost(EventData.IniTypeName)
            tasksReportController:Debug("Group named " .. killerName .. " got score " .. score)
            thisObj:MessageToKillerGroup(killerName, score)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------
--INITIALIZATION
-----------------------------------------------------------------------------------------------------------------------------------------------
tasksReportController = TasksReportController:New()

tasksReportController.isDebugMode = true

if tasksReportController.isDebugMode == true then 
    debugMarkCommandControllerExp = MarkCommandController:New():SetExplosion()
    debugMarkCommandControllerSPawn = MarkCommandController:New():SetSpawn()
end

function ReportTasksCommand()
    tasksReportController:ReportAllTasks()
    tasksReportController:Debug("Report Task Pressed")
end

MenuTasks = MENU_MISSION:New("Tasks")
MenuStatusShow = MENU_MISSION_COMMAND:New("Report Task", MenuTasks, ReportTasksCommand)

mainTasksContainer = TasksContainer:New()

