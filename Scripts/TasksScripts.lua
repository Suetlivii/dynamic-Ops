------------------------------------------------------------------------------------------------------------------------------------------------
--DeepStrike task controller
--Dependencies: TaskController class
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------
--Task Config
--
-- taskName = "Default Task Config"
-- taskCoalition = coalition.side.BLUE
-- taskDifficulty = 1
-- isFailCounts = true
------------------------------------------------------

-- TaskDeepStrike = TaskController:New()
-- TaskDeepStrike.taskName = "Deep Strike"
-- TaskDeepStrike.localizedReport["En"] = 
-- "DEEP STRIKE:\n" ..
-- "Destroy the factory, check F10 map"
-- TaskDeepStrike.taskCoalition = coalition.side.BLUE
-- TaskDeepStrike.isFailCounts = true

-- --TaskDeepStrike:AddTaskToContainer(TaskDeepStrike)
 
-- function TaskDeepStrike:StartTask()
--     TaskDeepStrike:ReportTask("En")

--     local missionZoneSet = SET_ZONE:New()
--     missionZoneSet:FilterPrefixes( { "s<2>st<MissionRespawnUnable>zp<DeepStrikeFactory>gp<MissionTarget>" } )
--     missionZoneSet:FilterOnce()

--     local missionTargetSpawn = SPAWN:New( "RedMissionTarget" )
--     local missionTargetUnit = missionTargetSpawn:SpawnInZone( missionZoneSet:GetRandomZone() )

--     local targetCoord = missionTargetUnit:GetCoordinate()
--     local markID = targetCoord:MarkToCoalitionBlue( "DEEP STRIKE: TARGET", true)

--     missionTargetUnit:HandleEvent(EVENTS.Dead)

--     function missionTargetUnit:OnEventDead( EventData )

--         TaskDeepStrike.localizedReport["En"] = 
--         "DEEP STRIKE:\n" ..
--         "Target destoyed, mission completed"

--         TaskDeepStrike:ReportTask("En")

--     end

-- end

------------------------------------------------------------------------------------------------------------------------------------------------
--TrainStation Strike Task
------------------------------------------------------------------------------------------------------------------------------------------------

trainStationTaskConfig = TaskConfig:New()

trainStationTaskConfig.taskName = "trainStationStrike"

StrikeTrainStationTask = TaskController:New()

StrikeTrainStationTask.taskConfig = trainStationTaskConfig

function StrikeTrainStationTask:StartTask(_taskCoalition)
    local debugMsg = 
    "STARTED TASK " .. self.taskConfig.taskName .. " with coalition " .. self.taskConfig.taskCoalition .. " difficulty is " .. self.taskConfig.taskDifficulty
    tasksReportController:Debug(debugMsg)

    

end

StrikeTrainStationTask:AddTaskToContainer(StrikeTrainStationTask)