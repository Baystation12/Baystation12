// See specific map job files for valid jobs. They use types so cannot be compiled at this level.
/decl/cultural_info/education/nabber
	name = EDUCATION_NABBER_CMINUS
	description = "You have been trained to Xynergy Grade PLACEHOLDER."
	var/list/valid_jobs = list()
	var/list/hidden_valid_jobs = list(/datum/job/ai, /datum/job/cyborg)

/decl/cultural_info/education/nabber/New()
	..()

	// Make sure this will show up in the manifest and on IDs.
	education_suffix = " ([name])"

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

/decl/cultural_info/education/nabber/c
	name = EDUCATION_NABBER_C
	valid_jobs = list(/datum/job/janitor)

/decl/cultural_info/education/nabber/c/plus
	name = EDUCATION_NABBER_CPLUS

/decl/cultural_info/education/nabber/b
	name = EDUCATION_NABBER_B
	valid_jobs = list(/datum/job/bartender, /datum/job/chef)

/decl/cultural_info/education/nabber/b/minus
	name = EDUCATION_NABBER_BMINUS

/decl/cultural_info/education/nabber/b/plus
	name = EDUCATION_NABBER_BPLUS

/decl/cultural_info/education/nabber/a
	name = EDUCATION_NABBER_A
	valid_jobs = list(/datum/job/chemist, /datum/job/roboticist)

/decl/cultural_info/education/nabber/a/minus
	name = EDUCATION_NABBER_AMINUS

/decl/cultural_info/education/nabber/a/plus
	name = EDUCATION_NABBER_APLUS
