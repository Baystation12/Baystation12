/obj/item/robot_module/janitor
	name = "janitorial robot module"
	display_name = "Janitor"
	channels = list(
		"Service" = TRUE
	)
	sprites = list(
		"Basic" = "JanBot2",
		"Mopbot"  = "janitorrobot",
		"Mop Gear Rex" = "mopgearrex"
	)
	equipment = list(
		/obj/item/soap,
		/obj/item/storage/bag/trash,
		/obj/item/mop/advanced,
		/obj/item/holosign_creator,
		/obj/item/device/lightreplacer,
		/obj/item/borg/sight/hud/jani,
		/obj/item/device/plunger/robot,
		/obj/item/crowbar,
		/obj/item/weldingtool
	)
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray,
		/obj/item/flamethrower/full/loaded
	)

	var/flamethrower_recharge_modifier = 20

/obj/item/robot_module/janitor/finalize_emag()
	. = ..()

	var/obj/item/reagent_containers/spray/fuel = locate() in equipment
	fuel.reagents.add_reagent(/datum/reagent/fuel, 250)
	fuel.SetName("Fuel spray")

/obj/item/robot_module/janitor/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	if (LR)
		LR.Charge(R, amount)

	if (R.emagged)
		var/obj/item/reagent_containers/spray/S = locate() in equipment
		if (S)
			S.reagents.add_reagent(/datum/reagent/fuel, flamethrower_recharge_modifier * amount)

		var/obj/item/flamethrower/full/loaded/flamethrower = locate() in equipment
		if (flamethrower)
			flamethrower.beaker.reagents.add_reagent(/datum/reagent/napalm, flamethrower_recharge_modifier * amount)
