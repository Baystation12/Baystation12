#define WEBHOOK_SUBMAP_LOADED_ASCENT "webhook_submap_ascent"

// Submap datum and archetype.
/decl/webhook/submap_loaded/ascent
	id = WEBHOOK_SUBMAP_LOADED_ASCENT

/decl/submap_archetype/ascent_seedship
	descriptor = "Ascent colony ship"
	map = ASCENT_COLONY_SHIP_NAME
	blacklisted_species = null
	whitelisted_species = null
	crew_jobs = list(
		/datum/job/submap/ascent,
		/datum/job/submap/ascent/alate,
		/datum/job/submap/ascent/drone,
		//datum/job/submap/ascent/control_mind,
		//datum/job/submap/ascent/msq,
		//datum/job/submap/ascent/msw,
	)
	call_webhook = WEBHOOK_SUBMAP_LOADED_ASCENT

/datum/submap/ascent
	var/gyne_name

/datum/submap/ascent/sync_cell(obj/effect/overmap/visitable/cell)
	return

/datum/submap/ascent/check_general_join_blockers(var/mob/new_player/joining, var/datum/job/submap/job)
	. = ..()
	if(. && istype(job, /datum/job/submap/ascent))
		var/datum/job/submap/ascent/ascent_job = job
		if(ascent_job.set_species_on_join == SPECIES_MANTID_GYNE && !is_species_whitelisted(joining, SPECIES_MANTID_GYNE))
			to_chat(joining, SPAN_WARNING("You are not whitelisted to play a [SPECIES_MANTID_GYNE]."))
			return FALSE
		if(ascent_job.set_species_on_join == SPECIES_MONARCH_QUEEN && !is_species_whitelisted(joining, SPECIES_NABBER))
			to_chat(joining, SPAN_WARNING("You must be whitelisted to play a [SPECIES_NABBER] to join as a [SPECIES_MONARCH_QUEEN]."))
			return FALSE

/mob/living/carbon/human/proc/gyne_rename_lineage()
	set name = "Name Nest-Lineage"
	set category = "IC"
	set desc = "Rename yourself and your alates."

	if(species.name == SPECIES_MANTID_GYNE && mind && istype(mind.assigned_job, /datum/job/submap/ascent))
		var/datum/job/submap/ascent/ascent_job = mind.assigned_job
		var/datum/submap/ascent/cutter = ascent_job.owner
		if(istype(cutter))

			var/new_number = input("What is your position in your lineage?", "Name Nest-Lineage") as num|null
			if(!new_number)
				return
			new_number = Clamp(new_number, 1, 999)
			var/new_name = sanitize(input("What is the true name of your nest-lineage?", "Name Nest-Lineage") as text|null, MAX_NAME_LEN)
			if(!new_name)
				return

			if(species.name != SPECIES_MANTID_GYNE || !mind || mind.assigned_job != ascent_job)
				return

			// Rename ourselves.
			fully_replace_character_name("[new_number] [new_name]")

			// Rename our alates (and only our alates).
			cutter.gyne_name = new_name
			for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
				if(!H.mind || H.species.name != SPECIES_MANTID_ALATE)
					continue
				var/datum/job/submap/ascent/temp_ascent_job = H.mind.assigned_job
				if(!istype(temp_ascent_job) || temp_ascent_job.owner != ascent_job.owner)
					continue


				var/new_alate_number = is_species_whitelisted(H, SPECIES_MANTID_GYNE) ? random_id(/datum/species/mantid, 1000, 9999) : random_id(/datum/species/mantid, 10000, 99999)
				H.fully_replace_character_name("[new_alate_number] [new_name]")
				to_chat(H, SPAN_NOTICE("<font size = 3>Your gyne, [real_name], has awakened, and you recall your place in the nest-lineage: <b>[H.real_name]</b>.</font>"))

	verbs -= /mob/living/carbon/human/proc/gyne_rename_lineage

// Jobs.
/datum/job/submap/ascent
	title = "Ascent Gyne"
	total_positions = 1
	supervisors = "nobody but yourself"
	info = "You are the Gyne of an independent Ascent vessel. Your hunting has brought you to this remote sector full of crawling primitives. Impose your will, found a new nest, and bring prosperity to your lineage."
	outfit_type = /decl/hierarchy/outfit/job/ascent
	blacklisted_species = null
	whitelisted_species = null
	loadout_allowed = FALSE
	is_semi_antagonist = TRUE
	var/requires_supervisor = FALSE
	var/set_species_on_join = SPECIES_MANTID_GYNE
	min_skill = list(SKILL_EVA = SKILL_ADEPT,
					SKILL_PILOT = SKILL_ADEPT,
					SKILL_HAULING = SKILL_ADEPT,
					SKILL_COMBAT = SKILL_ADEPT,
					SKILL_WEAPONS = SKILL_ADEPT,
					SKILL_SCIENCE = SKILL_ADEPT,
					SKILL_MEDICAL = SKILL_BASIC)

/datum/job/submap/ascent/is_position_available()
	. = ..()
	if(. && requires_supervisor)
		for(var/mob/M in GLOB.player_list)
			if(!M.client || !M.mind || !M.mind.assigned_job || M.mind.assigned_job.title != requires_supervisor)
				continue
			var/datum/job/submap/ascent/ascent_job = M.mind.assigned_job
			if(istype(ascent_job) && ascent_job.owner == owner)
				return TRUE
		return FALSE

