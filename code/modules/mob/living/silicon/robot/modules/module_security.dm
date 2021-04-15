/obj/item/robot_module/security
	channels = list(
		"Security" = TRUE
	)
	networks = list(
		NETWORK_SECURITY
	)
	subsystems = list(
		/datum/nano_module/crew_monitor,
		/datum/nano_module/program/digitalwarrant
	)
	can_be_pushed = FALSE
	supported_upgrades = list(
		/obj/item/borg/upgrade/weaponcooler
	)
	skills = list(
		SKILL_COMBAT      = SKILL_EXPERT,
		SKILL_WEAPONS     = SKILL_EXPERT,
		SKILL_FORENSICS   = SKILL_EXPERT,
		SKILL_BUREAUCRACY = SKILL_ADEPT
	)

/obj/item/robot_module/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	for(var/obj/item/gun/energy/T in equipment)
		if(T && T.power_supply)
			if(T.power_supply.charge < T.power_supply.maxcharge)
				T.power_supply.give(T.charge_cost * amount)
				T.update_icon()
			else
				T.charge_tick = 0
	var/obj/item/melee/baton/robot/B = locate() in equipment
	if(B && B.bcell)
		B.bcell.give(amount)

/obj/item/robot_module/security/general
	name = "security robot module"
	display_name = "Security"
	crisis_locked = TRUE
	sprites = list(
		"Basic" = "secborg",
		"Red Knight" = "Security",
		"Black Knight" = "securityrobot",
		"Bloodhound" = "bloodhound",
		"Bloodhound - Treaded" = "secborg+tread",
		"Tridroid" = "orb-security"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/hud/sec,
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/robot,
		/obj/item/gun/energy/gun/secure/mounted,
		/obj/item/taperoll/police,
		/obj/item/device/megaphone,
		/obj/item/device/holowarrant,
		/obj/item/crowbar,
		/obj/item/device/hailer
	)
	emag = /obj/item/gun/energy/laser/mounted

/obj/item/robot_module/security/combat
	name = "combat robot module"
	display_name = "Combat"
	crisis_locked = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Combat Android" = "droid-combat"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/thermal,
		/obj/item/gun/energy/laser/mounted,
		/obj/item/gun/energy/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
		/obj/item/crowbar
	)
	emag = /obj/item/gun/energy/lasercannon/mounted

/obj/item/robot_module/security/combat/Initialize()
	. = ..()
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		R.status_flags &= ~CANWEAKEN // Pre-install the optical matrix shielding
		R.flash_protected = TRUE
