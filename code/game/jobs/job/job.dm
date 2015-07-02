/datum/job

	//The name of the job
	var/title = "NOPE"
	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()      // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()              // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/flag = 0 	                      // Bitflags for the job
	var/department_flag = 0
	var/faction = "None"	              // Players will be allowed to spawn in as jobs that are set to "Station"
	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job
	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"       // Selection screen color
	var/idtype = /obj/item/weapon/card/id // The type of the ID the player will have
	var/list/alt_titles                   // List of alternate titles, if any
	var/req_admin_notify                  // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0            // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/department = null                 // Does this position have a department tag?
	var/head_position = 0                 // Is this position Command?

	var/account_allowed = 1				  // Does this job type come with a station account?
	var/economic_modifier = 2			  // With how much does this job modify the initial account amount?

/datum/job/proc/equip(var/mob/living/carbon/human/H)
	return 1

/datum/job/proc/equip_survival(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.species.equip_survival_gear(H,0)
	return 1

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
	var/money_amount = (rand(5,50) + rand(5, 50)) * loyalty * economic_modifier * (H.species ? economic_species_modifier[H.species.type] : 2)
	var/datum/money_account/M = create_account(H.real_name, money_amount, null)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	H << "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>"

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/del()
/datum/job/proc/equip_preview(mob/living/carbon/human/H)
	return equip(H)

/datum/job/proc/get_access()
	if(!config || config.jobs_have_minimal_access)
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	return (available_in_days(C) == 0) //Available in 0 days = available right now = player is old enough to play.

/datum/job/proc/available_in_days(client/C)
	if(C && config.use_age_restriction_for_jobs && isnum(C.player_age) && isnum(minimal_player_age))
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
