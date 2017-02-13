/datum/unit_test/jobs_shall_have_a_valid_outfit_type
	name = "JOB: Shall have a valid outfit type"

/datum/unit_test/jobs_shall_have_a_valid_outfit_type/start_test()
	var/failed_jobs = 0

	for (var/occ in job_master.occupations)
		var/datum/job/occupation = occ
		var/decl/hierarchy/outfit/job/outfit = outfit_by_type(occupation.outfit_type)
		if(!istype(outfit))
			log_bad("[occupation.title] - [occupation.type]: Invalid outfit type [outfit ? outfit.type : "NULL"].")
			failed_jobs++

	if(failed_jobs)
		fail("[failed_jobs] job\s with invalid outfit type.")
	else
		pass("All jobs had outfit types.")
	return 1

/datum/unit_test/jobs_shall_have_a_HUD_icon
	name = "JOB: Shall have a HUD icon"

/datum/unit_test/jobs_shall_have_a_HUD_icon/start_test()
	var/failed_jobs = 0
	var/failed_sanity_checks = 0
	var/job_icons = get_all_job_icons()
	var/job_huds = icon_states(using_map.id_hud_icons)

	if(!("" in job_huds))
		log_bad("Sanity Check - Missing default/unnamed HUD icon")
		failed_sanity_checks++

	if(!("hudunknown" in job_huds))
		log_bad("Sanity Check - Missing HUD icon: hudunknown")
		failed_sanity_checks++

	if(!("hudcentcom" in job_huds))
		log_bad("Sanity Check - Missing HUD icon: hudcentcom")
		failed_sanity_checks++

	for (var/occ in job_master.occupations)
		var/datum/job/occupation = occ
		if(!(occupation.title in job_icons)) // Not a job role for this map or at least defaults to "hudunknown"
			continue

		var/hud_icon_state = "hud[ckey(occupation.title)]"
		if(!(hud_icon_state in job_huds))
			log_bad("[occupation.title] - [occupation.type] - Missing HUD icon: [hud_icon_state]")
			failed_jobs++

	if(failed_sanity_checks || failed_jobs)
		fail("[using_map.id_hud_icons] - [failed_sanity_checks] failed sanity check\s, [failed_jobs] job\s with missing HUD icon.")
	else
		pass("All jobs have a HUD icon.")
	return 1
