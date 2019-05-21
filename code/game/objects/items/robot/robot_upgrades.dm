// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "robot upgrade module"
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	var/locked = 0
	var/require_module = 0
	var/installed = 0

/obj/item/borg/upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, "<span class='warning'>The [src] will not function on a deceased robot.</span>")
		return 1
	return 0


/obj/item/borg/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	require_module = 1

/obj/item/borg/upgrade/reset/action(var/mob/living/silicon/robot/R)
	if((. = ..())) return 0

	R.reset_module()
	return 1

/obj/item/borg/upgrade/uncertified
	name = "uncertified robotic module"
	desc = "You shouldn't be seeing this!"
	icon_state = "cyborg_upgrade5"
	require_module = 0
	var/new_module = null

/obj/item/borg/upgrade/uncertified/action(var/mob/living/silicon/robot/R)
	if((. = ..())) return 0
	if(!new_module)
		to_chat(usr, "<span class='warning'>[R]'s error lights strobe repeatedly - something seems to be wrong with the chip.</span>")
		return 0

	// Suppress the alert so the AI doesn't see a reset message.
	R.reset_module(TRUE)
	R.pick_module(new_module)
	return 1

/obj/item/borg/upgrade/uncertified/party
	name = "\improper Madhouse Productions Official Party Module"
	desc = "A weird-looking chip with third-party additions crudely soldered in. It feels cheap and chintzy in the hand. Inscribed into the cheap-feeling circuit is the logo of Madhouse Productions, a group that arranges parties and entertainment venues."
	new_module = "Party"

/obj/item/borg/upgrade/uncertified/combat
	name = "ancient module"
	desc = "A well-made but somewhat archaic looking bit of circuitry. The chip is stamped with an insignia: a gun protruding from a stylized fist."
	new_module = "Combat"

/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user as mob)
	heldname = sanitizeSafe(input(user, "Enter new robot name", "Robot Reclassification", heldname), MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.SetName(heldname)
	R.custom_name = heldname
	R.real_name = heldname

	return 1

/obj/item/borg/upgrade/floodlight
	name = "robot floodlight module"
	desc = "Used to boost cyborg's light intensity."
	icon_state = "cyborg_upgrade1"

/obj/item/borg/upgrade/floodlight/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.intenselight)
		to_chat(usr, "This cyborg's light was already upgraded")
		return 0
	else
		R.intenselight = 1
		R.update_robot_light()
		to_chat(R, "Lighting systems upgrade detected.")
	return 1

/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"


/obj/item/borg/upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return 0

	if(!R.key)
		for(var/mob/observer/ghost/ghost in GLOB.player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.set_stat(CONSCIOUS)
	R.switch_from_dead_to_living_mob_list()
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return 1


/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	require_module = 1

/obj/item/borg/upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.vtec == TRUE)
		return FALSE

	R.speed--
	R.vtec = TRUE
	return TRUE


/obj/item/borg/upgrade/weaponcooler
	name = "robotic Rapid Weapon Cooling Module"
	desc = "Used to cool a mounted energy gun, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	require_module = 1


/obj/item/borg/upgrade/weaponcooler/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

	var/obj/item/weapon/gun/energy/gun/secure/mounted/T = locate() in R.module
	if(!T)
		T = locate() in R.module.equipment
	if(!T)
		to_chat(usr, "This robot has had its energy gun removed!")
		return 0

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return 0

	else
		T.recharge_time = max(2 , T.recharge_time - 4)

	return 1

/obj/item/borg/upgrade/jetpack
	name = "mining robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	else
		R.module.equipment += new/obj/item/weapon/tank/jetpack/carbondioxide
		for(var/obj/item/weapon/tank/jetpack/carbondioxide in R.module.equipment)
			R.internals = src
		//R.icon_state="Miner+j"
		return 1

/obj/item/borg/upgrade/rcd
	name = "engineering robot RCD"
	desc = "A rapid construction device module for use during construction operations."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/rcd/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	else
		R.module.equipment += new/obj/item/weapon/rcd/borg(R.module)
		return 1

/obj/item/borg/upgrade/syndicate/
	name = "illegal equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/syndicate/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.emagged == 1)
		return 0

	R.emagged = 1
	return 1
