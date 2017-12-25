
/datum/game_mode/stranded
	name = "Stranded"
	config_tag = "Stranded"
	required_players = 0
	required_enemies = 0
	end_on_antag_death = 0
	round_description = "Build a base in order to survive. The Flood is coming..."
	extended_round_description = "Your ship has crash landed on a distant alien world. Now waves of Flood are attacking and there is only limited time to setup defences. Can you survive until the rescue team arrives?"
	//hub_descriptions = list("desperately struggling to survive against waves of parasitic aliens on a distant world...")

	allowed_ghost_roles = list(/datum/ghost_role/flood_combat_form)

	var/player_faction = "UNSC"
	var/wave_num = 0
	var/area/planet/daynight/planet_area
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
	var/duration_wave_base = 6000
	var/duration_wave_current = 6000
	var/duration_rest_base = 6000
	var/duration_rest_current = 6000
	var/time_wave_cycle = 0
	var/interval_resupply = 2000
	var/time_next_resupply = 0

	//day night cycle stuff
	var/solar_cycle_start = 0			//deciseconds, calculated using world.time
	var/solar_cycle_duration = 6000		//deciseconds
	var/solar_cycle_offset = 1500		//deciseconds
	var/threshold_dawn = 0.25			//percent
	var/threshold_dusk = 0.75			//percent
	var/light_change_amount = 0.1		//set this to 2 for light changes to be 100% instead of a dawn/dusk period
	//var/current_light_level = 9
	var/do_daynight_cycle = 1			//for testing
	var/time_light_update = 0			//deciseconds, calculated using world.time
	var/solar_announcement_status = 0
	//
	var/datum/light_source/ambient/ambient_light
	var/list/light_sources
	var/light_power = 0
	var/light_range = 255
	var/light_color = "#ffffff"

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

/datum/game_mode/stranded/process()
	latest_tick_time = world.time

	if(do_daynight_cycle)
		process_daynight()
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
#include "mode_stranded_daynight.dm"
#include "mode_stranded_evac.dm"
#include "mode_stranded_finish.dm"
#include "mode_stranded_start.dm"
