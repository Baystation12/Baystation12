
/datum/job/covenant/lesser_prophet
	title = "Lesser Prophet"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	selection_color = "#80080"
	outfit_type = /decl/hierarchy/outfit/lesser_prophet
	access = list(240,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sanshyuum)
	access = list(access_covenant, access_covenant_command)

/datum/job/covenant/lesser_prophet/equip()
	.=..()
	var/datum/job/to_modify = job_master.occupations_by_type[/datum/job/covenant/sangheili_honour_guard]
	to_modify.total_positions = 2
