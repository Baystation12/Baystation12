var/global/list/all_antag_types = list()
var/global/list/all_antag_spawnpoints = list()
var/global/list/antag_names_to_ids = list()

/proc/get_antag_data(var/antag_type)
	if(all_antag_types[antag_type])
		return all_antag_types[antag_type]
	else
		for(var/cur_antag_type in all_antag_types)
			var/datum/antagonist/antag = all_antag_types[cur_antag_type]
			if(antag && antag.is_type(antag_type))
				return antag

/proc/clear_antag_roles(var/datum/mind/player, var/implanted)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/proc/update_antag_icons(var/datum/mind/player)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/proc/populate_antag_type_list()
	for(var/antag_type in typesof(/datum/antagonist)-/datum/antagonist)
		var/datum/antagonist/A = new antag_type
		all_antag_types[A.id] = A
		all_antag_spawnpoints[A.landmark_id] = list()
		antag_names_to_ids[A.role_text] = A.id

/proc/get_antags(var/atype)
	var/datum/antagonist/antag = all_antag_types[atype]
	if(antag && islist(antag.current_antagonists))
		return antag.current_antagonists
	return list()

/datum/antagonist

	var/role_type = BE_TRAITOR
	var/role_text = "Traitor"
	var/role_text_plural = "Traitors"
	var/welcome_text = "Cry havoc and let slip the dogs of war!"
	var/leader_welcome_text
	var/victory_text
	var/loss_text
	var/victory_feedback_tag
	var/loss_feedback_tag

	var/spawn_upper = 5
	var/spawn_lower = 3
	var/max_antags = 3
	var/max_antags_round = 5

	// Random spawn values.
	var/spawn_announcement
	var/spawn_announcement_title
	var/spawn_announcement_sound
	var/spawn_announcement_delay

	var/id = "traitor"
	var/landmark_id
	var/antag_indicator
	var/mob_path = /mob/living/carbon/human
	var/feedback_tag = "traitor_objective"
	var/bantype = "Syndicate"
	var/suspicion_chance = 50
	var/flags = 0


	var/datum/mind/leader

	var/nuke_spawn_loc

	var/list/starting_locations = list()
	var/list/current_antagonists = list()
	var/list/global_objectives = list()
	var/list/restricted_jobs = list()
	var/list/protected_jobs = list()

/datum/antagonist/New()
	..()
	get_starting_locations()
	if(config.protect_roles_from_antagonist)
		restricted_jobs |= protected_jobs

/datum/antagonist/proc/attempt_late_spawn(var/datum/mind/player)

	var/main_type
	if(ticker && ticker.mode)
		if(ticker.mode.antag_tag && ticker.mode.antag_tag == id)
			main_type = 1
	else
		return 0

	var/cur_max = (main_type ? max_antags_round : max_antags)
	if(ticker.mode.antag_scaling_coeff)
		cur_max = Clamp((ticker.mode.num_players()/ticker.mode.antag_scaling_coeff), 1, cur_max)

	if(get_antag_count() > cur_max-1)
		return 0

	player.current << "<span class='danger'><i>You have been selected this round as an antagonist!</i></span>"
	return

/datum/antagonist/proc/tick()
	return 1

/datum/antagonist/proc/is_antagonist(var/datum/mind/player)
	if(player in current_antagonists)
		return 1

/datum/antagonist/proc/is_type(var/antag_type)
	if(antag_type == id || antag_type == role_text)
		return 1
	return 0

/datum/antagonist/proc/get_panel_entry(var/datum/mind/player)

	var/dat = "<tr>"
	dat += "<td><b>[role_text]:</b></td>"
	if(is_antagonist(player))
		dat += "<td><a href='?src=\ref[player];remove_antagonist=[id]'>\[-\]</a></td>"
		dat += "<td><a href='?src=\ref[player];equip_antagonist=[id]'>\[equip\]</a></td>"
		if(starting_locations && starting_locations.len)
			dat += "<td><a href='?src=\ref[player];move_antag_to_spawn=[id]'>\[move to spawn\]</a></td>"
	else
		dat += "<td><a href='?src=\ref[player];add_antagonist=[id]'>\[+\]</a></td>"
	var/extra = get_extra_panel_options(player)
	if(extra) dat += "[extra]"
	dat += "</tr>"

	return dat

/datum/antagonist/proc/get_extra_panel_options()
	return

/datum/antagonist/proc/antags_are_dead()
	for(var/datum/mind/antag in current_antagonists)
		if(mob_path && !istype(antag.current,mob_path))
			continue
		if(antag.current.stat==2)
			continue
		return 0
	return 1

