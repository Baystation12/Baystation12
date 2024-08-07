/obj/aura/regenerating
	name = "regenerating aura"
	var/brute_mult = 1
	var/fire_mult = 1
	var/tox_mult = 1

/obj/aura/regenerating/aura_check_life()
	user.adjustBruteLoss(-brute_mult)
	user.adjustFireLoss(-fire_mult)
	user.adjustToxLoss(-tox_mult)
	return EMPTY_BITFIELD

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


/obj/aura/regenerating/human/proc/external_regeneration_effect(obj/item/organ/external/O, mob/living/carbon/human/H)
	return

/obj/aura/regenerating/human/aura_check_life()
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		CRASH("Someone gave [user.type] a [src.type] aura. This is invalid.")
	if(!innate_heal || H.InStasis() || H.stat == DEAD)
		return EMPTY_BITFIELD
	if(H.nutrition < nutrition_damage_mult)
		low_nut_warning()
		return EMPTY_BITFIELD

	if(brute_mult && H.getBruteLoss())
		H.adjustBruteLoss(-brute_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)
	if(fire_mult && H.getFireLoss())
		H.adjustFireLoss(-fire_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)
	if(tox_mult && H.getToxLoss())
		H.adjustToxLoss(-tox_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)

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
							to_chat(H, replacetext(regen_message,"ORGAN", regen_organ.name))
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
	return AURA_CANCEL

/obj/aura/regenerating/human/proc/low_nut_warning(wound_type)
	if (last_nutrition_warning + 1 MINUTE < world.time)
		to_chat(user, SPAN_WARNING("You need more energy to regenerate your [wound_type || "wounds"]."))
		last_nutrition_warning = world.time
		return 1
	return 0

/obj/aura/regenerating/human/proc/toggle()
	innate_heal = !innate_heal

/obj/aura/regenerating/human/proc/can_toggle()
	return TRUE

/obj/aura/regenerating/human/proc/can_regenerate_organs()
	return TRUE

/// Any damage that goes past this through armor will cause a reduction in regeneration.
#define UNATHI_DAMAGE_REGEN_MALUS_THRESHOLD 15
/// Any damage past the malus threshold will give damage/divider amount of regen malus stacks , rounded down. Heavy hits will give a big malus
#define UNATHI_REGEN_MALUS_DAMAGE_DIVIDER 10

/obj/aura/regenerating/human/unathi
	nutrition_damage_mult = 2
	brute_mult = 2
	organ_mult = 4
	regen_message = "<span class='warning'>You feel a soothing sensation as your ORGAN mends...</span>"
	grow_chance = 2
	grow_threshold = 150
	ignore_tag = BP_HEAD
	/// Regen Malus , incremented by every attack.
	var/regeneration_malus = 0
	/// The upper limit of the regeneration malus ,at this point it will be debuffed by 75%
	var/regeneration_malus_cap = 20

/obj/aura/regenerating/human/unathi/can_toggle()
	return FALSE

// Default return; we're just logging.
/obj/aura/regenerating/human/unathi/aura_post_weapon(obj/item/weapon, mob/attacker, click_params, damage_dealt)
	if(weapon.force > UNATHI_DAMAGE_REGEN_MALUS_THRESHOLD)
		regeneration_malus += round(damage_dealt / UNATHI_REGEN_MALUS_DAMAGE_DIVIDER)

/obj/aura/regenerating/human/unathi/aura_post_thrown(atom/movable/thrown_atom, datum/thrownthing/thrown_datum, damage_dealt)
	if(damage_dealt > UNATHI_DAMAGE_REGEN_MALUS_THRESHOLD)
		regeneration_malus += round(damage_dealt / UNATHI_REGEN_MALUS_DAMAGE_DIVIDER)

/obj/aura/regenerating/human/unathi/aura_post_bullet(obj/item/projectile/proj, def_zone, damage_dealt)
	if(!proj.nodamage && damage_dealt > UNATHI_DAMAGE_REGEN_MALUS_THRESHOLD)
		regeneration_malus += round(damage_dealt / UNATHI_REGEN_MALUS_DAMAGE_DIVIDER)

/obj/aura/regenerating/human/unathi/aura_check_life()
	var/mob/living/carbon/human/H = user
	if (!istype(H) || H.stat == DEAD)
		return AURA_CANCEL
	if (H.stasis_value)
		return AURA_FALSE
	if (H.nutrition < 50)
		H.apply_damage(5, DAMAGE_TOXIN)
		H.adjust_nutrition(3)
		return AURA_FALSE
	// min of 25% guaranteed
	var/regen_mult = max(0.25, 1 - (regeneration_malus ? 0 : (regeneration_malus / regeneration_malus_cap)))
	regeneration_malus = max(0, regeneration_malus - 1)
	// Yes you can.. damage yourself to avoid regen damage ? call it unathi adrenaline!
	nutrition_damage_mult = 2 * regen_mult
	brute_mult = 2 * regen_mult
	organ_mult = 4 * regen_mult
	grow_chance = 2 * regen_mult
	var/obj/machinery/optable/optable = locate() in get_turf(H)
	if (optable?.suppressing && H.sleeping)
		nutrition_damage_mult = 1 * regen_mult
		brute_mult = 1 * regen_mult
		organ_mult = 2 * regen_mult
		grow_chance = 1 * regen_mult

	return ..()

/obj/aura/regenerating/human/unathi/can_regenerate_organs()
	return can_toggle()

/obj/aura/regenerating/human/unathi/external_regeneration_effect(obj/item/organ/external/O, mob/living/carbon/human/H)
	to_chat(H, SPAN_DANGER("With a shower of fresh blood, a new [O.name] forms."))
	H.visible_message(SPAN_DANGER("With a shower of fresh blood, a length of biomass shoots from [H]'s [O.amputation_point], forming a new [O.name]!"))
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

/obj/aura/regenerating/human/diona/external_regeneration_effect(obj/item/organ/external/O, mob/living/carbon/human/H)
	to_chat(H, SPAN_WARNING("Some of your nymphs split and hurry to reform your [O.name]."))
	H.adjust_nutrition(-external_nutrition_mult)

/obj/aura/regenerating/human/unathi/yeosa
	brute_mult = 1.5
	organ_mult = 3
	tox_mult = 2
