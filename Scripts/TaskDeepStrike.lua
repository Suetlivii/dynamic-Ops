-----------------------------------------
--DeepStrike task controller
--Dependencies: TaskController class
-----------------------------------------

TaskDeepStrike = TaskController:New()
TaskDeepStrike.taskName = "Deep Strike"
TaskDeepStrike.localizedReport["En"] = "Test en brif"
TaskDeepStrike.taskCoalition = "Blue"
TaskDeepStrike.isFailCounts = true

TaskDeepStrike:AddTaskToContainer()
 
function TaskDeepStrike:StartTask()
    TaskDeepStrike:ReportTask("En")
end

