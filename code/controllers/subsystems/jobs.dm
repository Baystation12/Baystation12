var/global/const/ENG = FLAG(0)
var/global/const/SEC = FLAG(1)
var/global/const/MED = FLAG(2)
var/global/const/SCI = FLAG(3)
var/global/const/CIV = FLAG(4)
var/global/const/COM = FLAG(5)
var/global/const/MSC = FLAG(6)
var/global/const/SRV = FLAG(7)
var/global/const/SUP = FLAG(8)
var/global/const/SPT = FLAG(9)
var/global/const/EXP = FLAG(10)
var/global/const/ROB = FLAG(11)

GLOBAL_VAR(antag_code_phrase)
GLOBAL_VAR(antag_code_response)

SUBSYSTEM_DEF(jobs)
	name = "Jobs"
	init_order = SS_INIT_JOBS
	flags = SS_NO_FIRE

	var/list/archetype_job_datums =    list()
	var/list/job_lists_by_map_name =   list()
	var/list/titles_to_datums =        list()
	var/list/types_to_datums =         list()
	var/list/primary_job_datums =      list()
	var/list/unassigned_roundstart =   list()
	var/list/positions_by_department = list()
	var/list/job_icons =               list()


/datum/controller/subsystem/jobs/UpdateStat(time)
	return


/datum/controller/subsystem/jobs/Initialize(start_uptime)

	// Create main map jobs.
	primary_job_datums.Cut()
	for(var/jobtype in (list(DEFAULT_JOB_TYPE) | GLOB.using_map.allowed_jobs))
		var/datum/job/job = get_by_path(jobtype)
		if(!job)
			job = new jobtype
		primary_job_datums += job

	// Create abstract submap archetype jobs for use in prefs, etc.
	archetype_job_datums.Cut()
	for(var/atype in SSmapping.submap_archetypes)
		var/decl/submap_archetype/arch = SSmapping.submap_archetypes[atype]
		for(var/jobtype in arch.crew_jobs)
			var/datum/job/job = get_by_path(jobtype)
			if(!job && ispath(jobtype, /datum/job/submap))
				// Set this here so that we don't create multiples of the same title
				// before getting to the cache updating proc below.
				types_to_datums[jobtype] = new jobtype(abstract_job = TRUE)
				job = get_by_path(jobtype)
			if(job)
				archetype_job_datums |= job

	// Init skills.
	if(!GLOB.skills.len)
		decls_repository.get_decl(/decl/hierarchy/skill)
	if(!GLOB.skills.len)
		log_error("<span class='warning'>Error setting up job skill requirements, no skill datums found!</span>")

	// Update title and path tracking, submap list, etc.
	// Populate/set up map job lists.
	job_lists_by_map_name = list("[GLOB.using_map.full_name]" = list("jobs" = primary_job_datums, "default_to_hidden" = FALSE))

	for(var/atype in SSmapping.submap_archetypes)
		var/list/submap_job_datums
		var/decl/submap_archetype/arch = SSmapping.submap_archetypes[atype]
		for(var/jobtype in arch.crew_jobs)
			var/datum/job/job = get_by_path(jobtype)
			if(job)
				LAZYADD(submap_job_datums, job)
		if(LAZYLEN(submap_job_datums))
			job_lists_by_map_name[arch.descriptor] = list("jobs" = submap_job_datums, "default_to_hidden" = TRUE)

	// Update global map blacklists and whitelists.
	for(var/mappath in GLOB.all_maps)
		var/datum/map/M = GLOB.all_maps[mappath]
		M.setup_job_lists()

	// Update valid job titles.
	titles_to_datums = list()
	types_to_datums = list()
	positions_by_department = list()
	for(var/map_name in job_lists_by_map_name)
		var/list/map_data = job_lists_by_map_name[map_name]
		for(var/datum/job/job in map_data["jobs"])
			types_to_datums[job.type] = job
			titles_to_datums[job.title] = job
			for(var/alt_title in job.alt_titles)
				titles_to_datums[alt_title] = job
			if(job.department_flag)
				for (var/I in 1 to GLOB.bitflags.len)
					if(job.department_flag & GLOB.bitflags[I])
						LAZYDISTINCTADD(positions_by_department["[GLOB.bitflags[I]]"], job.title)
						if (length(job.alt_titles))
							LAZYDISTINCTADD(positions_by_department["[GLOB.bitflags[I]]"], job.alt_titles)

	// Set up syndicate phrases.
	GLOB.antag_code_phrase = generate_code_phrase()
	GLOB.antag_code_response = generate_code_phrase()

	// Set up AI spawn locations
	spawn_empty_ai()


