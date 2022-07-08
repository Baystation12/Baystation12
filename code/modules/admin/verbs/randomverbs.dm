/client/proc/cmd_admin_drop_everything(mob/M as mob in SSmobs.mob_list)
	set category = null
	set name = "Drop Everything"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		M.drop_from_inventory(W)

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	message_admins("[key_name_admin(usr)] made [key_name_admin(M)] drop everything!", 1)

/client/proc/cmd_admin_prison(mob/M as mob in SSmobs.mob_list)
	set category = "Admin"
	set name = "Prison"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if (ismob(M))
		if(istype(M, /mob/living/silicon/ai))
			alert("The AI can't be sent to prison you jerk!", null, null, null, null, null)
			return
		//strip their stuff before they teleport into a cell :downs:
		for(var/obj/item/W in M)
			M.drop_from_inventory(W)
		//teleport person to cell
		M.Paralyse(5)
		sleep(5)	//so they black out before warping
		M.forceMove(pick(GLOB.prisonwarp))
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(prisoner), slot_w_uniform)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), slot_shoes)
		spawn(50)
			to_chat(M, "<span class='warning'>You have been sent to the prison station!</span>")
		log_and_message_admins("sent [key_name_admin(M)] to the prison station.")

/client/proc/cmd_check_new_players()	//Allows admins to determine who the newer players are.
	set category = "Admin"
	set name = "Check new Players"
	if(!holder)
		to_chat(src, "Only staff members may use this command.")

	var/age = alert(src, "Age check", "Show accounts yonger then _____ days","7", "30" , "All")

	if(age == "All")
		age = 9999999
	else
		age = text2num(age)

	var/missing_ages = 0
	var/msg = ""

	for(var/client/C in GLOB.clients)
		if(C.player_age == "Requires database")
			missing_ages = 1
			continue
		if(C.player_age < age)
			msg += "[key_name(C, 1, 1, 1)]: account is [C.player_age] days old<br>"

	if(missing_ages)
		to_chat(src, "Some accounts did not have proper ages set in their clients.  This function requires database to be present")

	if(msg != "")
		show_browser(src, msg, "window=Player_age_check")
	else
		to_chat(src, "No matches for that age range found.")


/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = "Special Verbs"
	set name = "Global Narrate"
	set desc = "Narrate to everyone, or players on specific z-levels."

	if(!check_rights(R_ADMIN))
		return

	var/region = input("Narrate Globally, single Z level, or connected Z levels?", "Region") as null | anything in list(
		"Global",
		"Single Z",
		"Connected Zs"
	)

	if (!region)
		return

	if (region != "Global")
		var/chosen_z = input("Choose Z level: [region]", "Choose Z", "[get_z(usr) ? get_z(usr) : 0]") as null | num
		if (!chosen_z)
			return

		var/list/z_levels = list(chosen_z)
		if (region == "Connected Zs")
			z_levels = GetConnectedZlevels(chosen_z)

		var/result = cmd_admin_narrate_helper(src)
		if (!result)
			return

		for (var/mob/L in GLOB.player_list)
			if (get_z(L) in z_levels)
				to_chat(L, result[1])

		log_and_message_staff(" - GlobalNarrate to z-level(s): ([english_list(z_levels)]), [result[2]]/[result[3]]: [result[4]]")
	else
		var/result = cmd_admin_narrate_helper(src)
		if (!result)
			return

		to_world(result[1])
		log_and_message_staff(" - GlobalNarrate [region] [result[2]]/[result[3]]: [result[4]]")


