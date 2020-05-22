
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
	sound_flyby = sound('code/modules/halo/sound/sprit_flyby.ogg', volume = 75)

	wave_message = "The human vermin are coming! We shall be like the rock that the tides wash against!"
	rest_message = "The humans have been destroyed for now. But they will return."
	evac_message = "The spirit has arrived. Protect it until we can depart this place."

	special_job_titles = list(\
		"Sangheili Zealot",\
		"T-Voan Champion")

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
