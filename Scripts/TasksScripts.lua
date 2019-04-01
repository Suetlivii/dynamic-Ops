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
--TrainStation Strike Task
------------------------------------------------------------------------------------------------------------------------------------------------

trainStationTaskConfig = TaskConfig:New()
trainStationTaskConfig.taskName = "trainStationStrike"

trainStationStrikeStartConfig = GenericStrikeTaskStartConfig:New()
trainStationStrikeStartConfig.LAGroupName = "TrainStation"
trainStationStrikeStartConfig.GroupRandomizeProbability = 0.5
trainStationStrikeStartConfig.MarkText = "TRAIN STATION STRIKE TARGET"
trainStationStrikeStartConfig.minLifePercent = 0.6

StrikeTrainStationTask = GenericStrikeTask:New()

StrikeTrainStationTask.taskConfig = trainStationTaskConfig
StrikeTrainStationTask.startConfig = trainStationStrikeStartConfig

StrikeTrainStationTask:AddTaskToContainer(StrikeTrainStationTask)
