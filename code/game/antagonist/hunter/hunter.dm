GLOBAL_DATUM_INIT(hunters, /datum/antagonist/hunter, new)

/datum/antagonist/hunter
	id = MODE_HUNTER
	role_text = "Bounty Hunter"
	role_text_plural = "Bounty Hunters"
	flags = ANTAG_HAS_LEADER | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT
	leader_welcome_text = "You are leading a squad to hunt down and capture a target."
	welcome_text = "You are part of a squad trying to hunt down and capture a target."
	antaghud_indicator = "hudhunter"
	antag_indicator = "hudhunter"
	hard_cap = 4
	hard_cap_round = 4
	initial_spawn_req = 3
	initial_spawn_target = 4
	landmark_id = "HunterSpawn"
	faction = "bountyhunter"
	var/is_ascent_mode = FALSE

/datum/antagonist/hunter/proc/set_generic_mode()
	role_text = "Bounty Hunter"
	role_text_plural = "Bounty Hunters"
	leader_welcome_text = "You are the leader of a notorious guild of bounty hunters, and you have been contracted to hunt down a high value target on [GLOB.using_map.full_name]. Bring them in alive if possible, dead if not."
	welcome_text = "You are a member of a notorious guild of bounty hunters, contracted to bring in a high value target from [GLOB.using_map.full_name] alive if possible, dead if not."
	is_ascent_mode = FALSE
	base_to_load = /datum/map_template/ruin/antag_spawn/hunter
	id_type = /obj/item/weapon/card/id

/datum/antagonist/hunter/proc/set_ascent_mode()
	role_text = "Hunter"
	role_text_plural = "Hunters"
	leader_welcome_text = "You are a Gyne of the Ascent, leading your brood to hunt down and kill or capture your rival on [GLOB.using_map.full_name]."
	welcome_text = "You are an Alate of the Ascent, following your Gyne in hunting down and killing or capturing her rival on [GLOB.using_map.full_name]."
	is_ascent_mode = TRUE
	base_to_load = /datum/map_template/ruin/antag_spawn/hunter_ascent
	id_type = /obj/item/weapon/card/id/ascent

/datum/antagonist/hunter/update_leader()
	if(is_ascent_mode && !leader)
		var/list/gyne_candidates = list()
		for(var/datum/mind/player in current_antagonists)
			if(is_species_whitelisted(player.current, SPECIES_MANTID_GYNE))
				gyne_candidates |= player
		if(length(gyne_candidates))
			leader = pick(gyne_candidates)
	..()

// Get the raw list of potential players.
/datum/antagonist/hunter/build_candidate_list(datum/game_mode/mode, ghosts_only)
	. = ..()
	set_generic_mode()
	for(var/datum/mind/player in .)
		if(is_species_whitelisted(player.current, SPECIES_MANTID_GYNE))
			set_ascent_mode()
			break

/datum/antagonist/hunter/update_antag_mob(var/datum/mind/player, var/preserve_appearance)
	. = ..()
	if(is_ascent_mode && ishuman(player.current))
		var/mob/living/carbon/human/H = player.current
		if(!leader && is_species_whitelisted(player.current, SPECIES_MANTID_GYNE))
			leader = player
			if(H.species.get_bodytype() != SPECIES_MANTID_GYNE)
				H.set_species(SPECIES_MANTID_GYNE)
			H.gender = FEMALE
		else
			if(H.species.get_bodytype() != SPECIES_MANTID_ALATE)
				H.set_species(SPECIES_MANTID_ALATE)
			H.gender = MALE
		var/decl/cultural_info/culture/ascent/ascent_culture = SSculture.get_culture(CULTURE_ASCENT)
		H.real_name = ascent_culture.get_random_name(H.gender)
		H.name = H.real_name

/datum/antagonist/hunter/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		if(is_ascent_mode)
			if(player.species.get_bodytype(player) == SPECIES_MANTID_GYNE)
				equip_rig(/obj/item/weapon/rig/mantid/gyne, player)
				create_id("Huntmaster", player)
			else
				equip_rig(/obj/item/weapon/rig/mantid, player)
				create_id("Raptorial", player)
		else
			var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/hunter)
			outfit.equip(player)
			create_id("Bounty Hunter", player)
	return 1

/datum/antagonist/hunter/create_id(assignment, mob/living/carbon/human/player, equip)
	var/obj/item/weapon/card/id/id = ..()
	if(istype(id))
		if(is_ascent_mode)
			id.access = list(access_ascent, access_ascent_warship)
		else
			id.access = list(access_hunter)
	return id

/datum/antagonist/hunter/equip_rig(rig_type, mob/living/carbon/human/player)
	var/obj/item/weapon/rig/rig = ..()
	if(rig)
		rig.visible_name = player.real_name
		return rig

/datum/antagonist/hunter/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)
	. = ..()
	if(!base_to_load) // this will not be null unless the mode is not hunter and admin are spawning someone manually
		if(is_species_whitelisted(player.current, SPECIES_MANTID_GYNE))
			set_ascent_mode()
		else
			set_generic_mode()
	if(GLOB.hunter_targets.leader && GLOB.hunter_targets.leader_picked_role)
		to_chat(player, SPAN_DANGER("The target is [GLOB.hunter_targets.leader.current.real_name], [GLOB.hunter_targets.leader_picked_role.article] [GLOB.hunter_targets.leader_picked_role.name]. Bring them in warm or cold."))

/datum/antagonist/hunter/proc/declare_completion()
	return FALSE

/obj/effect/landmark/hunter_start
	name = "HunterSpawn"

/decl/hierarchy/outfit/hunter
	name = OUTFIT_JOB_NAME("Bounty Hunter")
