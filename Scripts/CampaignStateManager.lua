------------------------------------------------
--CampaignStateManager 
--Dependencies: CampaignStateContainer
------------------------------------------------

CampaignStateManager = {}

function CampaignStateManager:New(_campaignStateContainer)
    newObj = 
    {
        managedCampaignStateContainer = _campaignStateContainer
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function CampaignStateManager:GetFrontSectorID(_coalition)

    local redFrontsectorID = 0
    local blueFrontsectorID = 0

    if self.managedCampaignStateContainer ~= nil then 

        for i in ipairs(self.managedCampaignStateContainer.allSectorStates) do
            
            if self.managedCampaignStateContainer.allSectorStates[i].sectorCoalition ~= self.managedCampaignStateContainer.allSectorStates[i+1].sectorCoalition then
                redFrontsectorID = self.managedCampaignStateContainer.allSectorStates[i].sectorID
                blueFrontsectorID = self.managedCampaignStateContainer.allSectorStates[i+1].sectorID

                tasksReportController:Debug("CampaignStateManager:GetFronsectorID: Red is " .. redFrontsectorID .. " Blue is " .. blueFrontsectorID)

                break
            end

        end

        if _coalition == coalition.side.RED then 
            return redFrontsectorID
        end
    
        if _coalition == coalition.side.BLUE then 
            return blueFrontsectorID
        end

    end

end