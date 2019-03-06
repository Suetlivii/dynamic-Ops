-----------------------------------
--MissionStarter - starts mission logic
-----------------------------------

MissionStarter = {}

function MissionStarter:New()
    newObj = 
    {

    }
    self.__index = self
    return setmetatable(newObj, self)
end

function MissionStarter:StartMission()
    if #mainTasksContainer.allTasks >= 0 then
        local randomTaskNum = math.random(1, #mainTasksContainer.allTasks)
        tasksReportController:Debug("MissionStarter:StartMission randomTaskNum = " .. randomTaskNum)
        mainTasksContainer.allTasks[randomTaskNum]:StartTask()
    end
end

mainMissionStarter = MissionStarter:New()

mainMissionStarter:StartMission()

