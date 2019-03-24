/obj/item/weapon/robot_module/flying/filing
	name = "filing drone module"
	display_name = "Filing"
	channels = list(
		"Service" = TRUE, 
		"Supply" = TRUE
		)
	languages = list(
		LANGUAGE_SOL_COMMON	=  TRUE,
		LANGUAGE_UNATHI =      TRUE,
		LANGUAGE_SKRELLIAN =   TRUE,
		LANGUAGE_LUNAR =       TRUE,
		LANGUAGE_GUTTER     =  TRUE,
		LANGUAGE_INDEPENDENT = TRUE,
		LANGUAGE_SPACER =      TRUE
	)
	sprites = list("Drone" = "drone-service")
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
		/obj/item/device/megaphone,
		/obj/item/stack/package_wrap/cyborg
	)
	emag = /obj/item/weapon/stamp/chameleon
	synths = list(/datum/matter_synth/package_wrap)

/obj/item/weapon/robot_module/flying/filing/finalize_synths()
	. = ..()
	var/datum/matter_synth/package_wrap =       locate() in synths
	var/obj/item/stack/package_wrap/cyborg/PW = locate() in equipment
	PW.synths = list(package_wrap)
