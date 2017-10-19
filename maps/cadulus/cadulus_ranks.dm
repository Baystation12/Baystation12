/datum/map/torch
	branch_types = list(
		/datum/mil_branch/crew,
		/datum/mil_branch/pmc,
		/datum/mil_branch/other
	)

	spawn_branch_types = list(
		/datum/mil_branch/crew,
		/datum/mil_branch/pmc,
		/datum/mil_branch/other
	)

	species_to_branch_whitelist = list(
		/datum/species/tajaran = list()
	)

	species_to_branch_blacklist = list(
		/datum/species/diona   = list(/datum/mil_branch/pmc),
		/datum/species/nabber  = list(/datum/mil_branch/pmc,/datum/mil_branch/other)
	)


/*
 *  Branches
 *  ========
 */

/datum/mil_branch/crew
	name = "Crew"
	name_short = "crw"
	email_domain = "mail.cadulus.tu"

	assistant_job = "Passenger"

/datum/mil_branch/pmc
	name = "Redshift Security"
	name_short = "RSC"
	email_domain = "rsc.cadulus.tu"

	assistant_job = "Passenger"

/datum/mil_branch/other
	name = "Other"
	name_short = "civ"
	email_domain = "freemail.nt"

	assistant_job = "Passenger"
