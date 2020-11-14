/*
		SPAWNCHECKS: To prevent people from spawning if they muck up their custom species
*/

/mob/new_player/proc/spawn_checks()
	var/pass = TRUE

	//Custom species checks
	if (client && client.prefs && client.prefs.species == "Custom Species")

		//Didn't name it
		if(!client.prefs.custom_species)
			pass = FALSE
			to_chat(src,"<span class='warning'>You have to name your custom species. Do this under the genemod tab in character setup.</span>")

		//Check traits/costs
		var/list/megalist = client.prefs.neu_traits
		var/traits_left = client.prefs.max_traits
		for(var/T in megalist)
			var/cost = traits_costs[T]

			if(cost)
				traits_left--

			//A trait was removed from the game
			if(isnull(cost))
				pass = FALSE
				to_chat(src,"<span class='warning'>Your custom species is not playable. One or more traits appear to have been removed from the game or renamed. Enter character setup to correct this.</span>")
				break

		//Went into negatives
		if(traits_left < 0)
			pass = FALSE
			to_chat(src,"<span class='warning'>Your custom species is not playable. Reconfigure your traits under the genemod tab.</span>")

	//Final popup notice
	if (!pass)
		alert(src,"There were problems with spawning your character. Check your message log for details.","Error","OK")
	return pass

/proc/attempt_vr(callon, procname, list/args=null)	//No clue what this actually does, but it's needed
	try
		if(!callon || !procname)
			error("attempt_vr: Invalid obj/proc: [callon]/[procname]")
			return 0

		var/result = call(callon,procname)(arglist(args))

		return result

	catch(var/exception/e)
		error("attempt_vr runtimed when calling [procname] on [callon].")
		error("attempt_vr catch: [e] on [e.file]:[e.line]")
		return 0

/*//////////////////////////////////////////////////////////////////////////////////
		BIG FAT PROC OVERRIDE
*///////////////////////////////////////////////////////////////////////////////////

/mob/new_player/AttemptLateSpawn(var/datum/job/job, var/spawning_at)

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
	if(job.is_restricted(client,client.prefs, src))
		return 0
	if(!attempt_vr(src,"spawn_checks",list())) //Really the only thing changed here
		return 0									// Ditto

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
//	equip_custom_items(character)

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
	if(job.create_record)
		if(character.mind.assigned_role != "Robot")
			CreateModularRecord(character)
			SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
			AnnounceArrival(character, job, spawnpoint.msg)
		else
			AnnounceCyborg(character, job, spawnpoint.msg)
		matchmaker.do_matchmaking()
	log_and_message_admins("has joined the round as [character.mind.assigned_role].", character)

	if(character.cannot_stand())
		equip_wheelchair(character)

	qdel(src)