
/mob/living/carbon/human/spartan/New(var/new_loc)
	..(new_loc,"Spartan")
	if(gender == "male")
		name = pick(GLOB.first_names_male)
	else
		name = pick(GLOB.first_names_female)
	name += " "
	name += pick(GLOB.last_names)
	real_name = name



/obj/item/organ/external/chest/augmented
	min_broken_damage = 50

/obj/item/organ/external/groin/augmented
	min_broken_damage = 50

/obj/item/organ/external/head/augmented
	min_broken_damage = 50

/obj/item/organ/external/arm/augmented
	min_broken_damage = 50 //Needs 20 more damage to break

/obj/item/organ/external/arm/right/augmented
	min_broken_damage = 50

/obj/item/organ/external/leg/augmented
	min_broken_damage = 50

/obj/item/organ/external/leg/right/augmented
	min_broken_damage = 50

/obj/item/organ/external/hand/augmented
	min_broken_damage = 50

/obj/item/organ/external/hand/right/augmented
	min_broken_damage = 50

/obj/item/organ/external/foot/augmented
	min_broken_damage = 50

/obj/item/organ/external/foot/right/augmented
	min_broken_damage = 50

/obj/item/organ/internal/eyes/occipital_reversal
	//Organ is slightly tougher
	min_bruised_damage = 25
	min_broken_damage = 35
	//Minor protection from flashes
	innate_flash_protection = FLASH_PROTECTION_MODERATE
	//Also protects against Phoron gas
	phoron_guard = 1

/obj/item/organ/internal/liver/spartan
	//Twice as good at handling toxin damage... but not any tougher
	toxin_danger_level = 120

/obj/item/organ/internal/liver/spartan/process()
	//To allow some filtering first, we're putting off our ..() call
	if(owner.chem_effects[CE_ALCOHOL] && owner.chem_effects[CE_ALCOHOL_TOXIC])
		//Remove an additional amount of alcohol
		owner.vessel.remove_reagent(/datum/reagent/ethanol, min(owner.chem_effects[CE_ALCOHOL_TOXIC], 3))

	// Small amounts of radiation can be handled by a spartan
	if(owner.radiation && !owner.chem_effects[CE_TOXIN])
		var/amount = min(owner.radiation, 10)
		owner.radiation -= amount
		//Radiation is scavenged into metabolizable compounds by the enhanced liver
		owner.vessel.add_reagent(/datum/reagent/radiotox, amount)

	. = ..()



