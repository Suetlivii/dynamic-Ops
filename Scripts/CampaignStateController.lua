------------
--Controlling Campaign State
--Main Data Class
--Dependencies: Nothing
------------

--CampaignStateController
CampaignStateController = {}

function CampaignStateController:New()
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

function CampaignStateController:DecreaseGroupCount(GroupPrefix, count)

end

function CampaignStateController:GetGroupSpawnPossible(GroupPrefix)

end

function CampaignStateController:GetZoneGroupIsAlive(zonePrefix)

end
--CampaignStateController end

