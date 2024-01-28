local IsDead, IsEMSNotified, secondsRemaining, isBleedingOut, bleedOutTime, cprInProgress = false, false, 0, false, 0, false
local respawnDelay = Config.respawnTime -- Set the delay in milliseconds
local bleedOutTimer = Config.bleedOutTimer -- Set the bleed-out timer duration in milliseconds (10 seconds)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if secondsRemaining > 0 and IsDead then
            secondsRemaining = secondsRemaining - 1
        end
        if isBleedingOut and GetGameTimer() > bleedOutTime then
            -- Handle what happens when bleed-out timer reaches 0
            ShowRespawnText() -- Show the respawn text
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local health = GetEntityHealth(PlayerPedId())
        IsDead = health < 2

        if IsDead then
            exports.spawnmanager:setAutoSpawn(false)
            ShowRespawnText()

            -- Check if the E key is pressed and the respawn text is displayed
            if IsControlJustReleased(1, 38) and GetGameTimer() > bleedOutTime then
                -- Respawn the player
                RespawnPlayer()
            end

            if not IsEMSNotified then
                -- Get player coordinates
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))

                -- Get street name at player's coordinates
                local streetName, crossingRoad = GetStreetNameAtCoord(x, y, z)

                -- Convert hash to street names
                local streetStr = GetStreetNameFromHashKey(streetName)
                local crossingRoadStr = GetStreetNameFromHashKey(crossingRoad)

                -- Display location information
                print("Player is at " .. streetStr)

                -- Trigger the server event to notify relevant jobs
                TriggerServerEvent("PlayerDownNotification", streetStr, crossingRoadStr)
                IsEMSNotified = true
            end

            if not isBleedingOut then
                -- Start the bleeding-out timer when the player is declared dead
                isBleedingOut = true
                bleedOutTime = GetGameTimer() + bleedOutTimer
            end

            if secondsRemaining > 0 then
                secondsRemaining = secondsRemaining - 1
            end

            DisableControlAction(0, 1, true)  -- LookLeftRight
            DisableControlAction(0, 2, true)  -- LookUpDown

            -- Check if player is down and notify specific jobs
            if not IsEMSNotified then
                TriggerServerEvent("PlayerDownNotification")
                IsEMSNotified = true
                secondsRemaining = Config.respawnTime -- Initialize timer
            end
        else
            IsEMSNotified = false
            ShowRespawnText()

            EnableControlAction(0, 1, false)  -- LookLeftRight
            EnableControlAction(0, 2, true)  -- LookUpDown
        end
    end
end)

function ShowRespawnText()
    local textToShow = ""
    if IsDead then
        if isBleedingOut then
            local timeLeft = math.ceil((bleedOutTime - GetGameTimer()) / 1000)
            textToShow = (timeLeft > 0) and (Config.respawnTextWithTimer):format(timeLeft) or Config.respawnText
        else
            textToShow = (secondsRemaining > 0) and (Config.respawnTextWithTimer):format(secondsRemaining) or Config.respawnText
        end
    end
    DrawCustomText(textToShow, 0.500, 0.900, 0.50, 4)
end

function RespawnPlayer()
    if secondsRemaining <= 0 then
        local respawnLocation = GetClosestRespawnLocation(GetEntityCoords(PlayerPedId()))
        local playerPed = PlayerPedId()

        if respawnLocation then
            IsDead = false
            DoScreenFadeOut(3500)
            Citizen.Wait(5500)

            SetEntityInvincible(playerPed, true)
            SetEntityCollision(playerPed, false, false)
            ClearPedTasksImmediately(playerPed)
            ClearPedSecondaryTask(playerPed)

            SetEntityHealth(playerPed, 100)

            if IsPedRagdoll(playerPed) then
                SetPedToRagdoll(playerPed, 1, 1, 0, 0, 0, 0)
                Wait(10)
            end

            Citizen.Wait(1000)

            SetEntityCoordsNoOffset(playerPed, respawnLocation.x, respawnLocation.y, respawnLocation.z, true, true, true)
            SetEntityHeading(playerPed, respawnLocation.h)

            Citizen.Wait(1000)

            if NetworkIsPlayerActive(PlayerId()) then
                NetworkResurrectLocalPlayer(respawnLocation.x, respawnLocation.y, respawnLocation.z, respawnLocation.h, true, true, false)

                SetEntityInvincible(playerPed, false)
                SetEntityCollision(playerPed, true, true)

                Citizen.Wait(1000)

                DoScreenFadeIn(2500)
                secondsRemaining = Config.respawnTime

                NetworkRequestControlOfEntity(playerPed)
                while not NetworkHasControlOfEntity(playerPed) do
                    Wait(0)
                end
            end
        else
            print("No valid respawn location found.")
        end
    else
        print("Cannot respawn until the bleed out timer reaches 0.")
    end
