
/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60

/obj/item/organ/internal/liver/robotize()
	. = ..()
	icon_state = "liver-prosthetic"

/obj/item/organ/internal/liver/process()

	..()
	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			to_chat(owner, "<span class='danger'>Your skin itches.</span>")
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.vomit()

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 60 && !owner.chem_effects[CE_ANTITOX])
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * PROCESS_ACCURACY
			//Damaged one shares the fun
			else if(!owner.isSynthetic())
				var/obj/item/organ/internal/O = pick(owner.internal_organs)
				if(O && O.robotic < ORGAN_ROBOT)
					O.take_damage(0.2)

		//Detox can heal small amounts of damage
		if (src.damage < src.max_damage && !owner.chem_effects[CE_TOXIN])
			src.damage -= (0.2 * owner.chem_effects[CE_ANTITOX]) * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		// Get the effectiveness of the liver.
		var/filter_effect = 3
		if(is_bruised())
			filter_effect -= 1
		if(is_broken())
			filter_effect -= 2
		// Robotic organs filter better but don't get benefits from dylovene for filtering.
		if(robotic >= ORGAN_ROBOT)
			filter_effect += 1
		else if(owner.chem_effects[CE_ANTITOX])
			filter_effect += 1


		// If you're not filtering well, you're going to take damage. Even more if you have alcohol in you.
		if(filter_effect < 2)
			owner.adjustToxLoss(PROCESS_ACCURACY * 0.5 * max((3 - filter_effect), 0) * (1 + owner.chem_effects[CE_ALCOHOL_TOXIC] + (owner.chem_effects[CE_ALCOHOL] / 2)))

		// If you drink alcohol, your liver won't heal.
		if(owner.chem_effects[CE_ALCOHOL])
			if(owner.chem_effects[CE_ALCOHOL_TOXIC])
				take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC] * PROCESS_ACCURACY, prob(90)) // Chance to warn them

		// Heal a bit if needed. This allows recovery from low amounts of toxloss.
		else if(damage < min_broken_damage && !owner.chem_effects[CE_TOXIN] && !owner.radiation)
			damage = max(0, damage - 0.4 * PROCESS_ACCURACY)

	//Blood regeneration if there is some space
	var/blood_volume_raw = owner.vessel.get_reagent_amount(/datum/reagent/blood)
	if(blood_volume_raw < species.blood_volume)
		var/datum/reagent/blood/B = owner.get_blood(owner.vessel)
		if(istype(B))
			B.volume += 0.1 // regenerate blood VERY slowly
			if(CE_BLOODRESTORE in owner.chem_effects)
				B.volume += owner.chem_effects[CE_BLOODRESTORE]

	// Blood loss or liver damage make you lose nutriments
	var/blood_volume = owner.get_blood_volume()
	if(blood_volume < BLOOD_VOLUME_SAFE || is_bruised())
		if(owner.nutrition >= 300)
			owner.nutrition -= 10
		else if(owner.nutrition >= 200)
			owner.nutrition -= 3
