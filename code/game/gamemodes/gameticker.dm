var/global/datum/controller/gameticker/ticker

/datum/controller/gameticker
	var/const/restart_timeout = 600
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/post_game = 0
	var/event_time = null
	var/event = 0

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/Bible_icon_state	// icon_state the chaplain has chosen for his bible
	var/Bible_item_state	// item_state the chaplain has chosen for his bible
	var/Bible_name			// name of the bible
	var/Bible_deity_name

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of traitor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = 0
	var/gamemode_voted = 0

	var/delay_end = 0	//if set to nonzero, the round will not restart on it's own

	var/triai = 0//Global holder for Triumvirate

	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	var/list/antag_pool = list()
	var/looking_for_antags = 0

/datum/controller/gameticker/proc/pregame()
	do
		if(!gamemode_voted)
			pregame_timeleft = 180
		else
			pregame_timeleft = 15
			if(!isnull(secondary_mode))
				master_mode = secondary_mode
				secondary_mode = null
				to_world("Trying to start the second top game mode...")

				if(!hide_mode)
					to_world("<b>The game mode is now: [master_mode]</b>")

			else if(!isnull(tertiary_mode))
				master_mode = tertiary_mode
				tertiary_mode = null
				to_world("Trying to start the third top game mode...")

				if(!hide_mode)
					to_world("<b>The game mode is now: [master_mode]</b>")

			else
				master_mode = "extended"
				to_world("<b>Forcing the game mode to extended...</b>")

		to_world("<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>")

		to_world("Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds")

		while(current_state == GAME_STATE_PREGAME)
			for(var/i=0, i<10, i++)
				sleep(1)
				vote.process()
			if(round_progressing)
				pregame_timeleft--
			if(pregame_timeleft == config.vote_autogamemode_timeleft && !gamemode_voted)
				gamemode_voted = 1
				if(!vote.time_remaining)
					vote.autogamemode()	//Quit calling this over and over and over and over.
					while(vote.time_remaining)
						for(var/i=0, i<10, i++)
							sleep(1)
							vote.process()
			if(pregame_timeleft <= 0 || ((initialization_stage & INITIALIZATION_NOW_AND_COMPLETE) == INITIALIZATION_NOW_AND_COMPLETE))
				current_state = GAME_STATE_SETTING_UP
	while (!setup())


