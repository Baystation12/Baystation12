/datum/species/unggoy
	name = "unggoy"
	name_plural = "unggoy"
	blurb = "Shouldn't be seeing this." // Doesn't appear in chargen
	flesh_color = "#4F4F7F"
	blood_color = "#4A4A64" //Same blood colour as Elites.
	icobase = 'code/modules/halo/icons/species/r_unggoy.dmi'
	deform = 'code/modules/halo/icons/species/r_unggoy.dmi'
	default_language = "Sangheili" //Just for now, no special language just yet
	language = "Sangheili"
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	spawn_flags = SPECIES_IS_WHITELISTED
	flags = NO_MINOR_CUT
	item_icon_offsets = list(0,0)

	breath_type = "methane"
	poison_type = "oxygen"
	exhale_type = "carbon_dioxide"

/datum/species/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	H.backbag = 0
	H.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/special/unggoy_combat_harness,slot_back_str)
	H.equip_to_slot_if_possible(new /obj/item/clothing/mask/rebreather,slot_wear_mask_str)