/datum/controller/subsystem/jobs/proc/guest_jobbans(var/job)
	for(var/dept in list(COM, MSC, SEC))
		if(job in titles_by_department(dept))
			return TRUE
	return FALSE

/datum/controller/subsystem/jobs/proc/reset_occupations()
	for(var/mob/new_player/player in GLOB.player_list)
		if((player) && (player.mind))
			player.mind.assigned_job = null
			player.mind.assigned_role = null
			player.mind.special_role = null
	for(var/datum/job/job in primary_job_datums)
		job.current_positions = 0
	unassigned_roundstart = list()

/datum/controller/subsystem/jobs/proc/get_by_title(var/rank)
	return titles_to_datums[rank]

/datum/controller/subsystem/jobs/proc/get_by_path(var/path)
	RETURN_TYPE(/datum/job)
	return types_to_datums[path]

/datum/controller/subsystem/jobs/proc/check_general_join_blockers(var/mob/new_player/joining, var/datum/job/job)
	if(!istype(joining) || !joining.client || !joining.client.prefs)
		return FALSE
	if(!istype(job))
		log_debug("Job assignment error for [joining] - job does not exist or is of the incorrect type.")
		return FALSE
	if(!job.is_position_available())
		to_chat(joining, "<span class='warning'>Unfortunately, that job is no longer available.</span>")
		return FALSE
	if(!config.enter_allowed)
		to_chat(joining, "<span class='warning'>There is an administrative lock on entering the game!</span>")
		return FALSE
	if(SSticker.mode && SSticker.mode.explosion_in_progress)
		to_chat(joining, "<span class='warning'>The [station_name()] is currently exploding. Joining would go poorly.</span>")
		return FALSE
	return TRUE

/datum/controller/subsystem/jobs/proc/check_latejoin_blockers(var/mob/new_player/joining, var/datum/job/job)
	if(!check_general_join_blockers(joining, job))
		return FALSE
	if(job.minimum_character_age && (joining.client.prefs.age < job.minimum_character_age))
		to_chat(joining, "<span class='warning'>Your character's in-game age is too low for this job.</span>")
		return FALSE
	if(!job.player_old_enough(joining.client))
		to_chat(joining, "<span class='warning'>Your player age (days since first seen on the server) is too low for this job.</span>")
		return FALSE
	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(joining, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return FALSE
	return TRUE

/datum/controller/subsystem/jobs/proc/check_unsafe_spawn(var/mob/living/spawner, var/turf/spawn_turf)
	var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	if(airstatus || radlevel > 0)
		var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus] Radiation: [radlevel] IU/s", "Atmosphere warning", "Abort", "Spawn anyway")
		if(reply == "Abort")
			return FALSE
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("User [spawner] spawned at spawn point with dangerous atmosphere.")
	return TRUE

/datum/controller/subsystem/jobs/proc/assign_role(var/mob/new_player/player, var/rank, var/latejoin = 0, var/datum/game_mode/mode = SSticker.mode)
	if(player && player.mind && rank)
		var/datum/job/job = get_by_title(rank)
		if(!job)
			return 0
		if(jobban_isbanned(player, rank))
			return 0
		if(!job.player_old_enough(player.client))
			return 0
		if(job.is_restricted(player.client.prefs))
			return 0
		if(job.title in mode.disabled_jobs)
			return 0

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			player.mind.assigned_job = job
			player.mind.assigned_role = rank
			player.mind.role_alt_title = job.get_alt_title_for(player.client)
			unassigned_roundstart -= player
			job.current_positions++
			return 1
	return 0