/datum/controller/gameticker/proc/setup()
	//Create and announce mode
	if(master_mode=="secret")
		src.hide_mode = 1

	var/list/runnable_modes = config.get_runnable_modes()
	if((master_mode=="random") || (master_mode=="secret"))
		if(!runnable_modes.len)
			current_state = GAME_STATE_PREGAME
			to_world("<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby.")

			return 0
		if(secret_force_mode != "secret")
			src.mode = config.pick_mode(secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = config.probabilities[GM.config_tag]
			src.mode = gamemode_cache[pickweight(weighted_modes)]
	else
		src.mode = config.pick_mode(master_mode)

	if(!src.mode)
		current_state = GAME_STATE_PREGAME
		to_world("<span class='danger'>Serious error in mode setup!</span> Reverting to pre-game lobby.")

		return 0

	job_master.ResetOccupations()
	src.mode.create_antagonists()
	src.mode.pre_setup()
	job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	var/t = src.mode.startRequirements()
	if(t)
		to_world("<B>Unable to start [mode.name].</B> [t] Reverting to pre-game lobby.")

		current_state = GAME_STATE_PREGAME
		mode.fail_setup()
		mode = null
		job_master.ResetOccupations()
		return 0

	if(hide_mode)
		to_world("<B>The current game mode is - Secret!</B>")

		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				to_world("<B>Possibilities:</B> [english_list(tmpmodes)]")

	else
		src.mode.announce()

	setup_economy()
	current_state = GAME_STATE_PLAYING
	create_characters() //Create player characters and transfer them
	collect_minds()
	equip_characters()
	data_core.manifest()

	callHook("roundstart")

	shuttle_controller.setup_shuttle_docks()

	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				qdel(S)
		to_world("<FONT color='blue'><B>Enjoy the game!</B></FONT>")
		sound_to(world, sound('sound/AI/welcome.ogg'))// Skie

		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2adminirc("Round has started with no admins online.")

/*	supply_controller.process() 		//Start the supply shuttle regenerating points -- TLE // handled in scheduler
	master_controller.process()		//Start master_controller.process()
	lighting_controller.process()	//Start processing DynamicAreaLighting updates
	*/

	processScheduler.start()

	if(config.sql_enabled)
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return 1

/datum/controller/gameticker
	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
	proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
		if( cinematic )	return	//already a cinematic in progress!

		//initialise our cinematic screen object
		cinematic = new(src)
		cinematic.icon = 'icons/effects/station_explosion.dmi'
		cinematic.icon_state = "station_intact"
		cinematic.plane = HUD_PLANE
		cinematic.layer = HUD_ABOVE_ITEM_LAYER
		cinematic.mouse_opacity = 0
		cinematic.screen_loc = "1,0"

		var/obj/structure/bed/temp_buckle = new(src)
		//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
		if(station_missed)
			for(var/mob/living/M in living_mob_list_)
				M.buckled = temp_buckle				//buckles the mob so it can't do anything
				if(M.client)
					M.client.screen += cinematic	//show every client the cinematic
		else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
			for(var/mob/living/M in living_mob_list_)
				M.buckled = temp_buckle
				if(M.client)
					M.client.screen += cinematic

				switch(M.z)
					if(0)	//inside a crate or something
						var/turf/T = get_turf(M)
						if(T && T.z in using_map.station_levels)				//we don't use M.death(0) because it calls a for(/mob) loop and
							M.health = 0
							M.set_stat(DEAD)
					if(1)	//on a z-level 1 turf.
						M.health = 0
						M.set_stat(DEAD)

		//Now animate the cinematic
		switch(station_missed)
			if(1)	//nuke was nearby but (mostly) missed
				if( mode && !override )
					override = mode.name
				switch( override )
					if("mercenary") //Nuke wasn't on station when it blew up
						flick("intro_nuke",cinematic)
						sleep(35)
						sound_to(world, sound('sound/effects/explosionfar.ogg'))
						flick("station_intact_fade_red",cinematic)
						cinematic.icon_state = "summary_nukefail"
					else
						flick("intro_nuke",cinematic)
						sleep(35)
						sound_to(world, sound('sound/effects/explosionfar.ogg'))
						//flick("end",cinematic)


			if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
				sleep(50)
				sound_to(world, sound('sound/effects/explosionfar.ogg'))
			else	//station was destroyed
				if( mode && !override )
					override = mode.name
				switch( override )
					if("mercenary") //Nuke Ops successfully bombed the station
						flick("intro_nuke",cinematic)
						sleep(35)
						flick("station_explode_fade_red",cinematic)
						sound_to(world, sound('sound/effects/explosionfar.ogg'))
						cinematic.icon_state = "summary_nukewin"
					if("AI malfunction") //Malf (screen,explosion,summary)
						flick("intro_malf",cinematic)
						sleep(76)
						flick("station_explode_fade_red",cinematic)
						sound_to(world, sound('sound/effects/explosionfar.ogg'))
						cinematic.icon_state = "summary_malf"
					if("blob") //Station nuked (nuke,explosion,summary)
						flick("intro_nuke",cinematic)
						sleep(35)
						flick("station_explode_fade_red",cinematic)
						sound_to(world, sound('sound/effects/explosionfar.ogg'))
						cinematic.icon_state = "summary_selfdes"
					else //Station nuked (nuke,explosion,summary)
						flick("intro_nuke",cinematic)
						sleep(35)
						flick("station_explode_fade_red", cinematic)
						sound_to(world, sound('sound/effects/explosionfar.ogg'))
						cinematic.icon_state = "summary_selfdes"
				for(var/mob/living/M in living_mob_list_)
					if(is_station_turf(get_turf(M)))
						M.death()//No mercy
		//If its actually the end of the round, wait for it to end.
		//Otherwise if its a verb it will continue on afterwards.
		sleep(300)

		if(cinematic)	qdel(cinematic)		//end the cinematic
		if(temp_buckle)	qdel(temp_buckle)	//release everybody
		return


	proc/create_characters()
		for(var/mob/new_player/player in player_list)
			if(player && player.ready && player.mind)
				if(player.mind.assigned_role=="AI")
					player.close_spawn_windows()
					player.AIize()
				else if(!player.mind.assigned_role)
					continue
				else
					if(player.create_character())
						qdel(player)


	proc/collect_minds()
		for(var/mob/living/player in player_list)
			if(player.mind)
				ticker.minds += player.mind


	proc/equip_characters()
		var/captainless=1
		for(var/mob/living/carbon/human/player in player_list)
			if(player && player.mind && player.mind.assigned_role)
				if(player.mind.assigned_role == "Captain")
					captainless=0
				if(!player_is_antag(player.mind, only_offstation_roles = 1))
					job_master.EquipRank(player, player.mind.assigned_role, 0)
					UpdateFactionList(player)
					equip_custom_items(player)
					player.apply_aspects()
		if(captainless)
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player))
					to_chat(M, "Captainship not forced on anyone.")


	proc/process()
		if(current_state != GAME_STATE_PLAYING)
			return 0

		mode.process()

