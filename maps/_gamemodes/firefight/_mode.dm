
/datum/game_mode/firefight
	name = "Firefight"
	config_tag = "firefight"
	required_players = 0
	required_enemies = 0
	end_on_antag_death = 0
	round_description = "Survive against waves of enemies"
	extended_round_description = "Waves of enemies are coming in, can you survive?"
	//hub_descriptions = list("desperately struggling to survive against waves of parasitic aliens on a distant world...")

	allowed_ghost_roles = list()

	var/player_faction_name = "UNSC"
	var/datum/faction/player_faction
	var/enemy_faction_name = "Covenant"
	var/datum/faction/enemy_faction
	//var/area/planet/daynight/planet_area
	var/list/spawn_landmarks[3]
	var/assault_landmark_type = /obj/effect/landmark/assault_target/covenant
	var/pilot_name = "GA-TL1 Longsword Pilot"

	var/current_wave = 0
	var/max_waves = 4

	var/is_spawning = 0	//0 = rest, 1 = spawning
	var/max_spawns_tick = 20		//keep this the same for performance reasons
	var/enemy_strength_base = 1//10		//the total value of all spawned enemy strength ratings
	var/enemy_strength_left = 1//10		//the total strength to spawn this round
	var/wave_strength_multiplier = 0//0.1	//increase in strength each round

	var/time_rest_end = 0
	var/interval_resupply = 4 MINUTES
	var/time_next_resupply = 0

	var/rest_time = 2 MINUTES
	var/safe_time = 999999

	var/time_evac_leave = 0
	var/evac_wait_time = 2 MINUTES
	var/evac_stage = 0

	var/obj/structure/evac_ship/evac_ship
	var/evac_ship_type = /obj/structure/evac_ship

	//var/obj/effect/landmark/day_night_zcontroller/daynight_controller
	var/datum/npc_overmind/firefight/overmind

	var/wave_message = "Enemy spawns have started! Here they come..."
	var/rest_message = "The wave of enemies have been defeated! Better heal up and restock your ammo..."
	var/evac_message = "The evac ship has arrived! Get to da choppa!"
	var/win_message = "<span class='good'>The evac ship takes off! The survivors were:</span><br>"
	var/empty_message = "<span class='bad'>Defeat: The evac ship left with no-one on it!</span>"
	var/destroyed_message = "<span class='bad'>Defeat: The evac ship has been destroyed! Any survivors are doomed to die alone in the wastes...</span><br>"
	var/overrun_message = "<span class='bad'>Defeat: The survivors have been overrun. The evac ship did not arrive in time.</span>"

	disabled_jobs_types = list(\
		//Covenant jobs
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
		/datum/job/covenant/yanmee_leader,\

		//UNSC jobs
		/*
		/datum/job/firefight_unsc_marine,\
		/datum/job/firefight_colonist,\
		*/

		//UNSC survivor jobs
		/datum/job/stranded/unsc_marine,\
		/datum/job/stranded/unsc_tech,\
		/datum/job/stranded/unsc_medic,\
		/datum/job/stranded/unsc_crew,\
		/datum/job/stranded/unsc_civ\
		)

/datum/game_mode/firefight/proc/get_num_survivors()
	. = 0
	for(var/mob/M in GLOB.player_list)
		if(M.client && M.stat == CONSCIOUS && M.faction == src.player_faction)
			.++

/*
/datum/game_mode/firefight/proc/survive_duration()
	return round((duration_wave_base + duration_rest_base) * max_waves)
	*/

/datum/game_mode/firefight/handle_mob_death(var/mob/M, var/list/args = list())
	//stop having the AI chase this player
	for(var/obj/effect/landmark/assault_target/T in M)
		GLOB.assault_targets[T.type] -= T
		qdel(T)

	. = ..()

/datum/game_mode/firefight/pre_setup()
	. = ..()
	modify_job_slots()

/datum/game_mode/firefight/proc/modify_job_slots()
	//this seems like hacky way of doing things
	//but i cant think of a better way to handle per-gamemode job customisations as long as we use standardised job definitions

/datum/game_mode/firefight/get_respawn_time()
	return 1 MINUTE
