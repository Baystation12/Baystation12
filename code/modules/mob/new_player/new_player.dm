//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/respawned_time = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
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
						var/can_see_hidden = check_rights(R_INVESTIGATE, 0)
						var/datum/game_mode/mode = SSticker.pick_mode(SSticker.master_mode)
						var/list/readied_antag_roles = list()
						if (mode && can_see_hidden)
							for (var/role in player.client.prefs.be_special_role)
								if (role in mode.antag_tags)
									readied_antag_roles += role

						var/antag_role_text = "[length(readied_antag_roles) ? "Readied for ([english_list(readied_antag_roles)])" : ""]"
						stat("[player.key]", (player.ready && (show_ready || can_see_hidden)?("(Playing[highjob]) [(can_see_hidden && !show_ready) ? "(Hidden)" : ""] [antag_role_text]"):(null)))
				totalPlayers++
				if(player.ready)totalPlayersReady++
		else
			stat("Next Continue Vote:", "[max(round(transfer_controller.time_till_transfer_vote() / 600, 1), 0)] minutes")

/mob/new_player/Topic(href, href_list) // This is a full override; does not call parent.
	if(usr != src || !client)
		return TOPIC_NOACTION

	if(href_list["lobby_setup"])
		client.prefs.open_setup_window(src)
		return 1

	if(href_list["lobby_init"])
		GLOB.using_map.update_titlescreen(client)
		return 1
	if(href_list["lobby_changelog"])
		client.changes()
		return 1
	if (href_list["lobby_github"])
		client.link_url(config.source_url, "Source", TRUE)
		return 1
	if (href_list["lobby_discord"])
		client.link_url(config.discord_url, "Discord", TRUE)
		return 1
	if (href_list["lobby_wiki"] || href_list["show_wiki"])
		client.link_url(config.wiki_url, "Wiki", TRUE)
		return 1
	if (href_list["show_rules"])
		client.link_url(config.rules_url, "Rules", TRUE)
		return 1
	if (href_list["show_lore"])
		client.link_url(config.lore_url, "Lore", TRUE)
		return 1

	if(href_list["lobby_ready"])

		if(GAME_STATE <= RUNLEVEL_LOBBY)
			ready = !ready
			GLOB.using_map.set_titlescreen_ready(client, ready)

		if(config.minimum_byondacc_age && client.player_age <= config.minimum_byondacc_age)
			if(!client.discord_id || (client.discord_id && length(client.discord_id) == 32))
				client.load_player_discord(client)
				to_chat(usr, "<span class='danger'>Вам необходимо привязать дискорд-профиль к аккаунту!</span>")
				to_chat(usr, "<span class='warning'>Нажмите 'Привязка Discord' во вкладке 'Special Verbs' для получения инструкций.</span>")
				return FALSE

	if(href_list["lobby_observe"])
		if(config.minimum_byondacc_age && client.player_age <= config.minimum_byondacc_age)
			if(!client.discord_id || (client.discord_id && length(client.discord_id) == 32))
				client.load_player_discord(client)
				to_chat(usr, "<span class='danger'>Вам необходимо привязать дискорд-профиль к аккаунту!</span>")
				to_chat(usr, "<span class='warning'>Нажмите 'Привязка Discord' во вкладке 'Special Verbs' для получения инструкций.</span>")
				return FALSE

		if(GAME_STATE < RUNLEVEL_LOBBY)
			to_chat(src, SPAN_WARNING("Please wait for server initialization to complete..."))
			return

		if(!config.respawn_delay || client.holder || alert(src,"Are you sure you wish to observe? You will have to wait [config.respawn_delay] minute\s before being able to respawn!","Player Setup","Yes","No") == "Yes")
			if(!client)	return
			var/mob/observer/ghost/observer = new()

			spawning = 1
			sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo


			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if(istype(O))
				to_chat(src, SPAN_NOTICE("Now teleporting."))
				observer.forceMove(O.loc)
			else
				to_chat(src, SPAN_DANGER("Could not locate an observer spawn point. Use the Teleport verb to jump to the map."))
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			var/should_announce = client.get_preference_value(/datum/client_preference/announce_ghost_join) == GLOB.PREF_YES

			if(isnull(client.holder) && should_announce)
				announce_ghost_joinleave(src)

			var/mob/living/carbon/human/dummy/mannequin = new()
			client.prefs.dress_preview_mob(mannequin)
			observer.set_appearance(mannequin)
			qdel(mannequin)

			observer.real_name = client.prefs.real_name
			observer.SetName(observer.real_name)
			if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			qdel(src)

			return

	if(href_list["lobby_join"])
		if(config.minimum_byondacc_age && client.player_age <= config.minimum_byondacc_age)
			if(!client.discord_id || (client.discord_id && length(client.discord_id) == 32))
				client.load_player_discord(client)
				to_chat(usr, "<span class='danger'>Вам необходимо привязать дискорд-профиль к аккаунту!</span>")
				to_chat(usr, "<span class='warning'>Нажмите 'Привязка Discord' во вкладке 'Special Verbs' для получения инструкций.</span>")
				return FALSE

		if(GAME_STATE != RUNLEVEL_GAME)
			to_chat(usr, SPAN_WARNING("The round has either not started yet or already ended."))
			return
		if (!client.holder)
			var/dsdiff = config.respawn_menu_delay MINUTES - (world.time - respawned_time)
			if (dsdiff > 0)
				to_chat(usr, SPAN_WARNING("You must wait [time2text(dsdiff, "mm:ss")] before rejoining."))
				return
		LateChoices() //show the latejoin job selection menu

	if(href_list["lobby_crew"])
		ViewManifest()

	if (href_list["invalid_jobs"])
		show_invalid_jobs = !show_invalid_jobs
		LateChoices()

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

