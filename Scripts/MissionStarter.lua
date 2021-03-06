-----------------------------------
--MissionStarter - starts mission logic
--Dependencies: taskReportController object, CampaignStateContainer class, ZoneGroupSpawner class, mainCampaignStateSetter object
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
        local tempAllTasksList = mainTasksContainer.allTasks
        tasksReportController:Debug("MissionStarter:StartMission randomTaskNum = " .. randomTaskNum)
        mainTasksContainer.allTasks[randomTaskNum]:StartTask(mainCampaignStateContainer.defaultCampaignCoalition)
        table.remove( mainTasksContainer.allTasks, randomTaskNum )
        mainTasksContainer:AddNewActiveTask(mainTasksContainer.allTasks[randomTaskNum])
    else
        tasksReportController:Debug("MissionStarter:StartMission: No tasks, allTasks count is 0 ")
    end
end

mainMissionStarter = MissionStarter:New()

mainMissionStarter:StartRandomTask()

mainFrontlineHandler = FrontLineHandler:New(2, 200000, 900000, 410000, 20000)
mainFrontlineHandler:SetAnchors("ga:cl<2>", "gae:cl<2>")

mainGenericZoneManager = GenericZoneManager:New( mainFrontlineHandler.managerCoalition, mainFrontlineHandler)
mainGenericZoneManager:SetGenericZones("gz:")
mainGenericZoneManager:UpdateZonesCoalitions()

mainFrontlineHandler:AddOnFrontlineChangeListener(mainGenericZoneManager, "UpdateZonesCoalitions")

blueCombatScoreManager = CombatScoreManager:New(2)

blueCombatScoreManager:AddUnitsScoreConfig(mainCombatScoreUnitsConfig)
blueCombatScoreManager:StartScoring()


-- SEADController = SEAD:New( {"AirdefenceRadarSamsite"} ) 

-- testGenerizZoneSetParser = GenericZoneSetParser:New()
-- testGenerizZoneSetParser:AddToSet("tp", "forest")
-- testGenerizZoneSetParser:AddToSet("tp", "road")

-- for i in ipairs(testGenerizZoneSetParser.setList) do 
--     tasksReportController:Debug("CREATING MARK FOR ZONE " .. testGenerizZoneSetParser.setList[i])
-- end