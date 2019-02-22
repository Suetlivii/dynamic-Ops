MissionStateEnum = 
{
    done = "DONE",
    inProgress = "In progress",
    failed = "FAILED"
}

MissionController = {}
function MissionController:New()

    newObj =
    {
        missionBrifString = "",
        missionState = MissionStateEnum.inProgress
    }

    self.__index = self
    return setmetatable(newObj, self)
end

function MissionController:PrintStatus()

    print(self.missionState)

end

missionStateController = MissionController:New()

missionStateController:PrintStatus()