/mob/new_player/proc/AttemptLateSpawn(datum/job/job, spawning_at)

	if(src != usr)
		return 0
	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(usr, SPAN_WARNING("The round is either not ready, or has already finished..."))
		return 0
	if(!config.enter_allowed)
		to_chat(usr, SPAN_NOTICE("There is an administrative lock on entering the game!"))
		return 0
	if(spawning)
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

	spawning = 1
	GLOB.using_map.fade_titlescreen(client)
	sleep(20)

	var/mob/living/character = create_character(spawn_turf)	//creates the human and transfers vars and mind
	if(!character)
		return 0

	character = SSjobs.equip_rank(character, job.title, 1)					//equips the human
	SScustomitems.equip_custom_items(character)

	character.overlay_fullscreen("init_blackout", /obj/screen/fullscreen/blackout/above_hud)
	character.clear_fullscreen("init_blackout", 30)

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


/mob/new_player/proc/AnnounceCyborg(mob/living/character, rank, join_message)
	if (GAME_STATE == RUNLEVEL_GAME)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		GLOB.global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived"].", "Arrivals Announcement Computer")

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.real_name

	var/list/header = list("<html><body><center>")
	header += "<b>Добро пожаловать, [name].<br></b>"
	header += "Длительность раунда: [roundduration2text()]<br>"

	if(evacuation_controller.has_evacuated())
		header += "[SPAN_COLOR("red", "<b>[station_name()] была эвакуирована.</b>")]<br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of no recall
			header += "[SPAN_COLOR("red", "[station_name()] в текущий момент эвакуируется.")]<br>"
		else                                           // Crew transfer initiated
			header += "[SPAN_COLOR("red", "[station_name()] перемещается в следующий сектор.")]<br>"

	var/list/dat = list()
	dat += "Выберите одну из доступных ролей:<br>"
	dat += "<a href='byond://?src=\ref[src];invalid_jobs=1'>[show_invalid_jobs ? "Скрыть":"Показать"] недоступные профессии</a><br>"
	dat += "<table>"
	dat += "<tr><td align = 'center' colspan = 3><b>[GLOB.using_map.station_name]:</b></td></tr>"

	var/list/categorizedJobs = list(
		"Командование" =         list(jobs = list(), dep = COM, color = "#aac1ee"),
		"Младшее командование" = list(jobs = list(), dep = SPT, color = "#aac1ee"),
		"Инженерия" =     list(jobs = list(), dep = ENG, color = "#ffd699"),
		"Служба безопасности" =        list(jobs = list(), dep = SEC, color = "#ff9999"),
		"Разное" =   list(jobs = list(), dep = CIV, color = "#ffffff", colBreak = 1),
		"Синтетики" =       list(jobs = list(), dep = MSC, color = "#ccffcc"),
		"Сервис" =         list(jobs = list(), dep = SRV, color = "#cccccc"),
		"Медицина" =         list(jobs = list(), dep = MED, color = "#99ffe6"),
		"Наука" =         list(jobs = list(), dep = SCI, color = "#e6b3e6", colBreak = 1),
		"Карго" =          list(jobs = list(), dep = SUP, color = "#ead4ae"),
		"Экспедиция" =      list(jobs = list(), dep = EXP, color = "#ffd699"),
		"ОШИБКА" =           list(jobs = list(), color = "#ffffff", colBreak = 1)
	)

	// TORCH JOBS
	var/list/job_summaries
	var/list/hidden_reasons = list()
	var/catcheck
	for(var/datum/job/job in SSjobs.primary_job_datums)
		var/summary = job.get_join_link(client, "byond://?src=\ref[src];SelectedJob=[job.title]", show_invalid_jobs)
		if(job.department_flag)
			catcheck |= job.department_flag
		if(summary && summary != "")
			for(var/category in categorizedJobs)
				var/list/jobs = list()

				if(job.department_flag & categorizedJobs[category]["dep"])
					LAZYADD(jobs, job)

				if(category == "ОШИБКА")
					if(!job.department_flag)
						LAZYADD(jobs, job)
						continue

					var/check = FALSE
					for(var/categ in categorizedJobs)
						if(job in categorizedJobs[categ]["jobs"])
							check = TRUE
							continue
					if(!check)
						LAZYADD(jobs, job)

				if(length(jobs))
					categorizedJobs[category]["jobs"] += jobs
		else
			for(var/raisin in job.get_unavailable_reasons(client))
				hidden_reasons[raisin] = TRUE

	dat += "<tr><td valign='top'>"
	for(var/jobcat in categorizedJobs)

		if(categorizedJobs[jobcat]["colBreak"])
			dat += "</td><td valign='top'>"

		if((length(categorizedJobs[jobcat]["jobs"]) < 1) && (jobcat == "ОШИБКА"))
			continue

		var/flag = categorizedJobs[jobcat]["dep"]
		if(!flag)
			log_admin("[jobcat] НЕТ ФЛАГА КАТЕГОРИИ.")
			message_staff("[jobcat] НЕТ ФЛАГА КАТЕГОРИИ.")
			continue
		else if(!(catcheck & flag))
			continue

		var/color = categorizedJobs[jobcat]["color"]
		dat += "<fieldset style='width: 250px; border: 2px solid [color]; display: inline'>"
		dat += "<legend align='center' style='color: [color]'>[jobcat]</legend>"
		dat += "<table align = 'center'>"
		if(length(categorizedJobs[jobcat]["jobs"]) < 1)
			dat += "<tr><td></td><td align = 'center'><i>Нет доступных ролей.</i><br></td></tr>"
			dat += "</table>"
			dat += "</fieldset><br>"
			continue
		for(var/datum/job/prof in categorizedJobs[jobcat]["jobs"])
			if(jobcat == "Командование")
				if(istype(prof, /datum/job/captain))
					dat += prof.get_join_link(client, "byond://?src=\ref[src];SelectedJob=[prof.title]", show_invalid_jobs, TRUE)
				else
					dat += prof.get_join_link(client, "byond://?src=\ref[src];SelectedJob=[prof.title]", show_invalid_jobs)
			else if(prof.department_flag & COM)
				dat += prof.get_join_link(client, "byond://?src=\ref[src];SelectedJob=[prof.title]", show_invalid_jobs, TRUE)
			else
				dat += prof.get_join_link(client, "byond://?src=\ref[src];SelectedJob=[prof.title]", show_invalid_jobs)
		dat += "</table>"
		dat += "</fieldset><br>"
	dat += "</td></tr></table>"
	// END TORCH JOBS

	// SUBMAP JOBS
	if(SSmapping.submaps)
		dat += "<table><tr><td>"
		for(var/thing in SSmapping.submaps)
			var/datum/submap/submap = thing
			if(submap && submap.available())
				var/color = "ffffff"
				dat += "<fieldset style='border: 2px solid [color]; display: inline'>"
				dat += "<legend align='center' style='color: [color]'><b>[submap.name] ([submap.archetype.descriptor])</b></legend>"
				dat += "<table align = 'center'>"
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
					dat += "</table>"
					dat += "</fieldset><br>"
				else
					dat += "<tr><td></td><td align = 'center'><i>Нет доступных ролей.</i></td></tr>"
					dat += "</table>"
					dat += "</fieldset><br>"
		dat += "</td></tr></table>"
	// END SUBMAP JOBS

	dat += "</center></body></html>"
	if(LAZYLEN(hidden_reasons))
		var/list/additional_dat = list("<br><b>Некоторые роли были убраны из этого списка по следующим причинам:</b><br>")
		for(var/raisin in hidden_reasons)
			additional_dat += "[raisin]<br>"
		additional_dat += "<br>"
		dat = additional_dat + dat
	dat = header + dat
	var/datum/browser/popup = new(src, "latechoices", "Choose Profession", 900, 900)
	popup.set_content(jointext(dat, null))
	popup.open(0) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/new_player/proc/create_character(turf/spawn_turf)
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
		if(spawnpoint)
			spawn_turf = pick(spawnpoint.turfs)
		else
			spawning = 0


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

/mob/new_player/proc/check_species_allowed(datum/species/S, show_alert=1)
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

/mob/new_player/hear_say(message, verb = "says", datum/language/language = null, alt_name = "",italics = 0, mob/speaker = null)
	return

/mob/new_player/hear_radio(message, verb="says", datum/language/language=null, part_a, part_b, part_c, mob/speaker = null, hard_to_hear = 0)
	return

/mob/new_player/show_message(msg, type, alt, alt_type)
	return

/mob/new_player/MayRespawn()
	return 1

/mob/new_player/touch_map_edge()
	return

/mob/new_player/say(message)
	sanitize_and_communicate(/singleton/communication_channel/ooc, client, message)

/mob/new_player/verb/next_lobby_track()
	set name = "Play Different Lobby Track"
	set category = "OOC"

	if(get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_NO)
		return
	var/singleton/audio/track/track = GLOB.using_map.get_lobby_track(GLOB.using_map.lobby_track.type)
	sound_to(src, track.get_sound())
	to_chat(src, track.get_info())


/hook/roundstart/proc/update_lobby_browsers()
	GLOB.using_map.update_titlescreens()
	return TRUE
