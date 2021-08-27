//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/respawned_time = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/datum/browser/panel
	var/show_invalid_jobs = 0
	universal_speak = TRUE

	invisibility = 101

	density = FALSE
	stat = DEAD

	movement_handlers = list()
	anchored = TRUE	//  don't get pushed around

	virtual_mob = null // Hear no evil, speak no evil

/mob/new_player/New()
	..()
	verbs += /mob/proc/toggle_antag_pool

/mob/new_player/proc/new_player_panel(force = FALSE)
	if(!SScharacter_setup.initialized && !force)
		return // Not ready yet.
	var/output = list()
	output += "<div align='center'>"
	output += "<i>[GLOB.using_map.get_map_info()]</i>"
	output +="<hr>"
	output += "<a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A> "

	if(GAME_STATE > RUNLEVEL_LOBBY)
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A> "

	output += "<a href='byond://?src=\ref[src];observe=1'>Observe</A> "
	output += "<hr>Current character: <a href='byond://?src=\ref[client.prefs];load=1;details=1'>[client.prefs.real_name]</a>[client.prefs.job_high ? ", [client.prefs.job_high]" : null]<br>"
	if(GAME_STATE <= RUNLEVEL_LOBBY)
		if(ready)
			output += "<a class='linkOn' href='byond://?src=\ref[src];ready=0'>Un-Ready</a>"
		else
			output += "<a href='byond://?src=\ref[src];ready=1'>Ready Up</a>"
	else
		output += "<a href='byond://?src=\ref[src];late_join=1'>Join Game!</A>"

	output += "</div>"

	panel = new(src, "Welcome","Welcome to [GLOB.using_map.full_name]", 560, 280, src)
	panel.set_window_options("can_close=0")
	panel.set_content(JOINTEXT(output))
	panel.open()