//		emergency_shuttle.process() //handled in scheduler

		var/game_finished = 0
		var/mode_finished = 0
		if (config.continous_rounds)
			game_finished = (evacuation_controller.round_over() || mode.station_was_nuked)
			mode_finished = (!post_game && mode.check_finished())
		else
			game_finished = (mode.check_finished() || (evacuation_controller.round_over() && evacuation_controller.emergency_evacuation) || universe_has_ended)
			mode_finished = game_finished

		if(!mode.explosion_in_progress && game_finished && (mode_finished || post_game))
			current_state = GAME_STATE_FINISHED

			spawn
				declare_completion()


			spawn(50)
				if(config.allow_map_switching && config.auto_map_vote && all_maps.len > 1)
					vote.automap()
					while(vote.time_remaining)
						sleep(50)

				callHook("roundend")
				if (universe_has_ended)
					if(mode.station_was_nuked)
						feedback_set_details("end_proper","nuke")
					else
						feedback_set_details("end_proper","universe destroyed")
					if(!delay_end)
						to_world("<span class='notice'><b>Rebooting due to destruction of station in [restart_timeout/10] seconds</b></span>")

				else
					feedback_set_details("end_proper","proper completion")
					if(!delay_end)
						to_world("<span class='notice'><b>Restarting in [restart_timeout/10] seconds</b></span>")



				if(blackbox)
					blackbox.save_all_data_to_sql()

				if(!delay_end)
					sleep(restart_timeout)
					if(!delay_end)
						world.Reboot()
					else
						to_world("<span class='notice'><b>An admin has delayed the round end</b></span>")

				else
					to_world("<span class='notice'><b>An admin has delayed the round end</b></span>")


		else if (mode_finished)
			post_game = 1

			mode.cleanup()

			//call a transfer shuttle vote
			spawn(50)
				if(!round_end_announced) // Spam Prevention. Now it should announce only once.
					to_world("<span class='danger'>The round has ended!</span>")

					round_end_announced = 1
				vote.autotransfer()

		return 1

/datum/controller/gameticker/proc/declare_completion()
	to_world("<br><br><br><H1>A round of [mode.name] has ended!</H1>")

	for(var/mob/Player in player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(evacuation_controller.round_over() && evacuation_controller.emergency_evacuation)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, "<font color='blue'><b>You managed to survive, but were marooned on [station_name()] as [Player.real_name]...</b></font>")
					else
						to_chat(Player, "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>")
				else
					to_chat(Player, "<font color='blue'><b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b></font>")
			else
				if(isghost(Player))
					var/mob/observer/ghost/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
	to_world("<br>")


	for (var/mob/living/silicon/ai/aiPlayer in mob_list)
		if (aiPlayer.stat != 2)
			to_world("<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the round were:</b>")

		else
			to_world("<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b>")

		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated) (Played by: [robo.key]), ":" (Played by: [robo.key]), "]"
			to_world("[robolist]")


	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in mob_list)

		if(istype(robo,/mob/living/silicon/robot/drone))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				to_world("<b>[robo.name] (Played by: [robo.key]) survived as an AI-less synthetic! Its laws were:</b>")

			else
				to_world("<b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a synthetic without an AI. Its laws were:</b>")


			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		to_world("<b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b>")


	mode.declare_completion()//To declare normal completion.

	//Ask the event manager to print round end information
	event_manager.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	return 1

/datum/controller/gameticker/proc/attempt_late_antag_spawn(var/list/antag_choices)
	var/datum/antagonist/antag = antag_choices[1]
	while(antag_choices.len && antag)
		var/needs_ghost = antag.flags & (ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB)
		if (needs_ghost)
			looking_for_antags = 1
			antag_pool.Cut()
			to_world("<b>A ghost is needed to spawn \a [antag.role_text].</b>\nGhosts may enter the antag pool by making sure their [antag.role_text] preference is set to high, then using the toggle-add-antag-candidacy verb. You have 3 minutes to enter the pool.")

			sleep(3 MINUTES)
			looking_for_antags = 0
			antag.update_current_antag_max()
			antag.build_candidate_list(needs_ghost)
			for(var/datum/mind/candidate in antag.candidates)
				if(!(candidate in antag_pool))
					antag.candidates -= candidate
					log_debug("[candidate.key] was not in the antag pool and could not be selected.")
		else
			antag.update_current_antag_max()
			antag.build_candidate_list(needs_ghost)
			for(var/datum/mind/candidate in antag.candidates)
				if(isghostmind(candidate))
					antag.candidates -= candidate
					log_debug("[candidate.key] is a ghost and can not be selected.")
		if(length(antag.candidates) >= antag.initial_spawn_req)
			antag.attempt_spawn()
			antag.finalize_spawn()
			additional_antag_types.Add(antag.id)
			return 1
		else
			if(antag.initial_spawn_req > 1)
				to_world("Failed to find enough [antag.role_text_plural].")

			else
				to_world("Failed to find a [antag.role_text].")

			antag_choices -= antag
			if(length(antag_choices))
				antag = antag_choices[1]
				if(antag)
					to_world("Attempting to spawn [antag.role_text_plural].")

	return 0