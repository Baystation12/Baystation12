//Returns 1 if mob can be infected, 0 otherwise.
proc/infection_chance(var/mob/living/carbon/M, var/vector = "Airborne")
	if (!istype(M))
		return 0

	var/mob/living/carbon/human/H = M
	if(istype(H) && H.species.get_virus_immune(H))
		return 0

	var/protection = M.getarmor(null, "bio")	//gets the full body bio armour value, weighted by body part coverage.
	var/score = round(0.06*protection) 			//scales 100% protection to 6.

	switch(vector)
		if("Airborne")
			if(M.internal) //not breathing infected air helps greatly
				return 0
			var/obj/item/I = M.wear_mask
			//masks provide a small bonus and can replace overall bio protection
			if(I)
				score = max(score, round(0.06*I.armor["bio"]))
				if (istype(I, /obj/item/clothing/mask))
					score += 1 //this should be added after

		if("Contact")
			if(istype(H))
				//gloves provide a larger bonus
				if (istype(H.gloves, /obj/item/clothing/gloves))
					score += 2

	switch(score)
		if (6 to INFINITY)
			return 0
		if (5)
			return 1
		if (4)
			return 5
		if (3)
			return 25
		if (2)
			return 45
		if (1)
			return 65
		else
			return 100

//Similar to infection check, but used for when M is spreading the virus.
/proc/infection_spreading_check(var/mob/living/carbon/M, var/vector = "Airborne")
	if (!istype(M))
		return 0

	var/protection = M.getarmor(null, "bio")	//gets the full body bio armour value, weighted by body part coverage.

	if (vector == "Airborne")	//for airborne infections face-covering items give non-weighted protection value.
		if(M.internal)
			return 1
		protection = max(protection, M.getarmor(FACE, "bio"))

	return prob(protection)

/proc/airborne_can_reach(turf/simulated/source, turf/simulated/target)
	//Can't ariborne without air
	if(is_below_sound_pressure(source) || is_below_sound_pressure(target))
		return FALSE
	//no infecting from other side of the hallway
	if(get_dist(source,target) > 5)
		return FALSE
	if(istype(source) && istype(target))
		return source.zone == target.zone

//Attemptes to infect mob M with virus. Set forced to 1 to ignore protective clothnig
/proc/infect_virus2(var/mob/living/carbon/M,var/datum/disease2/disease/disease,var/forced = 0)
	if(!istype(disease))
//		log_debug("Bad virus")
		return
	if(!istype(M))
//		log_debug("Bad mob")
		return
	if ("[disease.uniqueID]" in M.virus2)
		return
	// if one of the antibodies in the mob's body matches one of the disease's antigens, don't infect
	var/list/antibodies_in_common = M.antibodies & disease.antigen
	if(antibodies_in_common.len)
		return
	if(prob(100 * M.reagents.get_reagent_amount("spaceacillin") / (REAGENTS_OVERDOSE/2)))
		return

	if(!disease.affected_species.len)
		return

	if (!(M.species.get_bodytype(M) in disease.affected_species))
		if (forced)
			disease.affected_species[1] = M.species.get_bodytype(M)
		else
			return //not compatible with this species

//	log_debug("Infecting [M]")
	var/mob_infection_prob = infection_chance(M, disease.spreadtype) * M.immunity_weakness()
	if(forced || (prob(disease.infectionchance) && prob(mob_infection_prob)))
		var/datum/disease2/disease/D = disease.getcopy()
		D.minormutate()
//		log_debug("Adding virus")
		M.virus2["[D.uniqueID]"] = D
		BITSET(M.hud_updateflag, STATUS_HUD)

//Infects mob M with random lesser disease, if he doesn't have one
/proc/infect_mob_random_lesser(var/mob/living/carbon/M)
	var/datum/disease2/disease/D = new /datum/disease2/disease

	D.makerandom(VIRUS_MILD)
	infect_virus2(M, D, 1)

//Infects mob M with random greated disease, if he doesn't have one
/proc/infect_mob_random_greater(var/mob/living/carbon/M)
	var/datum/disease2/disease/D = new /datum/disease2/disease

	D.makerandom(VIRUS_COMMON)
	infect_virus2(M, D, 1)

//Fancy prob() function.
/proc/dprob(var/p)
	return(prob(sqrt(p)) && prob(sqrt(p)))

/mob/living/carbon/proc/spread_disease_to(var/mob/living/carbon/victim, var/vector = "Airborne")
	if (src == victim)
		return "retardation"

//	log_debug("Spreading [vector] diseases from [src] to [victim]")
	if (virus2.len > 0)
		for (var/ID in virus2)
//			log_debug("Attempting virus [ID]")
			var/datum/disease2/disease/V = virus2[ID]
			if(V.spreadtype != vector) continue

			//It's hard to get other people sick if you're in an airtight suit.
			if(!infection_spreading_check(src, V.spreadtype)) continue

			if (vector == "Airborne")
				if(airborne_can_reach(get_turf(src), get_turf(victim)))
//					log_debug("In range, infecting")
					infect_virus2(victim,V)
//				else
//					log_debug("Could not reach target")

			if (vector == "Contact")
				if (Adjacent(victim))
//					log_debug("In range, infecting")
					infect_virus2(victim,V)

	//contact goes both ways
	if (victim.virus2.len > 0 && vector == "Contact" && Adjacent(victim))
//		log_debug("Spreading [vector] diseases from [victim] to [src]")
		var/nudity = 1

		if (ishuman(victim))
			var/mob/living/carbon/human/H = victim

			//Allow for small chance of touching other zones.
			//This is proc is also used for passive spreading so just because they are targeting
			//that zone doesn't mean that's necessarily where they will touch.
			var/touch_zone = zone_sel ? zone_sel.selecting : "chest"
			touch_zone = ran_zone(touch_zone, 80)
			var/obj/item/organ/external/select_area = H.get_organ(touch_zone)
			if(!select_area)
				//give it one more chance, since this is also called for passive spreading
				select_area = H.get_organ(ran_zone())

			if(!select_area)
				nudity = 0 //cant contact a missing body part
			else
				var/list/clothes = list(H.head, H.wear_mask, H.wear_suit, H.w_uniform, H.gloves, H.shoes)
				for(var/obj/item/clothing/C in clothes)
					if(C && istype(C))
						if(C.body_parts_covered & select_area.body_part)
							nudity = 0
		if (nudity)
			for (var/ID in victim.virus2)
				var/datum/disease2/disease/V = victim.virus2[ID]
				if(V && V.spreadtype != vector) continue
				if(!infection_spreading_check(victim, V.spreadtype)) continue
				infect_virus2(src,V)
