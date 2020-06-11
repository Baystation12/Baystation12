
/datum/job/unsc/odst
	title = "Orbital Drop Shock Trooper"
	total_positions = -1
	spawn_positions = -1
	is_whitelisted = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc/odst
	alt_titles = list(\
		"ODST Sharpshooter",\
		"ODST Close Quarters Specialist",\
		"ODST Combat Engineer",\
		"ODST Combat Medic")
	access = list(\
		access_unsc,\
		access_unsc_armoury,\
		access_unsc_marine,\
		access_unsc_odst,\
		access_unsc_specialist)

/datum/job/unsc/odst/squad_leader
	title = "Orbital Drop Shock Trooper Officer"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	is_whitelisted = 1
	economic_modifier = 1.5
	outfit_type = /decl/hierarchy/outfit/job/unsc/odst/e5
	alt_titles = list(\
		"ODST Sergeant",\
		"ODST Staff Sergeant" = /decl/hierarchy/outfit/job/unsc/odst/e6,\
		"ODST Gunnery Sergeant" = /decl/hierarchy/outfit/job/unsc/odst/e7,\
		"ODST Master Sergeant" = /decl/hierarchy/outfit/job/unsc/odst/e8)
