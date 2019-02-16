local isDebugMode = false

function PrintToDCS(messageString)

    if isDebugMode == true then
    MESSAGE:NewType(messageString, MESSAGE.Type.Information ):ToAll()

    end
end

    
function PrintTableToDCS(tableToPrint)

    for key, val in pairs(tableToPrint) do
        
        messageString = val.nickname .. " " .. val.money .. " " .. val.destroedObjects
        MESSAGE:NewType(messageString , MESSAGE.Type.Information ):ToAll()
     
    end

end