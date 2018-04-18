/datum/objective/hunter_flood
	explanation_text = "Vent at least half of the human settlement. Choke them in their den."

/datum/objective/hunter_flood/check_completion()
	var/list/station_zones = list()
	var/vent_count = 0
	for(var/thing in stationlocs)
		var/area/A = thing
		for(var/turf/simulated/T in A.contents)
			if(T.zone && !station_zones[T.zone])
				station_zones[T.zone] = 1
				if(T.zone.air.total_moles <= 50 || T.zone.air.gas["oxygen"] < 10)
					vent_count++
	return vent_count >= round(station_zones.len/2)

/datum/objective/hunter_depower
	explanation_text = "Destroy any power infrastructure in the human settlement and leave it in darkness."

/datum/objective/hunter_depower/check_completion()
	var/total_area_count = 0
	var/depower_count = 0
	for(var/thing in stationlocs)
		var/area/A = thing
		if(A.requires_power)
			total_area_count++
			if(!A.get_apc() || (!A.power_light && !A.power_equip && !A.power_environ))
				depower_count++
	return (depower_count >= round(total_area_count/2))

/datum/objective/hunter_purge
	explanation_text = "Purge the human settlement of life. Kill or displace at least half of the primitives living there."

/datum/objective/hunter_purge/check_completion()
	var/human_count = 0
	var/dead_human_count = 0
	for(var/mob/living/carbon/human/H in (GLOB.dead_mob_list_ + GLOB.living_mob_list_))
		if(H.species.name in (GLOB.hunters.queen_species|GLOB.hunters.soldier_species))
			continue
		human_count++
		if(H.stat == DEAD)
			dead_human_count++
		else
			var/turf/T = get_turf(H)
			if(T && is_type_in_list(T.loc, GLOB.using_map.post_round_safe_areas))
				human_count++
	return (dead_human_count >= round(human_count/2))

/datum/objective/hunter_preserve_gyne
	explanation_text = "Preserve the lives of any queens present."

/datum/objective/hunter_preserve_gyne/check_completion()
	var/queen_count = 0
	for(var/mob/living/carbon/human/H in (GLOB.dead_mob_list_ + GLOB.living_mob_list_))
		if((H.species.name in GLOB.hunters.queen_species) && H.stat != DEAD)
			queen_count++
	return (queen_count >= GLOB.hunters.queen_count)

/datum/objective/hunter_preserve_alates
	explanation_text = "Preserve the lives of at least half of the soldiers present."

/datum/objective/hunter_preserve_alates/check_completion()
	var/soldier_count = 0
	for(var/mob/living/carbon/human/H in (GLOB.dead_mob_list_ + GLOB.living_mob_list_))
		if((H.species.name in GLOB.hunters.soldier_species) && H.stat != DEAD)
			soldier_count++
	return (soldier_count >= round(GLOB.hunters.soldier_count/2))