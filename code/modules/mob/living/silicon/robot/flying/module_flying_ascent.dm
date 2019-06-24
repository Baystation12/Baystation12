/obj/item/weapon/robot_module/flying/ascent
	name = "\improper Ascent drone module"
	display_name = "Ascent"
	upgrade_locked = TRUE
	sprites = list(
		"Drone" = "drone-ascent"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/gun/energy/particle/small,
		/obj/item/device/multitool/mantid,
		/obj/item/clustertool,
		/obj/item/weapon/weldingtool/electric,
		/obj/item/weapon/extinguisher,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/device/geiger,
		/obj/item/weapon/gripper,
		/obj/item/weapon/gripper/no_use/loader,
		/obj/item/inducer/borg,
		/obj/item/stack/medical/resin,
		/obj/item/weapon/surgicaldrill,
		/obj/item/weapon/hemostat,
		/obj/item/weapon/bonesetter,
		/obj/item/weapon/circular_saw
	)

/obj/item/weapon/robot_module/flying/ascent/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/stack/medical/resin/resin = locate() in equipment
	if(!resin)
		resin = new(src)
	if(resin.get_amount() < resin.get_max_amount())
		resin.add(1)
	..()