/proc/cmd_admin_narrate_helper(var/user, var/style, var/size, var/message)
	if (!style)
		style = input("Pick a text style:", "Text Style") as null|anything in list(
			"default",
			"italic",
			"bold",
			"subtle",
			"notice",
			"warning",
			"danger",
			"occult",
			"unsafe"
		)
	if (!style)
		return

	if (style == "unsafe")
		if (!config.allow_unsafe_narrates)
			to_chat(user, SPAN_WARNING("Unsafe narrates are not permitted by the server configuration."))
			return

	if (style != "unsafe")
		if (!size)
			size = input("Pick a text size:", "Text Size") as null|anything in list(
				"normal",
				"small",
				"large",
				"huge",
				"giant"
			)
		if (!size)
			return

	if (!message)
		message = input("Message:", text("Enter the text you wish to appear to your target:")) as null|text
		if (style != "unsafe")
			message = sanitize(message)
	if (!message)
		return

	var/result = message
	if (style != "unsafe")
		switch (style)
			if ("italic")  result = "<i>[result]</i>"
			if ("bold")    result = "<b>[result]</b>"
			if ("subtle")  result = "<b>You hear a voice in your head... [result]</b>"
			if ("notice")  result = SPAN_NOTICE(result)
			if ("warning") result = SPAN_WARNING(result)
			if ("danger")  result = SPAN_DANGER(result)
			if ("occult")  result = SPAN_OCCULT(result)
		switch (size)
			if ("small")  result = FONT_SMALL(result)
			if ("large")  result = FONT_LARGE(result)
			if ("huge")   result = FONT_HUGE(result)
			if ("giant")  result = FONT_GIANT(result)

	return list(result, style, size, message)

//Condenced version of the mob targeting narrates
/client/proc/cmd_admin_narrate(atom/A)
	set category = "Special Verbs"
	set name = "Narrate"
	set desc = "Selection of narrates targeting a mob."

	if(!check_rights(R_INVESTIGATE))
		return

	var/options = list()

	if(ismob(A))
		options += list("Direct Narrate")

	if(check_rights(R_MOD, FALSE))
		options += list("Visual Narrate", "Audible Narrate")

	var/result = input("What type of narrate?") as null | anything in options
	switch(result)
		if (null)
			return
		if ("Direct Narrate")
			cmd_admin_direct_narrate(A)
		if ("Visual Narrate")
			cmd_admin_visible_narrate(A)
		if ("Audible Narrate")
			cmd_admin_audible_narrate(A)


// Targetted narrate: will narrate to one specific mob
/client/proc/cmd_admin_direct_narrate(var/mob/M)
	set popup_menu = FALSE
	set category = null
	set name = "Direct Narrate"
	set desc = "Narrate to a specific mob."

	if (!check_rights(R_INVESTIGATE))
		return

	if (!M)
		M = input("Direct narrate to who?", "Active Players") as null|anything in get_mob_with_client_list()
	if (!M)
		return

	var/style
	var/size

	var/result = cmd_admin_narrate_helper(src, style, size)
	if (!result)
		return

	to_chat(M, result[1])
	log_and_message_staff(" - DirectNarrate [result[2]]/[result[3]] to ([M.name]/[M.key]): [result[4]]")

// Local narrate, narrates to everyone who can see where you are regardless of whether they are blind or deaf.
/client/proc/cmd_admin_local_narrate()
	set category = "Special Verbs"
	set name = "Local Narrate"
	set desc = "Narrate to everyone who can see the turf your mob is on."

	if(!check_rights(R_MOD))
		return

	var/result = cmd_admin_narrate_helper(src)
	if (!result)
		return

	var/list/listening_hosts = hosts_in_view_range(usr)

	for(var/listener in listening_hosts)
		to_chat(listener, result[1])
	log_and_message_staff(" - LocalNarrate [result[2]]/[result[3]]: [result[4]]")

// Visible narrate, it's as if it's a visible message
/client/proc/cmd_admin_visible_narrate(var/atom/A)
	set popup_menu = FALSE
	set category = null
	set name = "Visible Narrate"
	set desc = "Narrate to those who can see the given atom."

	if(!check_rights(R_MOD))
		return

	var/mob/M = mob

	if(!M)
		to_chat(src, "You must be in control of a mob to use this.")
		return

	var/result = cmd_admin_narrate_helper(src)
	if (!result)
		return

	M.visible_message(result[1], result[1], narrate = TRUE)
	log_and_message_staff(" - VisibleNarrate [result[2]]/[result[3]] on [A]: [result[4]]")

