/datum/job

	//The name of the job
	var/title = "NOPE"
	var/list/access = list()              // The job's default access tokens
	var/list/software_on_spawn = list()   // Defines the software files that spawn on tablets and labtops
	var/department_flag = 0
	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job
	var/availablity_chance = 100          // Percentage chance job is available each round

	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#515151"       // Selection screen color
	var/list/alt_titles                   // List of alternate titles, if any and any potential alt. outfits as assoc values.
	var/req_admin_notify                  // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0            // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/department = null                 // Does this position have a department tag?
	var/head_position = 0                 // Is this position Command?
	var/minimum_character_age			  // List of species = age, if species is not here, it's auto-pass
	var/ideal_character_age = 30
	var/create_record = 1                 // Do we announce/make records for people who spawn on this job?
	var/is_semi_antagonist = FALSE        // Whether or not this job is given semi-antagonist status.
	var/account_allowed = 1               // Does this job type come with a station account?
	var/economic_power = 2             // With how much does this job modify the initial account amount?

	var/outfit_type                       // The outfit the employee will be dressed in, if any

	var/loadout_allowed = TRUE            // Whether or not loadout equipment is allowed and to be created when joining.
	var/list/allowed_branches             // For maps using branches and ranks, also expandable for other purposes
	var/list/allowed_ranks                // Ditto

	var/announced = TRUE                  //If their arrival is announced on radio
	var/latejoin_at_spawnpoints           //If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)

	var/hud_icon						  //icon used for Sec HUD overlay

	var/min_skill = list()				  //Minimum skills allowed for the job. List should contain skill (as in /decl/hierarchy/skill path), with values which are numbers.
	var/max_skill = list()				  //Maximum skills allowed for the job.
	var/skill_points = 16				  //The number of unassigned skill points the job comes with (on top of the minimum skills).
	var/no_skill_buffs = FALSE			  //Whether skills can be buffed by age/species modifiers.
	var/available_by_default = TRUE

	var/list/possible_goals
	var/min_goals = 0
	var/max_goals = 5

	var/defer_roundstart_spawn = FALSE // If true, the job will be put off until all other jobs have been populated.
	var/list/species_branch_rank_cache_ = list()
	var/list/psi_faculties                // Starting psi faculties, if any.
	var/psi_latency_chance = 0            // Chance of an additional psi latency, if any.
	var/give_psionic_implant_on_join = TRUE // If psionic, will be implanted for control.

	var/use_species_whitelist // If set, restricts the job to players with the given species whitelist. This does NOT restrict characters joining as the job to the species itself.

	var/required_language

/datum/job/New()

	if(prob(100-availablity_chance))	//Close positions, blah blah.
		total_positions = 0
		spawn_positions = 0

	if(!hud_icon)
		hud_icon = "hud[ckey(title)]"

	..()

/datum/job/dd_SortValue()
	return title

/datum/job/proc/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)

	if (required_language)
		H.add_language(required_language)
		H.set_default_language(all_languages[required_language])

	if (!H.languages.len)
		H.add_language(LANGUAGE_SPACER)
		H.set_default_language(all_languages[LANGUAGE_SPACER])

	if(psi_latency_chance && prob(psi_latency_chance) && H.species.type == /datum/species/human && !psi_faculties)
		H.set_psi_rank(pick(PSI_COERCION, PSI_REDACTION, PSI_ENERGISTICS, PSI_PSYCHOKINESIS), 1, defer_update = TRUE)
	if(islist(psi_faculties))
		for(var/psi in psi_faculties)
			H.set_psi_rank(psi, psi_faculties[psi], take_larger = TRUE, defer_update = TRUE)
	if(H.psi)
		H.psi.update()
		if(give_psionic_implant_on_join)
			var/obj/item/implant/psi_control/imp = new
			imp.implanted(H)
			imp.forceMove(H)
			imp.imp_in = H
			imp.implanted = TRUE
			var/obj/item/organ/external/affected = H.get_organ(BP_HEAD)
			if(affected)
				affected.implants += imp
				imp.part = affected
			to_chat(H, SPAN_DANGER("As a registered psionic, you are fitted with a psi-dampening control implant. Using psi-power while the implant is active will result in neural shocks and your violation being reported."))

	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title, branch, grade)
	if(outfit) . = outfit.equip(H, title, alt_title)

