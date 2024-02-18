-- Define a custom distance calculation function
function CalculateDistance(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

lib.addCommand("adrev", {
    help = "Admin command, revive player.",
    restricted = "group.admin",
    params = {
        {
            name = "target",
            type = "playerId",
            help = "Target player's server id"
        }
    }
}, function(source, args, raw)
    local player = NDCore.getPlayer(args.target)

    if not player then
        print("[adrev] Error: Player not found.")
        local adminPlayer = NDCore.getPlayer(source)
        adminPlayer.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Invalid player ID.",
            type = "error",
            duration = 5000
        })
        return
    end

    local targetPlayerId = tonumber(args.target)

    if targetPlayerId then
        local targetPlayerId = NDCore.getPlayer(targetPlayerId)
        targetPlayerId.revive()
        TriggerClientEvent("AdminRevivePlayerAtPosition", targetPlayerId)
        player.notify({
            title = "Admin Action",
            position = 'top',  -- Set the position of the notification
            description = "You have been revived by an admin.",
            type = "success",
            duration = 5000
        })

        local adminPlayer = NDCore.getPlayer(source)
        adminPlayer.notify({
            title = "Admin Action",
            position = 'top',  -- Set the position of the notification
            description = "You have revived player " .. targetPlayerId,
            type = "success",
            duration = 5000
        })
    else
        local adminPlayer = NDCore.getPlayer(source)
        adminPlayer.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Invalid player ID.",
            type = "error",
            duration = 5000
        })
    end
end)

lib.addCommand("cpr", {
    help = "Medic command, perform CPR on a player.",
    restricted = "medic", -- Change to the appropriate group or remove for no restriction
    params = {
        {
            name = "target",
            type = "playerId",
            help = "Target player's server id"
        }
    }
}, function(source, args, raw)
    local player = NDCore.getPlayer(source)

    if not player then
        print("[CPR] Error: Character data not found for source player.")
        return player.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Character data not found.",
            type = "error",
            duration = 5000
        })
    end

    local hasPermission = false
    for _, department in pairs(Config.MedDept) do
        if player.job == department then
            hasPermission = true
            break
        end
    end

    if not hasPermission then
        print("[CPR] Error: Player does not have permission to use this command.")
        return player.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "You don't have permission to use this command.",
            type = "error",
            duration = 5000
        })
    end

    local targetPlayerId = tonumber(args.target)

    if not targetPlayerId then
        print("[CPR] Error: Invalid player ID.")
        return player.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Invalid player ID.",
            type = "error",
            duration = 5000
        })
    end

    local targetPlayer = NDCore.getPlayer(targetPlayerId)
    if not targetPlayer then
        print("[CPR] Error: Character data not found for the target player.")
        return player.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Character data not found for the target player.",
            type = "error",
            duration = 5000
        })
    end

    local maxDistance = 5.0 -- Change this value to your desired maximum distance

    local playerPed = GetPlayerPed(source)

    if not DoesEntityExist(playerPed) then
        print("[CPR] Error: Invalid player entity. PlayerPed is nil.")
        return player.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Invalid player entity.",
            type = "error",
            duration = 5000
        })
    end

    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayerId))

    if not playerCoords or not targetCoords then
        print("[CPR] Error: Invalid player positions.")
        return player.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Invalid player positions.",
            type = "error",
            duration = 5000
        })
    end

    local distance = #(playerCoords - targetCoords)

    print("[CPR] Debug: Distance between players:", distance)

    if distance < maxDistance then
        TriggerClientEvent("startCPRAnimation", source)
        Citizen.Wait(5000)

        local cprMessage = "You have initiated CPR!"
        player.notify({
            title = "Medical Action",
            position = 'top',  -- Set the position of the notification
            description = cprMessage,
            type = "inform",
            duration = 5000
        })

        TriggerClientEvent("ND_Death:CPR", targetPlayerId)
        local targetPlayer = NDCore.getPlayer(targetPlayerId)
        targetPlayerId.revive()
        local reviveMessage = "You have revived a Player."
        player.notify({
            title = "Medical Action",
            position = 'top',  -- Set the position of the notification
            description = reviveMessage,
            type = "success",
            duration = 5000
        })
    else
        print("[CPR] Error: Target player is too far away.")
        player.notify({
            title = "Error",
            position = 'top',  -- Set the position of the notification
            description = "Target player is too far away.",
            type = "error",
            duration = 5000
        })
    end
end)

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
    local player = NDCore.getPlayer(source)
    
    if player then
        local playerJob = player.job

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
