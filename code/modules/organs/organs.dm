/obj/item/organ
	icon = 'icons/mob/human_races/r_human.dmi'
	health = 50
	var/max_health = 0

	var/body_part                             // Part represented.
	var/mob/living/carbon/human/owner
	var/status = 0
	var/vital //Lose a vital limb, die immediately.
	var/parent_organ

	var/brute_dam = 0
	var/burn_dam = 0

	var/min_organ_damage = 0
	var/min_bruised_damage = 15
	var/min_broken_damage = 30

	var/list/datum/autopsy_data/autopsy_data = list()
	var/list/trace_chemicals = list() // traces of chemicals in the organ,
									  // links chemical IDs to number of ticks for which they'll stay in the blood

/obj/item/organ/New(var/mob/living/carbon/H, var/spawn_robotic)
	..()
	max_health = initial(health)
	create_reagents(5)
	if(!H) //Stopgap to stop runtimes filling up log during testing
		del(src) // remove before merge
	owner = H
	if(!istype(H))
		return
	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type

	if(owner)
		processing_objects -= src
	else
		processing_objects |= src

	// Is this item prosthetic?
	if(spawn_robotic)
		roboticize()

	if(!istype(loc,/turf))
		germ_level = 0

/obj/item/organ/proc/heal_damage(var/new_brute, var/new_burn)
	brute_dam = max(0,brute_dam-new_brute)
	burn_dam = max(0,burn_dam-new_burn)
	update_health()

/obj/item/organ/proc/take_damage(var/brute, var/burn, var/sharp, var/edge, var/used_weapon = null, var/list/forbidden_limbs = list())
	if(status & ORGAN_ROBOT)
		brute *= 0.8
		burn *= 0.8
	brute_dam += brute
	burn_dam += burn
	update_health()
	return get_damage()

/obj/item/organ/proc/set_damage(var/new_brute, var/new_burn)
	brute_dam = new_brute
	burn_dam = new_burn
	update_health()

// This is distinct from health as it is used by several existing procs.
// Should be swapped over when all existing procs are adjusted to use
// new values.
/obj/item/organ/proc/get_damage()
	return brute_dam + burn_dam

/obj/item/organ/proc/update_health()
	var/max_health = initial(health)
	health = min(max(0,(max_health-(brute_dam+burn_dam))),max_health)
	if(health == 0)
		die()

/obj/item/organ/proc/removed(var/mob/living/user)
	germ_level = max(GERM_LEVEL_AMBIENT,germ_level)
	src.status &= ~(ORGAN_BROKEN|ORGAN_BLEEDING|ORGAN_SPLINTED|ORGAN_DEAD)

	var/turf/target_loc
	if(user)
		target_loc = get_turf(user)
	else
		target_loc = get_turf(owner)
	loc = target_loc
	if(!(status & ORGAN_ROBOT))
		processing_objects |= src

	owner.update_body(1)
	if(vital)
		owner.death()

/obj/item/organ/proc/roboticize()
	src.status &= ~(ORGAN_BROKEN|ORGAN_BLEEDING|ORGAN_SPLINTED|ORGAN_CUT_AWAY|ORGAN_ATTACHABLE|ORGAN_DESTROYED)
	src.status |= ORGAN_ROBOT
	name = "robotic [initial(name)]"

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/get_icon(var/icon/race_icon, var/icon/deform_icon)
	return icon('icons/mob/human.dmi',"blank")

//Germs
/obj/item/organ/proc/handle_antibiotics()
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (!germ_level || antibiotics < 5)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 6	//at germ_level == 500, this should cure the infection in a minute
	else
		germ_level -= 2 //at germ_level == 1000, this will cure the infection in 5 minutes

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

/obj/item/organ/Del()
	if(!(status & ORGAN_ROBOT)) processing_objects -= src
	..()

/obj/item/organ/proc/die()
	name = "dead [initial(name)]"
	status |= ORGAN_DEAD
	health = 0
	processing_objects -= src

	//TODO: Grey out the icon state.
	//TODO: Inject an organ with peridaxon to make it alive again.

/obj/item/organ/proc/process_internal()
	return

/obj/item/organ/process()
	if(status & (ORGAN_ROBOT|ORGAN_DEAD))
		processing_objects -= src
		return
	// Don't process if we're in a freezer, an MMI or a stasis bag. //TODO: ambient temperature?
	if(istype(loc,/obj/item/device/mmi) || istype(loc,/obj/item/bodybag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer))
		return

	if(health && prob(40))
		take_damage(rand(1,3),0)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		blood_splatter(src,B,1)


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

/obj/item/organ/proc/rejuvenate()
	set_damage(0,0)

/obj/item/organ/proc/is_bruised()
	return get_damage() <= min_bruised_damage

/obj/item/organ/proc/is_broken()
	return (get_damage() <= min_broken_damage) || (status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED))

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_DESTROYED|ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	owner = target
	src.loc = affected

/obj/item/organ/proc/createwound(var/type = CUT, var/damage)
	/*if(damage == 0) return

	//moved this before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if(damage > 15 && type != BURN && local_damage > 30 && prob(damage) && !(status & ORGAN_ROBOT))
		var/datum/wound/internal_bleeding/I = new (min(damage - 15, 15))
		wounds += I
		owner.custom_pain("You feel something rip in your [display_name]!", 1)

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(prob(25))
					//maybe have a separate message for BRUISE type damage?
					owner.visible_message(
					"<span class='danger'>The wound on [owner.name]'s [display_name] widens with a nasty ripping noise.</span>",\
					"<span class='danger'>The wound on your [display_name] widens with a nasty ripping noise.</span>",\
					"<span class='danger'>You hear a nasty ripping noise, as if flesh is being torn apart.</span>")
				return*/