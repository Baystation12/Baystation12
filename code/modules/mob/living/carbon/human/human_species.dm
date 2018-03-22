/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	GLOB.human_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(new_name)
	..("[new_name] (mannequin)", FALSE)

/mob/living/carbon/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs

/mob/living/carbon/human/skrell/New(var/new_loc)
	h_style = "Skrell Male Tentacles"
	..(new_loc, SPECIES_SKRELL)

/mob/living/carbon/human/tajaran/New(var/new_loc)
	h_style = "Tajaran Ears"
	..(new_loc, SPECIES_TAJARA)

/mob/living/carbon/human/unathi/New(var/new_loc)
	h_style = "Unathi Horns"
	..(new_loc, SPECIES_UNATHI)

/mob/living/carbon/human/vox/New(var/new_loc)
	h_style = "Long Vox Quills"
	..(new_loc, SPECIES_VOX)

/mob/living/carbon/human/diona/New(var/new_loc)
	..(new_loc, SPECIES_DIONA)

/mob/living/carbon/human/machine/New(var/new_loc)
	..(new_loc, SPECIES_IPC)

/mob/living/carbon/human/bogani/New(var/new_loc)
	..(new_loc, SPECIES_BOGANI)

/mob/living/carbon/human/egyno/New(var/new_loc)
	..(new_loc, SPECIES_EGYNO)

/mob/living/carbon/human/nabber/New(var/new_loc)
	pulling_punches = 1
	..(new_loc, SPECIES_NABBER)

/mob/living/carbon/human/monkey/New(var/new_loc)
	..(new_loc, "Monkey")

/mob/living/carbon/human/farwa/New(var/new_loc)
	..(new_loc, "Farwa")

/mob/living/carbon/human/neaera/New(var/new_loc)
	..(new_loc, "Neaera")

/mob/living/carbon/human/stok/New(var/new_loc)
	..(new_loc, "Stok")
