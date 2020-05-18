/obj/item/weapon/robot_module/flying/filing
	name = "filing drone module"
	display_name = "Filing"
	channels = list(
		"Service" = TRUE, 
		"Supply" = TRUE
		)
	languages = list(
		LANGUAGE_HUMAN_EURO     = TRUE,
		LANGUAGE_HUMAN_ARABIC   = TRUE,
		LANGUAGE_HUMAN_INDIAN   = TRUE,
		LANGUAGE_HUMAN_CHINESE  = TRUE,
		LANGUAGE_HUMAN_IBERIAN  = TRUE,
		LANGUAGE_HUMAN_RUSSIAN  = TRUE,
		LANGUAGE_HUMAN_SELENIAN = TRUE,
		LANGUAGE_UNATHI_SINTA   = TRUE,
		LANGUAGE_SKRELLIAN      = TRUE,
		LANGUAGE_SPACER         = TRUE
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
	skills = list(
		SKILL_BUREAUCRACY         = SKILL_PROF,
		SKILL_FINANCE             = SKILL_PROF,
		SKILL_COMPUTER            = SKILL_EXPERT,
		SKILL_SCIENCE             = SKILL_EXPERT,
		SKILL_DEVICES             = SKILL_EXPERT
	)

/obj/item/weapon/robot_module/flying/filing/finalize_synths()
	. = ..()
	var/datum/matter_synth/package_wrap =       locate() in synths
	var/obj/item/stack/package_wrap/cyborg/PW = locate() in equipment
	PW.synths = list(package_wrap)
