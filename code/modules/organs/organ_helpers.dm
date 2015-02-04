/obj/item/organ/proc/is_bruised()
	return (health < min_bruised_damage)

/obj/item/organ/proc/is_broken()
	return (health < min_broken_damage) || (status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED))

/obj/item/organ/external/is_broken()
	if(..() || is_dislocated() > 0)
		return 1

/obj/item/organ/external/proc/is_dislocated()
	if(dislocated > 0)
		return 1
	if(parent)
		return parent.is_dislocated()
	return 0

/obj/item/organ/external/proc/dislocate(var/primary)
	if(dislocated != -1)
		if(primary)
			dislocated = 2
		else
			dislocated = 1
		owner.verbs |= /mob/living/carbon/human/proc/undislocate

	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			child.dislocate()

/obj/item/organ/external/proc/undislocate(var/primary)
	if(dislocated != -1)
		dislocated = 0
		if(owner)
			owner.shock_stage += 20
			if(primary && !(owner.species.flags & NO_PAIN))
				owner.emote("scream")
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			child.undislocate()

/obj/item/organ/proc/is_bleeding()
	if(istype(owner,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		if(H && !(H.species.flags & NO_BLOOD))
			return 0
	return (status & ORGAN_BLEEDING) && !(status & ORGAN_ROBOT)

/obj/item/organ/proc/mutate()
	src.status |= ORGAN_MUTATED
	owner.update_body()

/obj/item/organ/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	owner.update_body()

/obj/item/organ/proc/is_malfunctioning()
	return ((status & ORGAN_ROBOT) && prob(brute_dam + burn_dam))

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_DESTROYED|ORGAN_MUTATED|ORGAN_DEAD))

//Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W
	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

/obj/item/organ/proc/roboticize()
	src.status &= ~(ORGAN_BROKEN|ORGAN_BLEEDING|ORGAN_SPLINTED|ORGAN_CUT_AWAY|ORGAN_ATTACHABLE|ORGAN_DESTROYED)
	src.status |= ORGAN_ROBOT
	name = "robotic [initial(name)]"

/obj/item/organ/external/roboticize()
	..()
	for(var/obj/item/organ/external/E in children)
		if(E)
			E.roboticize()
	for(var/obj/item/organ/internal/I in internal_organs)
		if(I)
			I.roboticize()