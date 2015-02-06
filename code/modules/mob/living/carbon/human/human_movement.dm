/mob/living/carbon/human/movement_delay()

	var/tally = 0

	if(species.slowdown)
		if(src.species.name == "Wryn")		//handles Wryn specific movement
			if(!istype(get_turf(src), /turf/space))		//Space is 20c whut..
				var/loc_temp = T0C
				var/datum/gas_mixture/environment = loc.return_air()
				if(istype(src.loc, /obj/mecha))
					var/obj/mecha/M = src.loc
					loc_temp =  M.return_temperature()
				else
					loc_temp = environment.temperature

				switch(loc_temp)			//messy switch statement to assign the proper speed
					if(0 to 213.15)			tally = -2	 //you deserve this, god speed to you
					if(213.15 to 250.15) 	tally = -1.2	 //must get colder..
					if(260.15 to 273.15)	tally = -0.8
					if(273.15 to 283.15) 	tally = 0	 //pretty fast, though will likely never happen
					if(283.15 to 300.15)	tally = 3	 //slower than humans at normal room temperatures
					if(300.15 to 310.15)	tally = 5
					if(317.15 to 400)		tally = 8
					else					tally = 12	//Stop running into fire you stupid bug
			else
				tally = -7
		else
			tally = species.slowdown

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if(reagents.has_reagent("hyperzine")) return -1

	if(reagents.has_reagent("nuka_cola")) return -1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if (!(species && (species.flags & NO_PAIN)))
		if(halloss >= 10) tally += (halloss / 10) //halloss shouldn't slow you down if you can't even feel it

	var/hungry = (500 - nutrition)/5 // So overeat would be 100 and default level would be 80
	if (hungry >= 70) tally += hungry/50

	if(wear_suit)
		tally += wear_suit.slowdown

	if(istype(buckled, /obj/structure/stool/bed/chair/wheelchair))
		for(var/organ_name in list("l_hand","r_hand","l_arm","r_arm"))
			var/datum/organ/external/E = get_organ(organ_name)
			if(!E || (E.status & ORGAN_DESTROYED))
				tally += 4
			if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5
	else
		if(shoes)
			tally += shoes.slowdown

		for(var/organ_name in list("l_foot","r_foot","l_leg","r_leg"))
			var/datum/organ/external/E = get_organ(organ_name)
			if(!E || (E.status & ORGAN_DESTROYED))
				tally += 4
			if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if(shock_stage >= 10) tally += 3

	if(FAT in src.mutations)
		tally += 1.5
	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	return (tally+config.human_delay)

/mob/living/carbon/human/Process_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust
	if(back)
		if(istype(back,/obj/item/weapon/tank/jetpack))
			thrust = back
		else if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = back
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				thrust = module.jets
				break

	if(thrust)
		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

	//If no working jetpack then use the other checks
	if(..())
		return 1
	return 0


/mob/living/carbon/human/Process_Spaceslipping(var/prob_slip = 5)
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.

	if(species.flags & NO_SLIP)
		return

	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment, and also, make more sense.

	//Do we have magboots or such on if so no slip
	if(istype(shoes, /obj/item/clothing/shoes/magboots) && (shoes.flags & NOSLIP))
		prob_slip = 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= 2)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= 2)	prob_slip -= 1

	prob_slip = round(prob_slip)
	return(prob_slip)