// Visible narrate, it's as if it's a audible message
/client/proc/cmd_admin_audible_narrate(var/atom/A)
	set popup_menu = FALSE
	set category = null
	set name = "Audible Narrate"
	set desc = "Narrate to those who can hear the given atom."

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/mob/M = mob

	if(!M)
		to_chat(src, "You must be in control of a mob to use this.")
		return

	var/result = cmd_admin_narrate_helper(src)
	if (!result)
		return

	M.audible_message(result[1], result[1], narrate = TRUE)
	log_and_message_staff(" - AudibleNarrate [result[2]]/[result[3]] on [A]: [result[4]]")

/client/proc/cmd_admin_godmode(mob/M as mob in SSmobs.mob_list)
	set category = "Special Verbs"
	set name = "Godmode"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	M.status_flags ^= GODMODE
	to_chat(usr, "<span class='notice'>Toggled [(M.status_flags & GODMODE) ? "ON" : "OFF"]</span>")
	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	message_admins("[key_name_admin(usr)] has toggled [key_name_admin(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]", 1)

/client/proc/cmd_admin_notarget(mob/living/M as mob in SSmobs.mob_list)
	set category = "Special Verbs"
	set name = "Notarget"
	set desc = "Makes the target mob become invisible to all simple mobs."

	if (!check_rights(R_ADMIN))
		return

	M.status_flags ^= NOTARGET
	log_and_message_admins("has toggled [key_name(M)]'s notarget to [(M.status_flags & NOTARGET) ? "On" : "Off"]")

