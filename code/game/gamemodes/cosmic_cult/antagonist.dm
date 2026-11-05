GLOBAL_TYPED_NEW(cosmic_cult, /datum/antagonist/cosmic_cultist)

/datum/antagonist/cosmic_cultist
	id = MODE_COSMIC_CULTIST
	role_text = "Cosmic Cultist"
	role_text_plural = "Cosmic Cultists"
	restricted_jobs = list(/datum/job/lawyer, /datum/job/captain, /datum/job/hos, /datum/job/officer, /datum/job/warden, /datum/job/detective)
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/psychiatrist, /datum/job/submap)

	welcome_text = "Usher in the end of all things through subterfuge and sabotage, brainwashing those who would oppose you."

	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 3
	hard_cap_round = 5

	initial_spawn_req = 1
	initial_spawn_target = 3
	skill_setter = /datum/antag_skill_setter/station

	antag_indicator = "hud_cosmic_cultist"
	antaghud_indicator = "hud_cosmic_cultist"

	faction = "cosmic_cult"

	base_to_load = /datum/map_template/ruin/antag_spawn/cosmic_cult

	var/rift_timer

	var/tier = 1
	var/progress = 0
	var/crew_proportion = 0.40
	var/progress_per_crew = 8
	var/rift_group_size = 3
	var/crew_per_rift_group = 6

/datum/antagonist/cosmic_cultist/add_antagonist(datum/mind/player, ignore_role, do_not_equip, move_to_spawn, do_not_announce, preserve_appearance)
	. = ..()
	if(!.)
		return

	player.current.playsound_local(null, 'sound/coscult/cosmic-start.ogg', 100, 0)
	new /datum/cosmic_cultist(player)

/datum/antagonist/cosmic_cultist/remove_antagonist(datum/mind/player, show_message, implanted)
	. = ..()
	if(!.)
		return

	player.cosmic_cultist.Remove()

/datum/antagonist/cosmic_cultist/proc/spawn_rift()
	var/turf/target = pick_area_and_turf(
		GLOB.is_station_but_not_space_or_shuttle_area,
		list(GLOBAL_PROC_REF(not_turf_contains_dense_objects), GLOBAL_PROC_REF(has_air))
	)

	. = new /obj/cosmic_cult/rift(target)

/datum/antagonist/cosmic_cultist/proc/spawn_rift_wave()
	var/rifts = ceil(count_station_players() / crew_per_rift_group) * rift_group_size
	for (var/counter in 1 to rifts)
		spawn_rift()

	return rifts

/datum/antagonist/cosmic_cultist/proc/do_rift_wave()
	spawn_rift_wave()
	queue_rift_wave()

/datum/antagonist/cosmic_cultist/proc/queue_rift_wave()
	if (!isnull(rift_timer))
		deltimer(rift_timer)
	rift_timer = addtimer(new Callback(src, PROC_REF(do_rift_wave)), rift_wave_delay(), TIMER_STOPPABLE | TIMER_UNIQUE)

/datum/antagonist/cosmic_cultist/proc/rift_wave_delay()
	return rand(230 SECONDS, 360 SECONDS)

/datum/antagonist/cosmic_cultist/proc/count_station_players()
	var/count = 0
	for (var/mob/player as anything in GLOB.player_list)
		if (player.stat == DEAD)
			continue

		var/datum/job/job = SSjobs.get_by_title(player.mind.assigned_role)
		if (job?.create_record)
			count += 1

	return count

/datum/antagonist/cosmic_cultist/proc/count_cultists()
	var/count = 0

	for (var/datum/mind/mind as anything in get_antags(MODE_COSMIC_CULTIST))
		var/mob/living/living = mind.current

		if (living && living.stat != DEAD)
			count += 1

	return count

/datum/antagonist/cosmic_cultist/proc/get_target_progress(tier)
	var/target_crew_amount = ceil(count_station_players() * crew_proportion)
	var/entropy_amount = target_crew_amount * progress_per_crew

	switch (tier)
		if (2)
			return ceil(entropy_amount / 3)
		if (3)
			return ceil(entropy_amount * 2 / 3)
		if (4)
			return ceil(entropy_amount)

	return entropy_amount

/datum/antagonist/cosmic_cultist/proc/adjust_progress(delta)
	src.progress += delta

	if (src.progress < get_target_progress(tier + 1))
		return

	switch (tier)
		if (1)
			enter_tier_two()
		if (2)
			enter_tier_three()
		if (3)
			enter_pre_finale()

/datum/antagonist/cosmic_cultist/proc/malign_narration(msg)
	for (var/mob/player as anything in GLOB.player_list)
		if (!isnewplayer(player))
			to_chat(player, SPAN_CLASS("malign", SPAN_ITALIC(msg)))

/datum/antagonist/cosmic_cultist/proc/give_all_cultists_progress(progress)
	for (var/datum/mind/mind as anything in get_antags(MODE_COSMIC_CULTIST))
		mind.cosmic_cultist.adjust_progress(progress)

/datum/antagonist/cosmic_cultist/proc/enter_tier_two()
	set waitfor = FALSE
	src.tier = 2

	cosmic_tier_2_announcement.Announce("Scanners detect a notable increase in Lambda-CDM! Rifts in realspace may appear shortly. Please alert the Research department if sighted.")
	sleep(5 SECONDS)
	malign_narration("An unnerving numbness prickles your senses.")
	sleep(5 SECONDS)
	do_rift_wave()
	give_all_cultists_progress(8)

/datum/antagonist/cosmic_cultist/proc/enter_tier_three()
	set waitfor = FALSE
	src.tier = 3

	cosmic_tier_3_announcement.Announce("Critical increase in Lambda-CDM detected. Realspace corrosion and infected personnel are to be eliminated on sight.")
	sleep(5 SECONDS)
	malign_narration("Arcs of malign energy crackle across \the [GLOB.using_map.name]'s groaning structure. The end draws nearer.")
	sleep(5 SECONDS)
	do_rift_wave()
	give_all_cultists_progress(8)

	SSskybox.change_skybox("void", COLOR_WHITE, new_use_stars = TRUE, new_use_overmap_details = FALSE, new_ignore_z_overrides = TRUE, new_star_state = "wisp")

/datum/antagonist/cosmic_cultist/proc/enter_pre_finale()
	set waitfor = FALSE
	src.tier = 4

	cosmic_tier_4_announcement.Announce("All hands on deck. The Lambda-CDM anomaly is going supercritical, instruments failing; bluespace-to-real event horizon IMMINENT. If you are not already on counter-protocol, immediately sortie and intervene. Repeat: Intervene immediately or die.")
	sleep(5 SECONDS)
	malign_narration("The boundary between that-which-is and that-which-is-not begins to blur...")
	give_all_cultists_progress(8)

/proc/is_cosmic_cultist(mob/subject)
	var/datum/mind/mind = subject
	if (ismob(mind))
		mind = subject.mind
	return istype(mind) && !isnull(mind.cosmic_cultist)
