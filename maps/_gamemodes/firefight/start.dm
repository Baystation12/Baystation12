
//any of these placed on the map will automatically be replaced with the right assault_target to attract enemy mobs
/obj/effect/landmark/assault_target_firefight
	name = "assault target marker"
	icon = 'code/modules/halo/misc/ai_tokens.dmi'
	invisibility = INVISIBILITY_SYSTEM

/datum/game_mode/firefight/pre_setup()
	..()

	GLOB.hostile_attackables += /obj/structure/evac_ship

	overmind = new()

	//covenant radio channel
	overmind.comms_channel = RADIO_COV


	enemy_faction = GLOB.factions_by_name[enemy_faction_name]
	player_faction = GLOB.factions_by_name[player_faction_name]
	overmind.comms_channel = enemy_faction.default_radio_channel

	//loop over the map and setup spawn landmarks
	spawn(-1)

		var/list/easy_spawns = list()
		for(var/obj/effect/landmark/spawn_easy/F in world)
			easy_spawns.Add(F)

		var/list/medium_spawns = list()
		for(var/obj/effect/landmark/spawn_medium/F in world)
			medium_spawns.Add(F)

		var/list/hard_spawns = list()
		for(var/obj/effect/landmark/spawn_hard/F in world)
			hard_spawns.Add(F)

		spawn_landmarks[1] = easy_spawns
		spawn_landmarks[2] = medium_spawns
		spawn_landmarks[3] = hard_spawns

	//loop over the map and setup assault targets
	spawn(-1)
		for(var/obj/effect/landmark/assault_target_firefight/A in world)
			new assault_landmark_type(A.loc)
			qdel(A)

	//planet_area = locate() in world

/datum/game_mode/firefight/announce()
	..()
	to_world("<span class='notice'>You must survive for [max_waves] waves until the evacuation ship arrives. \
		Chop down trees, dig up rocks and sand, gather cloth from plants or scavenge resources from around the map.</span>")

/datum/game_mode/firefight/post_setup()
	..()
	time_next_resupply = world.time + interval_resupply
	time_rest_end = world.time// + rest_time		//for testing have the waves start immediately
	safe_time = world.time + rest_time
	//time_new_cycle = world.time + solar_cycle_duration - solar_cycle_duration * threshold_dawn

	/*daynight_controller = locate() in world
	if(!daynight_controller)
		daynight_controller = new (1,1,1)*/

	//for all protagonist faction members set an AI path target on their mob
	for(var/datum/mind/M in player_faction.assigned_minds)
		new assault_landmark_type(M.current)

/datum/game_mode/firefight/handle_latejoin(var/mob/living/carbon/human/character)
	. = ..()

	//set an AI path target on their mob
	if(character.faction == player_faction_name)
		new assault_landmark_type(character)
