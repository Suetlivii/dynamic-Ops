-----------------------------------
--MissionStarter - starts mission logic
--Dependencies: taskReportController object, CampaignStateController class, ZoneGroupSpawner class, mainCampaignStateSetter object
-----------------------------------

MissionStarter = {}

function MissionStarter:New()
    newObj = 
    {

    }
    self.__index = self
    return setmetatable(newObj, self)
end

function MissionStarter:StartRandomTask()
    if #mainTasksContainer.allTasks > 0 then
        local randomTaskNum = math.random(1, #mainTasksContainer.allTasks)
        tasksReportController:Debug("MissionStarter:StartMission randomTaskNum = " .. randomTaskNum)
        mainTasksContainer.allTasks[randomTaskNum]:StartTask()
    else
        tasksReportController:Debug("MissionStarter:StartMission: No tasks, allTasks count is 0 ")
    end
end

mainMissionStarter = MissionStarter:New()

mainCampaignStateController = CampaignStateController:New()

mainCampaignStateSetter:SetState()

mainZoneGroupsSpawner = ZoneGroupsSpawner:New()
mainZoneGroupsSpawner:SpawnAllGroups()

mainMissionStarter:StartRandomTask()

