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
        Brief = "Brief Default",
        MapMarkText = "Target",
        OnWin = "Task completed.",
        OnLost = "Task failed.",
        OnCanceled = "Task canceled.",
        AfterWin = "Task completed.",
        AfterLose = "Task failed.",
        AfterCanceled = "Task canceled." 
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
        genericTaskReportsList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TaskLocalizationData:GetReport(_language, _report)
    if self.genericTaskReportsList._language._report ~= nil or self.genericTaskReportsList._language._report ~= "" then 
        return self.genericTaskReportsList._language._report
    end
end
--TaskLocalizationData end


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TaskReportsData
--
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
    if self.taskLocalizationDatasList._taskName._language._report ~= nil or self.taskLocalizationDatasList._taskName._language._report ~= "" then
        return self.taskLocalizationDatasList._taskName._language._report
    end
end

function TaskReportsData:AddNewTaskLocalization(_taskName, _taskLocalization)
    if _taskLocalization ~= nil then 
        self.taskLocalizationDatasList._taskName = _taskLocalization
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

trainStationStrikeLocalization.genericTaskReportsList.En.Brief = "Destroy enemy forces at the train station. Check F10 Map for coordinates."
trainStationStrikeLocalization.genericTaskReportsList.En.MapMarkText = "Target"
trainStationStrikeLocalization.genericTaskReportsList.En.OnWin = "Enemy forces has been destroyed. Task completed!"
trainStationStrikeLocalization.genericTaskReportsList.En.OnLost = "Enemy forces hasn't been destroyed. Task Failed!"
trainStationStrikeLocalization.genericTaskReportsList.En.OnCanceled = "Task was canceled."

trainStationStrikeLocalization.genericTaskReportsList.Ru.Brief = "Уничтожьте вражеские силы на железнодорожной станции."
trainStationStrikeLocalization.genericTaskReportsList.Ru.OnWin = "Цель уничтожена, задание выполено."
trainStationStrikeLocalization.genericTaskReportsList.Ru.OnLost = "Цель не была уничтожена, задание провалено."
trainStationStrikeLocalization.genericTaskReportsList.Ru.OnCanceled = "Задание отменено."

MainTaskReportsData:AddNewTaskLocalization("trainStationStrike", trainStationStrikeLocalization)