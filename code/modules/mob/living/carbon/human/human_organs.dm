/mob/living/carbon/human/var/list/organs = list()
/mob/living/carbon/human/var/list/organs_by_name = list() // map organ names to organs
/mob/living/carbon/human/var/list/internal_organs_by_name = list() // so internal organs have less ickiness too

//Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/datum/reagent/A in reagents.reagent_list)
		var/obj/item/organ/O = pick(organs)
		O.trace_chemicals[A.name] = 100

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs()

	number_wounds = 0
	var/force_process = 0
	var/damage_this_tick = getBruteLoss() + getFireLoss() + getToxLoss()
	if(damage_this_tick > last_dam)
		force_process = 1
	last_dam = damage_this_tick
	if(force_process)
		bad_external_organs.Cut()
		for(var/obj/item/organ/external/Ex in organs)
			bad_external_organs += Ex

	//processing internal organs is pretty cheap, do that first.
	for(var/obj/item/organ/internal/I in internal_organs)
		I.process()

	//losing a limb stops it from processing, so this has to be done separately
	handle_stance()

	if(!force_process && !bad_external_organs.len)
		return

	for(var/obj/item/organ/external/E in bad_external_organs)
		if(!E)
			continue
		if(!E.need_process())
			bad_external_organs -= E
			continue
		else
			if(bodytemperature >= 170) //Cryo stops organ processing.
				E.process_internal()

			if (!lying && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (E.is_broken() && E.internal_organs && prob(15))
					var/obj/item/organ/internal/I = pick(E.internal_organs)
					custom_pain("You feel broken bones moving in your [E]!", 1)
					I.take_damage(rand(3,5))

				//Moving makes open wounds get infected much faster
				//if (E.wounds.len)
				//	for(var/datum/wound/W in E.wounds)
				//		if (W.infection_check())
				//			W.germ_level += 1

/mob/living/carbon/human/proc/handle_stance()
	// Don't need to process any of this if they aren't standing anyways
	// unless their stance is damaged, and we want to check if they should stay down
	if (!stance_damage && (lying || resting) && (life_tick % 4) == 0)
		return

	stance_damage = 0

	// Buckled to a bed/chair. Stance damage is forced to 0 since they're sitting on something solid
	if (istype(buckled, /obj/structure/stool/bed))
		return

	for (var/organ in list("l_leg","l_foot","r_leg","r_foot"))
		var/obj/item/organ/external/E = organs_by_name[organ]
		if(!E)
			stance_damage += 2
		else if (E.status & ORGAN_DESTROYED)
			stance_damage += 2 // let it fail even if just foot&leg
		else if (E.is_malfunctioning() || (E.is_broken() && !(E.status & ORGAN_SPLINTED)) || !E.is_usable())
			stance_damage += 1

	// Canes and crutches help you stand (if the latter is ever added)
	// One cane mitigates a broken leg+foot, or a missing foot.
	// Two canes are needed for a lost leg. If you are missing both legs, canes aren't gonna help you.
	if (istype(l_hand, /obj/item/weapon/cane))
		stance_damage -= 2
	if (istype(l_hand, /obj/item/weapon/cane))
		stance_damage -= 2

	// standing is poor
	if(stance_damage >= 4 || (stance_damage >= 2 && prob(5)))
		if(!(lying || resting))
			if(species && !(species.flags & NO_PAIN))
				emote("scream")
			custom_emote(1, "collapses!")
		Weaken(5) //can't emote while weakened, apparently.