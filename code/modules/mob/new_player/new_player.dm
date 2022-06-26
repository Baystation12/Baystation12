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


/mob/new_player/proc/new_player_panel(force)
	if (!force && !SScharacter_setup.initialized)
		return
	var/list/output = list()
	output += "<div align='center'>"
	if (config.wiki_url || config.rules_url || config.lore_url)
		var/player_age = client?.player_age
		if (isnum(player_age) && player_age < 7)
			output += "<b>Welcome! Please check out these links:</b><br>"
		if (config.wiki_url)
			output += "<a href='byond://?src=\ref[src];show_wiki=1'>Wiki</a>"
		if (config.rules_url)
			output += "<a href='byond://?src=\ref[src];show_rules=1'>Rules</a>"
		if (config.lore_url)
			output += "<a href='byond://?src=\ref[src];show_lore=1'>Lore</a>"
	output += "<hr>"
	if (GAME_STATE > RUNLEVEL_LOBBY)
		output += "<a href='byond://?src=\ref[src];manifest=1'>Manifest</a>"
	output += "<a href='byond://?src=\ref[src];show_preferences=1'>Options</a>"
	output += "<hr>"
	output += "<b>Playing As</b><br>"
	output += "<a href='byond://?src=\ref[client.prefs];load=1;details=1'>[client.prefs.real_name || "(Random)"]</a><br>"
	output += client.prefs.job_high ? "[client.prefs.job_high]" : null
	output += "<hr>"
	output += "<a href='byond://?src=\ref[src];observe=1'>Join As Observer</a>"
	if (GAME_STATE > RUNLEVEL_LOBBY)
		output += "<a href='byond://?src=\ref[src];late_join=1'>Join As Selected</a>"
	else
		output += "<a [ready?"class='linkOn'":""] href='byond://?src=\ref[src];ready=[!ready]'>Round Start Join</a>"
	output += "<hr>"
	output += "<i>[GLOB.using_map.get_map_info()||"No information available for the current map."]</i>"
	output += "</div>"
	panel = new (src, "Welcome","Welcome to [GLOB.using_map.full_name]", 520, 340, src)
	panel.set_window_options("can_close=0")
	panel.set_content(output.Join())
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
			var/we_are_admin = isadmin(src)
			for(var/mob/new_player/player in GLOB.player_list)
				if(player.is_stealthed() && !we_are_admin)
					continue
				var/highjob
				if (player.client)
					var/show_ready = player.client.get_preference_value(/datum/client_preference/show_ready) == GLOB.PREF_SHOW
					if (player.client.prefs?.job_high)
						highjob = " as [player.client.prefs.job_high]"
					if (!player.is_stealthed())
						var/can_see_hidden = check_rights(R_INVESTIGATE, 0)
						var/datum/game_mode/mode = config.pick_mode(SSticker.master_mode)
						var/list/readied_antag_roles = list()
						if (mode && can_see_hidden)
							for (var/role in player.client.prefs.be_special_role)
								if (role in mode.antag_tags)
									readied_antag_roles += role

						var/antag_role_text = "[readied_antag_roles.len ? "Readied for ([english_list(readied_antag_roles)])" : ""]"
						stat("[player.key]", (player.ready && (show_ready || can_see_hidden)?("(Playing[highjob]) [(can_see_hidden && !show_ready) ? "(Hidden)" : ""] [antag_role_text]"):(null)))
				totalPlayers++
				if(player.ready)totalPlayersReady++
		else
			stat("Next Continue Vote:", "[max(round(transfer_controller.time_till_transfer_vote() / 600, 1), 0)] minutes")

