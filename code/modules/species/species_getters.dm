/datum/species/proc/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return list()

/datum/species/proc/get_additional_examine_text(var/mob/living/carbon/human/H)
	return

/datum/species/proc/get_tail(var/mob/living/carbon/human/H)
	return tail

/datum/species/proc/get_tail_animation(var/mob/living/carbon/human/H)
	return tail_animation

/datum/species/proc/get_tail_hair(var/mob/living/carbon/human/H)
	return tail_hair

/datum/species/proc/get_blood_mask(var/mob/living/carbon/human/H)
	return blood_mask

/datum/species/proc/get_damage_overlays(var/mob/living/carbon/human/H)
	return damage_overlays

/datum/species/proc/get_damage_mask(var/mob/living/carbon/human/H)
	return damage_mask

/datum/species/proc/get_examine_name(var/mob/living/carbon/human/H)
	return name

/datum/species/proc/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	return (get_deform ? deform : icobase)

/datum/species/proc/get_station_variant()
	return name

/datum/species/proc/get_race_key(var/mob/living/carbon/human/H)
	return race_key

/datum/species/proc/get_bodytype(var/mob/living/carbon/human/H)
	return name

/datum/species/proc/get_knockout_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots!" : knockout_message)

/datum/species/proc/get_death_message(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "gives one shrill beep before falling lifeless." : death_message)

/datum/species/proc/get_ssd(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "flashing a 'system offline' glyph on their monitor" : show_ssd)

/datum/species/proc/get_blood_colour(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_BLOOD_COLOUR : blood_color)

/datum/species/proc/get_flesh_colour(var/mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_FLESH_COLOUR : flesh_color)

/datum/species/proc/get_environment_discomfort(var/mob/living/carbon/human/H, var/msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	for(var/obj/item/clothing/clothes in H)
		if(H.l_hand == clothes || H.r_hand == clothes)
			continue
		if((clothes.body_parts_covered & UPPER_TORSO) && (clothes.body_parts_covered & LOWER_TORSO))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered)
				to_chat(H, "<span class='danger'>[pick(cold_discomfort_strings)]</span>")
		if("heat")
			if(covered)
				to_chat(H, "<span class='danger'>[pick(heat_discomfort_strings)]</span>")

/datum/species/proc/get_vision_flags(var/mob/living/carbon/human/H)
	return vision_flags

/datum/species/proc/get_husk_icon(var/mob/living/carbon/human/H)
	return husk_icon

/datum/species/proc/get_sex(var/mob/living/carbon/H)
	return H.gender

/datum/species/proc/get_surgery_overlay_icon(var/mob/living/carbon/human/H)
	return 'icons/mob/surgery.dmi'

/datum/species/proc/get_footstep(var/mob/living/carbon/human/H, var/footstep_type)
	return

/datum/species/proc/get_brute_mod(var/mob/living/carbon/human/H)
	. = brute_mod

/datum/species/proc/get_burn_mod(var/mob/living/carbon/human/H)
	. = burn_mod

/datum/species/proc/get_toxins_mod(var/mob/living/carbon/human/H)
	. = toxins_mod

/datum/species/proc/get_radiation_mod(var/mob/living/carbon/human/H)
	. = (H && H.isSynthetic() ? 0.5 : radiation_mod)

/datum/species/proc/get_slowdown(var/mob/living/carbon/human/H)
	. = (H && H.isSynthetic() ? 0 : slowdown)
