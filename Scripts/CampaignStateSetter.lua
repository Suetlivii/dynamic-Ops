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

abkhazianCampaignState = CampaignStateSetter:New()

function abkhazianCampaignState:SetState()

    newAllSectorStates = 
    {
        SectorState:New(1, coalition.side.RED, 3),
        SectorState:New(2, coalition.side.RED, 3),
        SectorState:New(3, coalition.side.RED, 3),
        SectorState:New(4, coalition.side.RED, 3),
        SectorState:New(5, coalition.side.RED, 3),
        SectorState:New(6, coalition.side.BLUE, 3),
        SectorState:New(7, coalition.side.BLUE, 3),
    }

    self.newCampaignState.allSectorStates = newAllSectorStates

end