/mob/new_player/Topic(href, href_list) // This is a full override; does not call parent.
	if (usr != src)
		return TOPIC_NOACTION
	if (!client)
		return TOPIC_NOACTION
	if (href_list["show_preferences"])
		client.prefs.open_setup_window(src)
		return 1
	if (href_list["show_wiki"])
		client.link_url(config.wiki_url, "Wiki", TRUE)
		return 1
	if (href_list["show_rules"])
		client.link_url(config.rules_url, "Rules", TRUE)
		return 1
	if (href_list["show_lore"])
		client.link_url(config.lore_url, "Lore", TRUE)
		return 1
	if (href_list["ready"])
		ready = GAME_STATE > RUNLEVEL_LOBBY ? 0 : text2num(href_list["ready"])
	if (href_list["refresh"])
		panel.close()
		if(client)
			new_player_panel()

	if(href_list["observe"])
		if(GAME_STATE < RUNLEVEL_LOBBY)
			to_chat(src, "<span class='warning'>Пожалуйста, подождите загрузки сервера.</span>")
			return

		if(!config.respawn_delay || client.holder || alert(src,"Вы уверены, что хотите наблюдать? Вам придется ждать [OBSERV_SPAWN_DELAY] минут прежде чем получить возможность респавна.","Player Setup","Да","Нет") == "Да")
			if(!client) return 1

			var/mob/observer/ghost/observer = new()

			spawning = 1
			sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo


			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if(istype(O))
				to_chat(src, "<span class='notice'>Телепортация.</span>")
				observer.forceMove(O.loc)
			else
				to_chat(src, "<span class='danger'>Не удалость обнаружить точку спавна наблюдателей. Используйте кнопку Teleport чтобы переместить к карте.</span>")
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
			to_chat(usr, SPAN_WARNING("Раунд или не начался или уже закончился..."))
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

	if(href_list["invalid_jobs"])
		show_invalid_jobs = !show_invalid_jobs
		LateChoices()

	else if(!href_list["late_join"])
		if(client)
			new_player_panel()

/mob/new_player/proc/AttemptLateSpawn(var/datum/job/job, var/spawning_at)

	if(src != usr)
		return 0
	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(usr, "<span class='warning'>Раунд не начался или уже закончился...</span>")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>Возможность зайти за профессию отключена администрацией в ивентных целях. Пожалуйста, станьте наблюдателем.</span>")
		return 0

	if(!job || !job.is_available(client))
		alert("Позиция [job.title] недоступна. Пожалуйста, выберите другую.")
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
		to_chat(src, alert("Позиция [job.title] недоступна. Пожалуйста, выберите другую."))
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

		/*AnnounceCyborg(character, job.title, "has been downloaded to the empty core in \the [character.loc.loc]")*/
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
		GLOB.global_announcer.autosay("Новый [rank ? "[rank]" : "visitor" ] [join_message ? join_message : "активировался"].", "Arrivals Announcement Computer")

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/list/header = list("<html><body><center>")
	header += "<b>Welcome, [name].<br></b>"
	header += "Round Duration: [roundduration2text()]<br>"

	if(evacuation_controller.has_evacuated())
		header += "<font color='red'><b>[station_name()] была эвакуирована.</b></font><br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of no recall
			header += "<font color='red'>[station_name()] в текущий момент эвакуируется.</font><br>"
		else                                           // Crew transfer initiated
			header += "<font color='red'>[station_name()] в текущий момент перемещается в следующий сектор.</font><br>"

	var/list/dat = list()
	dat += "Выберите одну из доступных ролей:<br>"
	dat += "<a href='byond://?src=\ref[src];invalid_jobs=1'>[show_invalid_jobs ? "Скрыть":"Показать"] недоступные профессии.</a><br>"
	dat += "<table>"
