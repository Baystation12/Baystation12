/datum/codex_entry/maint_drone
	display_name = "maintenance drone"
	associated_paths = list(/mob/living/silicon/robot/drone)
	mechanics_text = "Drones are player-controlled synthetics which are lawed to maintain their assigned vessel and not \
	interfere with anyone else, except for other drones. They hold a wide array of tools to build, repair, maintain, and clean. \
	They function similarly to other synthetics, in that they require recharging regularly, have laws, and are resilient to many hazards, \
	such as fire, radiation, vacuum, and more. Ghosts can join the round as a maintenance drone by using the appropriate verb in the 'ghost' tab. \
	An inactive drone can be rebooted by swiping an ID card on it with engineering or robotics access, and an active drone can be shut down in the same manner. \
	Maintenance drone presence can be requested to specific areas from any maintenance drone control console."
	antag_text = "A cryptographic sequencer, available via a traitor uplink, can be used to subvert the drone to your cause."

/datum/codex_entry/uncertified_module
	associated_paths = list(/obj/item/borg/upgrade/uncertified)
	mechanics_text = "This special chip will forcibly change a robot's module to a new one. In most cases, this is the only way for the robot to obtain these modules. Once you've unlocked the robot's maintenance hatch with an ID card and opened it with a crowbar, click the bot to install this chip."
	lore_text = "No TSC, industrial concern, or military organization worth their salt would dare install uncertified hardware on their robotic platforms. Nevertheless, in backwater sectors of the universe, there is a thriving grey market for third-party modular configurations such as this one."
