/datum/artifact_trigger/touch
	name = "touch"

/datum/artifact_trigger/touch/proc/can_touch(mob/living/carbon/human/H, bodypart)
	return TRUE

/datum/artifact_trigger/touch/on_touch(mob/living/M)
	return can_touch(M, M.hand ? BP_R_HAND : BP_L_HAND)

/datum/artifact_trigger/touch/on_bump(atom/movable/AM)
	if(prob(25))
		return can_touch(AM, pick(BP_R_HAND, BP_L_HAND))

/datum/artifact_trigger/touch/organic
	name = "organic touch"

/datum/artifact_trigger/touch/organic/can_touch(mob/living/carbon/human/H, bodypart)
	if(!istype(H))
		return FALSE
	if(H.get_covering_equipped_item_by_zone(bodypart))
		return FALSE
	return TRUE

/datum/artifact_trigger/touch/organic/on_hit(obj/O, mob/user)
	return istype(O, /obj/item/organ/external)

/datum/artifact_trigger/touch/synth
	name = "robotic touch"

/datum/artifact_trigger/touch/synth/can_touch(mob/living/L, bodypart)
	if(issilicon(L))
		return TRUE
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.isSynthetic())
			return TRUE
		var/obj/item/organ/external/E = H.get_organ(bodypart)
		if(E && BP_IS_ROBOTIC(E))
			return TRUE
		return FALSE
		