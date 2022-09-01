/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING_MOB(src)
	GLOB.human_mobs -= src
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(new_name)
	..("[new_name] (mannequin)", FALSE)

/mob/living/carbon/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs

/mob/living/carbon/human/skrell/New(new_loc)
	head_hair_style = "Skrell Male Tentacles"
	..(new_loc, SPECIES_SKRELL)

/mob/living/carbon/human/unathi/New(new_loc)
	head_hair_style = "Unathi Horns"
	..(new_loc, SPECIES_UNATHI)

/mob/living/carbon/human/vox/New(new_loc)
	head_hair_style = "Long Vox Quills"
	..(new_loc, SPECIES_VOX)

/mob/living/carbon/human/diona/New(new_loc)
	..(new_loc, SPECIES_DIONA)

/mob/living/carbon/human/machine/New(new_loc)
	..(new_loc, SPECIES_IPC)

/mob/living/carbon/human/nabber/New(new_loc)
	pulling_punches = 1
	..(new_loc, SPECIES_NABBER)

/mob/living/carbon/human/monkey/New(new_loc)
	gender = pick(MALE, FEMALE)
	..(new_loc, SPECIES_MONKEY)

/mob/living/carbon/human/farwa/New(new_loc)
	..(new_loc, "Farwa")

/mob/living/carbon/human/neaera/New(new_loc)
	..(new_loc, "Neaera")

/mob/living/carbon/human/stok/New(new_loc)
	..(new_loc, "Stok")

/mob/living/carbon/human/adherent/New(new_loc)
	..(new_loc, SPECIES_ADHERENT)
