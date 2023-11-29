# Stellaris Tweaks

*by Zolana*

# Latest file - zol-stellaris-tweaks-v1.4.2.ps1 - for Stellaris v3.10.2 (Pyxis)

If downloaded from Steam, the file is saved in C:\Users\YOUR USERNAME\Documents\Paradox Interactive\Stellaris\mod\Zolana Stellaris Tweaks\

- This is a collection of small tweaks that you can use to adjust various parameters in your Stellaris games.
- It consists of a PowerShell query - run it and just follow the prompts!
- Pick and choose what tweaks suit your playstyle!

You will need to start a new game for the tweaks to take effect.

You will need to re-run the script whenever the game is updated, or to make changes to your selections!

**NB - Only available on Windows!**

**Not compatible with Achievements, or other mods that edit the relevant sections of the vanilla files (full list below)!**

# v1.4.x New Features:

  - Updated for compatibility with Stellaris v3.10.x (Pyxis)
  - Added option to pick which Precursor spawns (or disable Precursors entirely)
  - Added option to remove diplomacy tradition being a requirement to form a federation
  - Added Dugar system guarantee spawn option
  - Added Larionessi Refuge system guarantee spawn option
  - Added option to significantly reduce influence cost (by around 90%) of espionage operations
  - Bugfix where Ultima Vigilis/Ithome Cluster tweak wasn't working properly
  - Bugfix where disable AI researching habitats tweak wasn't working properly

A full changelog is available on GitHub (/ZolanaPrime/stellaris-small-tweaks/blob/main/changelog.txt)

# Full list of available tweaks:

## Systems:

### Guarantee Spawning:

- Great Wound
- Ithome Cluster
- Larionessi Refuge
- Sanctuary
- Ultima Vigilis
- L Cluster - choose what spawns!
- Select which Precursor spawns (or disable them entirely)

## Events:

### Guarantee Spawning:

- Crystalline Empire
- Horizon Signal
- Great Khan

### Misc:

- Guarantee relic capture after capital invasion
- Guarantee Galatron from Caravaneer loot crates
- End of the Cycle now has an equal chance of appearing
- Guarantee or Disable the War in Heaven
- Disable AI researching habitats
- Reduce influence cost of espionage operations (reduction is around 90%)

## Guardians:

### Guarantee Spawning:

- Automated Dreadnought
- Dimensional Horror
- Enigmatic Fortress
- Ether Drake
- Hive
- Infinity Machine
- Scavenger Bot
- Stellar Devourer
- Voidspawn
- Wraith

### Empire Defaults

- Adjust the base number of envoys each empire starts with (default/vanilla = 2)
- Adjust the base number of megastructures that can be built simultaneously (default/vanilla = 1)

### Federations:

- Remove diplomacy tradition being a requirement to form a federation
- Disable subjects joining automatically on federation creation
    - Can tweak by Federation type

# Instructions

- Download the mod, and run the PowerShell query;
- Follow the prompts on screen;
- Changes will apply to all new games;

**Please ensure that Stellaris is not running while you run the script!**

## Uninstallation

To uninstall, either reverify files on Steam; restore the old files by re-running the script and choosing the restore from backup option (assuming you chose to backup the files initially); or re-run the script and choose all Vanilla options

Please note that you need the relevant DLC for the respective patches that require them.

**This mod is NOT Achievement compatible.**

# Bugs/Feedback

If you find a bug, please file an issue on GitHub - https://github.com/ZolanaPrime/stellaris-small-tweaks/issues - include any error messages, system specs, Stellaris version, DLCs owned, and mods you use.

If there are any events/systems/etc you'd like added to this list - again, please open an issue on GitHub.

### Vanilla files changed:

- 00_actions.txt (\common\diplomatic_actions)
- 00_defines.txt
- 00_eng_tech.txt
- 00_federation_types.txt
- 00_on_actions.txt
- ancient_relics_arcsite_events_1.txt
- ancient_relics_arcsite_events_2.txt
- caravaneer_events.txt
- central_crystal_events.txt
- distant_stars_events_3.txt
- distant_stars_initializers.txt
- fallen_empire_awakening_events.txt
- leviathans_system_initializers.txt
- marauder_events.txt
- operations.txt
- paragon_initializers.txt
- pre_ftl_initializers.txt
- pre_ftl_operations.txt
- precursor_events.txt
- unique_system_initializers.txt
- utopia_shroud_events.txt
