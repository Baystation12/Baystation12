/obj/item/weapon/robot_module/flying/ascent
	name = "\improper Ascent drone module"
	display_name = "Ascent"
	upgrade_locked = TRUE
	sprites = list(
		"Drone" = "drone-ascent"
	)
	equipment = list(
		/obj/item/device/flash,

		// Uncomment post-merge.
		//obj/item/weapon/gun/energy/particle/small,
		//obj/item/clustertool,
		/obj/item/device/multitool, //mantid,

		// Placeholders.
		/obj/item/weapon/extinguisher,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wrench,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/wirecutters,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/device/geiger,
		/obj/item/weapon/gripper,
		/obj/item/weapon/gripper/no_use/loader,
		/obj/item/inducer/borg,
		/obj/item/weapon/weldingtool/electric,
		// End placeholders.

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