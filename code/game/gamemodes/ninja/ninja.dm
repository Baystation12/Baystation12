/datum/game_mode/var/list/datum/mind/ninjas = list()

/datum/game_mode/ninja
	name = "ninja"
	config_tag = "ninja"
	required_players = 1 //CHANGE DEBUG
	required_players_secret = 1 //CHANGE DEBUG
	required_enemies = 1
	recommended_enemies = 1
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)
	var/finished = 0

/datum/game_mode/ninja/announce()
	world << "<B>The current game mode is Ninja!</B>"

/datum/game_mode/ninja/can_start()
	if(!..())
		return 0
	var/list/datum/mind/possible_ninjas = get_players_for_role(BE_NINJA)
	if(possible_ninjas.len==0)
		return 0
	var/datum/mind/ninja = pick(possible_ninjas)
	ninjas += ninja
	modePlayer += ninja
	ninja.assigned_role = "MODE" //So they aren't chosen for other jobs.
	ninja.special_role = "Ninja"
	ninja.original = ninja.current
	if(ninjastart.len == 0)
		ninja.current << "<B>\red A proper starting location for you could not be found, please report this bug!</B>"
		ninja.current << "<B>\red Attempting to place at a carpspawn.</B>"
		for(var/obj/effect/landmark/L in landmarks_list)
			if(L.name == "carpspawn")
				ninjastart.Add(L)
		if(ninjastart.len == 0 && latejoin.len > 0)
			ninja.current << "<B>\red Still no spawneable locations could be found. Defaulting to latejoin.</B>"
			return 1
		else if (ninjastart.len == 0)
			ninja.current << "<B>\red Still no spawneable locations could be found. Aborting.</B>"
			return 0
	return 1

/datum/game_mode/ninja/pre_setup()
	for(var/datum/mind/ninja in ninjas)
		ninja.current = create_space_ninja(pick(ninjastart.len ? ninjastart : latejoin))
		ninja.current.ckey = ninja.key
	return 1

/datum/game_mode/ninja/post_setup()
	for(var/datum/mind/ninja in ninjas)
		if(ninja.current && !(istype(ninja.current,/mob/living/carbon/human))) return 0
		var/mob/living/carbon/human/N = ninja.current
		N.internal = N.s_store
		N.internals.icon_state = "internal1"
		if(N.wear_suit && istype(N.wear_suit,/obj/item/clothing/suit/space/space_ninja))
			var/obj/item/clothing/suit/space/space_ninja/S = N.wear_suit
			S:randomize_param()
			S:ninitialize(0, N)
	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	return ..()

/datum/game_mode/ninja/check_finished()
	if(config.continous_rounds)
		return ..()
	var/ninjas_alive = 0
	for(var/datum/mind/ninja in ninjas)
		if(!istype(ninja.current,/mob/living/carbon/human))
			continue
		if(ninja.current.stat==2)
			continue
		ninjas_alive++
	if (ninjas_alive)
		return ..()
	else
		finished = 1
		return 1