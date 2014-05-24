datum/directive/bluespace_contagion
	var/infection_count = 5
	var/list/infected = list()

datum/directive/bluespace_contagion/get_description()
	return {"
		<p>
			A manufactured and near-undetectable virus is spreading on NanoTrasen stations.
			The pathogen travels by bluespace after maturing for one day.
			No treatment has yet been discovered. Personnel onboard [station_name()] have been infected. Further information is classified.
		</p>
	"}

datum/directive/bluespace_contagion/initialize()
	var/list/candidates = list()
	
	for (var/mob/living/M in player_list)
		if (is_valid_candidate(M))
			candidates += M
	
	infection_count = min(infection_count, candidates.len)
	
	var/list/infected_names = list()
	for(var/i=0, i < infection_count, i++)
		if(!candidates.len)
			break

		var/mob/living/carbon/human/candidate = pick(candidates)
		candidates-=candidate
		infected+=candidate
		infected_names+="[candidate.mind.assigned_role] [candidate.mind.name]"

	special_orders = list(
		"Quarantine these personnel: [list2text(infected_names, ", ")].",
		"Allow one hour for a cure to be manufactured.",
		"If no cure arrives after that time, execute the infected.")

datum/directive/bluespace_contagion/proc/is_valid_candidate(mob/M)
	//don't select observers, dead, or disconnected people
	if(istype(M, /mob/new_player) || !M.client || M.stat == DEAD)
		return 0
	
	//don't allow AI, robots, simple_animals and the like
	if(!istype(M, /mob/living/carbon))
		return 0
	
	return 1

datum/directive/bluespace_contagion/meets_prerequisites()
	return player_list.len >= 7		//would be better to count the number of valid candidates but I don't know if that is possible here.

datum/directive/bluespace_contagion/directives_complete()
	return infected.len == 0

/hook/death/proc/infected_killed(mob/living/carbon/human/deceased, gibbed)
	var/datum/directive/bluespace_contagion/D = get_directive("bluespace_contagion")
	if(!D) return 1

	if(deceased in D.infected)
		D.infected-=deceased
	return 1
