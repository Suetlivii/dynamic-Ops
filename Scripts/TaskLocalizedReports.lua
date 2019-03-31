-------------------------------------------------------------------------------------------------------------------------------------------------
-- GenericTaskReports
-- GenericTaskReports contains some generic messages for tasks, each GenericTaskReports have language

-- .Brief = "Brief Default"
-- .MapMarkText = "Target"
-- .OnWin = "OnWin Default"
-- .OnLost = "OnLost Default"
-- .OnCanceled = "OnCanceled Default" 
-- .AfterWin = "AfterWin Default"
-- .AfterLose = "AfterLose Default"
-- .AfterCanceled = "AfterCanceled Default" 
-------------------------------------------------------------------------------------------------------------------------------------------------
GenericTaskReports = {}

function GenericTaskReports:New()
    newObj = 
    {
        reportsList = 
        {
            TaskName = "TASK NAME",
            Brief = "Brief Default",
            MapMarkText = "Target",
            OnWin = "Task completed.",
            OnLost = "Task failed.",
            OnCanceled = "Task canceled.",
            AfterWin = "Task completed.",
            AfterLose = "Task failed.",
            AfterCanceled = "Task canceled." 
        }
    }
    self.__index = self
    return setmetatable(newObj, self)
end
--GenericTaskReports END


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TaskLocalizationData
-- TaskLocalizationData contains all tasks reports with different languages 
-- En, Ru, De etc
-------------------------------------------------------------------------------------------------------------------------------------------------

TaskLocalizationData = {}

function TaskLocalizationData:New()
    newObj = 
    {
        taskName,
        genericTaskReportsList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

--TaskLocalizationData end


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TaskReportsData
--taskLocalizationDatasList[taskName].genericTaskReportsList[language].report
-------------------------------------------------------------------------------------------------------------------------------------------------

TaskReportsData = {}

function TaskReportsData:New()
    newObj = 
    {
        taskLocalizationDatasList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TaskReportsData:GetReport(_taskName, _language, _report)
    if self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList[_report] ~= nil 
    and self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList[_report] ~= "" then
        tasksReportController:Debug("TaskReportsData:GetReport(): taskName = " .. _taskName .. " language = " .. _language .. " report = " .. _report)
        local returnReport = self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList[_report]

        if self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList["TaskName"] ~= nil
        and self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList["TaskName"] ~= "" then
            returnReport = self.taskLocalizationDatasList[_taskName].genericTaskReportsList[_language].reportsList["TaskName"] .. "\n" .. returnReport
        end
        return returnReport
    end
end

function TaskReportsData:AddNewTaskLocalization(_taskName, _taskLocalizationData)
    if _taskLocalizationData ~= nil then 
        self.taskLocalizationDatasList[_taskName] = _taskLocalizationData
    end
end

MainTaskReportsData = TaskReportsData:New()
--TaskReportsData END


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TASKS LOCALIZATIONS
--
-------------------------------------------------------------------------------------------------------------------------------------------------

trainStationStrikeLocalization = TaskLocalizationData:New()

trainStationStrikeLocalization.genericTaskReportsList.En = GenericTaskReports:New()

trainStationStrikeLocalization.genericTaskReportsList.En.reportsList.TaskName = "TRAIN STATION STRIKE"
trainStationStrikeLocalization.genericTaskReportsList.En.reportsList.Brief = "Destroy enemy forces at the train station. Check F10 Map for coordinates."
trainStationStrikeLocalization.genericTaskReportsList.En.reportsList.MapMarkText = "Target"
trainStationStrikeLocalization.genericTaskReportsList.En.reportsList.OnWin = "Enemy forces has been destroyed. Task completed!"
trainStationStrikeLocalization.genericTaskReportsList.En.reportsList.OnLost = "Enemy forces hasn't been destroyed. Task Failed!"
trainStationStrikeLocalization.genericTaskReportsList.En.reportsList.OnCanceled = "Task was canceled."

trainStationStrikeLocalization.genericTaskReportsList.Ru = GenericTaskReports:New()
trainStationStrikeLocalization.genericTaskReportsList.Ru.Brief = "Уничтожьте вражеские силы на железнодорожной станции."
trainStationStrikeLocalization.genericTaskReportsList.Ru.OnWin = "Цель уничтожена, задание выполено."
trainStationStrikeLocalization.genericTaskReportsList.Ru.OnLost = "Цель не была уничтожена, задание провалено."
trainStationStrikeLocalization.genericTaskReportsList.Ru.OnCanceled = "Задание отменено."

MainTaskReportsData:AddNewTaskLocalization("trainStationStrike", trainStationStrikeLocalization)