/proc/cmd_admin_mute(mob/M as mob, mute_type)
	if(!usr || !usr.client)
		return
	if(!usr.client.holder)
		to_chat(usr, "<font color='red'>Error: cmd_admin_mute: You don't have permission to do this.</font>")
		return
	if(!M.client)
		to_chat(usr, "<font color='red'>Error: cmd_admin_mute: This mob doesn't have a client tied to it.</font>")
	if(M.client.holder)
		to_chat(usr, "<font color='red'>Error: cmd_admin_mute: You cannot mute an admin/mod.</font>")
	if(!M.client)		return
	if(M.client.holder)	return

	var/muteunmute
	var/mute_string

	switch(mute_type)
		if(MUTE_IC)			mute_string = "IC (say and emote)"
		if(MUTE_OOC)		mute_string = "OOC"
		if(MUTE_PRAY)		mute_string = "pray"
		if(MUTE_ADMINHELP)	mute_string = "adminhelp, admin PM and ASAY"
		if(MUTE_DEADCHAT)	mute_string = "deadchat and DSAY"
		if(MUTE_ALL)		mute_string = "everything"
		else				return


	if(M.client.prefs.muted & mute_type)
		muteunmute = "unmuted"
		M.client.prefs.muted &= ~mute_type
	else
		muteunmute = "muted"
		M.client.prefs.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(M)] from [mute_string]")
	message_staff("[key_name_admin(usr)] has [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
	to_chat(M, "<span class = 'alert'>You have been [muteunmute] from [mute_string].</span>")

/client/proc/cmd_admin_add_random_ai_law()
	set category = "Fun"
	set name = "Add Random AI Law"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	log_admin("[key_name(src)] has added a random AI law.")
	message_admins("[key_name_admin(src)] has added a random AI law.", 1)

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	if(show_log == "Yes")
		command_announcement.Announce("Ion storm detected near the [station_name()]. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')

	IonStorm(0)

/*
Allow admins to set players to be able to respawn/bypass 30 min wait, without the admin having to edit variables directly
Ccomp's first proc.
*/

/client/proc/get_ghosts(var/notify = 0,var/what = 2)
	// what = 1, return ghosts ass list.
	// what = 2, return mob list

	var/list/mobs = list()
	var/list/ghosts = list()
	var/list/sortmob = sortAtom(SSmobs.mob_list)                           // get the mob list.
	var/any=0
	for(var/mob/observer/ghost/M in sortmob)
		mobs.Add(M)                                             //filter it where it's only ghosts
		any = 1                                                 //if no ghosts show up, any will just be 0
	if(!any)
		if(notify)
			to_chat(src, "There doesn't appear to be any ghosts for you to select.")
		return

	for(var/mob/M in mobs)
		var/name = M.name
		ghosts[name] = M                                        //get the name of the mob for the popup list
	if(what==1)
		return ghosts
	else
		return mobs

/client/proc/get_ghosts_by_key()
	. = list()
	for(var/mob/observer/ghost/M in SSmobs.mob_list)
		.[M.ckey] = M
	. = sortAssoc(.)

/client/proc/allow_character_respawn(var/selection in get_ghosts_by_key())
	set category = "Special Verbs"
	set name = "Allow player to respawn"
	set desc = "Allows the player bypass the wait to respawn or allow them to re-enter their corpse."

	if(!check_rights(R_ADMIN))
		return

	var/list/ghosts = get_ghosts_by_key()
	var/mob/observer/ghost/G = ghosts[selection]
	if(!istype(G))
		to_chat(src, "<span class='warning'>[selection] no longer has an associated ghost.</span>")
		return

	if(G.has_enabled_antagHUD == 1 && config.antag_hud_restricted)
		var/response = alert(src, "[selection] has enabled antagHUD. Are you sure you wish to allow them to respawn?","Ghost has used AntagHUD","No","Yes")
		if(response == "No") return
	else
		var/response = alert(src, "Are you sure you wish to allow [selection] to respawn?","Allow respawn","No","Yes")
		if(response == "No") return

	G.timeofdeath=-19999						/* time of death is checked in /mob/verb/abandon_mob() which is the Respawn verb.
									   timeofdeath is used for bodies on autopsy but since we're messing with a ghost I'm pretty sure
									   there won't be an autopsy.
									*/
	G.has_enabled_antagHUD = 2
	G.can_reenter_corpse = CORPSE_CAN_REENTER_AND_RESPAWN

	G.show_message("<span class=notice><b>You may now respawn.  You should roleplay as if you learned nothing about the round during your time with the dead.</b></span>", 1)
	log_and_message_admins("has allowed [key_name(G)] to bypass the [config.respawn_delay] minute respawn limit.")

/client/proc/toggle_antagHUD_use()
	set category = "Server"
	set name = "Toggle antagHUD usage"
	set desc = "Toggles antagHUD usage for observers"

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
	var/action=""
	if(config.antag_hud_allowed)
		for(var/mob/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						//Remove the verb from non-admin ghosts
				g.verbs -= /mob/observer/ghost/verb/toggle_antagHUD
			if(g.antagHUD)
				g.antagHUD = 0						// Disable it on those that have it enabled
				g.has_enabled_antagHUD = 2				// We'll allow them to respawn
				to_chat(g, "<span class='danger'>The Administrator has disabled AntagHUD</span>")
		config.antag_hud_allowed = 0
		to_chat(src, "<span class='danger'>AntagHUD usage has been disabled</span>")
		action = "disabled"
	else
		for(var/mob/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						// Add the verb back for all non-admin ghosts
				g.verbs += /mob/observer/ghost/verb/toggle_antagHUD
				to_chat(g, "<span class='notice'><B>The Administrator has enabled AntagHUD </B></span>")// Notify all observers they can now use AntagHUD

		config.antag_hud_allowed = 1
		action = "enabled"
		to_chat(src, "<span class='notice'><B>AntagHUD usage has been enabled</B></span>")


	log_admin("[key_name(usr)] has [action] antagHUD usage for observers")
	message_admins("Admin [key_name_admin(usr)] has [action] antagHUD usage for observers", 1)



/client/proc/toggle_antagHUD_restrictions()
	set category = "Server"
	set name = "Toggle antagHUD Restrictions"
	set desc = "Restricts players that have used antagHUD from being able to join this round."
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
	var/action=""
	if(config.antag_hud_restricted)
		for(var/mob/observer/ghost/g in get_ghosts())
			to_chat(g, "<span class='notice'><B>The administrator has lifted restrictions on joining the round if you use AntagHUD</B></span>")
		action = "lifted restrictions"
		config.antag_hud_restricted = 0
		to_chat(src, "<span class='notice'><B>AntagHUD restrictions have been lifted</B></span>")
	else
		for(var/mob/observer/ghost/g in get_ghosts())
			to_chat(g, "<span class='danger'>The administrator has placed restrictions on joining the round if you use AntagHUD</span>")
			to_chat(g, "<span class='danger'>Your AntagHUD has been disabled, you may choose to re-enabled it but will be under restrictions</span>")
			g.antagHUD = 0
			g.has_enabled_antagHUD = 0
		action = "placed restrictions"
		config.antag_hud_restricted = 1
		to_chat(src, "<span class='danger'>AntagHUD restrictions have been enabled</span>")

	log_admin("[key_name(usr)] has [action] on joining the round if they use AntagHUD")
	message_admins("Admin [key_name_admin(usr)] has [action] on joining the round if they use AntagHUD", 1)

/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Fun"
	set name = "Add Custom AI law"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = sanitize(input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null)
	if(!input)
		return
	for(var/mob/living/silicon/ai/M in SSmobs.mob_list)
		if (M.stat == 2)
			to_chat(usr, "Upload failed. No signal is being detected from the AI.")
		else if (M.see_in_dark == 0)
			to_chat(usr, "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power.")
		else
			M.add_ion_law(input)
			for(var/mob/living/silicon/ai/O in SSmobs.mob_list)
				to_chat(O, "<span class='warning'>" + input + "...LAWS UPDATED</span>")
				O.show_laws()

	log_admin("Admin [key_name(usr)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(usr)] has added a new AI law - [input]", 1)

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	if(show_log == "Yes")
		command_announcement.Announce("Ion storm detected near the [station_name()]. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')

/client/proc/cmd_admin_rejuvenate(mob/living/M as mob in SSmobs.mob_list)
	set category = "Special Verbs"
	set name = "Rejuvenate"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot revive a ghost")
		return
	if(config.allow_admin_rev)
		M.revive()

		log_and_message_admins("healed / revived [key_name_admin(M)]!")
	else
		alert("Admin revive disabled")

/client/proc/cmd_admin_create_centcom_report()
	set category = "Special Verbs"
	set name = "Create Command Report"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = sanitize(input(usr, "Please enter anything you want. Anything. Serious.", "What?", "") as message|null, extra = 0)
	var/customname = sanitizeSafe(input(usr, "Pick a title for the report.", "Title") as text|null)
	if(!input)
		return
	if(!customname)
		customname = "[GLOB.using_map.boss_name] Update"

	//New message handling
	post_comm_message(customname, replacetext_char(input, "\n", "<br/>"))

	switch(alert("Should this be announced to the general population?",,"Yes","No"))
		if("Yes")
			command_announcement.Announce(input, customname, new_sound = GLOB.using_map.command_report_sound, msg_sanitized = 1);
		if("No")
			minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")

	log_admin("[key_name(src)] has created a command report: [input]")
	message_admins("[key_name_admin(src)] has created a command report", 1)

/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in range(world.view))
	set category = "Admin"
	set name = "Delete"

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No") == "Yes")
		log_admin("[key_name(usr)] deleted [O] at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] deleted [O] at ([O.x],[O.y],[O.z])", 1)

		// turfs are special snowflakes that'll explode if qdel'd
		if (isturf(O))
			var/turf/T = O
			T.ChangeTurf(world.turf)
		else
			qdel(O)

/client/proc/cmd_admin_list_open_jobs()
	set category = "Admin"
	set name = "List free slots"

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	for(var/datum/job/job in SSjobs.primary_job_datums)
		to_chat(src, "[job.title]: [job.total_positions]")

/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in range(world.view))
	set category = "Special Verbs"
	set name = "Explosion"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/devastation = input("Range of total devastation. -1 to none", text("Input"))  as num|null
	if(devastation == null) return
	var/heavy = input("Range of heavy impact. -1 to none", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light impact. -1 to none", text("Input"))  as num|null
	if(light == null) return
	var/flash = input("Range of flash. -1 to none", text("Input"))  as num|null
	if(flash == null) return
	var/shaped = 0
	if(config.use_recursive_explosions)
		if(alert(src, "Shaped explosion?", "Shape", "Yes", "No") == "Yes")
			shaped = input("Shaped where to?", "Input")  as anything in list("NORTH","SOUTH","EAST","WEST")
			shaped = text2dir(shaped)
	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20))
			if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return

		explosion(O, devastation, heavy, light, flash, shaped=shaped)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])", 1)
		return
	else
		return

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in range(world.view))
	set category = "Special Verbs"
	set name = "EM Pulse"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light pulse.", text("Input"))  as num|null
	if(light == null) return

	if (heavy || light)

		empulse(O, heavy, light)
		log_admin("[key_name(usr)] created an EM Pulse ([heavy],[light]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an EM PUlse ([heavy],[light]) at ([O.x],[O.y],[O.z])", 1)

		return
	else
		return