/datum/job/submap/ascent/is_available(client/caller)
	. = ..()
	if(.)
		switch(set_species_on_join)
			if(SPECIES_MANTID_GYNE)
				. = is_species_whitelisted(caller.mob, SPECIES_MANTID_GYNE)
			if(SPECIES_MONARCH_QUEEN)
				. = is_species_whitelisted(caller.mob, SPECIES_NABBER)

/datum/job/submap/ascent/handle_variant_join(var/mob/living/carbon/human/H, var/alt_title)

	if(ispath(set_species_on_join, /mob/living/silicon/robot))
		return H.Robotize(set_species_on_join)
	if(ispath(set_species_on_join, /mob/living/silicon/ai))
		return H.AIize(set_species_on_join, move = FALSE)

	var/datum/submap/ascent/cutter = owner
	if(!istype(cutter))
		crash_with("Ascent submap job is being used by a non-Ascent submap, aborting variant join.")
		return

	if(!cutter.gyne_name)
		cutter.gyne_name = create_gyne_name()

	if(set_species_on_join)
		H.set_species(set_species_on_join)
	switch(H.species.name)
		if(SPECIES_MANTID_GYNE)
			H.real_name = "[random_id(/datum/species/mantid, 1, 99)] [cutter.gyne_name]"
			H.verbs |= /mob/living/carbon/human/proc/gyne_rename_lineage
		if(SPECIES_MANTID_ALATE)
			var/new_alate_number = is_species_whitelisted(H, SPECIES_MANTID_GYNE) ? random_id(/datum/species/mantid, 1000, 9999) : random_id(/datum/species/mantid, 10000, 99999)
			H.real_name = "[new_alate_number] [cutter.gyne_name]"
	H.name = H.real_name
	if(H.mind)
		H.mind.name = H.real_name
	return H

/datum/job/submap/ascent/alate
	title = "Ascent Alate"
	total_positions = 4
	supervisors = "the Gyne"
	info = "You are an Alate of an independent Ascent vessel. Your Gyne has directed you to this remote sector full of crawling primitives. Follow her instructions and bring prosperity to your nest-lineage."
	set_species_on_join = SPECIES_MANTID_ALATE
	outfit_type = /decl/hierarchy/outfit/job/ascent/tech
	requires_supervisor = "Ascent Gyne"
	min_skill = list(SKILL_EVA = SKILL_ADEPT,
					SKILL_HAULING = SKILL_ADEPT,
					SKILL_COMBAT = SKILL_ADEPT,
					SKILL_WEAPONS = SKILL_ADEPT,
					SKILL_MEDICAL = SKILL_BASIC)	

/datum/job/submap/ascent/drone
	title = "Ascent Drone"
	supervisors = "the Gyne"
	total_positions = 2
	info = "You are a Machine Intelligence of an independent Ascent vessel. The Gyne you assist, and her children, have wandered into this sector full of primitive bioforms. Try to keep them alive, and assist where you can."
	set_species_on_join = /mob/living/silicon/robot/flying/ascent
	requires_supervisor = "Ascent Gyne"

/*
/datum/job/submap/ascent/msw
	title = "Serpentid Adjunct"
	supervisors = "your Queen"
	total_positions = 3
	info = "You are a Monarch Serpentid Worker serving as an attendant to your Queen on this vessel. Serve her however she requires."
	set_species_on_join = SPECIES_MONARCH_WORKER
	outfit_type = /decl/hierarchy/outfit/job/ascent/soldier
	min_skill = list(SKILL_EVA = SKILL_ADEPT,
					SKILL_HAULING = SKILL_ADEPT,
					SKILL_COMBAT = SKILL_ADEPT,
					SKILL_WEAPONS = SKILL_ADEPT,
					SKILL_SCIENCE = SKILL_ADEPT,
					SKILL_MEDICAL = SKILL_BASIC)

/datum/job/submap/ascent/msq
	title = "Serpentid Queen"
	supervisors = "your fellow Queens and the Gyne"
	total_positions = 2
	info = "You are a Monarch Serpentid Queen living on an independant Ascent vessel. Assist the Gyne in her duties and tend to your Workers."
	set_species_on_join = SPECIES_MONARCH_QUEEN
	min_skill = list(SKILL_EVA = SKILL_ADEPT,
					SKILL_HAULING = SKILL_ADEPT,
					SKILL_COMBAT = SKILL_ADEPT,
					SKILL_WEAPONS = SKILL_ADEPT,
					SKILL_MEDICAL = SKILL_BASIC)
*/

// Spawn points.
/obj/effect/submap_landmark/spawnpoint/ascent_seedship
	name = "Ascent Gyne"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/submap_landmark/spawnpoint/ascent_seedship/alate
	name = "Ascent Alate"

/obj/effect/submap_landmark/spawnpoint/ascent_seedship/drone
	name = "Ascent Drone"

/obj/effect/submap_landmark/spawnpoint/ascent_seedship/adjunct
	name = "Serpentid Adjunct"

/obj/effect/submap_landmark/spawnpoint/ascent_seedship/queen
	name = "Serpentid Queen"

/*
/datum/job/submap/ascent/control_mind
	title = "Ascent Control Mind"
	supervisors = "the Gyne"
	total_positions = 1
	info = "You are a Machine Intelligence of an independent Ascent vessel. The Gyne you assist, and her children, have wandered into this sector full of primitive bioforms. Try to keep them alive, and assist where you can."
	set_species_on_join = /mob/living/silicon/ai/ascent

/obj/effect/submap_landmark/spawnpoint/ascent_seedship/control
	name = "Ascent Control Mind"

/mob/living/silicon/ai/ascent
	name = "TODO"
*/

#undef WEBHOOK_SUBMAP_LOADED_ASCENT
