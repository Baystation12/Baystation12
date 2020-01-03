/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	GLOB.human_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/dummy/selfdress/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		equip_to_appropriate_slot(I)

/mob/living/carbon/human/corpse/Initialize(mapload, new_species, obj/effect/landmark/corpse/corpse)
	. = ..(mapload, new_species)

	adjustOxyLoss(maxHealth)//cease life functions
	setBrainLoss(maxHealth)
	var/obj/item/organ/internal/heart/corpse_heart = internal_organs_by_name[BP_HEART]
	if(corpse_heart)
		corpse_heart.pulse = PULSE_NONE//actually stops heart to make worried explorers not care too much
	if(corpse)
		corpse.randomize_appearance(src, new_species)
		corpse.equip_outfit(src)
	update_icon()

/mob/living/carbon/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(new_name)
	..("[new_name] (mannequin)", FALSE)

/mob/living/carbon/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs

/mob/living/carbon/human/skrell/Initialize(mapload)
	h_style = "Skrell Male Tentacles"
	. = ..(mapload, SPECIES_SKRELL)

/mob/living/carbon/human/unathi/Initialize(mapload)
	h_style = "Unathi Horns"
	. = ..(mapload, SPECIES_UNATHI)

/mob/living/carbon/human/vox/Initialize(mapload)
	h_style = "Long Vox Quills"
	. = ..(mapload, SPECIES_VOX)

/mob/living/carbon/human/diona/Initialize(mapload)
	. = ..(mapload, SPECIES_DIONA)

/mob/living/carbon/human/machine/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC)

/mob/living/carbon/human/nabber/Initialize(mapload)
	pulling_punches = 1
	. = ..(mapload, SPECIES_NABBER)

/mob/living/carbon/human/monkey/Initialize(mapload)
	gender = pick(MALE, FEMALE)
	. = ..(mapload, "Monkey")

/mob/living/carbon/human/farwa/Initialize(mapload)
	. = ..(mapload, "Farwa")

/mob/living/carbon/human/neaera/Initialize(mapload)
	. = ..(mapload, "Neaera")

/mob/living/carbon/human/stok/Initialize(mapload)
	. = ..(mapload, "Stok")

/mob/living/carbon/human/adherent/Initialize(mapload)
	. = ..(mapload, SPECIES_ADHERENT)
