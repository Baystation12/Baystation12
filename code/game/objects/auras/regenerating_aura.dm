/obj/aura/regenerating
	name = "regenerating aura"
	var/brute_per_tick = 1 //how much is natively healed per tick
	var/fire_per_tick = 1
	var/tox_per_tick = 1

/obj/aura/regenerating/life_tick()
	user.adjustBruteLoss(-brute_per_tick)
	user.adjustFireLoss(-fire_per_tick)
	user.adjustToxLoss(-tox_per_tick)

/obj/aura/regenerating/human
	var/regen_message = "<span class='warning'>Your body throbs as you feel your ORGAN regenerate.</span>"
	var/heal_cost = 2 //How much nutrition it takes to heal regular damage
	var/nutrition_required_to_regenerate = 150 //nutrition must be over this to do the serious regen stuff
	var/last_nutrition_warning = 0

	var/grow_chance = 0 //each tick, this is rolled to determine if a limb regrow should be attempted
	var/grow_cost = 50 // How much nutrition it takes to regrow a limb

	var/organ_chance = 2 //each tick, this is rolled to determine if an organ heal should be attempted
	var/organ_heal = 2 //how much organs can be healed by
	var/organ_heal_cost = 5 //how much nutrition it takes to heal an organ

/obj/aura/regenerating/human/proc/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	return

/obj/aura/regenerating/human/life_tick()
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		CRASH("Someone gave [user.type] a [src.type] aura. This is invalid.")
		return 0
	if(!H.innate_heal || H.InStasis() || H.stat == DEAD)
		return 0
	if(H.nutrition < heal_cost)
		low_nut_warning()
		return 0

	if(brute_per_tick && H.getBruteLoss())
		H.adjustBruteLoss(-brute_per_tick * config.organ_regeneration_multiplier)
		H.nutrition -= heal_cost
	if(fire_per_tick && H.getFireLoss())
		H.adjustFireLoss(-fire_per_tick * config.organ_regeneration_multiplier)
		H.nutrition -= heal_cost
	if(tox_per_tick && H.getToxLoss())
		H.adjustToxLoss(-tox_per_tick * config.organ_regeneration_multiplier)
		H.nutrition -= heal_cost

	if(prob(organ_chance) && H.nutrition >= nutrition_required_to_regenerate && !H.getBruteLoss() && !H.getFireLoss())
		var/obj/item/organ/external/head/D = H.organs_by_name["head"]
		if (D.status & ORGAN_DISFIGURED)
			if (H.nutrition > organ_heal_cost)
				D.status &= ~ORGAN_DISFIGURED
				H.nutrition -= organ_heal_cost
			else
				low_nut_warning("head")

	if(prob(organ_chance))
		for(var/bpart in shuffle(H.internal_organs_by_name - BP_BRAIN))
			var/obj/item/organ/internal/regen_organ = H.internal_organs_by_name[bpart]
			if(BP_IS_ROBOTIC(regen_organ))
				continue
			if(istype(regen_organ))
				if(regen_organ.damage > 0 && !(regen_organ.status & ORGAN_DEAD))
					if (H.nutrition > organ_heal_cost)
						regen_organ.damage = max(regen_organ.damage - organ_heal, 0)
						H.nutrition -= organ_heal_cost
						if(prob(5))
							to_chat(H, replacetext(regen_message,"ORGAN", regen_organ.name))
					else
						low_nut_warning(regen_organ.name)

	if(prob(grow_chance))
		for(var/limb_type in H.species.has_limbs)
			var/obj/item/organ/external/E = H.organs_by_name[limb_type]
			if(E && E.organ_tag != BP_HEAD && !E.vital && !E.is_usable())	//Skips heads and vital bits...
				if (H.nutrition > nutrition_required_to_regenerate)
					E.removed()			//...because no one wants their head to explode to make way for a new one.
					qdel(E)
					E= null
				else
					low_nut_warning(E.name)
			if(!E)
				var/list/organ_data = H.species.has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/external/O = new limb_path(H)
				external_regeneration_effect(O,H)
				organ_data["descriptor"] = O.name
				H.update_body()
				return
			else if (H.nutrition > nutrition_required_to_regenerate) //We don't subtract any nut here, but let's still only heal wounds when we have nut.
				for(var/datum/wound/W in E.wounds)
					if(W.wound_damage() == 0 && prob(50))
						E.wounds -= W
	return 1

/obj/aura/regenerating/human/proc/low_nut_warning(var/wound_type)
	if (last_nutrition_warning + 1 MINUTE < world.time)
		to_chat(user, "<span class='warning'>You need more energy to regenerate your [wound_type || "wounds"].</span>")
		last_nutrition_warning = world.time
		return 1
	return 0


/obj/aura/regenerating/human/unathi
	brute_per_tick = 0
	fire_per_tick = 0
	organ_chance = 4
	regen_message = "<span class='warning'>You feel a soothing sensation as your ORGAN mends...</span>"
	grow_chance = 2
	nutrition_required_to_regenerate = 250
	grow_cost = 150

/obj/aura/regenerating/human/unathi/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	to_chat(H, "<span class='danger'>With a shower of fresh blood, a new [O.name] forms.</span>")
	H.visible_message("<span class='danger'>With a shower of fresh blood, a length of biomass shoots from [H]'s [O.amputation_point], forming a new [O.name]!</span>")
	H.nutrition -= grow_cost
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
	blood_splatter(H,B,1)
	O.set_dna(H.dna)
	O.stun_act(4, 100)
	O.add_pain(O.max_damage) //adds as much pain as possible

/obj/aura/regenerating/human/diona
	brute_per_tick = 4
	fire_per_tick = 4
	tox_per_tick = 0
	organ_chance = 2
	regen_message = "<span class='warning'>You sense your nymphs shifting internally to regenerate your ORGAN..</span>"
	grow_chance = 5
	nutrition_required_to_regenerate = 100
	grow_cost = 60

/obj/aura/regenerating/human/diona/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	to_chat(H, "<span class='warning'>Some of your nymphs split and hurry to reform your [O.name].</span>")
	H.nutrition -= grow_cost

/obj/aura/regenerating/human/unathi/yeosa
	organ_chance = 3
	tox_per_tick = 2