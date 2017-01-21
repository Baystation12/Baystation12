/client/proc/cmd_admin_drop_everything(mob/M as mob in mob_list)
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
	feedback_add_details("admin_verb","DEVR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_prison(mob/M as mob in mob_list)
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
		M.loc = pick(prisonwarp)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(prisoner), slot_w_uniform)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), slot_shoes)
		spawn(50)
			to_chat(M, "<span class='warning'>You have been sent to the prison station!</span>")
		log_and_message_admins("sent [key_name_admin(M)] to the prison station.")
		feedback_add_details("admin_verb","PRISON") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_subtle_message(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Subtle Message"

	if(!ismob(M))	return
	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/msg = sanitize(input("Message:", text("Subtle PM to [M.key]")) as text)

	if (!msg)
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				to_chat(M, "<b>You hear a voice in your head... <i>[msg]</i></b>")
	log_and_message_admins(" - SubtleMessage -> [key_name_admin(M)] : [msg]")
	feedback_add_details("admin_verb","SMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mentor_check_new_players()	//Allows mentors / admins to determine who the newer players are.
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

	var/highlight_special_characters = 1
	if(is_mentor(usr.client))
		highlight_special_characters = 0

	for(var/client/C in clients)
		if(C.player_age == "Requires database")
			missing_ages = 1
			continue
		if(C.player_age < age)
			msg += "[key_name(C, 1, 1, highlight_special_characters)]: account is [C.player_age] days old<br>"

	if(missing_ages)
		to_chat(src, "Some accounts did not have proper ages set in their clients.  This function requires database to be present")

	if(msg != "")
		src << browse(msg, "window=Player_age_check")
	else
		to_chat(src, "No matches for that age range found.")


/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = "Special Verbs"
	set name = "Global Narrate"

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/msg = sanitize(input("Message:", text("Enter the text you wish to appear to everyone:")) as text)

	if (!msg)
		return
	to_world(msg)

	log_and_message_admins(" - GlobalNarrate: [msg]")
	feedback_add_details("admin_verb","GLN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_direct_narrate(var/mob/M)	// Targetted narrate -- TLE
	set category = "Special Verbs"
	set name = "Direct Narrate"

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(!M)
		M = input("Direct narrate to who?", "Active Players") as null|anything in get_mob_with_client_list()

	if(!M)
		return

	var/msg = sanitize(input("Message:", text("Enter the text you wish to appear to your target:")) as text)

	if( !msg )
		return

	to_chat(M, msg)
	log_and_message_admins(" - DirectNarrate to ([M.name]/[M.key]): [msg]")
	feedback_add_details("admin_verb","DIRN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_godmode(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Godmode"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	M.status_flags ^= GODMODE
	to_chat(usr, "<span class='notice'>Toggled [(M.status_flags & GODMODE) ? "ON" : "OFF"]</span>")
	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	message_admins("[key_name_admin(usr)] has toggled [key_name_admin(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]", 1)
	feedback_add_details("admin_verb","GOD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


proc/cmd_admin_mute(mob/M as mob, mute_type)
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
	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
	to_chat(M, "<span class = 'alert'>You have been [muteunmute] from [mute_string].</span>")
	feedback_add_details("admin_verb","MUTE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

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
		command_announcement.Announce("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')

	IonStorm(0)
	feedback_add_details("admin_verb","ION") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
Allow admins to set players to be able to respawn/bypass 30 min wait, without the admin having to edit variables directly
Ccomp's first proc.
*/

/client/proc/get_ghosts(var/notify = 0,var/what = 2)
	// what = 1, return ghosts ass list.
	// what = 2, return mob list

	var/list/mobs = list()
	var/list/ghosts = list()
	var/list/sortmob = sortAtom(mob_list)                           // get the mob list.
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
	for(var/mob/observer/ghost/M in mob_list)
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

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawn_character()
	set category = "Special Verbs"
	set name = "Respawn Character"
	set desc = "Respawn a person that has been gibbed/dusted/killed. They must be a ghost for this to work and preferably should not have a body to go back into."
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = ckey(input(src, "Please specify which key will be respawned.", "Key", ""))
	if(!input)
		return

	var/mob/observer/ghost/G_found
	for(var/mob/observer/ghost/G in player_list)
		if(G.ckey == input)
			G_found = G
			break

	if(!G_found)//If a ghost was not found.
		to_chat(usr, "<font color='red'>There is no active key like that in the game or the person is not currently a ghost.</font>")
		return

	var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

	var/datum/data/record/record_found			//Referenced to later to either randomize or not randomize the character.
	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		/*Try and locate a record for the person being respawned through data_core.
		This isn't an exact science but it does the trick more often than not.*/
		var/id = md5("[G_found.real_name][G_found.mind.assigned_role]")
		for(var/datum/data/record/t in data_core.locked)
			if(t.fields["id"]==id)
				record_found = t//We shall now reference the record.
				break

	if(record_found)//If they have a record we can determine a few things.
		new_character.real_name = record_found.fields["name"]
		new_character.gender = record_found.fields["sex"]
		new_character.age = record_found.fields["age"]
		new_character.b_type = record_found.fields["b_type"]
	else
		new_character.gender = pick(MALE,FEMALE)
		var/datum/preferences/A = new()
		A.sanitize_preferences()
		A.randomize_appearance_and_body_for(new_character)
		new_character.real_name = G_found.real_name

	if(!new_character.real_name)
		if(new_character.gender == MALE)
			new_character.real_name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
		else
			new_character.real_name = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
	new_character.name = new_character.real_name

	if(G_found.mind && !G_found.mind.active)
		G_found.mind.transfer_to(new_character)	//be careful when doing stuff like this! I've already checked the mind isn't in use
		new_character.mind.special_verbs = list()
	else
		new_character.mind_initialize()
	if(!new_character.mind.assigned_role)	new_character.mind.assigned_role = "Assistant"//If they somehow got a null assigned role.

	//DNA
	if(record_found)//Pull up their name from database records if they did have a mind.
		new_character.dna = new()//Let's first give them a new DNA.
		new_character.dna.unique_enzymes = record_found.fields["b_dna"]//Enzymes are based on real name but we'll use the record for conformity.

		// I HATE BYOND.  HATE.  HATE. - N3X
		var/list/newSE= record_found.fields["enzymes"]
		var/list/newUI = record_found.fields["identity"]
		new_character.dna.SE = newSE.Copy() //This is the default of enzymes so I think it's safe to go with.
		new_character.dna.UpdateSE()
		new_character.UpdateAppearance(newUI.Copy())//Now we configure their appearance based on their unique identity, same as with a DNA machine or somesuch.
	else//If they have no records, we just do a random DNA for them, based on their random appearance/savefile.
		new_character.dna.ready_dna(new_character)

	new_character.key = G_found.key

	/*
	The code below functions with the assumption that the mob is already a traitor if they have a special role.
	So all it does is re-equip the mob with powers and/or items. Or not, if they have no special role.
	If they don't have a mind, they obviously don't have a special role.
	*/

	var/player_key = G_found.key

	//Now for special roles and equipment.
	var/datum/antagonist/antag_data = get_antag_data(new_character.mind.special_role)
	if(antag_data)
		antag_data.add_antagonist(new_character.mind)
		antag_data.place_mob(new_character)
	else
		job_master.EquipRank(new_character, new_character.mind.assigned_role, 1)

	//Announces the character on all the systems, based on the record.
	if(!issilicon(new_character))//If they are not a cyborg/AI.
		if(!record_found && !player_is_antag(new_character.mind, only_offstation_roles = 1)) //If there are no records for them. If they have a record, this info is already in there. MODE people are not announced anyway.
			//Power to the user!
			if(alert(new_character,"Warning: No data core entry detected. Would you like to announce the arrival of this character by adding them to various databases, such as medical records?",,"No","Yes")=="Yes")
				data_core.manifest_inject(new_character)

			if(alert(new_character,"Would you like an active AI to announce this character?",,"No","Yes")=="Yes")
				call(/proc/AnnounceArrival)(new_character, new_character.mind.assigned_role)

	log_and_message_admins("has respawned [player_key] as [new_character.real_name].")

	to_chat(new_character, "You have been fully respawned. Enjoy the game.")
	feedback_add_details("admin_verb","RSPCH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return new_character

/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Fun"
	set name = "Add Custom AI law"
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = sanitize(input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null)
	if(!input)
		return
	for(var/mob/living/silicon/ai/M in mob_list)
		if (M.stat == 2)
			to_chat(usr, "Upload failed. No signal is being detected from the AI.")
		else if (M.see_in_dark == 0)
			to_chat(usr, "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power.")
		else
			M.add_ion_law(input)
			for(var/mob/living/silicon/ai/O in mob_list)
				to_chat(O, "<span class='warning'>" + input + "...LAWS UPDATED</span>")
				O.show_laws()

	log_admin("Admin [key_name(usr)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(usr)] has added a new AI law - [input]", 1)

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	if(show_log == "Yes")
		command_announcement.Announce("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')
	feedback_add_details("admin_verb","IONC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_rejuvenate(mob/living/M as mob in mob_list)
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
	feedback_add_details("admin_verb","REJU") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

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
		customname = "[command_name()] Update"

	//New message handling
	post_comm_message(customname, replacetext(input, "\n", "<br/>"))

	switch(alert("Should this be announced to the general population?",,"Yes","No"))
		if("Yes")
			command_announcement.Announce(input, customname, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
		if("No")
			to_world("<span class='warning'>New [using_map.company_name] Update available at all communication consoles.</span>")
			sound_to(world, sound('sound/AI/commandreport.ogg'))

	log_admin("[key_name(src)] has created a command report: [input]")
	message_admins("[key_name_admin(src)] has created a command report", 1)
	feedback_add_details("admin_verb","CCR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in range(world.view))
	set category = "Admin"
	set name = "Delete"

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No") == "Yes")
		log_admin("[key_name(usr)] deleted [O] at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] deleted [O] at ([O.x],[O.y],[O.z])", 1)
		feedback_add_details("admin_verb","DEL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		qdel(O)

/client/proc/cmd_admin_list_open_jobs()
	set category = "Admin"
	set name = "List free slots"

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if(job_master)
		for(var/datum/job/job in job_master.occupations)
			to_chat(src, "[job.title]: [job.total_positions]")
	feedback_add_details("admin_verb","LFS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

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
		feedback_add_details("admin_verb","EXPL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
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
		feedback_add_details("admin_verb","EMP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		return
	else
		return

/client/proc/cmd_admin_gib(mob/M as mob in mob_list)
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
	feedback_add_details("admin_verb","GIB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

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
		feedback_add_details("admin_verb","GIBS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/update_world()
	// If I see anyone granting powers to specific keys like the code that was here,
	// I will both remove their SVN access and permanently ban them from my servers.
	return

/client/proc/cmd_admin_check_contents(mob/living/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Check Contents"

	var/list/L = M.get_contents()
	for(var/t in L)
		to_chat(usr, "[t]")
	feedback_add_details("admin_verb","CC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/* This proc is DEFERRED. Does not do anything.
/client/proc/cmd_admin_remove_phoron()
	set category = "Debug"
	set name = "Stabilize Atmos."
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	feedback_add_details("admin_verb","STATM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
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
	feedback_add_details("admin_verb","CVRA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_call_shuttle()

	set category = "Admin"
	set name = "Call Evacuation"

	if(!ticker || !evacuation_controller)
		return

	if(!check_rights(R_ADMIN))	return

	if(alert(src, "Are you sure?", "Confirm", "Yes", "No") != "Yes") return

	if(ticker.mode.auto_recall_shuttle)
		if(input("The evacuation will just be cancelled if you call it. Call anyway?") in list("Confirm", "Cancel") != "Confirm")
			return

	var/choice = input("Is this an emergency evacuation or a crew transfer?") in list("Emergency", "Crew Transfer")
	evacuation_controller.call_evacuation(usr, (choice == "Emergency"))

	feedback_add_details("admin_verb","CSHUT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_and_message_admins("admin-called an evacuation.")
	return

/client/proc/admin_cancel_shuttle()
	set category = "Admin"
	set name = "Cancel Evacuation"

	if(!check_rights(R_ADMIN))	return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes") return

	if(!ticker || !evacuation_controller)
		return

	evacuation_controller.cancel_evacuation()

	feedback_add_details("admin_verb","CCSHUT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_and_message_admins("admin-cancelled the evacuation.")

	return

/client/proc/admin_deny_shuttle()
	set category = "Admin"
	set name = "Toggle Deny Evac"

	if (!ticker || !evacuation_controller)
		return

	if(!check_rights(R_ADMIN))	return

	evacuation_controller.deny = !evacuation_controller.deny

	log_admin("[key_name(src)] has [evacuation_controller.deny ? "denied" : "allowed"] evacuation to be called.")
	message_admins("[key_name_admin(usr)] has [evacuation_controller.deny ? "denied" : "allowed"] evacuation to be called.")

/client/proc/cmd_admin_attack_log(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Attack Log"

	to_chat(usr, text("<span class='danger'>Attack Log for []</span>", mob))
	for(var/t in M.attack_logs_)
		to_chat(usr, t)
	feedback_add_details("admin_verb","ATTL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/everyone_random()
	set category = "Fun"
	set name = "Make Everyone Random"
	set desc = "Make everyone have a random appearance. You can only use this before rounds!"

	if(!check_rights(R_FUN))	return

	if (ticker && ticker.mode)
		to_chat(usr, "Nope you can't do this, the game's already started. This only works before rounds!")
		return

	if(ticker.random_players)
		ticker.random_players = 0
		message_admins("Admin [key_name_admin(usr)] has disabled \"Everyone is Special\" mode.", 1)
		to_chat(usr, "Disabled.")
		return


	var/notifyplayers = alert(src, "Do you want to notify the players?", "Options", "Yes", "No", "Cancel")
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(src)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(usr)] has forced the players to have random appearances.", 1)

	if(notifyplayers == "Yes")
		to_world("<span class='notice'><b>Admin [usr.key] has forced the players to have completely random identities!</b></span>")

	to_chat(usr, "<i>Remember: you can always disable the randomness by using the verb again, assuming the round hasn't started yet</i>.")
	ticker.random_players = 1
	feedback_add_details("admin_verb","MER") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


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
	feedback_add_details("admin_verb","TRE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
