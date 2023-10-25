/datum/job/submap
	branch = /datum/mil_branch/civilian
	rank = /datum/mil_rank/civ/civ
	allowed_branches = list(/datum/mil_branch/civilian)
	allowed_ranks = list(/datum/mil_rank/civ/civ)

/datum/map/sierra
	branch_types = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor,
		/datum/mil_branch/employee,
		/datum/mil_branch/alien,
		/datum/mil_branch/skrell_fleet,
		/datum/mil_branch/iccgn,
		/datum/mil_branch/css,
		/datum/mil_branch/fleet,
		/datum/mil_branch/scga
	)

	spawn_branch_types = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor,
		/datum/mil_branch/employee,
		/datum/mil_branch/alien,
		/datum/mil_branch/skrell_fleet,
		/datum/mil_branch/iccgn,
		/datum/mil_branch/css,
		/datum/mil_branch/fleet,
		/datum/mil_branch/scga
	)

/*
 * Species restricts
 * =================
 */

	species_to_branch_blacklist = list(
		/datum/species/human    = list(
			/datum/mil_branch/alien,
			/datum/mil_branch/skrell_fleet),
		/datum/species/machine  = list(
			/datum/mil_branch/alien,
			/datum/mil_branch/skrell_fleet),
		/datum/species/adherent = list(
			/datum/mil_branch/contractor,
			/datum/mil_branch/alien,
			/datum/mil_branch/skrell_fleet),
		/datum/species/unathi   = list(
			/datum/mil_branch/alien,
			/datum/mil_branch/skrell_fleet),
		/datum/species/skrell   = list(
			/datum/mil_branch/alien),
		/datum/species/nabber   = list(
			/datum/mil_branch/civilian,
			/datum/mil_branch/employee,
			/datum/mil_branch/alien,
			/datum/mil_branch/skrell_fleet),
		/datum/species/diona    = list(
			/datum/mil_branch/contractor,
			/datum/mil_branch/alien,
			/datum/mil_branch/skrell_fleet),
		/datum/species/vox      = list(
			/datum/mil_branch/contractor,
			/datum/mil_branch/employee,
			/datum/mil_branch/skrell_fleet
		)
	)

	species_to_branch_whitelist = list(
		/datum/species/diona      = list(/datum/mil_branch/civilian,
		 								 /datum/mil_branch/employee),
		/datum/species/nabber     = list(/datum/mil_branch/contractor),
		/datum/species/skrell     = list(/datum/mil_branch/civilian,
		 								 /datum/mil_branch/employee,
		 								 /datum/mil_branch/contractor,
		 								 /datum/mil_branch/skrell_fleet),
		/datum/species/unathi     = list(/datum/mil_branch/civilian,
										 /datum/mil_branch/employee,
										 /datum/mil_branch/contractor),
		/datum/species/adherent   = list(/datum/mil_branch/civilian,
										 /datum/mil_branch/employee),
		/datum/species/vox        = list(/datum/mil_branch/alien,
										 /datum/mil_branch/civilian)
	)

	species_to_rank_whitelist = list(
		/datum/species/vox = list(
			/datum/mil_branch/alien = list(
				/datum/mil_rank/alien
			)
		)
	)


/*
 *  Branches
 *  ========
 */

/datum/mil_branch/civilian
	name = "Civilian"
	name_short = "civ"
	email_domain = "freemail.net"
	allow_custom_email = TRUE

	rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/offduty,
		/datum/mil_rank/civ/synthetic
	)

	spawn_rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/offduty,
		/datum/mil_rank/civ/synthetic
	)

	assistant_job = "Passenger"

/datum/mil_branch/contractor
	name = "Contractor"
	name_short = "contr"
	email_domain = "freemail.net"
	allow_custom_email = TRUE

	rank_types = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/offduty,
		/datum/mil_rank/civ/synthetic
	)

	spawn_rank_types = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/offduty,
		/datum/mil_rank/civ/synthetic
	)


/datum/mil_branch/employee
	name = "Employee"
	name_short = "empl"
	email_domain = "mail.nanotrasen.net"

	rank_types = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/offduty,
		/datum/mil_rank/civ/synthetic
	)

	spawn_rank_types = list(
		/datum/mil_rank/civ/nt,
		/datum/mil_rank/civ/offduty,
		/datum/mil_rank/civ/synthetic
	)


/datum/mil_rank/grade() //useless, for sure
	. = ..()
	if(!sort_order)
		return ""
	if(sort_order <= 10)
		return "E[sort_order]"
	return "O[sort_order - 10]"

/*
 *  Civilians
 *  =========
 */

/datum/mil_rank/civ/civ
	name = "Civilian"

/datum/mil_rank/civ/nt
	name = "NanoTrasen Employee"

/datum/mil_rank/civ/contractor
	name = "NanoTrasen Contractor"

/datum/mil_rank/civ/offduty
	name = "Off-Duty Personnel"

/datum/mil_rank/civ/synthetic
	name = "Synthetic"

/*
 * Vox/foreign alien branch
 * ========================
 */

/datum/mil_branch/alien
	name = "Alien"
	name_short = "Alien"
	rank_types = list(/datum/mil_rank/alien)
	spawn_rank_types = list(/datum/mil_rank/alien)

/datum/mil_rank/alien
	name = "Alien"
