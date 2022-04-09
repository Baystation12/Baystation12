/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.
	var/surface_accessible = FALSE
	var/relative_size = 25   // Relative size of the organ. Roughly % of space they take in the target projection :D
	var/min_bruised_damage = 10       // Damage before considered bruised
	var/damage_reduction = 0.5     //modifier for internal organ injury

/obj/item/organ/internal/New(var/mob/living/carbon/holder)
	if(max_damage)
		min_bruised_damage = Floor(max_damage / 4)
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

/obj/item/organ/internal/set_dna(var/datum/dna/new_dna)
	..()
	if(species && species.organs_icon)
		icon = species.organs_icon

//disconnected the organ from it's owner but does not remove it, instead it becomes an implant that can be removed with implant surgery
//TODO move this to organ/internal once the FPB port comes through
/obj/item/organ/proc/cut_away(var/mob/living/user)
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent)) //TODO ensure that we don't have to check this.
		removed(user, 0)
		parent.implants += src

/obj/item/organ/internal/removed(var/mob/living/user, var/drop_organ=1, var/detach=1)
	if(owner)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		owner.internal_organs_by_name -= null
		owner.internal_organs -= src

		if(detach)
			var/obj/item/organ/external/affected = owner.get_organ(parent_organ)
			if(affected)
				affected.internal_organs -= src
				status |= ORGAN_CUT_AWAY
	..()

/obj/item/organ/internal/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)

	if(!istype(target))
		return 0

	if(status & ORGAN_CUT_AWAY)
		return 0 //organs don't work very well in the body when they aren't properly attached

	// robotic organs emulate behavior of the equivalent flesh organ of the species
	if(BP_IS_ROBOTIC(src) || !species)
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
	if(BP_IS_ROBOTIC(src))
		return damage * 0.5
	return damage

/obj/item/organ/internal/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/internal/proc/is_damaged()
	return damage > 0

/obj/item/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/internal/proc/set_max_damage(var/ndamage)
	max_damage = Floor(ndamage)
	min_broken_damage = Floor(0.75 * max_damage)
	min_bruised_damage = Floor(0.25 * max_damage)

obj/item/organ/internal/take_general_damage(var/amount, var/silent = FALSE)
	take_internal_damage(amount, silent)

/obj/item/organ/internal/proc/take_internal_damage(amount, var/silent=0)
	if(BP_IS_ROBOTIC(src))
		damage = clamp(damage + (amount * 0.8), 0, max_damage)
	else
		damage = clamp(damage + amount, 0, max_damage)

		//only show this if the organ is not robotic
		if(owner && can_feel_pain() && parent_organ && (amount > 5 || prob(10)))
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				var/degree = ""
				if(is_bruised())
					degree = " a lot"
				if(damage < 5)
					degree = " a bit"
				owner.custom_pain("Something inside your [parent.name] hurts[degree].", amount, affecting = parent)

/obj/item/organ/internal/proc/get_visible_state()
	if(damage > max_damage)
		. = "bits and pieces of a destroyed "
	else if(is_broken())
		. = "broken "
	else if(is_bruised())
		. = "badly damaged "
	else if(damage > 5)
		. = "damaged "
	if(status & ORGAN_DEAD)
		if(can_recover())
			. = "decaying [.]"
		else
			. = "necrotic [.]"
	. = "[.][name]"

/obj/item/organ/internal/Process()
	..()
	handle_regeneration()

/obj/item/organ/internal/proc/handle_regeneration()
	if(!damage || BP_IS_ROBOTIC(src) || !owner || owner.chem_effects[CE_TOXIN] || owner.is_asystole())
		return
	if(damage < 0.1*max_damage)
		heal_damage(0.1)

/obj/item/organ/internal/proc/surgical_fix(mob/user)
	if(damage > min_broken_damage)
		var/scarring = damage/max_damage
		scarring = 1 - 0.3 * scarring ** 2 // Between ~15 and 30 percent loss
		var/new_max_dam = Floor(scarring * max_damage)
		if(new_max_dam < max_damage)
			to_chat(user, "<span class='warning'>Not every part of [src] could be saved, some dead tissue had to be removed, making it more suspectable to damage in the future.</span>")
			set_max_damage(new_max_dam)
	heal_damage(damage)

/obj/item/organ/internal/proc/get_scarring_level()
	. = (initial(max_damage) - max_damage)/initial(max_damage)

/obj/item/organ/internal/get_scan_results()
	. = ..()
	var/scar_level = get_scarring_level()
	if(scar_level > 0.01)
		. += "[get_wound_severity(get_scarring_level())] scarring"

/obj/item/organ/internal/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch (severity)
		if (1)
			take_internal_damage(16)
		if (2)
			take_internal_damage(9)
		if (3)
			take_internal_damage(6.5)