/datum/antagonist/proc/get_antag_count()
	return current_antagonists ? current_antagonists.len : 0

/datum/antagonist/proc/attempt_spawn(var/lower_count, var/upper_count, var/ghosts_only)

	world << "Attempting to spawn [id]."

	var/main_type
	if(ticker && ticker.mode)
		if(ticker.mode.antag_tag && ticker.mode.antag_tag == id)
			main_type = 1
	else
		world << "Ticker uninitialized, failed."
		return 0

	var/cur_max = (main_type ? max_antags_round : max_antags)
	if(ticker.mode.antag_scaling_coeff)
		cur_max = Clamp((ticker.mode.num_players()/ticker.mode.antag_scaling_coeff), 1, cur_max)

	if(get_antag_count() >= cur_max)
		world << "Antag count: [get_antag_count()] greater than [cur_max], failed."
		return 0

	// Sanity.
	if(lower_count)
		lower_count = max(lower_count,1)
		if(spawn_lower)
			lower_count = max(lower_count,spawn_lower)
	else
		lower_count = 1

	if(upper_count)
		if(spawn_upper)
			upper_count = max(min(spawn_upper, cur_max),1)
	else
		upper_count = 1

	if(upper_count < lower_count)
		upper_count = lower_count


	// Get the raw list of potential players.
	var/req_num = 0
	var/list/candidates = ticker.mode.get_players_for_role(role_type, id)
	if(!candidates) candidates = list()

	world << "Candidate count is [candidates.len]."

	// Prune restricted jobs and status.
	for(var/datum/mind/player in candidates)
		if((ghosts_only && !istype(player.current, /mob/dead)) || (player.assigned_role in restricted_jobs))
			world << "Removing [player.name]."
			candidates -= player

	world << "Candidate count is now [candidates.len]."

	// Update our boundaries.
	if((!candidates.len) || candidates.len < lower_count)
		world << "[candidates.len] not set or below [lower_count], failed."
		return 0
	else if(candidates.len < upper_count)
		req_num = candidates.len
	else
		req_num = upper_count

	//Grab candidates randomly until we have enough.
	while(req_num > 0)
		var/datum/mind/player = pick(candidates)
		current_antagonists |= player
		candidates -= player
		req_num--

	// This will be used in equip() and greet(). Random due to random order of candidates being grabbed.
	if(flags & ANTAG_HAS_LEADER)
		leader = current_antagonists[1]

	// Generate first stage antagonists.
	for(var/datum/mind/player in current_antagonists)
		apply(player)
		equip(player.current)
		finalize(player)

	spawn(1)
		if(spawn_announcement)
			if(spawn_announcement_delay)
				sleep(spawn_announcement_delay)
			if(spawn_announcement_sound)
				command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]", new_sound = spawn_announcement_sound)
			else
				command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]")

	world << "Success."
	return 1

/datum/antagonist/proc/apply(var/datum/mind/player)

	// Update job and role.
	player.special_role = role_text
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = "MODE"

	// Get the mob.
	if((flags & ANTAG_OVERRIDE_MOB) && (!player.current || (mob_path && !istype(player.current, mob_path))))
		var/mob/holder = player.current
		player.current = new mob_path(get_turf(player.current))
		player.transfer_to(player.current)
		if(holder) del(holder)

	player.original = player.current
	return player.current

/datum/antagonist/proc/create_objectives(var/datum/mind/player)
	if(config.objectives_disabled)
		return 0
	if(global_objectives && global_objectives.len)
		player.objectives |= global_objectives
	return 1

/datum/antagonist/proc/equip(var/mob/living/carbon/human/player)

	if(!istype(player))
		return 0

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			del(thing)
	return 1

/datum/antagonist/proc/unequip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return 0
	return 1

/datum/antagonist/proc/greet(var/datum/mind/player)

	// Basic intro text.
	player.current << "<span class='danger'><font size=3>You are a [role_text]!</font></span>"
	if(leader_welcome_text && player.current == leader)
		player.current << "<span class='notice'>[leader_welcome_text]</span>"
	else
		player.current << "<span class='notice'>[welcome_text]</span>"
	show_objectives(player)

	// Choose a name, if any.
	if(flags & ANTAG_CHOOSE_NAME)
		var/newname = sanitize(copytext(input(player.current, "You are a [role_text]. Would you like to change your name to something else?", "Name change") as null|text,1,MAX_NAME_LEN))
		if (newname)
			player.current.real_name = newname
			player.current.name = player.current.real_name
		player.name = player.current.name

	// Clown clumsiness check, I guess downstream might use it.
	if (player.current.mind)
		if (player.current.mind.assigned_role == "Clown")
			player.current << "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself."
			player.current.mutations.Remove(CLUMSY)
	return 1

