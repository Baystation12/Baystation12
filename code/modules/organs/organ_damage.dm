/obj/item/organ/emp_act(severity)
	if(status & ORGAN_ROBOT)
		switch (severity)
			if (1.0)
				take_damage(40,0)
				return
			if (2.0)
				take_damage(15,0)
				return
			if(3.0)
				take_damage(10,0)
				return

/obj/item/organ/proc/heal_damage(var/new_brute, var/new_burn)
	brute_dam = max(0,brute_dam-new_brute)
	burn_dam = max(0,burn_dam-new_burn)
	update_health()

/obj/item/organ/proc/take_damage(var/brute = 0, var/burn = 0)
	if(status & ORGAN_ROBOT)
		brute *= 0.8
		burn *= 0.8
	brute_dam += brute
	burn_dam += burn
	update_health()

/obj/item/organ/external/take_damage(var/brute, var/burn, var/sharp, var/edge)

	world << "Hit with [brute] brute [burn] burn [sharp] sharp [edge] edge."

	var/datum/wound/wound
	if(wounds.len && prob(wounds.len*10))
		owner.visible_message("Picked an existing wound.")
		wound = pick(wounds)

	if(!wound || wound.status == WOUND_CLOSED || wound.status == WOUND_SUTURED)
		owner.visible_message("No wound or unsuitable, new wound.")
		wound = new(owner)

	// Edge represents the total contact area of the weapon.
	// Sharp represents arbitrary weapon sharpness.
	var/wound_depth = 0
	var/list/tissue_strings = owner.species.tissues // Easier to write.

	if(wound.depth>0)
		wound_depth = wound.depth

	if(!tissues.len)
		return // This should NEVER happen.

	if(!sharp) sharp = 1
	if(!edge)  edge = 1

	var/impact_force = round((brute*sharp)/edge)
	var/damage_description_string = ""
	var/can_cut_surface = 0
	var/datum/tissue/tissue = tissues[tissue_strings[max(wound_depth,1)]]

	// Just assume we can damage the top layer for the sake of sanity.
	if(tissue.can_cut_with(sharp))
		can_cut_surface = 1

	// Get the depth of the resulting wound.
	for(var/x = max(wound_depth,1);x<=tissue_strings.len;x++)
		if(impact_force <= 1)
			break
		tissue = tissues[tissue_strings[x]]
		if(prob(impact_force))
			if(can_cut_surface)
				if(tissue.can_cut_with(sharp))
					damage_description_string += "cut through [tissue.descriptors[limb_name] ? tissue.descriptors[limb_name] : tissue.descriptor] ([pick(tissue.edge_damage_strings)]), "
					impact_force = round(impact_force*0.5)
					wound_depth++
					continue
			else
				damage_description_string += "bruised [tissue.descriptors[limb_name] ? tissue.descriptors[limb_name] : tissue.descriptor] ([pick(tissue.blunt_damage_strings)]),"
				impact_force = round(impact_force*0.75)
				wound_depth++
				continue
		break

	if(!isnull(damage_description_string) && damage_description_string != "")
		owner.visible_message("<span class='danger'>[damage_description_string]</span>")

	wound.expand((can_cut_surface ? WOUND_CUT : WOUND_BRUISE), edge, max(1,min(tissue_strings.len,wound_depth)))
	wounds |= wound
	update_health()

/obj/item/organ/internal/take_damage()
	..()
	if(!istype(owner))
		return
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(prob(5))
		owner.custom_pain("Something inside your [parent] hurts a lot.", 1)

/obj/item/organ/proc/set_damage(var/new_brute, var/new_burn)
	brute_dam = new_brute
	burn_dam = new_burn
	update_health()

/obj/item/organ/proc/update_health()
	var/max_health = initial(health)
	health = min(max(0,(max_health-(brute_dam+burn_dam))),max_health)
	if(health == 0)
		die()

/obj/item/organ/proc/die()
	status |= ORGAN_DEAD
	health = 0
	processing_objects -= src
	//TODO: Grey out the icon state.
	//TODO: Inject an organ with peridaxon to make it alive again.

/obj/item/organ/internal/die()
	..()
	if(dead_icon) icon_state = dead_icon

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/proc/rejuvenate()
	if(status & ORGAN_ROBOT)
		status = ORGAN_ROBOT
	else
		status = 0
	germ_level = 0
	set_damage(0,0)

/obj/item/organ/proc/is_damaged()
	if(max_health == health)
		return 0
	return max_health - health

/obj/item/organ/external/proc/fracture()

	if(status & ORGAN_BROKEN)
		return

	owner.visible_message(\
		"<span class='danger'>You hear a loud cracking sound coming from \the [owner].</span>",\
		"<span class='danger'><b>Something feels like it shattered in your [src.name]!</b></span>",\
		"You hear a sickening crack.")

	if(owner.species && !(owner.species.flags & NO_PAIN))
		owner.emote("scream")

	status |= ORGAN_BROKEN

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.
	if(!(status & ORGAN_SPLINTED) && istype(owner,/mob/living/carbon/human))

		var/mob/living/carbon/human/H = owner

		if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))

			var/obj/item/clothing/suit/space/suit = H.wear_suit

			if(isnull(suit.supporting_limbs))
				return

			owner << "You feel \the [suit] constrict about your [src.name], supporting it."
			status |= ORGAN_SPLINTED
			suit.supporting_limbs |= src
	return

/obj/item/organ/external/proc/mend_fracture()
	//if(status & ORGAN_ROBOT)
	//	return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * config.organ_health_multiplier)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN
	return 1