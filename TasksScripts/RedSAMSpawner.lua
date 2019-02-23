--Spawns SAM sites
--
--
local function SpawnSAMs()

    local RedGaliSAMZone = SET_ZONE:New():FilterPrefixes( {"RedGaliSAM"} ):FilterOnce()

    local RedOchamchiraSAMZone = SET_ZONE:New():FilterPrefixes( {"RedOchamchiraSAM"} ):FilterOnce()

    local RedSukhumiSAMZone = SET_ZONE:New():FilterPrefixes( {"RedSukhumiSAM"} ):FilterOnce()

    local RedGudautaSAMZone = SET_ZONE:New():FilterPrefixes( {"RedGudautaSAM"} ):FilterOnce()

    local redSamMed = SET_GROUP:New():FilterPrefixes( {"redSamMed"} ):FilterOnce()

    local redSamLong = SET_GROUP:New():FilterPrefixes( {"redSamLong"} ):FilterOnce()

    local redSamShort = SET_GROUP:New():FilterPrefixes( {"redSamShort"} ):FilterOnce()

    local galiSamSpawn = SPAWN:New( redSamShort:GetRandom():GetName() )
    :SpawnInZone( RedGaliSAMZone:GetRandomZone() )

    local ochamSamSpawn = SPAWN:New( redSamMed:GetRandom():GetName() )
    :SpawnInZone( RedOchamchiraSAMZone:GetRandomZone() )

    local sukhumiSamSpawn = SPAWN:New( redSamMed:GetRandom():GetName() )
    :SpawnInZone( RedSukhumiSAMZone:GetRandomZone() )

    local gudautaSamSpawn = SPAWN:New( redSamLong:GetRandom():GetName() )
    :SpawnInZone( RedGudautaSAMZone:GetRandomZone() )

end

SpawnSAMs()