/client/proc/cmd_admin_gib(mob/M as mob in SSmobs.mob_list)
	set category = "Special Verbs"
	set name = "Gib"

	if(!check_rights(R_ADMIN|R_FUN))	return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)	return

	log_admin("[key_name(usr)] has gibbed [key_name(M)]")
	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(M)]", 1)

	if(isobserver(M))
		gibs(M.loc)
		return

	M.gib()

/client/proc/cmd_admin_gib_self()
	set name = "Gibself"
	set category = "Fun"

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm == "Yes")
		if (isobserver(mob)) // so they don't spam gibs everywhere
			return
		else
			mob.gib()

		log_and_message_admins("used gibself.")

/client/proc/update_world()
	// If I see anyone granting powers to specific keys like the code that was here,
	// I will both remove their SVN access and permanently ban them from my servers.
	return

/client/proc/cmd_admin_check_contents(mob/living/M as mob in SSmobs.mob_list)
	set category = "Special Verbs"
	set name = "Check Contents"

	var/list/L = M.get_contents()
	for(var/t in L)
		to_chat(usr, "[t]")

/* This proc is DEFERRED. Does not do anything.
/client/proc/cmd_admin_remove_phoron()
	set category = "Debug"
	set name = "Stabilize Atmos."
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
// DEFERRED
	spawn(0)
		for(var/turf/T in view())
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.oxygen = 755985
			T.oldoxy = 755985
			T.tmpoxy = 755985
			T.co2 = 14.8176
			T.oldco2 = 14.8176
			T.tmpco2 = 14.8176
			T.n2 = 2.844e+006
			T.on2 = 2.844e+006
			T.tn2 = 2.844e+006
			T.tsl_gas = 0
			T.osl_gas = 0
			T.sl_gas = 0
			T.temp = 293.15
			T.otemp = 293.15
			T.ttemp = 293.15
*/

