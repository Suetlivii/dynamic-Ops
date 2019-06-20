-----------------------------------------------------------------------------------------------------------------------------------------------
-- A2AConfig example
-----------------------------------------------------------------------------------------------------------------------------------------------

-- A2AConfig = 
-- {
--     {
--         groupPrefix = "mig23",
--         spawnedGroupPrefix = "capMig23",
--         minAltitude = 200,
--         maxAltitude = 6000,
--         airBase = "Gelendzhik",
--         isCap = true,
--         isGci = false,
--         grouping = 2,
--         overhead = 1,
--         airCraftLimit = 8
--     }
-- }

-----------------------------------------------------------------------------------------------------------------------------------------------
-- A2AUnitConfig
-----------------------------------------------------------------------------------------------------------------------------------------------

A2AConfigurator = {}

function A2AConfigurator:New()
    newObj = 
    {
        a2aConfigs = {},
        A2AController = nil
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function A2AConfigurator:SetA2AConfigs(_configs)
    if #_configs > 0 then 
        self.a2aConfigs = _configs
    end
end

function A2AConfigurator:SetController(_controller)
    if _controller ~= nil then 
        self.A2AController = _controller
    end

    for i in ipairs(self.a2aConfigs) do 
        self.A2AController:StartCapGCI(self.a2aConfigs[i].groupPrefix, self.a2aConfigs[i].minAltitude, self.a2aConfigs[i].maxAltitude, self.a2aConfigs[i].airBase, self.a2aConfigs[i].isCap, self.a2aConfigs[i].isGci, self.a2aConfigs[i].grouping, self.a2aConfigs[i].overhead, self.a2aConfigs[i].airCraftLimit)
        Debug:Log("A2AConfigurator:SetController() setting group from config with prefix " .. self.a2aConfigs[i].groupPrefix)
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------------
-- A2AController
-----------------------------------------------------------------------------------------------------------------------------------------------
A2AController = {}

function A2AController:New()
    newObj = 
    {
        A2ADispatcher = nil,
        borderZone = nil
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function A2AController:SetDispatcher(_ewrPrefix, _defaultDetectionRadius, _defaultEngageRadius, _defaultGciRadius, _borderZoneName)
    --EWR SETUP
    local DetectionSetGroup = SET_GROUP:New()
    DetectionSetGroup:FilterPrefixes( { _ewrPrefix } )
    DetectionSetGroup:FilterStart()

    local Detection = DETECTION_AREAS:New( DetectionSetGroup, _defaultDetectionRadius )

    --Dispatcher setup
    if self.A2ADispatcher == nil then 
        self.A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )
    end

    self.A2ADispatcher:SetEngageRadius( tonumber(_defaultEngageRadius) )
    self.A2ADispatcher:SetGciRadius( tonumber(_defaultGciRadius) )

    if _borderZoneName ~= nil or _borderZoneName ~= "" then 
        self.borderZone = ZONE:New(_borderZoneName)
        self.A2ADispatcher:SetBorderZone(ZONE:New(_borderZoneName))
    end
end

function A2AController:StartCapGCI(_groupPrefix, _minAlt, _maxAlt, _airBaseName, _isCap, _isGci, _grouping, _overhead, _limit)
    local squadronName = _groupPrefix .. ":" .. _airBaseName

    self.A2ADispatcher:SetSquadron( squadronName, _airBaseName, { _groupPrefix }, _limit )
    self.A2ADispatcher:SetSquadronTakeoffFromParkingHot( squadronName )
    self.A2ADispatcher:SetSquadronLandingAtEngineShutdown( squadronName )

    if _isGCI == true then 
        self.A2ADispatcher:SetSquadronGci( squadronName, 800, 2000 )
    end

    if _isCap == true and self.borderZone ~= nil then 
        self.A2ADispatcher:SetSquadronCap( squadronName, self.borderZone, _minAlt, _maxAlt, 600, 900, 800, 2000, "RADIO" )
        self.A2ADispatcher:SetSquadronCapInterval( squadronName, 1, 10, 15, 1 )

        self.A2ADispatcher:SetSquadronGrouping(squadronName, _grouping)
        self.A2ADispatcher:SetSquadronOverhead(squadronName, _overhead)

        self.A2ADispatcher:Start()
        Debug:Log("A2AController:StartCapGCI() statring new squadron named " .. squadronName)
    else
        Debug:Log("A2AController:StartCapGCI() patrol/border zone is null")
    end
end