/datum/job/proc/get_outfit(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	if(alt_title && alt_titles)
		. = alt_titles[alt_title]
	if(allowed_branches && branch)
		. = allowed_branches[branch.type] || .
	if(allowed_ranks && grade)
		. = allowed_ranks[grade.type] || .
	. = . || outfit_type
	. = outfit_by_type(.)

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	// Calculate our pay and apply all relevant modifiers.
	var/money_amount = 4 * rand(75, 100) * economic_power

	// Get an average economic power for our cultures.
	var/culture_mod =   0
	var/culture_count = 0
	for(var/token in H.cultural_info)
		var/decl/cultural_info/culture = H.get_cultural_value(token)
		if(culture && !isnull(culture.economic_power))
			culture_count++
			culture_mod += culture.economic_power
	if(culture_count)
		culture_mod /= culture_count
	money_amount *= culture_mod

	// Apply other mods.
	money_amount *= GLOB.using_map.salary_modifier
	money_amount *= 1 + 2 * H.get_skill_value(SKILL_FINANCE)/(SKILL_MAX - SKILL_MIN)
	money_amount = round(money_amount)

	if(money_amount <= 0)
		return // You are too poor for an account.

	//give them an account in the station database
	var/datum/money_account/M = create_account("[H.real_name]'s account", H.real_name, money_amount)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> [GLOB.using_map.local_currency_name_short][M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.get_source_name()]<br>"
		H.StoreMemory(remembered_info, /decl/memory_options/system)
		H.mind.initial_account = M

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/qdel()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade, var/additional_skips)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title, branch, grade)
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title, OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP|OUTFIT_ADJUSTMENT_SKIP_ID_PDA|additional_skips)

/datum/job/proc/get_access()
	return access.Copy()

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	return (available_in_days(C) == 0) //Available in 0 days = available right now = player is old enough to play.

/datum/job/proc/available_in_days(client/C)
	if(C && config.use_age_restriction_for_jobs && isnull(C.holder) && isnum(C.player_age) && isnum(minimal_player_age))
		return max(0, minimal_player_age - C.player_age)
	return 0

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/target)
	if(!istype(target))
		return 0
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return 1

/datum/job/proc/apply_fingerprints_to_item(var/mob/living/carbon/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)

/datum/job/proc/is_restricted(var/datum/preferences/prefs, var/feedback)
	var/datum/species/S

	if (!is_species_whitelist_allowed(prefs.client, use_species_whitelist))
		S = all_species[use_species_whitelist]
		to_chat(feedback, "<span class='boldannounce'>\An [S] species whitelist is required for [title].</span>")
		return TRUE

	if(!isnull(allowed_branches) && (!prefs.branches[title] || !is_branch_allowed(prefs.branches[title])))
		to_chat(feedback, "<span class='boldannounce'>Wrong branch of service for [title]. Valid branches are: [get_branches()].</span>")
		return TRUE

	if(!isnull(allowed_ranks) && (!prefs.ranks[title] || !is_rank_allowed(prefs.branches[title], prefs.ranks[title])))
		to_chat(feedback, "<span class='boldannounce'>Wrong rank for [title]. Valid ranks in [prefs.branches[title]] are: [get_ranks(prefs.branches[title])].</span>")
		return TRUE

	S = all_species[prefs.species]
	if(!is_species_allowed(S))
		to_chat(feedback, "<span class='boldannounce'>Restricted species, [S], for [title].</span>")
		return TRUE

	if(LAZYACCESS(minimum_character_age, S.get_bodytype()) && (prefs.age < minimum_character_age[S.get_bodytype()]))
		to_chat(feedback, "<span class='boldannounce'>Not old enough. Minimum character age is [minimum_character_age[S.get_bodytype()]].</span>")
		return TRUE

	if(!S.check_background(src, prefs))
		to_chat(feedback, "<span class='boldannounce'>Incompatible background for [title].</span>")
		return TRUE

	return FALSE

/datum/job/proc/get_join_link(var/client/caller, var/href_string, var/show_invalid_jobs)
	if(is_available(caller))
		if(is_restricted(caller.prefs))
			if(show_invalid_jobs)
				return "<tr><td><a style='text-decoration: line-through' href='[href_string]'>[title]</a></td><td>[current_positions]</td><td>(Active: [get_active_count()])</td></tr>"
		else
			return "<tr><td><a href='[href_string]'>[title]</a></td><td>[current_positions]</td><td>(Active: [get_active_count()])</td></tr>"
	return ""

// Only players with the job assigned and AFK for less than 10 minutes count as active
/datum/job/proc/check_is_active(var/mob/M)
	return (M.mind && M.client && M.mind.assigned_role == title && M.client.inactivity <= 10 * 60 * 10)

/datum/job/proc/get_active_count()
	var/active = 0
	for(var/mob/M in GLOB.player_list)
		if(check_is_active(M))
			active++
	return active

/datum/job/proc/is_species_allowed(var/datum/species/S)
	if(GLOB.using_map.is_species_job_restricted(S, src))
		return FALSE
	// We also make sure that there is at least one valid branch-rank combo for the species.
	if(!allowed_branches || !GLOB.using_map || !(GLOB.using_map.flags & MAP_HAS_BRANCH))
		return TRUE
	return LAZYLEN(get_branch_rank(S))