/client/proc/toggle_view_range()
	set category = "Special Verbs"
	set name = "Change View Range"
	set desc = "switches between 1x and custom views"

	if(view == world.view)
		view = input("Select view range:", "FUCK YE", 7) in list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,128)
	else
		view = world.view

	log_and_message_admins("changed their view range to [view].")

/client/proc/admin_call_shuttle()

	set category = "Admin"
	set name = "Call Evacuation"

	if(!SSticker.mode || !evacuation_controller)
		return

	if(!check_rights(R_ADMIN))	return

	if(alert(src, "Are you sure?", "Confirm", "Yes", "No") != "Yes") return

	if(SSticker.mode.auto_recall_shuttle)
		if(input("The evacuation will just be cancelled if you call it. Call anyway?") in list("Confirm", "Cancel") != "Confirm")
			return

	var/choice = input("Is this an emergency evacuation or a crew transfer?") in list("Emergency", "Crew Transfer")
	evacuation_controller.call_evacuation(usr, (choice == "Emergency"))
	log_and_message_admins("admin-called an evacuation.")
	return

/client/proc/admin_cancel_shuttle()
	set category = "Admin"
	set name = "Cancel Evacuation"

	if(!check_rights(R_ADMIN))	return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes") return

	if(!evacuation_controller)
		return

	evacuation_controller.cancel_evacuation()
	log_and_message_admins("admin-cancelled the evacuation.")

