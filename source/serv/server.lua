-- Define a custom distance calculation function
function CalculateDistance(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

QBCore.Commands.Add("adrev", "Admin command, revive player.", {{name="target", help="Target player's server id"}}, function(source, args)
    local player = QBCore.Functions.GetPlayer(args[1])

    if not player then
        print("[adrev] Error: Player not found.")
        local adminPlayer = QBCore.Functions.GetPlayer(source)
        adminPlayer.Functions.Notify("Invalid player ID.", "error")
        return
    end

    local targetPlayerId = tonumber(args[1])

    if targetPlayerId then
        local targetPlayer = QBCore.Functions.GetPlayer(targetPlayerId)
        targetPlayer.Functions.Revive()
        TriggerClientEvent("AdminRevivePlayerAtPosition", targetPlayer.PlayerData.source)
        player.Functions.Notify("You have been revived by an admin.", "success")

        local adminPlayer = QBCore.Functions.GetPlayer(source)
        adminPlayer.Functions.Notify("You have revived player " .. targetPlayerId, "success")
    else
        local adminPlayer = QBCore.Functions.GetPlayer(source)
        adminPlayer.Functions.Notify("Invalid player ID.", "error")
    end
end, "admin")

QBCore.Commands.Add("cpr", "Medic command, perform CPR on a player.", {{name="target", help="Target player's server id"}}, function(source, args)
    local player = QBCore.Functions.GetPlayer(source)

    if not player then
        print("[CPR] Error: Character data not found for source player.")
        return player.Functions.Notify("Character data not found.", "error")
    end

    local hasPermission = false
    for _, department in pairs(Config.MedDept) do
        if player.PlayerData.job.name == department then
            hasPermission = true
            break
        end
    end

    if not hasPermission then
        print("[CPR] Error: Player does not have permission to use this command.")
        return player.Functions.Notify("You don't have permission to use this command.", "error")
    end

    local targetPlayerId = tonumber(args[1])

    if not targetPlayerId then
        print("[CPR] Error: Invalid player ID.")
        return player.Functions.Notify("Invalid player ID.", "error")
    end

    local targetPlayer = QBCore.Functions.GetPlayer(targetPlayerId)
    if not targetPlayer then
        print("[CPR] Error: Character data not found for the target player.")
        return player.Functions.Notify("Character data not found for the target player.", "error")
    end

    local maxDistance = 5.0 -- Change this value to your desired maximum distance

    local playerPed = PlayerPedId()

    if not DoesEntityExist(playerPed) then
        print("[CPR] Error: Invalid player entity. PlayerPed is nil.")
        return player.Functions.Notify("Invalid player entity.", "error")
    end

    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayerId))

    if not playerCoords or not targetCoords then
        print("[CPR] Error: Invalid player positions.")
        return player.Functions.Notify("Invalid player positions.", "error")
    end

    local distance = CalculateDistance(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x, targetCoords.y, targetCoords.z)

    print("[CPR] Debug: Distance between players:", distance)

    if distance < maxDistance then
        TriggerClientEvent("startCPRAnimation", source)
        Citizen.Wait(5000)

        local cprMessage = "You have initiated CPR!"
        player.Functions.Notify(cprMessage, "inform")

        TriggerClientEvent("ND_Death:CPR", targetPlayerId)

        local reviveMessage = "You have revived a Player."
        player.Functions.Notify(reviveMessage, "success")
    else
        print("[CPR] Error: Target player is too far away.")
        player.Functions.Notify("Target player is too far away.", "error")
    end
end, "medic")

RegisterServerEvent("ND_Death:AdminRevivePlayerAtPosition")
AddEventHandler("ND_Death:AdminRevivePlayerAtPosition", function(targetPlayerId)
    local targetPlayer = tonumber(targetPlayerId)

    if targetPlayer then
        local targetPlayerPed = GetPlayerPed(targetPlayer)

        if IsEntityDead(targetPlayerPed) then
            TriggerClientEvent("ND_Death:AdminRevivePlayerAtPosition", targetPlayerId) -- Correct event name
            TriggerClientEvent("chatMessage", "^2Server: ^7Player " .. targetPlayer .. " revived by an admin.")
        else
            TriggerClientEvent("chatMessage", "^1Error: ^7Player is not dead.")
        end
    end
end)

RegisterServerEvent("PlayerDownNotification")
AddEventHandler("PlayerDownNotification", function(streetName, crossingRoad)
    local player = QBCore.Functions.GetPlayer(source)
    
    if player then
        local playerJob = player.PlayerData.job.name

        -- Check if the player's job is in MedDept
        for _, job in pairs(Config.MedDept) do
            if playerJob == job then
                -- Include location information in the notification
                local notificationMessage = "Player down at " .. streetName
                if crossingRoad then
                    notificationMessage = notificationMessage .. " and " .. crossingRoad
                end

                -- Send medical notification with location information
                TriggerClientEvent("SendMedicalNotifications", -1, notificationMessage, playerJob)
                break
            end
        end
    end
end)