/datum/job/proc/is_species_whitelist_allowed(client/C)
	if (isnull(use_species_whitelist))
		return TRUE
	if (!C?.mob)
		log_debug("Failed to find a valid client/mob for whitelist checking - Job `[src]` - Client `[C]` - Mob `[C?.mob]`")
		return FALSE
	return is_species_whitelisted(C.mob, use_species_whitelist)

// Don't use if the map doesn't use branches but jobs do.
/datum/job/proc/get_branch_rank(var/datum/species/S)
	. = species_branch_rank_cache_[S]
	if(.)
		return

	species_branch_rank_cache_[S] = list()
	. = species_branch_rank_cache_[S]

	var/spawn_branches = GLOB.mil_branches.spawn_branches(S)
	for(var/branch_type in allowed_branches)
		var/datum/mil_branch/branch = GLOB.mil_branches.get_branch_by_type(branch_type)
		if(branch.name in spawn_branches)
			if(!allowed_ranks || !(GLOB.using_map.flags & MAP_HAS_RANK))
				LAZYADD(., branch.name)
				continue // Screw this rank stuff, we're good.
			var/spawn_ranks = branch.spawn_ranks(S)
			for(var/rank_type in allowed_ranks)
				var/datum/mil_rank/rank = rank_type
				if(initial(rank.name) in spawn_ranks)
					LAZYADD(.[branch.name], initial(rank.name))

/**
 *  Check if members of the given branch are allowed in the job
 *
 *  This proc should only be used after the global branch list has been initialized.
 *
 *  branch_name - String key for the branch to check
 */
/datum/job/proc/is_branch_allowed(var/branch_name)
	if(!allowed_branches || !GLOB.using_map || !(GLOB.using_map.flags & MAP_HAS_BRANCH))
		return 1
	if(branch_name == "None")
		return 0

	var/datum/mil_branch/branch = GLOB.mil_branches.get_branch(branch_name)

	if(!branch)
		crash_with("unknown branch \"[branch_name]\" passed to is_branch_allowed()")
		return 0

	if(is_type_in_list(branch, allowed_branches))
		return 1
	else
		return 0

/**
 *  Check if people with given rank are allowed in this job
 *
 *  This proc should only be used after the global branch list has been initialized.
 *
 *  branch_name - String key for the branch to which the rank belongs
 *  rank_name - String key for the rank itself
 */
/datum/job/proc/is_rank_allowed(var/branch_name, var/rank_name)
	if(!allowed_ranks || !GLOB.using_map || !(GLOB.using_map.flags & MAP_HAS_RANK))
		return 1
	if(branch_name == "None" || rank_name == "None")
		return 0

	var/datum/mil_rank/rank = GLOB.mil_branches.get_rank(branch_name, rank_name)

	if(!rank)
		crash_with("unknown rank \"[rank_name]\" in branch \"[branch_name]\" passed to is_rank_allowed()")
		return 0

	if(is_type_in_list(rank, allowed_ranks))
		return 1
	else
		return 0

//Returns human-readable list of branches this job allows.
/datum/job/proc/get_branches()
	var/list/res = list()
	for(var/T in allowed_branches)
		var/datum/mil_branch/B = GLOB.mil_branches.get_branch_by_type(T)
		res += B.name
	return english_list(res)

//Same as above but ranks
/datum/job/proc/get_ranks(branch)
	var/list/res = list()
	var/datum/mil_branch/B = GLOB.mil_branches.get_branch(branch)
	for(var/T in allowed_ranks)
		var/datum/mil_rank/R = T
		if(B && !(initial(R.name) in B.ranks))
			continue
		res |= initial(R.name)
	return english_list(res)

/datum/job/proc/get_description_blurb()
	return ""

/datum/job/proc/get_job_icon()
	if(!SSjobs.job_icons[title])
		var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin("#job_icon")
		dress_mannequin(mannequin)
		mannequin.dir = SOUTH
		var/icon/preview_icon = getFlatIcon(mannequin)
		preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
		SSjobs.job_icons[title] = preview_icon
	return SSjobs.job_icons[title]

