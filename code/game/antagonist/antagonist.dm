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
	var/cur_max = 0

	var/datum/mind/leader
	var/spawned_nuke
	var/nuke_spawn_loc

	var/list/valid_species = list("Unathi","Tajara","Skrell","Human") // Used for setting appearance.
	var/list/starting_locations = list()
	var/list/current_antagonists = list()
	var/list/global_objectives = list()
	var/list/restricted_jobs = list()
	var/list/protected_jobs = list()
	var/list/candidates = list()

	var/default_access = list()
	var/id_type = /obj/item/weapon/card/id

/datum/antagonist/New()
	..()
	cur_max = max_antags
	get_starting_locations()
	if(config.protect_roles_from_antagonist)
		restricted_jobs |= protected_jobs

/datum/antagonist/proc/tick()
	return 1

/datum/antagonist/proc/get_panel_entry(var/datum/mind/player)

	var/dat = "<tr><td><b>[role_text]:</b>"
	var/extra = get_extra_panel_options(player)
	if(is_antagonist(player))
		dat += "<a href='?src=\ref[player];remove_antagonist=[id]'>\[-\]</a>"
		dat += "<a href='?src=\ref[player];equip_antagonist=[id]'>\[equip\]</a>"
		if(starting_locations && starting_locations.len)
			dat += "<a href='?src=\ref[player];move_antag_to_spawn=[id]'>\[move to spawn\]</a>"
		if(extra) dat += "[extra]"
	else
		dat += "<a href='?src=\ref[player];add_antagonist=[id]'>\[+\]</a>"
	dat += "</td></tr>"

	return dat

/datum/antagonist/proc/get_extra_panel_options()
	return

/datum/antagonist/proc/get_starting_locations()
	if(landmark_id)
		starting_locations = list()
		for(var/obj/effect/landmark/L in landmarks_list)
			if(L.name == landmark_id)
				starting_locations |= get_turf(L)

/datum/antagonist/proc/place_all_mobs()
	if(!starting_locations || !starting_locations.len || !current_antagonists || !current_antagonists.len)
		return
	for(var/datum/mind/player in current_antagonists)
		player.current.loc = pick(starting_locations)

/datum/antagonist/proc/finalize(var/datum/mind/target)

	// This will fail if objectives have already been generated.
	create_global_objectives()

	if(leader && flags & ANTAG_HAS_NUKE && !spawned_nuke)
		make_nuke(leader)

	if(target)
		apply(target)
		create_objectives(target)
		update_icons_added(target)
		greet(target)
		return

	for(var/datum/mind/player in current_antagonists)
		apply(player)
		equip(player.current)
		create_objectives(player)
		update_icons_added(player)
		greet(player)

	place_all_mobs()

	spawn(1)
		if(spawn_announcement)
			if(spawn_announcement_delay)
				sleep(spawn_announcement_delay)
			if(spawn_announcement_sound)
				command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]", new_sound = spawn_announcement_sound)
			else
				command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]")


/datum/antagonist/proc/print_player_summary()

	if(!current_antagonists.len)
		return 0

	var/text = "<br><font size = 2><b>The [current_antagonists.len == 1 ? "[role_text] was" : "[role_text_plural] were"]:</b></font>"
	for(var/datum/mind/P in current_antagonists)
		text += print_player_full(P)
		text += get_special_objective_text(P)
		var/failed
		if(!global_objectives.len && P.objectives && P.objectives.len)
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
				num++

		if(!config.objectives_disabled)
			if(failed)
				text += "<br><font color='red'><B>The [role_text] has failed.</B></font>"
			else
				text += "<br><font color='green'><B>The [role_text] was successful!</B></font>"

	if(global_objectives && global_objectives.len)
		text += "<BR/><FONT size = 2>Their objectives were:<FONT>"
		var/num = 1
		for(var/datum/objective/O in global_objectives)
			text += print_objective(O, num, 1)
			num++

	// Display the results.
	world << text

/datum/antagonist/proc/print_objective(var/datum/objective/O, var/num, var/append_success)
	var/text = "<br><b>Objective [num]:</b> [O.explanation_text] "
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
		if(H && H.owner && H.owner == ply)
			TC_uses += H.used_TC
			uplink_true = 1
			var/list/refined_log = new()
			for(var/datum/uplink_item/UI in H.purchase_log)
				refined_log.Add("[H.purchase_log[UI]]x[UI.log_icon()][UI.name]")
			purchases = english_list(refined_log, nothing_text = "")
	if(uplink_true)
		text += " (used [TC_uses] TC)"
		if(purchases)
			text += "<br>[purchases]"

	return text

/datum/antagonist/proc/update_all_icons()
	if(!antag_indicator)
		return
	for(var/datum/mind/antag in current_antagonists)
		if(antag.current && antag.current.client)
			for(var/image/I in antag.current.client.images)
				if(I.icon_state == antag_indicator)
					qdel(I)
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
							qdel(I)
		if(player.current && player.current.client)
			for(var/image/I in player.current.client.images)
				if(I.icon_state == antag_indicator)
					qdel(I)