/*[ORIG]
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
		dat += "<tr><td>Нет доступных ролей.</td></tr>"
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
				dat += "Нет доступных ролей."
	// END SUBMAP JOBS

	dat += "</table></center>"
	if(LAZYLEN(hidden_reasons))
		var/list/additional_dat = list("<br><b>Некоторые роли были убраны из этого списка по следующим причинам:</b><br>")
		for(var/raisin in hidden_reasons)
			additional_dat += "[raisin]<br>"
		additional_dat += "<br>"
		dat = additional_dat + dat
	dat = header + dat
	show_browser(src, jointext(dat, null), "window=latechoices;size=450x640;can_close=1")
[/ORIG]*/
//[INF]
	var/list/categorizedJobs = list(
		"Command" = list(jobs = list(), dep = COM, color = "#aac1ee"),
		"Command Support" = list(jobs = list(), dep = SPT, color = "#aac1ee"),
		"Engineering" = list(jobs = list(), dep = ENG, color = "#ffd699"),
		"Security" = list(jobs = list(), dep = SEC, color = "#ff9999"),
		"Miscellaneous" = list(jobs = list(), dep = CIV, color = "#ffffff", colBreak = 1),
		"Synthetic" = list(jobs = list(), dep = MSC, color = "#ccffcc"),
		"Service" = list(jobs = list(), dep = SRV, color = "#cccccc"),
		"Medical" = list(jobs = list(), dep = MED, color = "#99ffe6"),
		"Science" = list(jobs = list(), dep = SCI, color = "#e6b3e6", colBreak = 1),
		"Supply" = list(jobs = list(), dep = SUP, color = "#ead4ae"),
		"Expedition" = list(jobs = list(), dep = EXP, color = "#ffd699"),
		"ERROR" = list(jobs = list(), color = "#ffffff", colBreak = 1)
		)

	dat += "<tr><td align = 'center' colspan = 3><b>[GLOB.using_map.station_name]</b></td></tr>"

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
					jobs += job
				if(category == "ERROR")
					if(!job.department_flag)
						jobs += job
						continue
					var/check = FALSE
					for(var/categ in categorizedJobs)
						if(job in categorizedJobs[categ]["jobs"])
							check = TRUE
							continue
					if(!check)
						jobs += job
				if(length(jobs))
					categorizedJobs[category]["jobs"] += jobs
		else
			for(var/raisin in job.get_unavailable_reasons(client))
				hidden_reasons[raisin] = TRUE
	dat += "<tr><td valign='top'>"
	for(var/jobcat in categorizedJobs)
		if(categorizedJobs[jobcat]["colBreak"])
			dat += "</td><td valign='top'>"
		if((length(categorizedJobs[jobcat]["jobs"]) < 1) && (jobcat == "ERROR"))
			continue
		var/flag = categorizedJobs[jobcat]["dep"]
		if(!flag)
			log_admin("[jobcat] НЕТ ФЛАГА КАТЕГОРИИ.")
			message_staff("[jobcat] НЕТ ФЛАГА КАТЕГОРИИ.")
			continue
		else if(!(catcheck & flag))
//			log_admin("[jobcat] НЕ ПРЕДУСМОТРЕНЫ ПРОФЕСИИ.")
//			message_staff("[jobcat] НЕ ПРЕДУСМОТРЕНЫ ПРОФЕСИИ.")
			continue
		var/color = categorizedJobs[jobcat]["color"]
		dat += "<fieldset style='width: 300px; border: 2px solid [color]; display: inline'>"
		dat += "<legend align='center' style='color: [color]'>[jobcat]</legend>"
		dat += "<table align = 'center'>"
		if(length(categorizedJobs[jobcat]["jobs"]) < 1)
			dat += "<tr><td></td><td align = 'center'><i>Нет доступных ролей.</i><br></td></tr>"
			dat += "</table>"
			dat += "</fieldset><br>"
			continue
		for(var/datum/job/prof in categorizedJobs[jobcat]["jobs"])
			if(jobcat == "Command")
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
						job_summaries += summary
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
	dat += "</body></html>"
	if(LAZYLEN(hidden_reasons))
		var/list/additional_dat = list("<br><b>Некоторые роли были убраны из этого списка по следующим причинам:</b><br>")
		for(var/raisin in hidden_reasons)
			additional_dat += "[raisin]<br>"
		additional_dat += "<br>"
		dat = additional_dat + dat
	dat = header + dat
	var/datum/browser/popup = new(src, "latechoices", "Choose Profession", 1050, 900)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, null))
	popup.open(0) // 0 is passed to open so that it doesn't use the onclose() proc
//[/INF]

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
		if(spawnpoint)//inf
			spawn_turf = pick(spawnpoint.turfs)
//[INF]
		else
			spawning = 0
			return null
//[/INF]

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
			to_chat(src, alert("Ваша текущая раса ([client.prefs.species]) недоступна для игры."))
		return 0
	if(!is_alien_whitelisted(src, S))
		if(show_alert)
			to_chat(src, alert("Вы не находитесь в списке ксенорас для игры за [client.prefs.species]."))
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