/datum/controller/subsystem/jobs/proc/find_occupation_candidates(datum/job/job, level, flag)
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned_roundstart)
		if(jobban_isbanned(player, job.title))
			continue
		if(!job.player_old_enough(player.client))
			continue
		if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
			continue
		if(flag && !(flag in player.client.prefs.be_special_role))
			continue
		if(player.client.prefs.CorrectLevel(job,level))
			candidates += player
	return candidates

/datum/controller/subsystem/jobs/proc/give_random_job(var/mob/new_player/player, var/datum/game_mode/mode = SSticker.mode)
	for(var/datum/job/job in shuffle(primary_job_datums))
		if(!job)
			continue
		if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
			continue
		if(istype(job, get_by_title(GLOB.using_map.default_assistant_title))) // We don't want to give him assistant, that's boring!
			continue
		if(job.is_restricted(player.client.prefs))
			continue
		if(job.title in titles_by_department(COM)) //If you want a command position, select it!
			continue
		if(jobban_isbanned(player, job.title))
			continue
		if(!job.player_old_enough(player.client))
			continue
		if(job.title in mode.disabled_jobs)
			continue
		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			assign_role(player, job.title, mode = mode)
			unassigned_roundstart -= player
			break

///This proc is called before the level loop of divide_occupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/subsystem/jobs/proc/fill_head_position(var/datum/game_mode/mode)
	for(var/level = 1 to 3)
		for(var/command_position in titles_by_department(COM))
			var/datum/job/job = get_by_title(command_position)
			if(!job)	continue
			var/list/candidates = find_occupation_candidates(job, level)
			if(!candidates.len)	continue
			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!V.client) continue
				var/age = V.client.prefs.age
				if(age < job.minimum_character_age) // Nope.
					continue
				switch(age)
					if(job.minimum_character_age to (job.minimum_character_age+10))
						weightedCandidates[V] = 3 // Still a bit young.
					if((job.minimum_character_age+10) to (job.ideal_character_age-10))
						weightedCandidates[V] = 6 // Better.
					if((job.ideal_character_age-10) to (job.ideal_character_age+10))
						weightedCandidates[V] = 10 // Great.
					if((job.ideal_character_age+10) to (job.ideal_character_age+20))
						weightedCandidates[V] = 6 // Still good.
					if((job.ideal_character_age+20) to INFINITY)
						weightedCandidates[V] = 3 // Geezer.
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(candidates.len == 1) weightedCandidates[V] = 1
			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(assign_role(candidate, command_position, mode = mode))
				return 1
	return 0

///This proc is called at the start of the level loop of divide_occupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/subsystem/jobs/proc/CheckHeadPositions(var/level, var/datum/game_mode/mode)
	for(var/command_position in titles_by_department(COM))
		var/datum/job/job = get_by_title(command_position)
		if(!job)	continue
		var/list/candidates = find_occupation_candidates(job, level)
		if(!candidates.len)	continue
		var/mob/new_player/candidate = pick(candidates)
		assign_role(candidate, command_position, mode = mode)

