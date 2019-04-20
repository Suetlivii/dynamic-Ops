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
trainStationStrikeStartConfig.GroupRandomizeProbability = 0.75
trainStationStrikeStartConfig.MarkText = "TRAIN STATION STRIKE TARGET"
trainStationStrikeStartConfig.minLifePercent = 0.9

StrikeTrainStationTask = GenericStrikeTask:New()

StrikeTrainStationTask.taskConfig = trainStationTaskConfig
StrikeTrainStationTask.startConfig = trainStationStrikeStartConfig

StrikeTrainStationTask:AddTaskToContainer(StrikeTrainStationTask)
-------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
-- MLRSStrike
mlrsStrikeConfig = TaskConfig:New()
mlrsStrikeConfig.taskName = "mlrsStrike"

mlrsStrikeStartConfig = GenericStrikeTaskStartConfig:New()
mlrsStrikeStartConfig.LAGroupName = "mlrsStrike"
mlrsStrikeStartConfig.GroupRandomizeProbability = 0.8
mlrsStrikeStartConfig.MarkText = "MLRS STRIKE TARGET"
mlrsStrikeStartConfig.minLifePercent = 0.9

mlrsStrikeTask = GenericStrikeTask:New()

mlrsStrikeTask.taskConfig = mlrsStrikeConfig
mlrsStrikeTask.startConfig = mlrsStrikeStartConfig

mlrsStrikeTask:AddTaskToContainer(mlrsStrikeTask)
-------------------------------------------------------------------------------------------------------------------------------------------------