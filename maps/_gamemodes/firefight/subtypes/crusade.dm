
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

	special_job_titles = list(\
		"Sangheili Ultra",\
		"Special Operations Sangheili",
		"Sangheili Zealot",\
		"T-Voan Champion",\
		"Unggoy Deacon",\
		"Special Operations Unggoy",\
		"Unggoy Ultra")

	wave_spawns = list(\
		list(\
			/mob/living/simple_animal/hostile/unsc/marine = 3,\
			/mob/living/simple_animal/hostile/battledog = 1\
			),\
		list(\
			/mob/living/simple_animal/hostile/unsc/marine = 2,\
			/mob/living/simple_animal/hostile/unsc/odst = 1,\
			/mob/living/simple_animal/hostile/battledog/pmc = 1\
			),\
		list(\
			/mob/living/simple_animal/hostile/unsc/marine = 3,\
			/mob/living/simple_animal/hostile/unsc/odst = 3,\
			/mob/living/simple_animal/hostile/battledog/odst = 2,\
			/mob/living/simple_animal/hostile/unsc/spartan_two = 1,\
			),\
		list(\
			/mob/living/simple_animal/hostile/unsc/odst = 2,\
			/mob/living/simple_animal/hostile/battledog/odst = 1,\
			/mob/living/simple_animal/hostile/unsc/spartan_two = 1,\
			)\
		)

/datum/game_mode/firefight/crusade/pre_setup()
	. = ..()

	//human radio channel
	overmind.comms_channel = RADIO_SQUAD

/datum/game_mode/firefight/crusade/modify_job_slots()
	. = ..()

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
