--Manager that reports messages for players
ReportsManager = {}

function ReportsManager:New(_reportCoalition)

    newObj = 
    {
        reportCoalition
    }
    self.__index = self
    return setmetatable(newObj, self)

end

function ReportsManager:ReportTasksContainerToGroup(groupToReport, _taskContainer)

    for i in pairs(_taskContainer.tasksList) do
        MESSAGE:New(_taskContainer.tasksList[i].taskBrif, 30):ToGroup(groupToReport)
    end

end

function ReportsManager:ReportToAll(reportText)

    MESSAGE:NewType(tostring(reportText), MESSAGE.Type.Information ):ToAll()

end


reportManagerBlue = ReportsManager:New(coalition.side.BLUE)


--@param Wrapper.Group#GROUP
function ReportTasks (theSenderGroup)

    reportManagerBlue:ReportTasksContainerToGroup(theSenderGroup, tasksContainerBlue)

end

  --@param Wrapper.Group#GROUP
function AddMenu(aGroup)

    local myMenu = MENU_GROUP:New(aGroup, "Tasks")
    local myCMDmenu = MENU_GROUP_COMMAND:New(aGroup, "Show Tasks", myMenu, ReportTasks, aGroup) 

end

SetGroupObject = SET_GROUP:New():FilterCoalitions("blue"):FilterOnce()

SetGroupObject:ForEachGroup(AddMenu, GROUP)

