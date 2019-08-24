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
--         airCraftLimit = 8,
--         minCapTime = 600,
--         maxCapTime = 800,
--         minFrontlineDistance = 15000,
--         maxFrontlineDistance = 40000,
--         airStart = false
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
        self.A2AController:StartCapGCI(self.a2aConfigs[i].groupPrefix, self.a2aConfigs[i].minAltitude, self.a2aConfigs[i].maxAltitude, self.a2aConfigs[i].airBase, self.a2aConfigs[i].isCap, self.a2aConfigs[i].isGci, self.a2aConfigs[i].grouping, self.a2aConfigs[i].overhead, self.a2aConfigs[i].airCraftLimit, self.a2aConfigs[i].minCapTime, self.a2aConfigs[i].maxCapTime, self.a2aConfigs[i].minFrontlineDistance, self.a2aConfigs[i].maxFrontlineDistance, self.a2aConfigs[i].airStart)
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
        borderZone = nil,
        bluePatrolZone = nil,
        redPatrolZone = nil,
        frontlineAnchorZoneName = nil,
        currentFrontlineDistance = nil
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function A2AController:SetFrontlineAnchor(_frontlineAnchorZoneName)
    if ZONE:FindByName(_frontlineAnchorZoneName) ~= nil then 
        self.frontlineAnchorZoneName = _frontlineAnchorZoneName
    end
end

function A2AController:SetFrontlineDistance(_currentFrontlineDistance)
    if _currentFrontlineDistance ~= nil or _currentFrontlineDistance ~= 0 then 
        self.currentFrontlineDistance = _currentFrontlineDistance
    end
end

function A2AController:SetDispatcher(_ewrPrefix, _defaultDetectionRadius, _defaultEngageRadius, _defaultGciRadius, _borderZone, _redPatrolZone, _bluePatrolZone)
    --EWR SETUP
    local DetectionSetGroup = SET_GROUP:New()
    DetectionSetGroup:FilterPrefixes( { _ewrPrefix } )
    DetectionSetGroup:FilterStart()

    local Detection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

    --Dispatcher setup
    if self.A2ADispatcher == nil then 
        self.A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )
    end

    self.A2ADispatcher:SetEngageRadius( 120000 )
    self.A2ADispatcher:SetGciRadius( tonumber(_defaultGciRadius) )

    if _borderZone ~= nil then 
        self.borderZone = _borderZone
        --self.A2ADispatcher:SetBorderZone(ZONE:New(_borderZoneName))
    end

    if _redPatrolZone ~= nil then 
        self.redPatrolZone = _redPatrolZone
        --self.A2ADispatcher:SetBorderZone(ZONE:New(_borderZoneName))
    end

    if _bluePatrolZone ~= nil then 
        self.bluePatrolZone = _bluePatrolZone
        --self.A2ADispatcher:SetBorderZone(ZONE:New(_borderZoneName))
    end
end

function A2AController:CheckAirbaseDistanceFromFrontline(_airBaseName, squadronName, _minFrontline, _maxFrontline)
    if self.frontlineAnchorZoneName ~= nil and (self.currentFrontlineDistance ~= nil or self.currentFrontlineDistance ~= 0) then 
        local anchorCoord = ZONE:FindByName(self.frontlineAnchorZoneName):GetPointVec2()

        local distanceFromAnchor = AIRBASE:FindByName(_airBaseName):GetPointVec2():Get2DDistance(anchorCoord)

        if _minFrontline ~= nil then 
            if distanceFromAnchor <= self.currentFrontlineDistance and distanceFromAnchor >= self.currentFrontlineDistance - _minFrontline then 
                Debug:Log("A2AController:CheckAirbaseDistanceFromFrontline() cap is skipped because too close to frontline, squadrone name is " .. squadronName)
                return false 
            end
        end

        if _minFrontline ~= nil then 
            if distanceFromAnchor >= self.currentFrontlineDistance and distanceFromAnchor <= self.currentFrontlineDistance + _minFrontline then 
                Debug:Log("A2AController:CheckAirbaseDistanceFromFrontline() cap is skipped because too close to frontline, squadrone name is " .. squadronName)
                return false 
            end
        end

        if _maxFrontline ~= nil then 
            if distanceFromAnchor <= self.currentFrontlineDistance and distanceFromAnchor <= self.currentFrontlineDistance - _maxFrontline then 
                Debug:Log("A2AController:CheckAirbaseDistanceFromFrontline() cap is skipped because too far from frontline, squadrone name is " .. squadronName)
                return false 
            end
        end

        if _maxFrontline ~= nil then 
            if distanceFromAnchor >= self.currentFrontlineDistance and distanceFromAnchor >= self.currentFrontlineDistance + _maxFrontline then 
                Debug:Log("A2AController:CheckAirbaseDistanceFromFrontline() cap is skipped because too far from frontline, squadrone name is " .. squadronName)
                return false 
            end
        end

        Debug:Log("A2AController:CheckAirbaseDistanceFromFrontline() no restrictions for airbase distance for squadron " .. squadronName)
        return true

    else
        Debug:Log("A2AController:CheckAirbaseDistanceFromFrontline() no settings for airbase distance for squadron " .. squadronName)
        return true
    end
