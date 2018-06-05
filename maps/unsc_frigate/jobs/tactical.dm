
/datum/job/UNSC_ship/gunnery_chief
	title = "Crew Chief (gunnery)"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	department_flag = GUNCO
	total_positions = 1
	spawn_positions = 1
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/gunnery_chief
	selection_color = "#cc0000"
	req_admin_notify = 1
	//job_guide = "Your responsibility is to oversee the gunnery operators manning the ship's turrets. Unfortunately your job has no content yet but it's coming soon."

	access = list(access_unsc_crew, access_unsc_gunnery)

/datum/job/UNSC_ship/gunnery
	title = "Gunnery Operator"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	department_flag = GUN
	total_positions = -1
	spawn_positions = 2
	spawnpoint_override = "UNSC Frigate"
	outfit_type = /decl/hierarchy/outfit/job/UNSC_ship/gunnery
	selection_color = "#cc0000"
	//job_guide = "Your responsibility is to man the ship's turrets. Unfortunately your job has no content yet but it's coming soon."

	access = list(access_unsc_crew, access_unsc_gunnery)
