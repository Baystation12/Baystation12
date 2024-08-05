/proc/handle_protein(mob/living/carbon/C, datum/reagent/protein)
	if (!istype(C))
		return

	var/malus_level = C.GetTraitLevel(/singleton/trait/malus/animal_protein)
	var/malus_factor = malus_level ? malus_level * (1/3) : 0

	var/effective_dose = C.chem_doses[protein.type] * protein.protein_amount * malus_factor
	if (effective_dose > 20)
		C.adjustToxLoss(clamp((effective_dose - 20) / 4, 2, 10))
		C.vomit(8, 3, rand(1 SECONDS, 5 SECONDS))
	else if (effective_dose > 10)
		C.vomit(4, 2, rand(3 SECONDS, 10 SECONDS))
	else if(effective_dose)
		C.vomit(1, 1, rand(5 SECONDS, 15 SECONDS))

/proc/handle_sugar(mob/living/carbon/C, datum/reagent/sugar)
	if (!istype(C))
		return

	var/malus_level = C.GetTraitLevel(/singleton/trait/malus/sugar)
	var/malus_factor = malus_level ? malus_level * (1/3) : 0

	var/effective_dose = C.chem_doses[sugar.type] * sugar.sugar_amount * malus_factor
	if(effective_dose < 5)
		return

	C.druggy = max(C.druggy, 10)
	C.add_chemical_effect(CE_PULSE, -1)
	if(effective_dose > 15 && prob(7))
		C.emote(pick("twitch", "drool"))
	if(effective_dose > 20 && prob(10))
		C.SelfMove(pick(GLOB.cardinal))
	if(effective_dose > 50 && prob(60))
		var/obj/item/organ/internal/brain/O = C.internal_organs_by_name[BP_BRAIN]
		O?.take_internal_damage(10, FALSE)
