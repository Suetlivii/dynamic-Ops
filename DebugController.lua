isDebugMode = true

DebugController = {}
function DebugController:New(_isDebugMose)
    newObj =
    {
        debugMode = _isDebugMose
    }

    self.__index = self
    return setmetatable(newObj, self)
end

function DebugController:PrintToDCS(msg)

    if self.debugMode == true then
    MESSAGE:NewType(tostring(msg), MESSAGE.Type.Information ):ToAll()
    end

end

debugController = DebugController:New(isDebugMode)
debugController:PrintToDCS("Debug Controller Initialized")
