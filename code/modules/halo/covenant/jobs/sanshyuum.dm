
/datum/job/covenant/lesser_prophet
	title = "Lesser Prophet"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/lesser_prophet
	access = list(240,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sanshyuum)
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	pop_balance_mult = 0.5

/datum/job/covenant/lesser_prophet/equip()
	.=..()
	var/datum/job/to_modify = job_master.occupations_by_type[/datum/job/covenant/sangheili_honour_guard]
	if(to_modify)
		to_modify.total_positions = 2
	else
		message_admins("Warning, a [src]|[src.type] has joined the game \
			but the job code was unable to add 2 Sangheili Honour Guards")