/datum/antagonist/proc/get_starting_locations()
	if(landmark_id)
		starting_locations = list()
		for(var/obj/effect/landmark/L in landmarks_list)
			if(L.name == landmark_id)
				starting_locations |= get_turf(L)

/datum/antagonist/proc/create_global_objectives()
	return 	!((global_objectives && global_objectives.len) || config.objectives_disabled)

/datum/antagonist/proc/place_all_mobs()
	if(!starting_locations || !starting_locations.len || !current_antagonists || !current_antagonists.len)
		return
	for(var/datum/mind/player in current_antagonists)
		player.current.loc = pick(starting_locations)

/datum/antagonist/proc/place_mob(var/mob/living/mob)
	if(!starting_locations || !starting_locations.len)
		return
	mob.loc = pick(starting_locations)

/datum/antagonist/proc/finalize(var/datum/mind/target)

	// This will fail if objectives have already been generated.
	create_global_objectives()

	if(target)
		create_objectives(target)
		update_icons_added(target)
		greet(target)
		return

	for(var/datum/mind/player in current_antagonists)
		create_objectives(player)
		update_icons_added(player)
		greet(player)

	if(flags & ANTAG_HAS_NUKE)
		make_nuke(leader)

/datum/antagonist/proc/print_player_summary()

	if(!current_antagonists.len)
		return 0

	var/text = "<BR/><FONT size = 2><B>The [current_antagonists.len == 1 ? "[role_text] was" : "[role_text_plural] were"]:</B></FONT>"
	for(var/datum/mind/P in current_antagonists)
		text += print_player_full(P)
		text += get_special_objective_text(P)
		var/failed
		if(!global_objectives && P.objectives)
			var/num = 1
			for(var/datum/objective/O in P.objectives)
				text += print_objective(O, num)
				if(O.completed) // This is set actively in check_victory()
					text += "<font color='green'><B>Success!</B></font>"
					feedback_add_details(feedback_tag,"[O.type]|SUCCESS")
				else
					text += "<font color='red'>Fail.</font>"
					feedback_add_details(feedback_tag,"[O.type]|FAIL")
					failed = 1

		if(!config.objectives_disabled)
			if(failed)
				text += "<br><font color='red'><B>The [role_text] has failed.</B></font>"
			else
				text += "<br><font color='green'><B>The [role_text] was successful!</B></font>"

	if(global_objectives)
		text += "<BR/><FONT size = 2>Their objectives were:<FONT>"
		var/num = 1
		for(var/datum/objective/O in global_objectives)
			text += print_objective(O, num, 1)
			num++

	// Display the results.
	world << text

/datum/antagonist/proc/print_objective(var/datum/objective/O, var/num, var/append_success)
	var/text = "<BR/><B>Objective [num]:</B> [O.explanation_text] "
	if(append_success)
		if(O.check_completion())
			text += "<font color='green'><B>Success!</B></font>"
		else
			text += "<font color='red'>Fail.</font>"
	return text

/datum/antagonist/proc/print_player_lite(var/datum/mind/ply)
	var/role = ply.assigned_role == "MODE" ? "\improper[ply.special_role]" : "\improper[ply.assigned_role]"
	var/text = "<br><b>[ply.name]</b> (<b>[ply.key]</b>) as \a <b>[role]</b> ("
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += "died"
		else if(isNotStationLevel(ply.current.z))
			text += "fled the station"
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += "body destroyed"
	text += ")"

	return text

/datum/antagonist/proc/print_player_full(var/datum/mind/ply)
	var/text = print_player_lite(ply)

	var/TC_uses = 0
	var/uplink_true = 0
	var/purchases = ""
	for(var/obj/item/device/uplink/H in world_uplinks)
		if(H && H.uplink_owner && H.uplink_owner == ply)
			TC_uses += H.used_TC
			uplink_true = 1
			var/list/refined_log = new()
			for(var/datum/uplink_item/UI in H.purchase_log)
				var/obj/I = new UI.path
				refined_log.Add("[H.purchase_log[UI]]x\icon[I][UI.name]")
				del(I)
			purchases = english_list(refined_log, nothing_text = "")
	if(uplink_true)
		text += " (used [TC_uses] TC)"
		if(purchases)
			text += "<br>[purchases]"

	return text

/datum/antagonist/proc/get_special_objective_text()
	return ""

