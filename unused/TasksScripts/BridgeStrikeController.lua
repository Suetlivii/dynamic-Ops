--Create east bridge strike mission

taskStrikeEastBidge = TaskController:New()

function taskStrikeEastBidge:StartTask()

    local spawnZones = SET_ZONE:New()
    spawnZones:FilterPrefixes( {"RedBridgeEast"} )
    spawnZones:FilterOnce()

    local targetStatic = SPAWNSTATIC:NewFromStatic( "targetStatic" )
    targetStatic:SpawnFromZone( spawnZones:GetRandomZone(), 0, "bridgeTargetStatic")

    local targetStaticUNIT = STATIC:FindByName( "bridgeTargetStatic" )
    targetStaticUNIT:HandleEvent( EVENTS.Dead )

    self.taskBrif =
    "Destroy bridge"

    local bridgeCoord = targetStaticUNIT:GetCoordinate()
    local markID = bridgeCoord:MarkToCoalitionBlue( "STRIKE: Bridge" )

    function targetStaticUNIT:OnEventDead(EventData)

        --reportManagerBlue:ReportToAll("Bridge Destroyed!")

        self.taskBrif =
        "TASK: Strike\r" ..
        "\r" ..
        "Bridge is destroyed, task completed." 

    end

end

tasksContainerBlue:AddTask(taskStrikeEastBidge)