/mob/new_player/Stat()
	. = ..()

	if(statpanel("Lobby"))
		if(check_rights(R_INVESTIGATE, 0, src))
			stat("Game Mode:", "[SSticker.mode ? SSticker.mode.name : SSticker.master_mode] ([SSticker.master_mode])")
		else
			stat("Game Mode:", PUBLIC_GAME_MODE)
		var/extra_antags = list2params(additional_antag_types)
		stat("Added Antagonists:", extra_antags ? extra_antags : "None")
		stat("Initial Continue Vote:", "[round(config.vote_autotransfer_initial / 600, 1)] minutes")
		stat("Additional Vote Every:", "[round(config.vote_autotransfer_interval / 600, 1)] minutes")

		if(GAME_STATE <= RUNLEVEL_LOBBY)
			stat("Time To Start:", "[round(SSticker.pregame_timeleft/10)][SSticker.round_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in GLOB.player_list)
				var/highjob
				if (player.client)
					var/show_ready = player.client.get_preference_value(/datum/client_preference/show_ready) == GLOB.PREF_SHOW
					if (player.client.prefs?.job_high)
						highjob = " as [player.client.prefs.job_high]"
					if (!player.is_stealthed())
						stat("[player.key]", (player.ready && show_ready)?("(Playing[highjob])"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++
		else
			stat("Next Continue Vote:", "[max(round(transfer_controller.time_till_transfer_vote() / 600, 1), 0)] minutes")

/mob/new_player/Topic(href, href_list) // This is a full override; does not call parent.
	if(usr != src)
		return TOPIC_NOACTION
	if(!client)
		return TOPIC_NOACTION

	if(href_list["show_preferences"])
		client.prefs.open_setup_window(src)
		return 1

	if(href_list["ready"])
		if(GAME_STATE <= RUNLEVEL_LOBBY) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		panel.close()
		new_player_panel()

	if(href_list["observe"])
		if(GAME_STATE < RUNLEVEL_LOBBY)
			to_chat(src, "<span class='warning'>Please wait for server initialization to complete...</span>")
			return

		if(!config.respawn_delay || client.holder || alert(src,"Are you sure you wish to observe? You will have to wait [config.respawn_delay] minute\s before being able to respawn!","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1
			var/mob/observer/ghost/observer = new()

			spawning = 1
			sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo


			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if(istype(O))
				to_chat(src, "<span class='notice'>Now teleporting.</span>")
				observer.forceMove(O.loc)
			else
				to_chat(src, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the map.</span>")
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			var/should_announce = client.get_preference_value(/datum/client_preference/announce_ghost_join) == GLOB.PREF_YES

			if(isnull(client.holder) && should_announce)
				announce_ghost_joinleave(src)

			var/mob/living/carbon/human/dummy/mannequin = new()
			client.prefs.dress_preview_mob(mannequin)
			observer.set_appearance(mannequin)
			qdel(mannequin)

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.SetName(observer.real_name)
			if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			qdel(src)

			return 1

	if(href_list["late_join"])
		if(GAME_STATE != RUNLEVEL_GAME)
			to_chat(usr, SPAN_WARNING("The round has either not started yet or already ended."))
			return
		if (!client.holder)
			var/dsdiff = config.respawn_menu_delay MINUTES - (world.time - respawned_time)
			if (dsdiff > 0)
				to_chat(usr, SPAN_WARNING("You must wait [time2text(dsdiff, "mm:ss")] before rejoining."))
				return
		LateChoices() //show the latejoin job selection menu

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])
		var/datum/job/job = SSjobs.get_by_title(href_list["SelectedJob"])

		if(!SSjobs.check_general_join_blockers(src, job))
			return FALSE

		var/datum/species/S = all_species[client.prefs.species]
		if(!check_species_allowed(S))
			return 0

		AttemptLateSpawn(job, client.prefs.spawnpoint)
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)

	else if(!href_list["late_join"])
		new_player_panel()

/mob/new_player/proc/AttemptLateSpawn(var/datum/job/job, var/spawning_at)

	if(src != usr)
		return 0
	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0

	if(!job || !job.is_available(client))
		alert("[job.title] is not available. Please try another.")
		return 0
	if(job.is_restricted(client.prefs, src))
		return

	var/datum/spawnpoint/spawnpoint = job.get_spawnpoint(client)
	var/turf/spawn_turf = pick(spawnpoint.turfs)
	if(job.latejoin_at_spawnpoints)
		var/obj/S = job.get_roundstart_spawnpoint()
		spawn_turf = get_turf(S)

	if(!SSjobs.check_unsafe_spawn(src, spawn_turf))
		return

	// Just in case someone stole our position while we were waiting for input from alert() proc
	if(!job || !job.is_available(client))
		to_chat(src, alert("[job.title] is not available. Please try another."))
		return 0

	SSjobs.assign_role(src, job.title, 1)

	var/mob/living/character = create_character(spawn_turf)	//creates the human and transfers vars and mind
	if(!character)
		return 0

	character = SSjobs.equip_rank(character, job.title, 1)					//equips the human
	SScustomitems.equip_custom_items(character)

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(character.mind.assigned_role == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet

		// is_available for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.forceMove(C.loc)
		var/mob/living/silicon/ai/A = character
		A.on_mob_init()

		AnnounceCyborg(character, job.title, "has been downloaded to the empty core in \the [character.loc.loc]")
		SSticker.mode.handle_latejoin(character)

		qdel(C)
		qdel(src)
		return

	SSticker.mode.handle_latejoin(character)
	GLOB.universe.OnPlayerLatejoin(character)
	spawnpoint.after_join(character)
	if(job.create_record)
		if(character.mind.assigned_role != "Robot")
			CreateModularRecord(character)
			SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
			AnnounceArrival(character, job, spawnpoint.msg)
		else
			AnnounceCyborg(character, job, spawnpoint.msg)
	log_and_message_admins("has joined the round as [character.mind.assigned_role].", character)

	if(character.needs_wheelchair())
		equip_wheelchair(character)

	qdel(src)


/mob/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message)
	if (GAME_STATE == RUNLEVEL_GAME)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		GLOB.global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived"].", "Arrivals Announcement Computer")

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/list/header = list("<html><body><center>")
	header += "<b>Welcome, [name].<br></b>"
	header += "Round Duration: [roundduration2text()]<br>"

	if(evacuation_controller.has_evacuated())
		header += "<font color='red'><b>\The [station_name()] has been evacuated.</b></font><br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of no recall
			header += "<font color='red'>\The [station_name()] is currently undergoing evacuation procedures.</font><br>"
		else                                           // Crew transfer initiated
			header += "<font color='red'>\The [station_name()] is currently undergoing crew transfer procedures.</font><br>"

	var/list/dat = list()
	dat += "Choose from the following open/valid positions:<br>"
	dat += "<a href='byond://?src=\ref[src];invalid_jobs=1'>[show_invalid_jobs ? "Hide":"Show"] unavailable jobs.</a><br>"
	dat += "<table>"
	dat += "<tr><td colspan = 3><b>[GLOB.using_map.station_name]:</b></td></tr>"

	// TORCH JOBS
	var/list/job_summaries
	var/list/hidden_reasons = list()
	for(var/datum/job/job in SSjobs.primary_job_datums)
		var/summary = job.get_join_link(client, "byond://?src=\ref[src];SelectedJob=[job.title]", show_invalid_jobs)
		if(summary && summary != "")
			LAZYADD(job_summaries, summary)
		else
			for(var/raisin in job.get_unavailable_reasons(client))
				hidden_reasons[raisin] = TRUE

	if(LAZYLEN(job_summaries))
		dat += job_summaries
	else
		dat += "<tr><td>No available positions.</td></tr>"
	// END TORCH JOBS

	// SUBMAP JOBS
	for(var/thing in SSmapping.submaps)
		var/datum/submap/submap = thing
		if(submap && submap.available())
			dat += "<tr><td colspan = 3><b>[submap.name] ([submap.archetype.descriptor]):</b></td></tr>"
			job_summaries = list()
			for(var/otherthing in submap.jobs)
				var/datum/job/job = submap.jobs[otherthing]
				var/summary = job.get_join_link(client, "byond://?src=\ref[submap];joining=\ref[src];join_as=[otherthing]", show_invalid_jobs)
				if(summary && summary != "")
					LAZYADD(job_summaries, summary)
				else
					for(var/raisin in job.get_unavailable_reasons(client))
						hidden_reasons[raisin] = TRUE

			if(LAZYLEN(job_summaries))
				dat += job_summaries
			else
				dat += "No available positions."
	// END SUBMAP JOBS

	dat += "</table></center>"
	if(LAZYLEN(hidden_reasons))
		var/list/additional_dat = list("<br><b>Some roles have been hidden from this list for the following reasons:</b><br>")
		for(var/raisin in hidden_reasons)
			additional_dat += "[raisin]<br>"
		additional_dat += "<br>"
		dat = additional_dat + dat
	dat = header + dat
	show_browser(src, jointext(dat, null), "window=latechoices;size=450x640;can_close=1")

/mob/new_player/proc/create_character(var/turf/spawn_turf)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!spawn_turf)
		var/datum/job/job = SSjobs.get_by_title(mind.assigned_role)
		if(!job)
			job = SSjobs.get_by_title(GLOB.using_map.default_assistant_title)
		var/datum/spawnpoint/spawnpoint = job.get_spawnpoint(client, client.prefs.ranks[job.title])
		spawn_turf = pick(spawnpoint.turfs)

	if(chosen_species)
		if(!check_species_allowed(chosen_species))
			spawning = 0 //abort
			return null
		new_character = new(spawn_turf, chosen_species.name)
		if(chosen_species.has_organ[BP_POSIBRAIN] && client && client.prefs.is_shackled)
			var/obj/item/organ/internal/posibrain/B = new_character.internal_organs_by_name[BP_POSIBRAIN]
			if(B)	B.shackle(client.prefs.get_lawset())

	if(!new_character)
		new_character = new(spawn_turf)

	new_character.lastarea = get_area(spawn_turf)

	client.prefs.copy_to(new_character)

	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0 //we wish to transfer the key manually
		mind.original = new_character
		if(client.prefs.memory)
			mind.StoreMemory(client.prefs.memory)
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLOB.GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()

	new_character.key = key		//Manually transfer the key to log them in
	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<div align='center'>"
	dat += html_crew_manifest(OOC = 1)
	//show_browser(src, dat, "window=manifest;size=370x420;can_close=1")
	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	close_browser(src, "window=latechoices") //closes late choices window
	panel.close()

/mob/new_player/proc/check_species_allowed(datum/species/S, var/show_alert=1)
	if(!S.is_available_for_join() && !has_admin_rights())
		if(show_alert)
			to_chat(src, alert("Your current species, [client.prefs.species], is not available for play."))
		return 0
	if(!is_alien_whitelisted(src, S))
		if(show_alert)
			to_chat(src, alert("You are currently not whitelisted to play [client.prefs.species]."))
		return 0
	return 1

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species || !check_species_allowed(chosen_species, 0))
		return SPECIES_HUMAN

	return chosen_species.name

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	return

/mob/new_player/show_message(msg, type, alt, alt_type)
	return

mob/new_player/MayRespawn()
	return 1

/mob/new_player/touch_map_edge()
	return

/mob/new_player/say(var/message)
	sanitize_and_communicate(/decl/communication_channel/ooc, client, message)

/mob/new_player/verb/next_lobby_track()
	set name = "Play Different Lobby Track"
	set category = "OOC"

	if(get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_NO)
		return
	var/decl/audio/track/track = GLOB.using_map.get_lobby_track(GLOB.using_map.lobby_track.type)
	sound_to(src, track.get_sound())
	to_chat(src, track.get_info())
