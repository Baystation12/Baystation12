#define PROCESS_ACCURACY 3

/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.
	var/surface_accessible = FALSE
	var/relative_size = 25   // Relative size of the organ. Roughly % of space they take in the target projection :D
	var/list/will_assist_languages = list()
	var/list/datum/language/assists_languages = list()

/obj/item/organ/internal/New(var/mob/living/carbon/holder)
	..()
	if(istype(holder))
		holder.internal_organs |= src

		var/mob/living/carbon/human/H = holder
		if(istype(H))
			var/obj/item/organ/external/E = H.get_organ(parent_organ)
			if(!E)
				CRASH("[src] spawned in [holder] without a parent organ: [parent_organ].")
			E.internal_organs |= src

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	return ..()

/obj/item/organ/internal/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)

	if(!istype(target))
		return 0

	if(status & ORGAN_CUT_AWAY)
		return 0 //organs don't work very well in the body when they aren't properly attached

	// robotic organs emulate behavior of the equivalent flesh organ of the species
	if(robotic >= ORGAN_ROBOT || !species)
		species = target.species

	..()

	STOP_PROCESSING(SSobj, src)
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src
	return 1

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/remove_rejuv()
	if(owner)
		owner.internal_organs -= src
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	..()

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/robotize()
	..()
	min_bruised_damage += 5
	min_broken_damage += 10

/obj/item/organ/internal/proc/getToxLoss()
	if(isrobotic())
		return damage * 0.5
	return damage