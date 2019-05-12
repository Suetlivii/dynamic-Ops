-----------------------------------------------------------------------------------------------------------------------------------------------
-- GCIController
-----------------------------------------------------------------------------------------------------------------------------------------------
GCIController = {}

function GCIController:New()
    newObj = 
    {
        A2ADispatcher = nil,
        borderZone = nil,
        engageRadius = 300000,
        gciRadius = 300000,
        overhead = 1,
        grouping = 2,
        tacticalDisplay = false,
        aircraftLimit = 8
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function GCIController:SetDispatcher()
    --EWR SETUP
    local DetectionSetGroup = SET_GROUP:New()
    DetectionSetGroup:FilterPrefixes( { "AirdefenceRadarEwr" } )
    DetectionSetGroup:FilterStart()

    local Detection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

    --Dispatcher setup
    if self.A2ADispatcher == nil then 
        self.A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )
    end

    self.A2ADispatcher:SetEngageRadius( tonumber(self.engageRadius) )
    self.A2ADispatcher:SetGciRadius( tonumber(self.gciRadius) )


    if self.borderZone ~= nil then 
        self.borderZone = mainSectorZonesManager:GetSectorZone(mainCampaignStateManager:GetFrontSectorID(coalition.side.RED))
        self.A2ADispatcher:SetBorderZone( self.borderZone )
    end
end

function GCIController:StartCapGCI(_groupPrefix, _airField, _isCap, _isGCI)
    local squadronName = "GCISquadron:" .. tostring(_airField) .. ":" .. tostring(_groupPrefix), _airField

    self.A2ADispatcher:SetSquadron( squadronName, _airField, { _groupPrefix }, self.aircraftLimit )
    self.A2ADispatcher:SetSquadronTakeoffFromParkingHot( squadronName )
    self.A2ADispatcher:SetSquadronLandingAtEngineShutdown( squadronName )

    if _isGCI == true then 
        self.A2ADispatcher:SetSquadronGci( squadronName, 900, 1200 )
    end

    if _isCap == true then 
        self.A2ADispatcher:SetSquadronCap( squadronName, self.borderZone, 600, 6500, 600, 800, 800, 1200, "RADIO" )
        self.A2ADispatcher:SetSquadronCapInterval( squadronName, 1, 10, 15, 1 )
    end

    self.A2ADispatcher:SetSquadronGrouping(squadronName, self.grouping)
    self.A2ADispatcher:SetSquadronOverhead(squadronName, self.overhead)

    self.A2ADispatcher:Start()
     
    --tasksReportController:Debug("GCIController:StartGCI: Started GCI Squadron with name " .. squadronName .. " for border " .. borderZone:GetName() .. "GciRadius = " .. self.gciRadius .. " engage radius = " .. self.engageRadius)
end

mainA2ADispatcher = GCIController:New()
mainA2ADispatcher:SetDispatcher()

mainA2ADispatcher:StartCapGCI("RedPlaneMilitaryFighterSu27", AIRBASE.Caucasus.Gudauta, false, true)

mainA2ADispatcher:StartCapGCI("RedPlaneMilitaryFighterMig29s", AIRBASE.Caucasus.Sukhumi_Babushara, true, true)