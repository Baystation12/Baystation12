
/datum/game_mode/stranded
	name = "Stranded"
	config_tag = "Stranded"
	required_players = 0
	required_enemies = 0
	end_on_antag_death = 0
	round_description = "Build a base in order to survive. The Flood is coming..."
	extended_round_description = "Your ship has crash landed on a distant alien world. Now waves of Flood are attacking and there is only limited time to setup defences. Can you survive until the rescue team arrives?"
	//hub_descriptions = list("desperately struggling to survive against waves of parasitic aliens on a distant world...")

	allowed_ghost_roles = list()

	var/player_faction = "UNSC"
	var/wave_num = 0
	//var/area/planet/daynight/planet_area
	var/list/flood_spawn_turfs = list()
	var/list/flood_assault_turfs = list()

	var/is_spawning = 0	//0 = rest, 1 = spawning
	var/spawns_per_tick_base = 1
	var/spawns_per_tick_current = 1
	var/bonus_spawns = 0
	var/spawn_wave_multi = 1.1
	var/wave_dur_multi = 1//1.25
	var/rest_dur_multi = 1//0.9
	var/spawn_feral_chance = 0.1
	var/time_next_spawn_tick = 0
	var/spawn_interval = 30

	//deciseconds
	var/duration_wave_base = 3000
	var/duration_wave_current = 3000
	var/duration_rest_base = 12000
	var/duration_rest_current = 12000
	var/time_wave_cycle = 0
	var/interval_resupply = 2000
	var/time_next_resupply = 0

	var/latest_tick_time = 0
	var/round_start

	var/survive_duration = 18000
	var/pelican_load_time = 600
	var/time_pelican_arrive = 18000
	var/evac_stage = 0
	var/time_pelican_leave
	var/all_survivors_dead = 0

	var/obj/structure/evac_pelican/evac_pelican

	var/list/available_resupply_points = list()

	//var/obj/effect/landmark/day_night_zcontroller/daynight_controller

/datum/game_mode/stranded/process()
	latest_tick_time = world.time

	process_spawning()
	process_resupply()
	process_evac()

/datum/game_mode/stranded/proc/get_num_survivors()
	. = 0
	for(var/mob/M in GLOB.player_list)
		if(M.client && M.stat == CONSCIOUS && M.faction == src.player_faction)
			.++

#include "mode_stranded_attackers_process.dm"
#include "mode_stranded_attackers_spawn.dm"
#include "mode_stranded_evac.dm"
#include "mode_stranded_finish.dm"
#include "mode_stranded_start.dm"
