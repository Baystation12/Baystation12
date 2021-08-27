/obj/item/robot_module/clerical
	channels = list(
		"Service" = TRUE
	)
	skills = list(
		SKILL_BUREAUCRACY         = SKILL_PROF,
		SKILL_FINANCE             = SKILL_PROF,
		SKILL_COMPUTER            = SKILL_EXPERT,
		SKILL_SCIENCE             = SKILL_EXPERT,
		SKILL_DEVICES             = SKILL_EXPERT
	)

/obj/item/robot_module/clerical/butler
	name = "service robot module"
	display_name = "Service"
	sprites = list(
		"Waitress" = "Service",
		"Kent" = "toiletbot",
		"Bro" = "Brobot",
		"Rich" = "maximillion",
		"Default" = "Service2"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/gripper/service,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/material/minihoe,
		/obj/item/material/hatchet,
		/obj/item/device/scanner/plant,
		/obj/item/storage/plants,
		/obj/item/robot_harvester,
		/obj/item/material/kitchen/rollingpin,
		/obj/item/material/knife/kitchen,
		/obj/item/crowbar,
		/obj/item/rsf,
		/obj/item/reagent_containers/dropper/industrial,
		/obj/item/flame/lighter/zippo,
		/obj/item/tray/robotray,
		/obj/item/reagent_containers/borghypo/service
	)
	emag = /obj/item/reagent_containers/food/drinks/bottle/small/beer
	skills = list(
		SKILL_BUREAUCRACY         = SKILL_PROF,
		SKILL_COMPUTER            = SKILL_EXPERT,
		SKILL_COOKING             = SKILL_PROF,
		SKILL_BOTANY              = SKILL_PROF,
		SKILL_MEDICAL             = SKILL_BASIC,
		SKILL_CHEMISTRY           = SKILL_ADEPT
	)

/obj/item/robot_module/clerical/butler/finalize_equipment()
	. = ..()
	var/obj/item/rsf/M = locate() in equipment
	M.stored_matter = 30
	var/obj/item/flame/lighter/zippo/L = locate() in equipment
	L.lit = 1

/obj/item/robot_module/clerical/butler/finalize_emag()
	. = ..()
	if(emag)
		var/datum/reagents/R = emag.create_reagents(50)
		R.add_reagent(/datum/reagent/chloralhydrate/beer2, 50)
		emag.SetName("Mickey Finn's Special Brew")

/obj/item/robot_module/clerical/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in equipment
	E.reagents.add_reagent(/datum/reagent/enzyme, 2 * amount)
	if(emag)
		var/obj/item/reagent_containers/food/drinks/bottle/small/beer/B = emag
		B.reagents.add_reagent(/datum/reagent/chloralhydrate/beer2, 2 * amount)

/obj/item/robot_module/clerical/general
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
		"Default" =  "Service2"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/pen/robopen,
		/obj/item/form_printer,
		/obj/item/gripper/clerical,
		/obj/item/hand_labeler,
		/obj/item/stamp,
		/obj/item/stamp/denied,
		/obj/item/device/destTagger,
		/obj/item/crowbar,
		/obj/item/stack/package_wrap/cyborg
	)
	emag = /obj/item/stamp/chameleon
	synths = list(
		/datum/matter_synth/package_wrap
	)

/obj/item/robot_module/clerical/general/finalize_synths()
	. = ..()
	var/datum/matter_synth/package_wrap/wrap = locate() in synths
	var/obj/item/stack/package_wrap/cyborg/wrap_item = locate() in equipment
	wrap_item.synths = list(wrap)
