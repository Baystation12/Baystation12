
#define SUPPLY_SPREAD_RADIUS 3

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
	var/list/spawn_landmarks[4]
	var/assault_landmark_type = /obj/effect/landmark/assault_target/covenant
	var/pilot_name = "GA-TL1 Longsword Pilot"

	var/current_wave = 0
	var/max_waves = 8

	var/is_spawning = 0	//0 = rest, 1 = spawning
	var/spawn_subwave_interval = 10 SECONDS
	var/next_subwave_at = 0
	var/max_spawns_tick_perf = 20		//keep this the same for performance reasons. acts as a max-cap
	var/max_spawns_tick_base = 1 //Keep this low so players don't get overwhelmed. Increases by player_bonus_enemies
	var/max_spawns_tick = 1 //But this one changes based on players-active.
	var/enemy_numbers_base = 10 //the total number of enemies
	var/enemy_numbers_left = 10
	var/wave_bonus_enemies = list(3, 4, 5, 6, 8)
	var/player_bonus_enemies = list(0, 1, 1.5, 2.5)
	var/list/wave_spawn_landmarks = list()
	var/list/last_spawns_list

	var/time_rest_end = 0
	var/interval_resupply = 4 MINUTES
	var/time_next_resupply = 0

	var/rest_time = 4 MINUTES
	var/safe_time = 999999

	var/time_evac_leave = 0
	var/evac_wait_time = 2 MINUTES
	var/evac_stage = 0

	var/obj/structure/evac_ship/evac_ship
	var/evac_ship_type = /obj/structure/evac_ship

	//var/obj/effect/landmark/day_night_zcontroller/daynight_controller
	var/datum/npc_overmind/firefight/overmind

	var/finish_reason = 0

	var/wave_message = "Enemy spawns have started! Here they come..."
	var/rest_message = "The wave of enemies have been defeated! Better heal up and restock your ammo..."
	var/evac_message = "The evac ship has arrived! Get to da choppa!"
	var/win_message = "<span class='good'>The evac ship takes off! The survivors were:</span><br>"
	var/empty_message = "<span class='bad'>Defeat: The evac ship left with no-one on it!</span>"
	var/destroyed_message = "<span class='bad'>Defeat: The evac ship has been destroyed! Any survivors are doomed to die alone in the wastes...</span><br>"
	var/overrun_message = "<span class='bad'>Defeat: The survivors have been overrun. The evac ship did not arrive in time.</span>"

	//this should not ever be seen by players, but its here just in case
	var/stuck_message = "<span class='mixed'>Defeat: The evac ship suffered an engine problem. Any survivors are doomed to die alone in the wastes...</span>"

/datum/game_mode/firefight/handle_mob_death(var/mob/M, var/list/args = list())
	//stop having the AI chase this player
	for(var/obj/effect/landmark/assault_target/T in M)
		GLOB.assault_targets[T.type] -= T
		qdel(T)

	. = ..()

/datum/game_mode/firefight/handle_latejoin(var/mob/living/carbon/human/character)
	. = ..()
	if(character.faction == player_faction_name)
		new assault_landmark_type(character)

/datum/game_mode/firefight
	var/list/special_job_titles = list("Spartan II")

/datum/game_mode/firefight/proc/unlock_special_job()
	while(special_job_titles.len)
		var/chosen_title = pick(special_job_titles)
		var/datum/job/special_job = job_master.occupations_by_title[chosen_title]
		if(special_job)
			special_job.total_positions += 1
			to_world("\
			<span class='radio'>\
			<span class='name'>[pilot_name]</span> \
			<b>\[Emergency Freq\]</b> \
			<span class='message'>\"I've located a [special_job.title] fighting nearby, I'm dropping them off to you!\"</span>\
			</span>")
			minor_announcement.Announce("[uppertext(special_job.title)] SLOT UNLOCKED")
			break
		else
			log_and_message_admins("ERROR: Attempted to unlock job slot for [chosen_title] but it didn't exist!")
			special_job_titles -= chosen_title

/datum/game_mode/firefight/get_respawn_time()
	return 1
