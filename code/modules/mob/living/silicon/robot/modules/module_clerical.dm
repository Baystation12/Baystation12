/obj/item/weapon/robot_module/clerical
	channels = list(
		"Service" = TRUE
	)
	languages = list(
		LANGUAGE_SOL_COMMON  = TRUE,
		LANGUAGE_UNATHI      = TRUE,
		LANGUAGE_SKRELLIAN   = TRUE,
		LANGUAGE_LUNAR       = TRUE,
		LANGUAGE_GUTTER      = TRUE,
		LANGUAGE_INDEPENDENT = TRUE,
		LANGUAGE_SPACER      = TRUE
	)

/obj/item/weapon/robot_module/clerical/butler
	name = "service robot module"
	display_name = "Service"
	sprites = list(
		"Waitress" = "Service",
		"Kent" = "toiletbot",
		"Bro" = "Brobot",
		"Rich" = "maximillion",
		"Default" = "Service2",
		"Drone - Service" = "drone-service",
		"Drone - Hydro" = "drone-hydro",
		"Doot" = "eyebot-standard"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/gripper/service,
		/obj/item/weapon/reagent_containers/glass/bucket,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/hatchet,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/weapon/storage/plants,
		/obj/item/weapon/robot_harvester,
		/obj/item/weapon/material/kitchen/rollingpin,
		/obj/item/weapon/material/knife/kitchen,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/rsf,
		/obj/item/weapon/reagent_containers/dropper/industrial,
		/obj/item/weapon/flame/lighter/zippo,
		/obj/item/weapon/tray/robotray,
		/obj/item/weapon/reagent_containers/borghypo/service
	)
	emag = /obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer

/obj/item/weapon/robot_module/clerical/butler/finalize_equipment()
	. = ..()
	var/obj/item/weapon/rsf/M = locate() in equipment
	M.stored_matter = 30
	var/obj/item/weapon/flame/lighter/zippo/L = locate() in equipment
	L.lit = 1

/obj/item/weapon/robot_module/clerical/butler/finalize_emag()
	. = ..()
	if(emag)
		var/datum/reagents/R = emag.create_reagents(50)
		R.add_reagent(/datum/reagent/chloralhydrate/beer2, 50)
		emag.SetName("Mickey Finn's Special Brew")

/obj/item/weapon/robot_module/general/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/weapon/reagent_containers/food/condiment/enzyme/E = locate() in equipment
	E.reagents.add_reagent(/datum/reagent/enzyme, 2 * amount)
	if(emag)
		var/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer/B = emag
		B.reagents.add_reagent(/datum/reagent/chloralhydrate/beer2, 2 * amount)

/obj/item/weapon/robot_module/clerical/general
	name = "clerical robot module"
	display_name = "Clerical"
	channels = list(
		"Service" = TRUE,
		"Supply" =  TRUE
	)
	sprites = list(
		"Waitress" = "Service",
		"Kent" =     "toiletbot",
		"Bro" =      "Brobot",
		"Rich" =     "maximillion",
		"Default" =  "Service2",
		"Doot" =     "eyebot-standard"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/weapon/pen/robopen,
		/obj/item/weapon/form_printer,
		/obj/item/weapon/gripper/clerical,
		/obj/item/weapon/hand_labeler,
		/obj/item/weapon/stamp,
		/obj/item/weapon/stamp/denied,
		/obj/item/device/destTagger,
		/obj/item/weapon/crowbar,
		/obj/item/stack/package_wrap/cyborg
	)
	emag = /obj/item/weapon/stamp/chameleon
	synths = list(
		/datum/matter_synth/package_wrap
	)

/obj/item/weapon/robot_module/clerical/general/finalize_synths()
	. = ..()
	var/datum/matter_synth/package_wrap/wrap = locate() in synths
	var/obj/item/stack/package_wrap/cyborg/wrap_item = locate() in equipment
	wrap_item.synths = list(wrap)
