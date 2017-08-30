/datum/job

	//The name of the job
	var/title = "NOPE"
	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()      // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()              // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/department_flag = 0
	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job
	var/availablity_chance = 100          // Percentage chance job is available each round

	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"       // Selection screen color
	var/list/alt_titles                   // List of alternate titles, if any and any potential alt. outfits as assoc values.
	var/req_admin_notify                  // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0            // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/department = null                 // Does this position have a department tag?
	var/head_position = 0                 // Is this position Command?
	var/minimum_character_age = 0
	var/ideal_character_age = 30
	var/create_record = 1                 // Do we announce/make records for people who spawn on this job?

	var/account_allowed = 1               // Does this job type come with a station account?
	var/economic_modifier = 2             // With how much does this job modify the initial account amount?

	var/outfit_type                       // The outfit the employee will be dressed in, if any

	var/loadout_allowed = TRUE            // Whether or not loadout equipment is allowed and to be created when joining.
	var/list/allowed_branches             // For maps using branches and ranks, also expandable for other purposes
	var/list/allowed_ranks                // Ditto

	var/announced = TRUE                  //If their arrival is announced on radio
	var/latejoin_at_spawnpoints           //If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)

/datum/job/New()
	..()
	if(prob(100-availablity_chance))	//Close positions, blah blah.
		total_positions = 0
		spawn_positions = 0

/datum/job/dd_SortValue()
    return title

/datum/job/proc/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title, branch)
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title)

/datum/job/proc/get_outfit(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	if(alt_title && alt_titles)
		. = alt_titles[alt_title]
	if(allowed_branches && branch)
		. = allowed_branches[branch.type] || .
	. = . || outfit_type
	. = outfit_by_type(.)

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	var/loyalty = 1
	if(H.client)
		switch(H.client.prefs.nanotrasen_relation)
			if(COMPANY_LOYAL)		loyalty = 1.30
			if(COMPANY_SUPPORTATIVE)loyalty = 1.15
			if(COMPANY_NEUTRAL)		loyalty = 1
			if(COMPANY_SKEPTICAL)	loyalty = 0.85
			if(COMPANY_OPPOSED)		loyalty = 0.70

	//give them an account in the station database
	if(!(H.species && (H.species.type in economic_species_modifier)))
		return //some bizarre species like shadow, slime, or monkey? You don't get an account.

	var/species_modifier = economic_species_modifier[H.species.type]

	var/money_amount = (rand(5,50) + rand(5, 50)) * loyalty * economic_modifier * species_modifier
	var/datum/money_account/M = create_account(H.real_name, money_amount, null)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> T[M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	to_chat(H, "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>")

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/qdel()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title, branch)
	if(!outfit)
		return FALSE
	. = outfit.equip_base(H, title, alt_title)

/datum/job/proc/get_access()
	if(!config || config.jobs_have_minimal_access)
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

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
	if(!is_branch_allowed(prefs.char_branch))
		to_chat(feedback, "<span class='boldannounce'>Wrong branch of service for [title]. Valid branches are: [get_branches()].</span>")
		return TRUE

	if(!is_rank_allowed(prefs.char_branch, prefs.char_rank))
		to_chat(feedback, "<span class='boldannounce'>Wrong rank for [title]. Valid ranks in [prefs.char_branch] are: [get_ranks(prefs.char_branch)].</span>")
		return TRUE

	var/datum/species/S = all_species[prefs.species]
	if(!is_species_allowed(S))
		to_chat(feedback, "<span class='boldannounce'>Restricted species, [S], for [title].</span>")
		return TRUE

	return FALSE

/datum/job/proc/is_species_allowed(var/datum/species/S)
	return !GLOB.using_map.is_species_job_restricted(S, src)

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

	var/datum/mil_branch/branch = mil_branches.get_branch(branch_name)

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

	var/datum/mil_rank/rank = mil_branches.get_rank(branch_name, rank_name)

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
		var/datum/mil_branch/B = mil_branches.get_branch_by_type(T)
		res += B.name
	return english_list(res)

//Same as above but ranks
/datum/job/proc/get_ranks(branch)
	var/list/res = list()
	var/datum/mil_branch/B = mil_branches.get_branch(branch)
	for(var/T in allowed_ranks)
		var/datum/mil_rank/R = T
		if(B && !(initial(R.name) in B.ranks))
			continue
		res += initial(R.name)
	return english_list(res)
