#define SPECIAL -1
#define NON_CONTAGIOUS 0
#define BLOOD 1
#define CONTACT_FEET 2
#define CONTACT_HANDS 3
#define CONTACT_GENERAL 4
#define AIRBORNE 5

#define SCANNER 1
#define PANDEMIC 2

/*

IMPORTANT NOTE: Please delete the diseases by using cure() proc or del() instruction.
Diseases are referenced in a global list, so simply setting mob or obj vars
to null does not delete the object itself. Thank you.

*/

var/list/diseases = typesof(/datum/disease) - /datum/disease


/datum/disease
	var/form = "Virus" //During medscans, what the disease is referred to as
	var/name = "No disease"
	var/stage = 1 //all diseases start at stage 1
	var/max_stages = 0.0
	var/cure = null
	var/cure_id = null// reagent.id or list containing them
	var/cure_list = null // allows for multiple possible cure combinations
	var/cure_chance = 8//chance for the cure to do its job
	var/spread = null //spread type description
	var/initial_spread = null
	var/spread_type = AIRBORNE
	var/contagious_period = 0//the disease stage when it can be spread
	var/list/affected_species = list()
	var/mob/living/carbon/affected_mob = null //the mob which is affected by disease.
	var/holder = null //the atom containing the disease (mob or obj)
	var/carrier = 0.0 //there will be a small chance that the person will be a carrier
	var/curable = 0 //can this disease be cured? (By itself...)
	var/list/strain_data = list() //This is passed on to infectees
	var/stage_prob = 4		// probability of advancing to next stage, default 4% per check
	var/agent = "some microbes"//name of the disease agent
	var/permeability_mod = 1//permeability modifier coefficient.
	var/desc = null//description. Leave it null and this disease won't show in med records.
	var/severity = null//severity descr
	var/longevity = 150//time in "ticks" the virus stays in inanimate object (blood stains, corpses, etc). In syringes, bottles and beakers it stays infinitely.
	var/list/hidden = list(0, 0)
	var/can_carry = 1 // If the disease allows "carriers".
	var/age = 0 // age of the disease in the current mob
	var/stage_minimum_age = 0 // how old the disease must be to advance per stage
	// if hidden[1] is true, then virus is hidden from medical scanners
	// if hidden[2] is true, then virus is hidden from PANDEMIC machine

/datum/disease/proc/stage_act()
	age++
	var/cure_present = has_cure()
	//world << "[cure_present]"

	if(carrier&&!cure_present)
		//world << "[affected_mob] is carrier"
		return

	spread = (cure_present?"Remissive":initial_spread)
	if(stage > max_stages)
		stage = max_stages

	if(!cure_present && prob(stage_prob) && age > stage_minimum_age) //now the disease shouldn't get back up to stage 4 in no time
		stage = min(stage + 1, max_stages)
		age = 0

	else if(cure_present && prob(cure_chance))
		stage = max(stage - 1, 1)

	if(stage <= 1 && ((prob(1) && curable) || (cure_present && prob(cure_chance))))
		cure()
		return
	return

/datum/disease/proc/has_cure()//check if affected_mob has required reagents.
	if(!cure_id) return 0
	var/result = 1
	if(cure_list == list(cure_id))
		if(istype(cure_id, /list))
			for(var/C_id in cure_id)
				if(!affected_mob.reagents.has_reagent(C_id))
					result = 0
		else if(!affected_mob.reagents.has_reagent(cure_id))
			result = 0
	else
		for(var/C_list in cure_list)
			if(istype(C_list, /list))
				for(var/C_id in cure_id)
					if(!affected_mob.reagents.has_reagent(C_id))
						result = 0
			else if(!affected_mob.reagents.has_reagent(C_list))
				result = 0

	return result

/datum/disease/proc/spread_by_touch()
	switch(spread_type)
		if(CONTACT_FEET, CONTACT_HANDS, CONTACT_GENERAL)
			return 1
	return 0

/datum/disease/proc/spread(var/atom/source=null, var/airborne_range = 2,  var/force_spread)
	//world << "Disease [src] proc spread was called from holder [source]"

	// If we're overriding how we spread, say so here
	var/how_spread = spread_type
	if(force_spread)
		how_spread = force_spread

	if(how_spread == SPECIAL || how_spread == NON_CONTAGIOUS || how_spread == BLOOD)//does not spread
		return

	if(stage < contagious_period) //the disease is not contagious at this stage
		return

	if(!source)//no holder specified
		if(affected_mob)//no mob affected holder
			source = affected_mob
		else //no source and no mob affected. Rogue disease. Break
			return

	if(affected_mob)
		if(affected_mob.reagents.has_reagent("spaceacillin"))
			return // Don't spread if we have spaceacillin in our system.

	var/check_range = airborne_range//defaults to airborne - range 2

	if(how_spread != AIRBORNE && how_spread != SPECIAL)
		check_range = 1 // everything else, like infect-on-contact things, only infect things on top of it

	if(isturf(source.loc))
		for(var/mob/living/carbon/M in oview(check_range, source))
			if(isturf(M.loc))
				if(AStar(source.loc, M.loc, /turf/proc/AdjacentTurfs, /turf/proc/Distance, check_range))
					M.contract_disease(src, 0, 1, force_spread)

	return


/datum/disease/proc/process()
	if(!holder)
		active_diseases -= src
		return
	if(prob(65))
		spread(holder)

	if(affected_mob)
		for(var/datum/disease/D in affected_mob.viruses)
			if(D != src)
				if(IsSame(D))
					//error("Deleting [D.name] because it's the same as [src.name].")
					del(D) // if there are somehow two viruses of the same kind in the system, delete the other one

	if(holder == affected_mob)
		if(affected_mob.stat != DEAD) //he's alive
			stage_act()
		else //he's dead.
			if(spread_type!=SPECIAL)
				spread_type = CONTACT_GENERAL
			affected_mob = null
	if(!affected_mob) //the virus is in inanimate obj
//		world << "[src] longevity = [longevity]"

		if(prob(70))
			if(--longevity<=0)
				cure(0)
	return

/datum/disease/proc/cure(var/resistance=1)//if resistance = 0, the mob won't develop resistance to disease
	if(affected_mob)
		if(resistance && !(type in affected_mob.resistances))
			var/saved_type = "[type]"
			affected_mob.resistances += text2path(saved_type)
		/*if(istype(src, /datum/disease/alien_embryo))	//Get rid of the infection flag if it's a xeno embryo.
			affected_mob.status_flags &= ~(XENO_HOST)*/
		affected_mob.viruses -= src		//remove the datum from the list
	del(src)	//delete the datum to stop it processing
	return


/datum/disease/New(var/process=1, var/datum/disease/D)//process = 1 - adding the object to global list. List is processed by master controller.
	cure_list = list(cure_id) // to add more cures, add more vars to this list in the actual disease's New()
	if(process)				 // Viruses in list are considered active.
		active_diseases += src
	initial_spread = spread

/datum/disease/proc/IsSame(var/datum/disease/D)
	if(istype(src, D.type))
		return 1
	return 0

/datum/disease/proc/Copy(var/process = 0)
	return new type(process, src)

/*
/datum/disease/Del()
	active_diseases.Remove(src)
*/
