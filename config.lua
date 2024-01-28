-- Configuration settings
Config = {
    respawnText = "You are dead, press ~c~[E]~w~ to respawn.",
    respawnTextWithTimer = "You are dead, you can respawn in ~c~%d~w~ seconds.", -- MIA
	sosText = "Type /911 to call EMS",
    respawnKey = 38,
    respawnTime = 5,
    bleedOutTimer = 10000,
    payRespawn = 100,
    DeptCheck = true,
    blipDuration = 30000,
    CRPDist = 50,
    BlackoutTime = 1000,
    EffectTimeLevel1 = 8,
    EffectTimeLevel2 = 13,
    EffectTimeLevel3 = 19,
    EffectTimeLevel4 = 25,
    EffectTimeLevel5 = 33,
    BlackoutDamageRequiredLevel1 = 15,    -- If a vehicle suffers an impact greater than the specified value, the player blacks out
    BlackoutDamageRequiredLevel2 = 25,
    BlackoutDamageRequiredLevel3 = 45,
    BlackoutDamageRequiredLevel4 = 65,
    BlackoutDamageRequiredLevel5 = 300,  
    BlackoutSpeedRequiredLevel1 = 20, -- Speed in MPH -- If a vehicle slows down rapidly over this threshold, the player blacks out
    BlackoutSpeedRequiredLevel2 = 45,
    BlackoutSpeedRequiredLevel3 = 65,
    BlackoutSpeedRequiredLevel4 = 95,
    BlackoutSpeedRequiredLevel5 = 130,
    DisableControlsOnBlackout = true,-- Enable the disabling of controls if the player is blacked out
    TimeLeftToEnableControls = 10,
    ScreenShakeMultiplier = 0.1,-- Multiplier of screen shaking strength

    MedDept = {
        "lscso",
        "sasp",
        "safr",
        "doa"
    },
    respawnLocations = {
        { x = 298.29, y = -584.26, z = 43.26, h = 61.98 }, -- 1 
        { x = 1776.99, y = 3635.375, z = 34.66, h = 238.61 }, -- 2
        { x = -253.25, y = 6298.79, z = 31.45, h = 226.77 }, -- 3
        { x = 295.35, y = -1446.87, z = 29.95, h = 323.15 }, -- 4
        { x = 1152.15, y = -1527.49, z = 34.84, h = 328.82 },  -- 5
        { x = 360.87, y = -584.33, z = 28.82, h = 235.28 }, -- 6
        { x = -449.39, y = -341.50, z = 34.49, h = 68.03 } -- 7
    },
    notificationSettings = {
        id = "unique_id",  -- Set a unique ID to show the notification only once
        title = "EMS Call",  -- Provide a title
        duration = 8500,  -- Set the duration of the notification
        position = 'top',  -- Set the position of the notification
        type = 'inform',  -- Set the type of notification (inform, error, success, warning)
        style = { backgroundColor = 'rgba(32, 32, 32, 1)' },  -- Set custom styling using React CSS format
        icon = "fas fa-ambulance",  -- Set the Font Awesome 6 icon
        iconColor = '#ff8d00',  -- Set the color of the icon
        iconAnimation = 'fade',  -- Set the icon animation
        alignIcon = 'center'  -- Align the icon to the top
    }
    -- Ace Permissions
    -- Use cx.adrev to allow a group to use Admin Revive.
    -- Use cx.cpr to allow a group to use CPR To revive in spot.
}



