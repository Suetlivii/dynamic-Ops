-------------------------------------------
--TaskController - starting and controlling tasks progress, contains task brifieng
-------------------------------------------

TaskController = {}

function TaskController:New()
    newObj = 
    {
        taskName,
        localizedReport = {},
        taskCoalition = "",
        isFailCounts = true
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TaskController:AddTaskToContainer()
    mainTasksContainer:AddNewTask(self)
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. " added.")
end

function TaskController:StartTask()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default StartTask(). You have to overload method.")
end

function TaskController:FinishTaskWin()

end

function TaskController:FinishTaskLose()

end

function TaskController:CancelTask()

end