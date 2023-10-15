/datum/antagonist/proc/add_antagonist(datum/mind/player, ignore_role, do_not_equip, move_to_spawn, do_not_announce, preserve_appearance)

	if(!add_antagonist_mind(player, ignore_role))
		return

	if(base_to_load)
		var/singleton/map_template/base = new base_to_load()
		report_progress("Loading map template '[base]' for [role_text]...")
		base_to_load = null
		base.load_new_z()
		get_starting_locations()

	//do this again, just in case
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_job = null
		player.assigned_role = role_text
		player.role_alt_title = null
	player.special_role = role_text

	if(isghostmind(player))
		create_default(player.current)
	else
		create_antagonist(player, move_to_spawn, do_not_announce, preserve_appearance)
		if(istype(skill_setter))
			skill_setter.initialize_skills(player.current.skillset)
		if(!do_not_equip)
			equip(player.current)

	if(faction && player.current)
		if(no_prior_faction)
			player.current.last_faction = faction
		else
			player.current.last_faction = player.current.faction
		player.current.faction = faction
	return 1

/datum/antagonist/proc/add_antagonist_mind(datum/mind/player, ignore_role, nonstandard_role_type, nonstandard_role_msg)
	if(!istype(player))
		return 0
	if(!player.current)
		return 0
	if(player in current_antagonists)
		return 0
	if(!can_become_antag(player, ignore_role))
		return 0
	current_antagonists |= player
	GLOB.destroyed_event.register(player, src, .proc/remove_antagonist)

	if(faction_verb)
		player.current.verbs |= faction_verb

	if(config.objectives_disabled == CONFIG_OBJECTIVE_VERB)
		player.current.verbs += /mob/proc/add_objectives

	if(player.current.client)
		player.current.client.verbs += /client/proc/aooc

	if (istype(player.current, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/borg = player.current
		borg.emagged = TRUE

	spawn(1 SECOND) //Added a delay so that this should pop up at the bottom and not the top of the text flood the new antag gets.
		to_chat(player.current, SPAN_NOTICE("Once you decide on a goal to pursue, you can optionally display it to \
			everyone at the end of the shift with the <b>Set Ambition</b> verb, located in the IC tab.  You can change this at any time, \
			and it otherwise has no bearing on your round."))
	player.current.verbs += /mob/living/proc/set_ambition

	// Handle only adding a mind and not bothering with gear etc.
	if(nonstandard_role_type)
		faction_members |= player
		to_chat(player.current, SPAN_DANGER(FONT_LARGE("You are \a [nonstandard_role_type]!")))
		player.special_role = nonstandard_role_type
		if(nonstandard_role_msg)
			to_chat(player.current, SPAN_NOTICE("[nonstandard_role_msg]"))
		update_icons_added(player)
	return 1

/datum/antagonist/proc/remove_antagonist(datum/mind/player, show_message, implanted)
	GLOB.destroyed_event.unregister(player, src, .proc/remove_antagonist)
	if(!istype(player))
		current_antagonists -= player
		return 0
	if (player.current)
		if (faction_verb)
			player.current.verbs -= faction_verb
		if (faction && player.current.faction == faction)
			if(player.current.faction == player.current.last_faction)
				player.current.faction = MOB_FACTION_NEUTRAL
			else
				player.current.faction = player.current.last_faction
			player.current.last_faction = faction
	if(player in current_antagonists)
		to_chat(player.current, SPAN_DANGER(FONT_LARGE("You are no longer a [role_text]!")))
		current_antagonists -= player
		faction_members -= player
		player.special_role = null
		update_icons_removed(player)

		if(player.current)
			SET_BIT(player.current.hud_updateflag, SPECIALROLE_HUD)
			player.current.reset_skillset() //Reset their skills to be job-appropriate.

		if(!is_special_character(player))
			if(player.current)
				player.current.verbs -= /mob/living/proc/set_ambition
				if(player.current.client)
					player.current.client.verbs -= /client/proc/aooc
			qdel(SSgoals.ambitions[player])
		return 1
	return 0
