// See specific map job files for valid jobs. They use types so cannot be compiled at this level.
/decl/cultural_info/culture/nabber
	name = CULTURE_NABBER_CMINUS

	description = "You have been trained to Xynergy Grade PLACEHOLDER."
	language = LANGUAGE_NABBER
	secondary_langs = list(
		LANGUAGE_HUMAN_EURO,
		LANGUAGE_SPACER,
	)
	var/list/valid_jobs = list()
	var/list/hidden_valid_jobs = list(/datum/job/ai, /datum/job/cyborg)
	var/title_suffix

/decl/cultural_info/culture/nabber/get_formal_name_suffix()
	return title_suffix

/decl/cultural_info/culture/nabber/New()
	..()

	// Make sure this will show up in the manifest and on IDs.
	title_suffix = " ([name])"

	// Update our desc based on available jobs for this rank.
	var/list/job_titles = list()
	for(var/jobtype in valid_jobs)
		var/datum/job/job = jobtype
		LAZYADD(job_titles, initial(job.title))
	if(!LAZYLEN(job_titles))
		LAZYADD(job_titles, "none")
	description = "You have been trained by Xynergy to [name]. This makes you suitable for the following roles: [english_list(job_titles)]."

	// Set up our qualifications.
	LAZYADD(qualifications, "<b>[name]</b>")
	for(var/role in job_titles)
		LAZYADD(qualifications, "Safe for [role].")

	// Add our hidden jobs since we're done building the desc.
	if(LAZYLEN(hidden_valid_jobs))
		LAZYADD(valid_jobs, hidden_valid_jobs)

/decl/cultural_info/culture/nabber/c
	name = CULTURE_NABBER_C
	valid_jobs = list(/datum/job/janitor)

/decl/cultural_info/culture/nabber/c/plus
	name = CULTURE_NABBER_CPLUS

/decl/cultural_info/culture/nabber/b
	name = CULTURE_NABBER_B
	valid_jobs = list(/datum/job/chef)

/decl/cultural_info/culture/nabber/b/minus
	name = CULTURE_NABBER_BMINUS

/decl/cultural_info/culture/nabber/b/plus
	name = CULTURE_NABBER_BPLUS

/decl/cultural_info/culture/nabber/a
	name = CULTURE_NABBER_A
	valid_jobs = list(/datum/job/chemist, /datum/job/roboticist)

/decl/cultural_info/culture/nabber/a/minus
	name = CULTURE_NABBER_AMINUS

/decl/cultural_info/culture/nabber/a/plus
	name = CULTURE_NABBER_APLUS
