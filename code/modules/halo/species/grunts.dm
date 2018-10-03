/datum/species/unggoy
	name = "unggoy"
	name_plural = "unggoy"
	blurb = "" // Doesn't appear in chargen
	flesh_color = "#4F4F7F"
	blood_color = "#4A4A64" //Same blood colour as Elites.
	icobase = 'code/modules/halo/icons/species/r_unggoy.dmi'
	deform = 'code/modules/halo/icons/species/r_unggoy.dmi'
	default_language = "Sangheili" //Just for now, no special language just yet
	language = "Sangheili"
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	flags = NO_MINOR_CUT
	item_icon_offsets = list(0,0)

	breath_type = "methane"
	poison_type = "phoron"
	exhale_type = "carbon_dioxide"

	warning_low_pressure = 25
	hazard_low_pressure = -1

/datum/species/unggoy/create_organs(var/mob/living/carbon/human/H)
	. = ..()
	//I guess their leg-boots are kinda organs.
	H.equip_to_slot(new /obj/item/clothing/shoes/grunt_boots,slot_shoes)
	H.equip_to_slot(new /obj/item/clothing/shoes/grunt_gloves,slot_gloves)

/datum/species/unggoy/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	//unggoy have special breathing equipment handling via job outfits
/*
	H.backbag = 0
	H.equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/special/unggoy_combat_harness,slot_back_str)
	H.equip_to_slot_if_possible(new /obj/item/clothing/mask/rebreather,slot_wear_mask_str)
*/
/datum/species/unggoy/get_random_name(var/gender)
	var/list/consonants = list("d", "f", "k", "l", "m", "s", "w", "p", "y", "z", "b")
	var/list/vowels = list("a","i","u")
	var/newname = pick(consonants) + pick(vowels) + pick(consonants)
	if(prob(33))
		//repeat
		newname += newname
	else if(prob(50))
		//two different syllabes
		newname += pick(vowels) + pick(consonants)
	else
		//palindrome
		newname += reverse_text(copytext(newname,1,lentext(newname)))
	return capitalize(newname)
