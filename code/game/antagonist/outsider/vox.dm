GLOBAL_DATUM_INIT(vox_raiders, /datum/antagonist/vox, new)

/datum/antagonist/vox
	id = MODE_VOXRAIDER
	role_text = "Vox Raider"
	role_text_plural = "Vox Raiders"
	landmark_id = "Vox-Spawn"
	welcome_text = "Scrap has been hard to find lately, and the Shroud requires replacement parts. Do not disappoint your kin."
	flags = ANTAG_VOTABLE | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudraider"

	hard_cap = 5
	hard_cap_round = 10
	initial_spawn_req = 3
	initial_spawn_target = 4

	id_type = /obj/item/card/id/syndicate

	base_to_load = /datum/map_template/ruin/antag_spawn/vox_raider


/datum/antagonist/vox/build_candidate_list(datum/game_mode/mode, ghosts_only)
	candidates = list()
	for(var/datum/mind/player in mode.get_players_for_role(id))
		if (ghosts_only && !(isghostmind(player) || isnewplayer(player.current)))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts may join as this role!")
			continue
		if (player.special_role)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They already have a special role ([player.special_role])!")
			continue
		if (player in pending_antagonists)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They have already been selected for this role!")
			continue
		if (player_is_antag(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are already an antagonist!")
			continue
		if(!is_alien_whitelisted(player.current, all_species[SPECIES_VOX]))
			log_debug("[player.current.ckey] is not whitelisted")
			continue
		var/result = can_become_antag_detailed(player)
		if (result)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: [result]")
			continue
		candidates |= player

	return candidates

/datum/antagonist/vox/get_potential_candidates(datum/game_mode/mode, ghosts_only)
	var/candidates = list()

	for(var/datum/mind/player in mode.get_players_for_role(id))
		if(ghosts_only && !(isghostmind(player) || isnewplayer(player.current)))
		else if(config.use_age_restriction_for_antags && player.current.client.player_age < minimum_player_age)
		else if(player.special_role)
		else if (player in pending_antagonists)
		else if(!can_become_antag(player))
		else if(player_is_antag(player))
		else if(!is_alien_whitelisted(player.current, all_species[SPECIES_VOX]))
		else
			candidates |= player

	return candidates

/datum/antagonist/vox/can_become_antag_detailed(datum/mind/player, ignore_role)
	if(!is_alien_whitelisted(player.current, all_species[SPECIES_VOX]))
		return "Player doesn't have vox whitelist"
	..()




/datum/antagonist/vox/equip(mob/living/carbon/human/vox/player)
	if(!..())
		return FALSE

	player.set_species(SPECIES_VOX)
	var/decl/hierarchy/outfit/vox_raider = outfit_by_type(/decl/hierarchy/outfit/vox_raider)
	vox_raider.equip(player)


	return TRUE