/obj/item/robot_module/flying/surveyor
	name = "survey drone module"
	display_name = "Surveyor"
	channels = list(
		"Science" = TRUE,
		"Exploration" = TRUE
	)
	networks = list(NETWORK_EXPEDITION)
	sprites = list(
		"Drone"  = "drone-science",
		"Eyebot" = "eyebot-science"
	)
	var/list/flag_types = list(
		/obj/item/stack/flag/yellow,
		/obj/item/stack/flag/green,
		/obj/item/stack/flag/red
	)
	skills = list(
		SKILL_ELECTRICAL          = SKILL_PROF,
		SKILL_ATMOS               = SKILL_PROF,
		SKILL_PILOT               = SKILL_EXPERT,
		SKILL_BOTANY              = SKILL_PROF,
		SKILL_EVA                 = SKILL_PROF,
		SKILL_MECH                = HAS_PERK,
	)

	equipment = list(
		/obj/item/material/hatchet/machete/unbreakable,
		/obj/item/inducer/borg,
		/obj/item/device/scanner/gas,
		/obj/item/storage/plants,
		/obj/item/wirecutters/clippers,
		/obj/item/device/scanner/mining,
		/obj/item/extinguisher,
		/obj/item/gun/launcher/net/borg,
		/obj/item/device/gps,
		/obj/item/weldingtool/largetank,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/device/multitool,
		/obj/item/bioreactor,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/robot_harvester
	)

	emag = /obj/item/melee/energy/machete

/obj/item/robot_module/flying/surveyor/finalize_synths()
	. = ..()
	for(var/flag_type in flag_types)
		equipment += new flag_type(src)

/obj/item/robot_module/flying/surveyor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/gun/launcher/net/borg/gun = locate() in equipment
	if(!gun)
		gun = new(src)
		equipment += gun
	if(LAZYLEN(gun.shells) < gun.max_shells)
		gun.load(new /obj/item/net_shell)

	for(var/flagtype in flag_types)
		var/obj/item/stack/flag/flag = locate(flagtype) in equipment
		if(!flag)
			flag = new flagtype
			equipment += flag
		if(flag.amount < flag.max_amount)
			flag.add(1)
	..()

