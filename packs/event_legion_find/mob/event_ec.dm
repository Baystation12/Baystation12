/obj/spawner/preset_human/event_ec
	languages = list(
		LANGUAGE_HUMAN_EURO
	)


/obj/spawner/preset_human/event_ec/one
	outfit = /singleton/hierarchy/outfit/event_ec/one


/obj/spawner/preset_human/event_ec/two
	outfit = /singleton/hierarchy/outfit/event_ec/two


/singleton/hierarchy/outfit/event_ec
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/research)
	pda_type = /obj/item/modular_computer/pda/science
	l_ear = /obj/item/device/radio/headset/science


/singleton/hierarchy/outfit/job/torch/crew/research/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_RESEARCH


/singleton/hierarchy/outfit/event_ec/one
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/research


/singleton/hierarchy/outfit/event_ec/two
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
