// A lot of this is boilerplate from the standard job controller, but it's different enough and
// requires enough shit skipped or removed that I think the boilerplate is justified. The offsite
// roles do not require rank or branch checks, they don't require latejoin vs. initial spawn checks
// and they handle their spawn points on a ship by ship, archetype by archetype, overmap-aware
// manner. This is mostly being written here so I don't feel like a fool when I open the PR.

/datum/submap/Topic(href, href_list)
	. = ..()
	if(!.)
		var/join_as = href_list["join_as"]
		if(join_as && jobs[join_as])
			join_as(locate(href_list["joining"]), jobs[join_as])
			return TRUE

/datum/submap/proc/check_general_join_blockers(var/mob/new_player/joining, var/datum/job/submap/job)

	if(!istype(job)) // This proc uses a specific type that CheckLatejoinBlockers() does not.
		log_debug("Job assignment error for [name] - job does not exist or is of the incorrect type.")
		return FALSE

	if(!job_master.CheckLatejoinBlockers(joining, job))
		return FALSE

	if(!available())
		to_chat(joining, "<span class='warning'>Unfortunately, that job is no longer available.</span>")
		return FALSE

	if(jobban_isbanned(joining, "Offstation Roles"))
		to_chat(joining, "<span class='warning'>You are banned from playing offstation roles.</span>")
		return FALSE

	if(job.is_restricted(joining.client.prefs, joining))
		return FALSE

	return TRUE

/datum/submap/proc/join_as(var/mob/new_player/joining, var/datum/job/submap/job)

	if(!check_general_join_blockers(joining, job))
		return

	if(!LAZYLEN(job.spawnpoints))
		to_chat(joining, "<span class='warning'>There are no available spawn points for that job.</span>")

	var/turf/spawn_turf = get_turf(pick(job.spawnpoints))
	if(!job_master.CheckUnsafeSpawn(joining, spawn_turf))
		return

	// CheckUnsafeSpawn has an input() call, check blockers again.
	if(!check_general_join_blockers(joining, job))
		return

	log_debug("Player: [joining] is now offsite rank: [job.title] ([name]), JCP:[job.current_positions], JPL:[job.total_positions]")
	joining.mind.assigned_role = job.title
	joining.faction = name
	job.current_positions++

	var/mob/living/character = joining.create_character(spawn_turf)
	if(istype(character))

		var/mob/living/carbon/human/user_human
		if(ishuman(character))
			user_human = character
			if(job.branch && mil_branches)
				user_human.char_branch = mil_branches.get_branch(job.branch)
				user_human.char_rank =   mil_branches.get_rank(job.branch, job.rank)

			character.skillset.obtain_from_client(job, character.client)
			job.equip(character, "")
			job.apply_fingerprints(character)
			var/list/spawn_in_storage = job_master.EquipCustomLoadout(character, job)
			if(spawn_in_storage)
				for(var/datum/gear/G in spawn_in_storage)
					G.spawn_in_storage_or_drop(user_human, user_human.client.prefs.Gear()[G.display_name])
			equip_custom_items(user_human)

		character.job = job.title
		if(character.mind) character.mind.assigned_role = character.job

		to_chat(character, "<B>You are [job.total_positions == 1 ? "the" : "a"] [job.title] of the [name].</B>")

		if(job.supervisors)
			to_chat(character, "<b>As a [job.title] you answer directly to [job.supervisors].</b>")
		var/datum/job/submap/ojob = job
		if(istype(ojob) && ojob.info)
			to_chat(character, ojob.info)

		if(user_human && user_human.disabilities & NEARSIGHTED)
			var/equipped = user_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(user_human), slot_glasses)
			if(equipped)
				var/obj/item/clothing/glasses/G = user_human.glasses
				G.prescription = 7

		BITSET(character.hud_updateflag, ID_HUD)
		BITSET(character.hud_updateflag, IMPLOYAL_HUD)
		BITSET(character.hud_updateflag, SPECIALROLE_HUD)

		SSticker.mode.handle_offsite_latejoin(character)
		GLOB.universe.OnPlayerLatejoin(character)
		log_and_message_admins("has joined the round as offsite role [character.mind.assigned_role].", character)
		if(character.cannot_stand()) equip_wheelchair(character)
		qdel(joining)

	return character
