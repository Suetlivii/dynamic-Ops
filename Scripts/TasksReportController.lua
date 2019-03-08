------------
--Controller that print messages to DCS
--Dependencies: Moose 
------------

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
        newDebugMessage = MESSAGE:New(tostring(msgString .. "\r"), 10, "DEBUG", false):ToAll()
    end
end

function TasksReportController:ReportToAll(msgString)
    newDebugMessage = MESSAGE:New(tostring(msgString), 45, false):ToAll()
end

function TasksReportController:ReportAllTasks()
    
end
--TasksReportController end

tasksReportController = TasksReportController:New()

tasksReportController.isDebugMode = true

function ReportTasksCommand()

    tasksReportController:ReportAllTasks()
    tasksReportController:Debug("Report Task Pressed")

end

MenuTasks = MENU_MISSION:New("Tasks")
MenuStatusShow = MENU_MISSION_COMMAND:New("Report Task", MenuTasks, ReportTasksCommand)

