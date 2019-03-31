
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