# Stoic-Death
![STOIC (8)](https://github.com/TheStoicBear/Stoic-Death/assets/112611821/f4396db4-7420-44c2-808e-8056392285d5)


## Stoic-Death: Embracing Mortality with Stoic Resilience

### Features

- **Mortal Reflection**: When a player's health diminishes to a critical level, they confront the reality of mortality, entering a downed state, where a timer awaits their decision for rebirth.
- **Automatic EMS Invocation**: Elect the automatic invocation of EMS when a player descends into vulnerability, embracing the stoic virtue of communal support during trials.
- **CPR Contemplation**: Initiating a CPR animation becomes a ritualistic act of compassion, urging players to contemplate the fragility of life and the bonds that bind them.
- **Admin Revival Decree**: Admins, embodying the guardians of order, possess the power to decree instant revival upon players using their sacred player ID.
- **CPR Invocation**: Medical adepts, custodians of healing, can invoke CPR rituals upon players, offering them a chance to transcend mortal confines.
- **Customizable Rebirth Interval**: Configure the temporal threshold of resurrection, allowing players a moment of reflection before they embrace renewal.
- **Customizable Mortal Reflection Text**: Tailor the words that accompany the moment of vulnerability, echoing stoic wisdom in the face of adversity.
- **Integration with ND_Core**: Harmoniously integrates with the ND_Core framework, enriching the gaming experience with stoic resilience and communal ethos.

### Commands of Contemplation

- `/adrev [targetPlayerId]`: Admins, entrusted with the guardianship of the realm, decree instantaneous revival upon players. Channel the divine authority by replacing `[targetPlayerId]` with the player's sacred identifier.
  
- `/cpr [targetPlayerId]`: Medical custodians, emissaries of healing, initiate CPR rituals, offering a path to transcendence for the fallen. Utter the invocation by replacing `[targetPlayerId]` with the player's mortal designation.

### Ritual Configurations

The essence of stoic contemplation permeates through the configuration file (`config.lua`). Configure the following to shape the journey:

- `respawnText`: Define the message displayed when a player needs to respawn.
- `respawnTextWithTimer`: Customize the message displayed when a respawn timer is active.
- `sosText`: Specify the text guiding players to call EMS.
- `respawnKey`: Set the keybind for respawning the player.
- `respawnTime`: Determine the time in seconds that players have to respawn.
- `bleedOutTimer`: Set the time in milliseconds for the player's bleed out duration before respawn.
- `payRespawn`: Define the cost for respawning.
- `DeptCheck`: Enable or disable departmental checks.
- `blipDuration`: Set the duration of the EMS blip on the map.
- `CRPDist`: Set the distance for CPR invocation.
- `BlackoutTime`: Set the blackout time.
- `EffectTimeLevel1` to `EffectTimeLevel5`: Define the effect time for different blackout levels.
- `BlackoutDamageRequiredLevel1` to `BlackoutDamageRequiredLevel5`: Set the blackout damage required for different levels.
- `BlackoutSpeedRequiredLevel1` to `BlackoutSpeedRequiredLevel5`: Define the blackout speed required for different levels.
- `DisableControlsOnBlackout`: Enable or disable control disabling during blackout.
- `TimeLeftToEnableControls`: Set the time left to enable controls during blackout.
- `ScreenShakeMultiplier`: Set the multiplier of screen shaking strength.
- `MedDept`: Define the list of job departments considered part of the medical team.
- `respawnLocations`: Define a list of possible respawn locations with coordinates and heading.
- `notificationSettings`: Customize EMS notification settings.

### Dependencies

- [ND_Core](https://github.com/ND-Framework/ND-Core): ND_Core provides essential functionalities for seamless integration.
- [ND_Characters](https://github.com/ND-Framework/ND_Characters): ND_Characters provides essential functionalities for Job Notifications and Admin Permissions.

### Installation

1. Ensure you have the required dependencies installed.
2. Copy the contents of this repository into your server's resources folder.
3. Configure the script by modifying the `config.lua` file.
4. Add `ensure Stoic-Death` to your `server.cfg`. **Make sure you start it after ND_Core and ND_Characters.**

### Authors
- [TheStoicBear](https://github.com/TheStoicBear)








Creds to `daZepelin` for accident effects.