end

function A2AController:StartCapGCI(_groupPrefix, _minAlt, _maxAlt, _airBaseName, _isCap, _isGci, _grouping, _overhead, _limit, _minCapTime, _maxCapTime, _minFrontline, _maxFrontline, _airStart)
    local squadronName = _groupPrefix .. ":" .. _airBaseName

    if AIRBASE:FindByName(_airBaseName):GetCoalition() ~= GROUP:FindByName(_groupPrefix):GetCoalition() then 
        Debug:Log("A2AController:StartCapGCI() coalition of airbase does not match group coalition, group prefix: " .. _groupPrefix)
        return nil
    end

    self.A2ADispatcher:SetSquadron( squadronName, _airBaseName, { _groupPrefix }, _limit )
    if _airStart == true then 
        Debug:Log("A2AController:StartCapGCI() setting air start for squadron " .. squadronName)
        self.A2ADispatcher:SetSquadronTakeoffInAir( squadronName, 5000)
        self.A2ADispatcher:SetSquadronLandingNearAirbase( squadronName )
    else
        self.A2ADispatcher:SetSquadronTakeoffFromParkingHot( squadronName )
        self.A2ADispatcher:SetSquadronLandingAtEngineShutdown( squadronName )
    end

    if _isGci == true then 
        self.A2ADispatcher:SetSquadronGci( squadronName, 800, 2000 )

        self.A2ADispatcher:SetSquadronGrouping(squadronName, _grouping)
        self.A2ADispatcher:SetSquadronOverhead(squadronName, _overhead)
    end

    if _isCap == true then 

        if self.frontlineAnchorZoneName ~= nil or self.currentFrontlineDistance ~= nil then 
            local airbaseCheck = self:CheckAirbaseDistanceFromFrontline(_airBaseName, squadronName, _minFrontline, _maxFrontline)
            Debug:Log("A2AController:StartCapGCI() airbase check is " .. tostring(airbaseCheck))
            if airbaseCheck ~= true then 
                return nil
            end
        end

        if GROUP:FindByName(_groupPrefix):GetCoalition() == 1 then 
            self.A2ADispatcher:SetSquadronCap( squadronName, self.redPatrolZone, _minAlt, _maxAlt, 600, 900, 800, 2000, "RADIO" )
        end

        if GROUP:FindByName(_groupPrefix):GetCoalition() == 2 then 
            self.A2ADispatcher:SetSquadronCap( squadronName, self.bluePatrolZone, _minAlt, _maxAlt, 600, 900, 800, 2000, "RADIO" )
        end

        

        if _minCapTime ~= nil and _maxCapTime ~= nil then 
            self.A2ADispatcher:SetSquadronCapInterval( squadronName, 1, _minCapTime, _maxCapTime, 1 )
        else
            self.A2ADispatcher:SetSquadronCapInterval( squadronName, 1, 600, 800, 1 )
        end

        self.A2ADispatcher:SetSquadronGrouping(squadronName, _grouping)
        self.A2ADispatcher:SetSquadronOverhead(squadronName, _overhead)

        Debug:Log("A2AController:StartCapGCI() statring new squadron for CAP named " .. squadronName)
    else
        --Debug:Log("A2AController:StartCapGCI() patrol/border zone is null")
    end
end

function A2AController:StartA2A()
    self.A2ADispatcher:Start()
end
