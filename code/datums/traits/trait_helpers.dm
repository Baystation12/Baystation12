/mob/living/carbon/proc/handle_protein()
	var/malus_level = GetTraitLevel(/singleton/trait/malus/animal_protein)
	var/malus_factor = malus_level ? malus_level * (1/3) : 0
	if (!malus_factor)
		return
	var/effective_dose = 0
	for (var/datum/reagent/protein as anything in metabolized.reagent_list)
		if (!protein.protein_amount)
			continue
		effective_dose += (protein.volume * protein.protein_amount * malus_factor)

	if (effective_dose > 20)
		adjustToxLoss(clamp((effective_dose - 20) / 4, 2, 10))
		vomit(8, 3, rand(1 SECONDS, 5 SECONDS))
	else if (effective_dose > 10)
		vomit(4, 2, rand(3 SECONDS, 10 SECONDS))
	else if(effective_dose)
		vomit(1, 1, rand(5 SECONDS, 15 SECONDS))

/mob/living/carbon/proc/handle_sugar()
	var/malus_level = GetTraitLevel(/singleton/trait/malus/sugar)
	var/malus_factor = malus_level ? malus_level * (1/3) : 0
	if (!malus_factor)
		return
	var/effective_dose = 0
	for (var/datum/reagent/sugar as anything in metabolized.reagent_list)
		if (!sugar.sugar_amount)
			continue
		effective_dose += (sugar.volume * sugar.sugar_amount * malus_factor)

	if (effective_dose < 5)
		return

	druggy = max(druggy, 10)
	add_chemical_effect(CE_PULSE, -1)
	if (effective_dose > 15 && prob(7))
		emote(pick("twitch", "drool"))
	if (effective_dose > 20 && prob(10))
		SelfMove(pick(GLOB.cardinal))
	if (effective_dose > 50 && prob(60))
		var/obj/item/organ/internal/brain/O = internal_organs_by_name[BP_BRAIN]
		O?.take_internal_damage(10, FALSE)
