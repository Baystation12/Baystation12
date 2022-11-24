/obj/item/robot_module/syndicate
	name = "illegal robot module"
	display_name = "Illegal"
	hide_on_manifest = 1
	upgrade_locked = TRUE
	sprites = list(
		"Dread" = "securityrobot"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/melee/energy/sword,
		/obj/item/gun/energy/pulse_rifle/destroyer,
		/obj/item/crowbar,
		/obj/item/card/emag,
		/obj/item/tank/jetpack/carbondioxide
	)
	var/id

/obj/item/robot_module/syndicate/Initialize()
	for (var/path in GLOB.skills.skills_by_path)
		skills[path] = SKILL_EXPERT
	. = ..()

/obj/item/robot_module/syndicate/build_equipment(mob/living/silicon/robot/R)
	. = ..()
	id = R.idcard
	equipment += id

/obj/item/robot_module/syndicate/finalize_equipment(mob/living/silicon/robot/R)
	var/obj/item/tank/jetpack/carbondioxide/jetpack = locate() in equipment
	R.internals = jetpack
	. = ..()

/obj/item/robot_module/syndicate/Destroy()
	equipment -= id
	id = null
	. = ..()
