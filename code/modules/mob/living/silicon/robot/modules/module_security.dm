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
		SKILL_COMBAT      = SKILL_EXPERIENCED,
		SKILL_WEAPONS     = SKILL_EXPERIENCED,
		SKILL_FORENSICS   = SKILL_EXPERIENCED,
		SKILL_BUREAUCRACY = SKILL_TRAINED
	)

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
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/gun/energy/plasmacutter,
		/obj/item/borg/combat/shield
	)

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
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/gun/projectile/automatic/l6_saw
	)
	use_map_synth_access = FALSE
	use_all_station_access = TRUE

/obj/item/robot_module/security/combat/Initialize()
	. = ..()
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		R.status_flags &= ~CANWEAKEN // Pre-install the optical matrix shielding
		R.flash_protected = TRUE
