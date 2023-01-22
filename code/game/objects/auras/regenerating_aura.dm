/obj/aura/regenerating
	name = "regenerating aura"
	var/brute_mult = 1
	var/fire_mult = 1
	var/tox_mult = 1

/obj/aura/regenerating/life_tick()
	user.adjustBruteLoss(-brute_mult)
	user.adjustFireLoss(-fire_mult)
	user.adjustToxLoss(-tox_mult)

/obj/aura/regenerating/human
	var/nutrition_damage_mult = 1 //How much nutrition it takes to heal regular damage
	var/external_nutrition_mult = 50 // How much nutrition it takes to regrow a limb
	var/organ_mult = 2
	var/regen_message = "<span class='warning'>Your body throbs as you feel your ORGAN regenerate.</span>"
	var/grow_chance = 0
	var/grow_threshold = 0
	var/ignore_tag//organ tag to ignore
	var/last_nutrition_warning = 0
	var/innate_heal = TRUE // Whether the aura is on, basically.


/obj/aura/regenerating/human/proc/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	return

/obj/aura/regenerating/human/life_tick()
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		CRASH("Someone gave [user.type] a [src.type] aura. This is invalid.")
	if(!innate_heal || H.InStasis() || H.stat == DEAD)
		return 0
	if(H.nutrition < nutrition_damage_mult)
		low_nut_warning()
		return 0

	if(brute_mult && H.getBruteLoss())
		H.adjustBruteLoss(-brute_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)
	if(fire_mult && H.getFireLoss())
		H.adjustFireLoss(-fire_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)
	if(tox_mult && H.getToxLoss())
		H.adjustToxLoss(-tox_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)

	if(!can_regenerate_organs())
		return 1
	if(organ_mult)
		if(prob(10) && H.nutrition >= 150 && !H.getBruteLoss() && !H.getFireLoss())
			var/obj/item/organ/external/head/D = H.organs_by_name["head"]
			if (D.status & ORGAN_DISFIGURED)
				if (H.nutrition >= 20)
					D.status &= ~ORGAN_DISFIGURED
					H.adjust_nutrition(-20)
				else
					low_nut_warning("head")

		for(var/bpart in shuffle(H.internal_organs_by_name - BP_BRAIN))
			var/obj/item/organ/internal/regen_organ = H.internal_organs_by_name[bpart]
			if(BP_IS_ROBOTIC(regen_organ))
				continue
			if(istype(regen_organ))
				if(regen_organ.damage > 0 && !(regen_organ.status & ORGAN_DEAD))
					if (H.nutrition >= organ_mult)
						regen_organ.damage = max(regen_organ.damage - organ_mult, 0)
						H.adjust_nutrition(-organ_mult)
						if(prob(5))
							to_chat(H, replacetext_char(regen_message,"ORGAN", regen_organ.name))
					else
						low_nut_warning(regen_organ.name)

	if(prob(grow_chance))
		for(var/limb_type in H.species.has_limbs)
			var/obj/item/organ/external/E = H.organs_by_name[limb_type]
			if(E && E.organ_tag != BP_HEAD && !E.vital && (E.is_stump() || E.status & ORGAN_DEAD))	//Skips heads and vital bits...
				if (H.nutrition > grow_threshold)
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
			else if (H.nutrition > grow_threshold) //We don't subtract any nut here, but let's still only heal wounds when we have nut.
				for(var/datum/wound/W in E.wounds)
					if(W.wound_damage() == 0 && prob(50))
						qdel(W)
	return 1

/obj/aura/regenerating/human/proc/low_nut_warning(var/wound_type)
	if (last_nutrition_warning + 1 MINUTE < world.time)
		to_chat(user, "<span class='warning'>You need more energy to regenerate your [wound_type || "wounds"].</span>")
		last_nutrition_warning = world.time
		return 1
	return 0

/obj/aura/regenerating/human/proc/toggle()
	innate_heal = !innate_heal

/obj/aura/regenerating/human/proc/can_toggle()
	return TRUE

/obj/aura/regenerating/human/proc/can_regenerate_organs()
	return TRUE

/obj/aura/regenerating/human/unathi
	nutrition_damage_mult = 2
	brute_mult = 2
	organ_mult = 4
	regen_message = "<span class='warning'>You feel a soothing sensation as your ORGAN mends...</span>"
	grow_chance = 2
	grow_threshold = 150
	ignore_tag = BP_HEAD
	var/toggle_blocked_until = 0 // A time

/obj/aura/regenerating/human/unathi/toggle()
	..()
	toggle_blocked_until = max(world.time + 2 MINUTES, toggle_blocked_until)

/obj/aura/regenerating/human/unathi/can_toggle()
	if(world.time < toggle_blocked_until)
		return FALSE
	return ..()

// Default return; we're just logging.
/obj/aura/regenerating/human/unathi/attackby()
	toggle_blocked_until = max(world.time + 1 MINUTE, toggle_blocked_until)

/obj/aura/regenerating/human/unathi/hitby()
	toggle_blocked_until = max(world.time + 1 MINUTE, toggle_blocked_until)

/obj/aura/regenerating/human/unathi/bullet_act()
	toggle_blocked_until = max(world.time + 1 MINUTE, toggle_blocked_until)

/obj/aura/regenerating/human/unathi/life_tick()
	var/mob/living/carbon/human/H = user
	if(innate_heal && istype(H) && H.stat != DEAD && H.nutrition < 50)
		H.apply_damage(5, DAMAGE_TOXIN)
		H.adjust_nutrition(3)
		return 1
	return ..()

/obj/aura/regenerating/human/unathi/can_regenerate_organs()
	return can_toggle()

/obj/aura/regenerating/human/unathi/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	to_chat(H, "<span class='danger'>With a shower of fresh blood, a new [O.name] forms.</span>")
	H.visible_message("<span class='danger'>With a shower of fresh blood, a length of biomass shoots from [H]'s [O.amputation_point], forming a new [O.name]!</span>")
	H.adjust_nutrition(-external_nutrition_mult)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
	blood_splatter(H,B,1)
	O.set_dna(H.dna)


/obj/aura/regenerating/human/diona
	brute_mult = 4
	fire_mult = 4
	tox_mult = 0
	nutrition_damage_mult = 2
	organ_mult = 2
	regen_message = "<span class='warning'>You sense your nymphs shifting internally to regenerate your ORGAN..</span>"
	grow_chance = 5
	grow_threshold = 100
	external_nutrition_mult = 60

/obj/aura/regenerating/human/diona/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	to_chat(H, "<span class='warning'>Some of your nymphs split and hurry to reform your [O.name].</span>")
	H.adjust_nutrition(-external_nutrition_mult)

/obj/aura/regenerating/human/unathi/yeosa
	brute_mult = 1.5
	organ_mult = 3
	tox_mult = 2
