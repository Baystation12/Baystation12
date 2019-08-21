/obj/item/weapon/robot_module/syndicate
	name = "illegal robot module"
	display_name = "Illegal"
	hide_on_manifest = 1
	upgrade_locked = TRUE
	sprites = list(
		"Dread" = "securityrobot"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/gun/energy/pulse_rifle/destroyer,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/card/emag,
		/obj/item/weapon/tank/jetpack/carbondioxide
	)
	var/id

/obj/item/weapon/robot_module/syndicate/Initialize()
	for(var/decl/hierarchy/skill/skill in GLOB.skills)
		skills[skill.type] = SKILL_EXPERT
	. = ..()

/obj/item/weapon/robot_module/syndicate/build_equipment(var/mob/living/silicon/robot/R)
	. = ..()
	id = R.idcard
	equipment += id

/obj/item/weapon/robot_module/syndicate/finalize_equipment(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/tank/jetpack/carbondioxide/jetpack = locate() in equipment
	R.internals = jetpack
	. = ..()

/obj/item/weapon/robot_module/syndicate/Destroy()
	equipment -= id
	id = null
	. = ..()
