
-------------------------------------------------------------------------------------------------------------------------------------------------
-- TASKS LOCALIZATIONS
--
-------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------
-- TrainStationStrike
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
-------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
-- MLRS strike
mlrsStrikeLocalization = TaskLocalizationData:New()

mlrsStrikeLocalization.genericTaskReportsList.En = GenericTaskReports:New()

mlrsStrikeLocalization.genericTaskReportsList.En.reportsList.TaskName = "MLRS GROUP STRIKE"
mlrsStrikeLocalization.genericTaskReportsList.En.reportsList.Brief = "Destroy enemy MLRS. Check F10 Map for coordinates."
mlrsStrikeLocalization.genericTaskReportsList.En.reportsList.MapMarkText = "Target"
mlrsStrikeLocalization.genericTaskReportsList.En.reportsList.OnWin = "Enemy forces has been destroyed. Task completed!"
mlrsStrikeLocalization.genericTaskReportsList.En.reportsList.OnLost = "Enemy forces hasn't been destroyed. Task Failed!"
mlrsStrikeLocalization.genericTaskReportsList.En.reportsList.OnCanceled = "Task was canceled."

mlrsStrikeLocalization.genericTaskReportsList.Ru = GenericTaskReports:New()
mlrsStrikeLocalization.genericTaskReportsList.Ru.Brief = "Уничтожьте вражескую реактивную артиллерию."
mlrsStrikeLocalization.genericTaskReportsList.Ru.OnWin = "Цель уничтожена, задание выполено."
mlrsStrikeLocalization.genericTaskReportsList.Ru.OnLost = "Цель не была уничтожена, задание провалено."
mlrsStrikeLocalization.genericTaskReportsList.Ru.OnCanceled = "Задание отменено."

MainTaskReportsData:AddNewTaskLocalization("mlrsStrike", mlrsStrikeLocalization)
-------------------------------------------------------------------------------------------------------------------------------------------------