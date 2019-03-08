---------
--CampaignStateSetter creates new CampaignStateController
---------

--CampaignStateSetter
CampaignStateSetter = {}

function CampaignStateSetter:New()
    newObj = 
    {
        newCampaignState
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function CampaignStateSetter:SetState()

end
--CampaignStateSetter end

mainCampaignStateSetter = CampaignStateSetter:New()

function mainCampaignStateSetter:SetState()

    newAllSectorStates = 
    {
        SectorState:New(1, "Red", 3),
        SectorState:New(2, "Red", 3),
        SectorState:New(3, "Red", 3),
        SectorState:New(4, "Red", 3),
        SectorState:New(5, "Red", 3),
        SectorState:New(6, "Blue", 3),
        SectorState:New(7, "Blue", 3),
    }

    self.allSectorStates = newAllSectorStates



    mainCampaignStateController = routines.utils.deepCopy(self)
end

