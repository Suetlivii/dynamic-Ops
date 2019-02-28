------------
--Controller that print messages to DCS
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

function TasksReportController:Debug(msgString)
    if self.isDebugMode == true then
        newDebugMessage = MESSAGE:New(tostring(msgString .. "\r"), 10, "DEBUG", false):ToAll()
    end
end
--TasksReportController end

tasksReportController = TasksReportController:New()

tasksReportController.isDebugMode = true

