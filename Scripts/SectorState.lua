------------
--SectorState contains sector information, list of all SectorStates stored in CampaignStateController.allSectorStates
------------


--SectorState
SectorState = {}

function SectorState:New(_sectorID, _sectorCoalition, _requiredMissionCount)
    newObj = 
    {
        sectorID = _sectorID,
        sectorCoalition = _sectorCoalition,
        requiredMissionCount = _requiredMissionCount,
        missionsProgress
    }
    self.__index = self
    return setmetatable(newObj, self)
end

--SectorState end