end

function RespawnInPlace()
    local playerPed = PlayerPedId()

    if IsDead then
        IsDead = false
        DoScreenFadeOut(3500)
        Citizen.Wait(5500)

        SetEntityInvincible(playerPed, true)
        SetEntityCollision(playerPed, false, false)
        ClearPedTasksImmediately(playerPed)
        ClearPedSecondaryTask(playerPed)

        SetEntityHealth(playerPed, 100)

        if IsPedRagdoll(playerPed) then
            SetPedToRagdoll(playerPed, 1, 1, 0, 0, 0, 0)
            Wait(10)
        end

        Citizen.Wait(1000)

        local playerPos = GetEntityCoords(playerPed)

        SetEntityCoordsNoOffset(playerPed, playerPos.x, playerPos.y, playerPos.z, true, true, true)

        Citizen.Wait(1000)

        if NetworkIsPlayerActive(PlayerId()) then
            NetworkResurrectLocalPlayer(playerPos.x, playerPos.y, playerPos.z, GetEntityHeading(playerPed), true, true, false)

            SetEntityInvincible(playerPed, false)
            SetEntityCollision(playerPed, true, true)

            Citizen.Wait(1000)

            DoScreenFadeIn(2500)
            secondsRemaining = Config.respawnTime

            NetworkRequestControlOfEntity(playerPed)
            while not NetworkHasControlOfEntity(playerPed) do
                Wait(0)
            end
        end
    else
        print("Player is not dead.")
    end
end

function GetClosestRespawnLocation(playerCoords)
    local closestLocation, closestDistance = nil, math.huge

    for _, respawnLocation in pairs(Config.respawnLocations) do
        local distance = #(vector3(respawnLocation.x, respawnLocation.y, respawnLocation.z) - playerCoords)
        if distance < closestDistance then
            closestDistance = distance
            closestLocation = respawnLocation
        end
    end

    return closestLocation
end

function RespawnPlayerAtDownedPosition()
    local playerPos = GetEntityCoords(PlayerPedId())
    local respawnHeading = Config.respawnHeading
    local playerPed = PlayerPedId()
    IsDead = false
    DoScreenFadeOut(1500)
    Citizen.Wait(1500)
    NetworkResurrectLocalPlayer(playerPos.x, playerPos.y, playerPos.z, respawnHeading, true, true, false)
    SetEntityHeading(playerPed, respawnHeading)
    SetPlayerInvincible(playerPed, false)
    ClearPedBloodDamage(playerPed)
    DoScreenFadeIn(1500)
    secondsRemaining = Config.respawnTime
end



function DrawCustomText(text, x, y, scale, font)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextJustification(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent("ND_Death:CPR")
AddEventHandler("ND_Death:CPR", function()
    if IsEntityDead(PlayerPedId()) then
        RespawnInPlace()
    end
end)

RegisterNetEvent("ND_Death:AdminRevivePlayerAtPosition")
AddEventHandler("ND_Death:AdminRevivePlayerAtPosition", function()
    if IsEntityDead(PlayerPedId()) then
        RespawnInPlace()
    end
end)

RegisterNetEvent("startCPRAnimation")
AddEventHandler("startCPRAnimation", function()
    if cprInProgress then
        return
    end

    local playerPed = PlayerPedId()
    cprInProgress = true
    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
    Citizen.Wait(10000)
    ClearPedTasks(playerPed)
    cprInProgress = false
end)

RegisterNetEvent("SendMedicalNotifications")
AddEventHandler("SendMedicalNotifications", function(message)
    local notificationData = Config.notificationSettings
    notificationData.description = message  -- Set the message content dynamically
    lib.notify(notificationData)
end)
