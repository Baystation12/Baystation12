#define JOBWHITELISTFILE "config/jobwhitelist.txt"

GLOBAL_LIST_EMPTY(job_whitelist_list)

/hook/startup/proc/loadJobWhitelist()
	if(config.job_whitelist)
		load_job_whitelist()
		if(!LAZYLEN(GLOB.job_whitelist_list))
			config.job_whitelist = FALSE
			error("The whitelist system could not find any whitelist entities. The whitelist system will now disable itself.")
	else
		to_world_log("Whitelists are not enabled. They will not be loaded.")

	return TRUE

/proc/load_job_whitelist()
	if(fexists(JOBWHITELISTFILE))
		GLOB.job_whitelist_list = file2list(JOBWHITELISTFILE)
/proc/has_job_whitelist(var/client/C, var/datum/job/J)

	if(!C || !istype(C))
		error("has_job_whitelist() was called without a client. Please fix this.")
		return FALSE

	if(!J || !istype(J))
		error("has_job_whitelist() was called without a job. Please fix this.")
		return FALSE

	if(!config.job_whitelist)
		return TRUE

	if(!LAZYLEN(GLOB.job_whitelist_list)) //Its your fault if you turned the system on and didn't bother to setup whitelists.
		return TRUE

	if(check_rights(R_ADMIN, 0, C))
		return TRUE

	if(!J.is_whitelisted)
		return TRUE
	//Config File Whitelist
	//TODO: Make this a better fucking system that doesn't require having to go through every single fucking line like this. Holy fuck.
	for(var/s in GLOB.job_whitelist_list) //Everything here is converted to lowertext so people don't fuck it up
		if(lowertext(s) == lowertext("[C.ckey] - [J.title]"))
			return TRUE
		if(lowertext(s) == lowertext("[C.ckey] - All"))
			return TRUE

	return FALSE

#undef JOBWHITELISTFILE