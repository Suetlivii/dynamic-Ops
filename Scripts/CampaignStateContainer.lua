------------
--Controlling Campaign State
--Main Data Class
--Dependencies: Nothing
------------

--CampaignStateContainer
CampaignStateContainer = {}

function CampaignStateContainer:New()
    newObj = 
    {
        globalCampaignID = "noID",
        isFirstLaunch = true,
        sessionsPlayed = 0,
        missionsCompleted = 0,
        missionsFailed = 0,
        missionsCanceled = 0,
        activeSector = 4,
        allSectorStates = {},
        allGroupStates = {},
        allZoneGroupStates = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

--CampaignStateContainer end