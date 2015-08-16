//Returns 1 if mob can be infected, 0 otherwise.
proc/infection_check(var/mob/living/carbon/M, var/vector = "Airborne")
	if (!istype(M))
		return 0

	var/protection = M.getarmor(null, "bio")	//gets the full body bio armour value, weighted by body part coverage.
	var/score = round(0.06*protection) 			//scales 100% protection to 6.

	switch(vector)
		if("Airborne")
			if(M.internal)
				score = 6	//not breathing infected air helps greatly
				var/obj/item/I = M.wear_mask

				//masks provide a small bonus and can replace overall bio protection
				if(I)
					score = max(score, round(0.06*I.armor["bio"]))
					if (istype(I, /obj/item/clothing/mask))
						score += 1 //this should be added after

		if("Contact")
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M

				//gloves provide a larger bonus
				if (istype(H.gloves, /obj/item/clothing/gloves))
					score += 2

	if(score >= 6)
		return 0
	else if(score >= 5 && prob(99))
		return 0
	else if(score >= 4 && prob(95))
		return 0
	else if(score >= 3 && prob(75))
		return 0
	else if(score >= 2 && prob(55))
		return 0
	else if(score >= 1 && prob(35))
		return 0
	return 1

//Similar to infection check, but used for when M is spreading the virus.
/proc/infection_spreading_check(var/mob/living/carbon/M, var/vector = "Airborne")
	if (!istype(M))
		return 0

	var/protection = M.getarmor(null, "bio")	//gets the full body bio armour value, weighted by body part coverage.

	if (vector == "Airborne")
		var/obj/item/I = M.wear_mask
		if (istype(I))
			protection = max(protection, I.armor["bio"])

	return prob(protection)

//Checks if table-passing table can reach target (5 tile radius)
proc/airborne_can_reach(turf/source, turf/target)
	var/obj/dummy = new(source)
	dummy.pass_flags = PASSTABLE

	for(var/i=0, i<5, i++) if(!step_towards(dummy, target)) break

	var/rval = dummy.Adjacent(target)
	dummy.loc = null
	dummy = null
	return rval

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
	if(M.reagents.has_reagent("spaceacillin"))
		return

	if(!disease.affected_species.len)
		return

	if (!(M.species.get_bodytype() in disease.affected_species))
		if (forced)
			disease.affected_species[1] = M.species.get_bodytype()
		else
			return //not compatible with this species

//	log_debug("Infecting [M]")

	if(forced || (infection_check(M, disease.spreadtype) && prob(disease.infectionchance)))
		var/datum/disease2/disease/D = disease.getcopy()
		D.minormutate()
//		log_debug("Adding virus")
		M.virus2["[D.uniqueID]"] = D
		BITSET(M.hud_updateflag, STATUS_HUD)


//Infects mob M with disease D
/proc/infect_mob(var/mob/living/carbon/M, var/datum/disease2/disease/D)
	infect_virus2(M,D,1)
	M.hud_updateflag |= 1 << STATUS_HUD

//Infects mob M with random lesser disease, if he doesn't have one
/proc/infect_mob_random_lesser(var/mob/living/carbon/M)
	var/datum/disease2/disease/D = new /datum/disease2/disease

	D.makerandom(1)
	infect_mob(M, D)

//Infects mob M with random greated disease, if he doesn't have one
/proc/infect_mob_random_greater(var/mob/living/carbon/M)
	var/datum/disease2/disease/D = new /datum/disease2/disease

	D.makerandom(2)
	infect_mob(M, D)

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
			var/obj/item/organ/external/select_area = H.get_organ(src.zone_sel.selecting)
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
