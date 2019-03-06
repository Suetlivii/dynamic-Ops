-----------------------------------------
--DeepStrike task controller
-----------------------------------------

TaskDeepStrike = TaskController:New()

TaskDeepStrike:AddTaskToContainer()

TaskDeepStrike.localizedReport["En"] = "Test en brif" 

function TaskDeepStrike:StartTask()
    self.ReportTask("En")
end