/client/proc/admin_deny_shuttle()
	set category = "Admin"
	set name = "Toggle Deny Evac"

	if (!evacuation_controller)
		return

	if(!check_rights(R_ADMIN))	return

	evacuation_controller.deny = !evacuation_controller.deny

	log_admin("[key_name(src)] has [evacuation_controller.deny ? "denied" : "allowed"] evacuation to be called.")
	message_admins("[key_name_admin(usr)] has [evacuation_controller.deny ? "denied" : "allowed"] evacuation to be called.")

/client/proc/cmd_admin_attack_log(mob/M as mob in SSmobs.mob_list)
	set category = "Special Verbs"
	set name = "Attack Log"

	to_chat(usr, text("<span class='danger'>Attack Log for []</span>", mob))
	for(var/t in M.attack_logs_)
		to_chat(usr, t)


/client/proc/toggle_random_events()
	set category = "Server"
	set name = "Toggle random events on/off"

	set desc = "Toggles random events such as meteors, black holes, blob (but not space dust) on/off"
	if(!check_rights(R_SERVER))	return

	if(!config.allow_random_events)
		config.allow_random_events = 1
		to_chat(usr, "Random events enabled")
		message_admins("Admin [key_name_admin(usr)] has enabled random events.", 1)
	else
		config.allow_random_events = 0
		to_chat(usr, "Random events disabled")
		message_admins("Admin [key_name_admin(usr)] has disabled random events.", 1)


/client/proc/cmd_admin_simulate_distant_explosion()
	set category = "Fun"
	set name = "Simulate Distant Explosion"
	set desc = "Plays distant explosion audio and optionally causes players to fall over"
	var/client/user = resolve_client()
	if (!check_rights(R_ADMIN, TRUE, user))
		return
	var/mob/mob = user.mob
	if (!mob || !isliving(mob) && !isobserver(mob))
		to_chat(user, SPAN_WARNING("You must be in the game world to use this command."))
		return
	var/turf/turf = get_turf(mob)
	if (!turf)
		to_chat(user, SPAN_WARNING("You must be in the game world to use this command."))
		return
	var/list/levels = GetConnectedZlevels(turf.z)
	if (!length(levels))
		to_chat(user, SPAN_WARNING("No levels connected to this z-group."))
		return
	levels = sortList(levels)
	var/mode
	var/response = alert(user, "Players on levels [levels.Join(", ")] will be affected.\nShould they be knocked over?", "Simulate Distant Explosion", "Yes", "No", "Cancel")
	if (!response || response == "Cancel")
		return
	if (response == "Yes")
		response = alert(user, "Should all players be knocked down, or only unstable ones?", "Simulate Distant Explosion", "Unstable", "All", "Cancel")
		if (!response || response == "Cancel")
			return
		if (response == "All")
			mode = 2
		else
			mode = 1
	var/affected = 0
	var/floored = 0
	for (mob as anything in GLOB.player_list)
		var/living = isliving(mob)
		if (!living && !isobserver(mob))
			continue
		turf = get_turf(mob)
		if (!(turf?.z in levels))
			continue
		++affected
		mob.playsound_local(mob, 'sound/effects/explosionfar.ogg', 15)
		if (!mode)
			continue
		if (!living || !mob.can_be_floored())
			continue
		var/fall = mode
		if (fall == 1)
			var/since_move = world.time - mob.l_move_time
			if (since_move > 5 SECONDS)
				fall = prob(20)
			else if (since_move > 3 SECONDS)
				fall = MOVING_QUICKLY(mob) ? prob(75) : prob(20)
			else
				fall = MOVING_QUICKLY(mob) ? prob(75) : prob(50)
		if (fall)
			to_chat(mob, SPAN_DANGER("You stumble onto the floor from the shaking!"))
			mob.AdjustWeakened(2)
			mob.AdjustStunned(2)
			++floored
	log_and_message_admins("[key_name_admin(user)] simulated a distant explosion, affecting [affected] players and flooring [floored] on levels [levels.Join(", ")].")