/datum/antagonist/proc/add_antagonist(var/datum/mind/player)
	if(!istype(player))
		return 0
	if(player in current_antagonists)
		return 0
	if(!can_become_antag(player))
		return 0
	current_antagonists |= player
	apply(player)
	finalize(player)
	return 1

/datum/antagonist/proc/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(player in current_antagonists)
		player.current << "<span class='danger'><font size = 3>You are no longer a [role_text]!</font></span>"
		current_antagonists -= player
		player.special_role = null
		update_icons_removed(player)
		BITSET(player.current.hud_updateflag, SPECIALROLE_HUD)
		return 1
	return 0

/datum/antagonist/proc/update_all_icons()
	if(!antag_indicator)
		return
	for(var/datum/mind/antag in current_antagonists)
		if(antag.current && antag.current.client)
			for(var/image/I in antag.current.client.images)
				if(I.icon_state == antag_indicator)
					del(I)
			for(var/datum/mind/other_antag in current_antagonists)
				if(other_antag.current)
					antag.current.client.images |= image('icons/mob/mob.dmi', loc = other_antag.current, icon_state = antag_indicator)

/datum/antagonist/proc/update_icons_added(var/datum/mind/player)
	if(!antag_indicator || !player.current)
		return
	spawn(0)
		for(var/datum/mind/antag in current_antagonists)
			if(!antag.current)
				continue
			if(antag.current.client)
				antag.current.client.images |= image('icons/mob/mob.dmi', loc = player.current, icon_state = antag_indicator)
			if(player.current.client)
				player.current.client.images |= image('icons/mob/mob.dmi', loc = antag.current, icon_state = antag_indicator)

/datum/antagonist/proc/update_icons_removed(var/datum/mind/player)
	if(!antag_indicator || !player.current)
		return
	spawn(0)
		for(var/datum/mind/antag in current_antagonists)
			if(antag.current)
				if(antag.current.client)
					for(var/image/I in antag.current.client.images)
						if(I.icon_state == antag_indicator && I.loc == player.current)
							del(I)
		if(player.current && player.current.client)
			for(var/image/I in player.current.client.images)
				if(I.icon_state == antag_indicator)
					del(I)

/datum/antagonist/proc/can_become_antag(var/datum/mind/player)
	if(player.current && jobban_isbanned(player.current, bantype))
		return 0
	if(player.assigned_role in protected_jobs)
		return 0
	if(config.protect_roles_from_antagonist && (player.assigned_role in restricted_jobs))
		return 0
	return 1

/datum/antagonist/proc/check_victory()
	var/result
	if(config.objectives_disabled)
		return 1
	if(!victory_text || !loss_text)
		return 1

	if(global_objectives && global_objectives.len)
		for(var/datum/objective/O in global_objectives)
			if(!O.completed && !O.check_completion())
				result = 1 // Victory.
			else
				O.completed = 1 //Will this break anything?

	if(result)
		world << "<span class='danger'><font size = 3>[victory_text]</span>"
		if(victory_feedback_tag) feedback_set_details("round_end_result","[victory_feedback_tag]")
	else
		world << "<span class='danger'><font size = 3>[loss_text]</span>"
		if(loss_feedback_tag) feedback_set_details("round_end_result","[loss_feedback_tag]")

/datum/antagonist/proc/make_nuke(var/atom/paper_spawn_loc, var/datum/mind/code_owner)

	// Decide on a code.
	var/obj/effect/landmark/nuke_spawn = locate(nuke_spawn_loc ? nuke_spawn_loc : "landmark*Nuclear-Bomb")

	var/code
	if(nuke_spawn)
		var/obj/machinery/nuclearbomb/nuke = new(get_turf(nuke_spawn))
		code = "[rand(10000, 99999)]"
		nuke.r_code = code

	if(code)
		if(!paper_spawn_loc)
			paper_spawn_loc = get_turf(locate("landmark*Nuclear-Code"))
		if(paper_spawn_loc)
			// Create and pass on the bomb code paper.
			var/obj/item/weapon/paper/P = new(paper_spawn_loc)
			P.info = "The nuclear authorization code is: <b>[code]</b>"
			P.name = "nuclear bomb code"
		if(code_owner)
			code_owner.store_memory("<B>Nuclear Bomb Code</B>: [code]", 0, 0)
			code_owner.current << "The nuclear authorization code is: <B>[code]</B>"

	else
		world << "<spam class='danger'>Could not spawn nuclear bomb. Contact a developer.</span>"
		return

	return code

/datum/antagonist/proc/random_spawn()
	return attempt_spawn((spawn_lower ? spawn_lower : 1),(spawn_upper ? spawn_upper : 1),(flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB)))