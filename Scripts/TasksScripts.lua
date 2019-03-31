------------------------------------------------------------------------------------------------------------------------------------------------
--DeepStrike task controller
--Dependencies: TaskController class

--BLUE is 2, RED is 1

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------
--Task Config
--
-- taskName = "Default Task Config"
-- taskCoalition = coalition.side.BLUE
-- taskDifficulty = 1
-- isFailCounts = true
------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- Generic Strike Task 
------------------------------------------------------------------------------------------------------------------------------------------------

GenericStrikeTaskStartConfig = {}

function GenericStrikeTaskStartConfig:New()
    newObj = 
    {
        LAGroupName = "Default",
        GroupRandomizeProbability = 0,
        MarkText = "Defaul" 
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

    if _taskCoalition == 1 then enemyCoalition = 2 end

    local frontSectorID = mainCampaignStateManager:GetFrontSectorID(enemyCoalition)
    local groupName = LAGroupNameParser:GetRandomGroupByNameByCoalitionInSector(self.startConfig.LAGroupName, enemyCoalition, frontSectorID)
    tasksReportController:Debug("Attempt to start task. LAGroupName = " .. self.startConfig.LAGroupName .. " taskColaition = " .. self.taskConfig.taskCoalition .. " sector = " .. frontSectorID)

    local targetGroupSpawn = SPAWN:NewWithAlias( groupName, self.startConfig.LAGroupName )
    targetGroup = targetGroupSpawn:ReSpawn()

    local groupRandomizer = GroupRandomizer:New()
    groupRandomizer:RandomizeGroup(targetGroup, self.startConfig.GroupRandomizeProbability)

    targetGroup:HandleEvent(EVENTS.Dead)

    function targetGroup:OnEventDead( EventData )
        self:FinishTaskWin()
    end

    local targetCoord = targetGroup:GetCoordinate()
    local markID = targetCoord:MarkToCoalitionBlue( self.startConfig.MarkText, true)

    self:ReportTask("En")

end

------------------------------------------------------------------------------------------------------------------------------------------------
--TrainStation Strike Task
------------------------------------------------------------------------------------------------------------------------------------------------

trainStationTaskConfig = TaskConfig:New()
trainStationTaskConfig.taskName = "trainStationStrike"

trainStationStrikeStartConfig = GenericStrikeTaskStartConfig:New()
trainStationStrikeStartConfig.LAGroupName = "TrainStation"
trainStationStrikeStartConfig.GroupRandomizeProbability = 0.5
trainStationStrikeStartConfig.MarkText = "TRAIN STATION STRIKE TARGET"

StrikeTrainStationTask = GenericStrikeTask:New()

StrikeTrainStationTask.startConfig = trainStationStrikeStartConfig

StrikeTrainStationTask:AddTaskToContainer(StrikeTrainStationTask)


-- trainStationTaskConfig = TaskConfig:New()

-- trainStationTaskConfig.taskName = "trainStationStrike"

-- StrikeTrainStationTask = TaskController:New()

-- StrikeTrainStationTask.taskConfig = trainStationTaskConfig

-- function StrikeTrainStationTask:StartTask(_taskCoalition)
--     local debugMsg = 
--     "STARTED TASK " .. self.taskConfig.taskName .. " with coalition " .. self.taskConfig.taskCoalition .. " difficulty is " .. self.taskConfig.taskDifficulty
--     tasksReportController:Debug(debugMsg)

--     local trainStationGroupName = LAGroupNameParser:GetRandomGroupByNameByCoalitionInSector("TrainStation", coalition.side.RED, 4)
--     tasksReportController:Debug(trainStationGroupName)

--     local targetGroupSpawn = SPAWN:NewWithAlias( trainStationGroupName, "TrainStationTarget" )
--     targetGroup = targetGroupSpawn:ReSpawn()

--     local groupRandomizer = GroupRandomizer:New()
--     groupRandomizer:RandomizeGroup(targetGroup, 0.5)

--     targetGroup:HandleEvent(EVENTS.Dead)

--     function targetGroup:OnEventDead( EventData )
--         tasksReportController:Debug("TrainStationStrike DEAD!!")
--     end

--     local targetCoord = targetGroup:GetCoordinate()
--     local markID = targetCoord:MarkToCoalitionBlue( "TRAIN STATION STRIKE: TARGET", true)

--     self:ReportTask("En")
-- end

-- StrikeTrainStationTask:AddTaskToContainer(StrikeTrainStationTask)