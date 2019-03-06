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

function TaskController:ReportTask(language)
    if localizedReport[language] ~= nil or localizedReport[language] ~= "" then 
        tasksReportController:ReportToAll( localizedReport[language] )
    else
        tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "nil or empty message on ReportTask")
    end
end

function TaskController:FinishTaskWin()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default FinishTaskWin(). You have to overload method.")
end

function TaskController:FinishTaskLose()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default FinishTaskLose(). You have to overload method.")
end

function TaskController:CancelTask()
    tasksReportController:Debug("TaskController:" .. self.taskName .. ": " .. "default CancelTask(). You have to overload method.")
end