/datum/job/proc/get_unavailable_reasons(var/client/caller)
	var/list/reasons = list()
	if(jobban_isbanned(caller, title))
		reasons["You are jobbanned."] = TRUE
	if(is_semi_antagonist && jobban_isbanned(caller, MODE_MISC_AGITATOR))
		reasons["You are semi-antagonist banned."] = TRUE
	if(!player_old_enough(caller))
		reasons["Your player age is too low."] = TRUE
	if(!is_position_available())
		reasons["There are no positions left."] = TRUE
	if(!isnull(allowed_branches) && (!caller.prefs.branches[title] || !is_branch_allowed(caller.prefs.branches[title])))
		reasons["Your branch of service does not allow it."] = TRUE
	else if(!isnull(allowed_ranks) && (!caller.prefs.ranks[title] || !is_rank_allowed(caller.prefs.branches[title], caller.prefs.ranks[title])))
		reasons["Your rank choice does not allow it."] = TRUE
	if (!is_species_whitelist_allowed(caller))
		reasons["You do not have the required [use_species_whitelist] species whitelist."] = TRUE
	var/datum/species/S = all_species[caller.prefs.species]
	if(S)
		if(!is_species_allowed(S))
			reasons["Your species choice does not allow it."] = TRUE
		if(!S.check_background(src, caller.prefs))
			reasons["Your background choices do not allow it."] = TRUE
	if(LAZYLEN(reasons))
		. = reasons

/datum/job/proc/dress_mannequin(var/mob/living/carbon/human/dummy/mannequin/mannequin)
	mannequin.delete_inventory(TRUE)
	equip_preview(mannequin, additional_skips = OUTFIT_ADJUSTMENT_SKIP_BACKPACK)

/datum/job/proc/is_available(var/client/caller)
	if(!is_position_available())
		return FALSE
	if(jobban_isbanned(caller, title))
		return FALSE
	if(is_semi_antagonist && jobban_isbanned(caller, MODE_MISC_AGITATOR))
		return FALSE
	if(!player_old_enough(caller))
		return FALSE
	return TRUE

/datum/job/proc/make_position_available()
	total_positions++

/datum/job/proc/make_position_unavailable()
	total_positions = 0

/datum/job/proc/get_roundstart_spawnpoint()
	var/list/loc_list = list()
	for(var/obj/effect/landmark/start/sloc in landmarks_list)
		if(sloc.name != title)	continue
		if(locate(/mob/living) in sloc.loc)	continue
		loc_list += sloc
	if(loc_list.len)
		return pick(loc_list)
	else
		return locate("start*[title]") // use old stype

/**
 *  Return appropriate /datum/spawnpoint for given client
 *
 *  Spawnpoint will be the one set in preferences for the client, unless the
 *  preference is not set, or the preference is not appropriate for the rank, in
 *  which case a fallback will be selected.
 */
/datum/job/proc/get_spawnpoint(var/client/C)

	if(!C)
		CRASH("Null client passed to get_spawnpoint_for() proc!")

	var/mob/H = C.mob
	var/spawnpoint = C.prefs.spawnpoint
	var/datum/spawnpoint/spawnpos

	if(spawnpoint == DEFAULT_SPAWNPOINT_ID)
		spawnpoint = GLOB.using_map.default_spawn

	if(spawnpoint)
		if(!(spawnpoint in GLOB.using_map.allowed_spawns))
			if(H)
				to_chat(H, "<span class='warning'>Your chosen spawnpoint ([C.prefs.spawnpoint]) is unavailable for the current map. Spawning you at one of the enabled spawn points instead. To resolve this error head to your character's setup and choose a different spawn point.</span>")
			spawnpos = null
		else
			spawnpos = spawntypes()[spawnpoint]

	if(spawnpos && !spawnpos.check_job_spawning(title))
		if(H)
			to_chat(H, "<span class='warning'>Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job ([title]). Spawning you at another spawn point instead.</span>")
		spawnpos = null

	if(!spawnpos)
		// Step through all spawnpoints and pick first appropriate for job
		for(var/spawntype in GLOB.using_map.allowed_spawns)
			var/datum/spawnpoint/candidate = spawntypes()[spawntype]
			if(candidate.check_job_spawning(title))
				spawnpos = candidate
				break

	if(!spawnpos)
		// Pick at random from all the (wrong) spawnpoints, just so we have one
		warning("Could not find an appropriate spawnpoint for job [title].")
		spawnpos = spawntypes()[pick(GLOB.using_map.allowed_spawns)]

	return spawnpos

/datum/job/proc/post_equip_rank(var/mob/person, var/alt_title)
	if(is_semi_antagonist && person.mind)
		GLOB.provocateurs.add_antagonist(person.mind)

/datum/job/proc/get_alt_title_for(var/client/C)
	return C.prefs.GetPlayerAltTitle(src)

/datum/job/proc/clear_slot()
	if(current_positions > 0)
		current_positions -= 1
		return TRUE
	return FALSE

/datum/job/proc/handle_variant_join(var/mob/living/carbon/human/H, var/alt_title)
	return

/datum/job/proc/get_min_skill(decl/hierarchy/skill/S)
	if(min_skill)
		. = min_skill[S.type]
	if(!.)
		. = SKILL_MIN