/** Proc divide_occupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/jobs/proc/divide_occupations(datum/game_mode/mode)
	//Get the players who are ready
	for(var/mob/new_player/player in GLOB.player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned_roundstart += player
	if(unassigned_roundstart.len == 0)	return 0
	//Shuffle players and jobs
	unassigned_roundstart = shuffle(unassigned_roundstart)
	//People who wants to be assistants, sure, go on.
	var/datum/job/assist = new DEFAULT_JOB_TYPE ()
	var/list/assistant_candidates = find_occupation_candidates(assist, 3)
	for(var/mob/new_player/player in assistant_candidates)
		assign_role(player, GLOB.using_map.default_assistant_title, mode = mode)
		assistant_candidates -= player

	//Select one head
	fill_head_position(mode)

	//Other jobs are now checked
	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(primary_job_datums)
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		CheckHeadPositions(level, mode)

		// Loop through all unassigned players
		var/list/deferred_jobs = list()
		for(var/mob/new_player/player in unassigned_roundstart)
			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(job && !mode.disabled_jobs.Find(job.title))
					if(job.defer_roundstart_spawn)
						deferred_jobs[job] = TRUE
					else if(attempt_role_assignment(player, job, level, mode))
						unassigned_roundstart -= player
						break

		if(LAZYLEN(deferred_jobs))
			for(var/mob/new_player/player in unassigned_roundstart)
				for(var/datum/job/job in deferred_jobs)
					if(attempt_role_assignment(player, job, level, mode))
						unassigned_roundstart -= player
						break
			deferred_jobs.Cut()

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			give_random_job(player, mode)
	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			var/datum/job/ass = DEFAULT_JOB_TYPE
			if((GLOB.using_map.flags & MAP_HAS_BRANCH) && player.client.prefs.branches[initial(ass.title)])
				var/datum/mil_branch/branch = GLOB.mil_branches.get_branch(player.client.prefs.branches[initial(ass.title)])
				ass = branch.assistant_job
			assign_role(player, initial(ass.title), mode = mode)
	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.new_player_panel()
			unassigned_roundstart -= player
	return TRUE

/datum/controller/subsystem/jobs/proc/attempt_role_assignment(var/mob/new_player/player, var/datum/job/job, var/level, var/datum/game_mode/mode)
	if(!jobban_isbanned(player, job.title) && \
	 job.player_old_enough(player.client) && \
	 player.client.prefs.CorrectLevel(job, level) && \
	 job.is_position_available())
		assign_role(player, job.title, mode = mode)
		return TRUE
	return FALSE

/datum/controller/subsystem/jobs/proc/equip_custom_loadout(var/mob/living/carbon/human/H, var/datum/job/job)

	if(!H || !H.client)
		return

	// Equip custom gear loadout, replacing any job items
	var/list/spawn_in_storage = list()
	var/list/loadout_taken_slots = list()
	if(H.client.prefs.Gear() && job.loadout_allowed)
		for(var/thing in H.client.prefs.Gear())
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(G.allowed_branches)
					if(H.char_branch && (H.char_branch.type in G.allowed_branches))
						permitted = 1
				else
					permitted = 1

				if(permitted)
					if(G.allowed_roles)
						if(job.type in G.allowed_roles)
							permitted = 1
						else
							permitted = 0
					else
						permitted = 1

				if(permitted && G.allowed_skills)
					for(var/required in G.allowed_skills)
						if(!H.skill_check(required,G.allowed_skills[required]))
							permitted = 0

				if(G.whitelisted && (!(H.species.name in G.whitelisted)))
					permitted = 0

				if(!permitted)
					to_chat(H, "<span class='warning'>Your current species, job, branch, skills or whitelist status does not permit you to spawn with [thing]!</span>")
					continue

				if(!G.slot || G.slot == slot_tie || (G.slot in loadout_taken_slots) || !G.spawn_on_mob(H, H.client.prefs.Gear()[G.display_name]))
					spawn_in_storage.Add(G)
				else
					loadout_taken_slots.Add(G.slot)

	// do accessories last so they don't attach to a suit that will be replaced
	if(H.char_rank && H.char_rank.accessory)
		for(var/accessory_path in H.char_rank.accessory)
			var/list/accessory_data = H.char_rank.accessory[accessory_path]
			if(islist(accessory_data))
				var/amt = accessory_data[1]
				var/list/accessory_args = accessory_data.Copy()
				accessory_args[1] = src
				for(var/i in 1 to amt)
					H.equip_to_slot_or_del(new accessory_path(arglist(accessory_args)), slot_tie)
			else
				for(var/i in 1 to (isnull(accessory_data)? 1 : accessory_data))
					H.equip_to_slot_or_del(new accessory_path(src), slot_tie)

	return spawn_in_storage

/datum/controller/subsystem/jobs/proc/equip_rank(var/mob/living/carbon/human/H, var/rank, var/joined_late = 0)
	if(!H)
		return

	var/datum/job/job = get_by_title(rank)
	var/list/spawn_in_storage

	if(job)
		if(H.client)
			if(GLOB.using_map.flags & MAP_HAS_BRANCH)
				H.char_branch = GLOB.mil_branches.get_branch(H.client.prefs.branches[rank])
			if(GLOB.using_map.flags & MAP_HAS_RANK)
				H.char_rank = GLOB.mil_branches.get_rank(H.client.prefs.branches[rank], H.client.prefs.ranks[rank])

		// Transfers the skill settings for the job to the mob
		H.skillset.obtain_from_client(job, H.client)

		//Equip job items.
		job.setup_account(H)

		// EMAIL GENERATION
		if(rank != "Robot" && rank != "AI")		//These guys get their emails later.
			var/domain
			var/addr = H.real_name
			var/pass
			if(H.char_branch)
				if(H.char_branch.email_domain)
					domain = H.char_branch.email_domain
				if (H.char_branch.allow_custom_email && H.client.prefs.email_addr)
					addr = H.client.prefs.email_addr
			else
				domain = "freemail.net"
			if (H.client.prefs.email_pass)
				pass = H.client.prefs.email_pass
			if(domain)
				ntnet_global.create_email(H, addr, domain, rank, pass)
		// END EMAIL GENERATION

		job.equip(H, H.mind ? H.mind.role_alt_title : "", H.char_branch, H.char_rank)
		job.apply_fingerprints(H)
		spawn_in_storage = equip_custom_loadout(H, job)

		var/obj/item/clothing/under/uniform = H.w_uniform
		if(istype(uniform) && uniform.has_sensor)
			uniform.sensor_mode = SUIT_SENSOR_MODES[H.client.prefs.sensor_setting]
			if(H.client.prefs.sensors_locked)
				uniform.has_sensor = SUIT_LOCKED_SENSORS
	else
		to_chat(H, "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator.")

	H.job = rank

	if(!joined_late || job.latejoin_at_spawnpoints)
		var/obj/S = job.get_roundstart_spawnpoint()

		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.forceMove(S.loc)
		else
			var/datum/spawnpoint/spawnpoint = job.get_spawnpoint(H.client)
			H.forceMove(pick(spawnpoint.turfs))
			spawnpoint.after_join(H)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	// If they're head, give them the account info for their department
	if(H.mind && job.head_position)
		var/remembered_info = ""
		var/datum/money_account/department_account = department_accounts[job.department]

		if(department_account)
			remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
			remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
			remembered_info += "<b>Your department's account funds are:</b> [GLOB.using_map.local_currency_name_short][department_account.money]<br>"

		H.StoreMemory(remembered_info, /decl/memory_options/system)

	var/alt_title = null
	if(H.mind)
		H.mind.assigned_job = job
		H.mind.assigned_role = rank
		alt_title = H.mind.role_alt_title

	var/mob/other_mob = job.handle_variant_join(H, alt_title)
	if(other_mob)
		job.post_equip_rank(other_mob, alt_title || rank)
		return other_mob

	if(spawn_in_storage)
		for(var/datum/gear/G in spawn_in_storage)
			G.spawn_in_storage_or_drop(H, H.client.prefs.Gear()[G.display_name])

	if(istype(H)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ(BP_L_FOOT)
		var/obj/item/organ/external/r_foot = H.get_organ(BP_R_FOOT)
		if(!l_foot || !r_foot)
			var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(H.loc)
			H.buckled = W
			H.UpdateLyingBuckledAndVerbStatus()
			W.set_dir(H.dir)
			W.buckled_mob = H
			W.add_fingerprint(H)

	to_chat(H, "<font size = 3><B>You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B></font>")

	if(job.supervisors)
		to_chat(H, "<b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>")

	to_chat(H, "<b>To speak on your department's radio channel use :h. For the use of other channels, examine your headset.</b>")

	if(job.req_admin_notify)
		to_chat(H, "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>")

	if (H.disabilities & NEARSIGHTED) //Try to give glasses to the vision impaired
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/prescription(H), slot_glasses)

	SET_BIT(H.hud_updateflag, ID_HUD)
	SET_BIT(H.hud_updateflag, IMPLOYAL_HUD)
	SET_BIT(H.hud_updateflag, SPECIALROLE_HUD)

	job.post_equip_rank(H, alt_title || rank)

	return H

/datum/controller/subsystem/jobs/proc/titles_by_department(var/dept)
	return positions_by_department["[dept]"] || list()

/datum/controller/subsystem/jobs/proc/spawn_empty_ai()
	for(var/obj/effect/landmark/start/S in landmarks_list)
		if(S.name != "AI")
			continue
		if(locate(/mob/living) in S.loc)
			continue
		empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(get_turf(S))
	return 1
