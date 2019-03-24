------------------------------------------------------------------------------------------------------------------------------------------------
--DeepStrike task controller
--Dependencies: TaskController class
------------------------------------------------------------------------------------------------------------------------------------------------

TaskDeepStrike = TaskController:New()
TaskDeepStrike.taskName = "Deep Strike"
TaskDeepStrike.localizedReport["En"] = 
"DEEP STRIKE:\n" ..
"Destroy the factory, check F10 map"
TaskDeepStrike.taskCoalition = coalition.side.BLUE
TaskDeepStrike.isFailCounts = true

--TaskDeepStrike:AddTaskToContainer(TaskDeepStrike)
 
function TaskDeepStrike:StartTask()
    TaskDeepStrike:ReportTask("En")

    local missionZoneSet = SET_ZONE:New()
    missionZoneSet:FilterPrefixes( { "s<2>st<MissionRespawnUnable>zp<DeepStrikeFactory>gp<MissionTarget>" } )
    missionZoneSet:FilterOnce()

    local missionTargetSpawn = SPAWN:New( "RedMissionTarget" )
    local missionTargetUnit = missionTargetSpawn:SpawnInZone( missionZoneSet:GetRandomZone() )

    local targetCoord = missionTargetUnit:GetCoordinate()
    local markID = targetCoord:MarkToCoalitionBlue( "DEEP STRIKE: TARGET", true)

    missionTargetUnit:HandleEvent(EVENTS.Dead)

    function missionTargetUnit:OnEventDead( EventData )

        TaskDeepStrike.localizedReport["En"] = 
        "DEEP STRIKE:\n" ..
        "Target destoyed, mission completed"

        TaskDeepStrike:ReportTask("En")

    end

end

------------------------------------------------------------------------------------------------------------------------------------------------
-- TrainStationFront Task
-- _taskName
-- _localizedReport
-- _coalition
-- _isFailCounts
-- _taskDificulti
-- _laGroupName
-- _sectorID
------------------------------------------------------------------------------------------------------------------------------------------------

StrikeTrainStationTask = DestroyLAGroupTaskController:New()

local StrikeTrainStationLocalizedReport = 
{
    "En" = "Destroy enemy forces at the train station. Check F10 map for a coordinates."
}

StrikeTrainStationTask:InitializeTask(
    "Train Station Strike",
    StrikeTrainStationLocalizedReport,
    
)


StrikeTrainStationTask.laGroupName = "TrainStation"
StrikeTrainStationTask.sectorID = mainCampaignStateManager:GetFrontSectorID(coalition.side.RED)

StrikeTrainStationTask:AddTaskToContainer(StrikeTrainStationTask)