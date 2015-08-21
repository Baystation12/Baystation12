var/datum/antagonist/revolutionary/revs

/datum/antagonist/revolutionary
	id = MODE_REVOLUTIONARY
	role_type = BE_REV
	role_text = "Revolutionary"
	role_text_plural = "Revolutionaries"
	bantype = "revolutionary"
	feedback_tag = "rev_objective"
	restricted_jobs = list("Internal Affairs Agent", "AI", "Cyborg","Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Research Director", "Chief Medical Officer")
	protected_jobs = list("Security Officer", "Warden", "Detective")
	antag_indicator = "rev"
	welcome_text = "The flash in your possession will help you to persuade the crew to join your cause."
	victory_text = "The heads of staff were relieved of their posts! The revolutionaries win!"
	loss_text = "The heads of staff managed to stop the revolution!"
	victory_feedback_tag = "win - heads killed"
	loss_feedback_tag = "loss - rev heads killed"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	max_antags = 200 // No upper limit.
	max_antags_round = 200

	var/list/head_revolutionaries = list()

/datum/antagonist/revolutionary/New()
	..()
	revs = src

/datum/antagonist/revolutionary/is_antagonist(var/datum/mind/player)
	if(..() || (player in head_revolutionaries))
		return 1
	return 0

/datum/antagonist/revolutionary/equip(mob/living/carbon/human/mob)

	if(!..())
		return 0

	if(!config.rp_rev)
		mob.verbs |= /mob/living/carbon/human/proc/convert_to_rev
		return

	var/obj/item/device/flash/T = new(mob)

	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
	)
	mob.equip_in_one_of_slots(T, slots)

/*
datum/antagonist/revolutionary/finalize(var/datum/mind/target)
	if(target)
		return ..(target)
	current_antagonists |= head_revolutionaries
	create_global_objectives()
	..()

/datum/antagonist/revolutionary/get_additional_check_antag_output(var/datum/admins/caller)
	return ..() //Todo

	Rev extras:
				dat += "<br><table cellspacing=5><tr><td><B>Revolutionaries</B></td><td></td></tr>"
			for(var/datum/mind/N in ticker.mode.head_revolutionaries)
				var/mob/M = N.current
				if(!M)
					dat += "<tr><td><i>Head Revolutionary not found!</i></td></tr>"
				else
					dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a> <b>(Leader)</b>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
					dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td></tr>"
			for(var/datum/mind/N in ticker.mode.revolutionaries)
				var/mob/M = N.current
				if(M)
					dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
					dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td></tr>"
			dat += "</table><table cellspacing=5><tr><td><B>Target(s)</B></td><td></td><td><B>Location</B></td></tr>"
			for(var/datum/mind/N in ticker.mode.get_living_heads())
				var/mob/M = N.current
				if(M)
					dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
					dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td>"
					var/turf/mob_loc = get_turf(M)
					dat += "<td>[mob_loc.loc]</td></tr>"
				else
					dat += "<tr><td><i>Head not found!</i></td></tr>"
*/

/datum/antagonist/revolutionary/create_global_objectives()
	if(!..())
		return

	global_objectives = list()

	for(var/datum/mind/head_mind in get_living_heads())
		var/datum/objective/mutiny/rev_obj = new
		rev_obj.target = head_mind
		rev_obj.explanation_text = "Assassinate [head_mind.name], the [head_mind.assigned_role]."
		global_objectives += rev_obj

/datum/antagonist/revolutionary/print_player_summary()

	current_antagonists |= head_revolutionaries
	if(!current_antagonists.len)
		return

	var/text = "<BR/><FONT size = 2><B>The [head_revolutionaries.len == 1 ? "Head Revolutionary was" : "Head Revolutionaries were"]:</B></FONT>"
	for(var/datum/mind/ply in head_revolutionaries)
		text += "<BR/><b>[ply.name]</b>"
	world << text

	..()

	var/list/heads = list()
	for(var/mob/player in mob_list)
		if(player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind

	text = "<FONT size = 2><B>The heads of staff were:</B></FONT>"
	for(var/datum/mind/head in heads)
		text += "<br>[head.key] was [head.name] ("
		if(head.current)
			if(head.current.stat == DEAD)
				text += "died"
			else if(isNotStationLevel(head.current.z))
				text += "fled the station"
			else
				text += "survived the revolution"
			if(head.current.real_name != head.name)
				text += " as [head.current.real_name]"
		else
			text += "body destroyed"
		text += ")"
	world << text

// This is a total redefine because headrevs are greeted differently to subrevs.
/datum/antagonist/revolutionary/add_antagonist(var/datum/mind/player, var/ignore_role)
	if((player in current_antagonists) || (player in head_revolutionaries))
		return 0
	if(!can_become_antag(player, ignore_role))
		return 0
	current_antagonists |= player
	player.current << "<span class='danger'><font size=3>You are a Revolutionary!</font></span>"
	player.current << "<span class='danger'>Help the cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons, and your leaders by the blue \"R\" icons. Help them overturn the ruling class!</span>"
	player.special_role = "Revolutionary"
	create_objectives(player)
	show_objectives(player)
	update_icons_added(player)
	return 1

/datum/antagonist/revolutionary/remove_antagonist(datum/mind/player, var/show_message, var/implanted)
	if(!..())
		return

	if(player in head_revolutionaries)
		return

	if(istype(player.current, /mob/living/carbon/brain))
		player.current << "<span class='danger'>The frame's firmware detects and deletes your neural reprogramming!  You remember nothing from the moment you were flashed until now.</span>"
		if(show_message)
			player.current.visible_message("The frame beeps contentedly, purging the hostile memory engram from the MMI before initalizing it.")
	else
		if(implanted)
			player.current << "<span class='danger'>The nanobots in the loyalty implant remove all thoughts about being a revolutionary.  Get back to work!</span>"
		else
			player.current << "<span class='danger'>You have been brainwashed! You are no longer a revolutionary! Your memory is hazy from the time you were a rebel...the only thing you remember is the name of the one who brainwashed you...</span>"
		if(show_message)
			player.current.visible_message("[player.current] looks like they just remembered their real allegiance!")

// Used by RP-rev.
/mob/living/carbon/human/proc/convert_to_rev(mob/M as mob in oview(src))
	set name = "Convert Bourgeoise"
	set category = "Abilities"

	if(revs.is_antagonist(M.mind))
		src << "<span class='danger'>\The [M] already serves the revolution.</span>"
		return
	if(!revs.can_become_antag(M.mind))
		src << "<span class='danger'>\The [M] cannot be a revolutionary!</span>"

	if(world.time < M.mind.rev_cooldown)
		src << "<span class='danger'>You must wait five seconds between attempts.</span>"
		return

	src << "<span class='danger'>You are attempting to convert \the [M]...</span>"
	log_admin("[src]([src.ckey]) attempted to convert [M].")
	message_admins("<span class='danger'>[src]([src.ckey]) attempted to convert [M].</span>")

	var/choice = alert(M,"Asked by [src]: Do you want to join the revolution?","Join the revolution?","No!","Yes!")
	if(choice == "Yes!")
		M << "<span class='notice'>You join the revolution!</span>"
		src << "<span class='notice'>[M] joins the revolution!</span>"
		revs.add_antagonist(M.mind, 0, 0, 1)
	else if(choice == "No!")
		M << "<span class='danger'>You reject this traitorous cause!</span>"
		src << "<span class='danger'>\The [M] does not support the revolution!</span>"
	M.mind.rev_cooldown = world.time+50