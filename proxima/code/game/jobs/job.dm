/datum/job
	var/required_role = null //a role which necessery to join as the job. For an example, explorers cannot be without EL
	var/good_genome_prob = 10

/datum/job/proc/is_required_roles_filled()
	if(!required_role) return 1

	// Abstract submap jobs is not writing to SStrade.primary_job_datums
	if(istype(src, /datum/job/submap))
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.mind && M.mind.assigned_job && (M.mind.assigned_job.title in required_role))
				return 1

	for(var/datum/job/J in SSjobs.primary_job_datums)
		if(J.title in required_role)
			if(J.current_positions || !J.total_positions)
				return 1
//			else
//				return
