
/datum/game_mode/firefight/crusade
	name = "Crusade"
	config_tag = "crusade"
	player_faction_name = "Covenant"
	enemy_faction_name = "UNSC"
	votable = 1
	round_description = "The Great Journey waits for no-one! Not even these filthy humans..."
	extended_round_description = "The Great Journey waits for no-one! Not even these filthy humans..."
	assault_landmark_type = /obj/effect/landmark/assault_target/unsc
	pilot_name = "Spirit Dropship Pilot"

	wave_message = "The human vermin are coming! We shall be like the rock that the tides wash against!"
	rest_message = "The humans have been destroyed for now. But they will return."
	evac_message = "The spirit has arrived. Protect it until we can depart this place."

	disabled_jobs_types = list(\
		//Covenant jobs
		/*
		/datum/job/covenant/brute_captain,\
		/datum/job/covenant/brute_major,\
		/datum/job/covenant/brute_minor,\
		//
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyar_marksman,\
		/datum/job/covenant/kigyar_sniper,\
		//
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/sangheili_ultra,\
		/datum/job/covenant/sangheili_honour_guard,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_ranger,\
		/datum/job/covenant/sangheili_specops,\
		/datum/job/covenant/sangheili_zealot,\
		//
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmmurmillo,\
		/datum/job/covenant/skirmcommando,\
		//
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major,\
		/datum/job/covenant/unggoy_ultra,\
		/datum/job/covenant/unggoy_deacon,\
		//
		/datum/job/covenant/yanmee_minor,\
		/datum/job/covenant/yanmee_major,\
		/datum/job/covenant/yanmee_ultra,\
		/datum/job/covenant/yanmee_leader\
		*/
		//UNSC jobs
		/datum/job/firefight_unsc_marine,\
		/datum/job/firefight_colonist,\
		//
		//UNSC survivor jobs
		/datum/job/stranded/unsc_marine,\
		/datum/job/stranded/unsc_tech,\
		/datum/job/stranded/unsc_medic,\
		/datum/job/stranded/unsc_crew,\
		/datum/job/stranded/unsc_civ\
		)

/datum/game_mode/firefight/crusade/modify_job_slots()
	//a whole bunch of slot tweaks
	var/datum/job/current_job

	// JIRALHANAE

	current_job = job_master.occupations_by_type[/datum/job/covenant/brute_minor]
	current_job.spawn_positions = -1
	current_job.total_positions = -1

	current_job = job_master.occupations_by_type[/datum/job/covenant/brute_major]
	current_job.spawn_positions = 1
	current_job.total_positions = 1

	current_job = job_master.occupations_by_type[/datum/job/covenant/brute_captain]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	// KIGYAR

	current_job = job_master.occupations_by_type[/datum/job/covenant/kigyar_marksman]
	current_job.spawn_positions = 1
	current_job.total_positions = 1
	current_job.open_slot_on_death = 1

	current_job = job_master.occupations_by_type[/datum/job/covenant/kigyar_sniper]
	current_job.spawn_positions = 1
	current_job.total_positions = 1

	// SANGHEILI

	current_job = job_master.occupations_by_type[/datum/job/covenant/sangheili_shipmaster]
	current_job.spawn_positions = 0
	current_job.total_positions = 0

	current_job = job_master.occupations_by_type[/datum/job/covenant/sangheili_ultra]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	current_job = job_master.occupations_by_type[/datum/job/covenant/sangheili_ultra]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	current_job = job_master.occupations_by_type[/datum/job/covenant/sangheili_major]
	current_job.spawn_positions = 2
	current_job.total_positions = 2

	current_job = job_master.occupations_by_type[/datum/job/covenant/sangheili_specops]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	current_job = job_master.occupations_by_type[/datum/job/covenant/sangheili_zealot]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	// TVOAN

	current_job = job_master.occupations_by_type[/datum/job/covenant/skirmminor]
	current_job.spawn_positions = -1
	current_job.total_positions = -1

	current_job = job_master.occupations_by_type[/datum/job/covenant/skirmmajor]
	current_job.spawn_positions = 2
	current_job.total_positions = 2

	current_job = job_master.occupations_by_type[/datum/job/covenant/skirmmurmillo]
	current_job.spawn_positions = 1
	current_job.total_positions = 1
	current_job.open_slot_on_death = 1

	current_job = job_master.occupations_by_type[/datum/job/covenant/skirmcommando]
	current_job.spawn_positions = 1
	current_job.total_positions = 1
	current_job.open_slot_on_death = 1

	current_job = job_master.occupations_by_type[/datum/job/covenant/skirmchampion]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	// UNGGOY

	current_job = job_master.occupations_by_type[/datum/job/covenant/unggoy_major]
	current_job.spawn_positions = 2
	current_job.total_positions = 2

	current_job = job_master.occupations_by_type[/datum/job/covenant/unggoy_ultra]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	current_job = job_master.occupations_by_type[/datum/job/covenant/unggoy_deacon]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	current_job = job_master.occupations_by_type[/datum/job/covenant/unggoy_specops]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	// YANMEE

	current_job = job_master.occupations_by_type[/datum/job/covenant/yanmee_ultra]
	current_job.spawn_positions = 1
	current_job.total_positions = 0

	current_job = job_master.occupations_by_type[/datum/job/covenant/yanmee_leader]
	current_job.spawn_positions = 1
	current_job.total_positions = 0
