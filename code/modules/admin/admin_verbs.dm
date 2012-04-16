//GUYS REMEMBER TO ADD A += to UPDATE_ADMINS
//AND A -= TO CLEAR_ADMIN_VERBS



//Some verbs that are still in the code but not used atm
			// Debug
//			verbs += /client/proc/radio_report //for radio debugging dont think its been used in a very long time
//			verbs += /client/proc/fix_next_move //has not been an issue in a very very long time


			// Mapping helpers added via enable_mapping_debug verb
// 			verbs += /client/proc/do_not_use_these
// 			verbs += /client/proc/camera_view
// 			verbs += /client/proc/sec_camera_report
// 			verbs += /client/proc/intercom_view
//			verbs += /client/proc/air_status //Air things
//			verbs += /client/proc/Cell //More air things

/client/proc/update_admins(var/rank)

	if(!holder)
		holder = new /obj/admins(src)

	holder.rank = rank

	if(!holder.state)
		var/state = alert("Which state do you want the admin to begin in?", "Admin-state", "Play", "Observe", "Neither")
		if(state == "Play")
			holder.state = 1
			admin_play()
			return
		else if(state == "Observe")
			holder.state = 2
			admin_observe()
			return
		else
			del(holder)
			return

	switch (rank)
		if ("Game Master")
			deadchat = 1
			seeprayers = 1
			holder.level = 6


		if ("Game Admin")
			deadchat = 1
			seeprayers = 1
			holder.level = 5


		if ("Badmin")
			deadchat = 1
			seeprayers = 1
			holder.level = 4


		if ("Trial Admin")
			deadchat = 1
			seeprayers = 1
			holder.level = 3

			if(holder.state == 2) // if observing
				// Debug
				verbs += /client/proc/debug_variables
				//verbs += /client/proc/cmd_modify_object_variables --Merged with view variables
				verbs += /client/proc/cmd_modify_ticker_variables
				verbs += /client/proc/toggleadminhelpsound

				// Admin helpers
				verbs += /client/proc/toggle_view_range

				// Admin game intrusion
				verbs += /client/proc/Getmob
				verbs += /client/proc/Getkey
				verbs += /client/proc/sendmob
				verbs += /client/proc/Jump
				verbs += /client/proc/jumptokey
				verbs += /client/proc/jumptomob
				verbs += /client/proc/jumptoturf
				verbs += /client/proc/jumptocoord
				verbs += /client/proc/cmd_admin_add_freeform_ai_law
				verbs += /client/proc/cmd_admin_rejuvenate
				verbs += /client/proc/cmd_admin_drop_everything


		if ("Admin Candidate")
			holder.level = 2
			if(holder.state == 2) // if observing
				deadchat = 1
				// Settings
				verbs += /obj/admins/proc/toggleaban			//abandon mob
				verbs += /client/proc/deadchat					//toggles deadchat
				// Admin helpers
				//verbs += /client/proc/cmd_admin_attack_log	//Use view variables
				verbs += /client/proc/cmd_admin_check_contents
				// Admin game intrusion
				verbs += /client/proc/Jump
				verbs += /client/proc/jumptokey
				verbs += /client/proc/jumptomob


		if ("Temporary Admin")
			holder.level = 1


		if ("Moderator")
			holder.level = 0


		if ("Admin Observer")
			holder.level = -1


		if ("Banned")
			holder.level = -2
			del(src)
			return

		if ("Retired Admin")
			holder.level = -3

		else
			del(holder)
			return

	if (holder)//Slightly easier to edit way of granting powers
		holder.owner = src
		if (holder.level >= 6)//Game Master********************************************************************
			verbs += /client/proc/callproc
			verbs += /obj/admins/proc/adjump
			verbs += /client/proc/get_admin_state
			verbs += /client/proc/reload_admins
			verbs += /client/proc/kill_air
			verbs += /client/proc/cmd_debug_make_powernets
			verbs += /client/proc/enable_mapping_debug
			verbs += /client/proc/everyone_random
			verbs += /client/proc/only_one // Fateweaver suggested I do this - Doohl
			verbs += /client/proc/callprocgen
			verbs += /client/proc/callprocobj
			verbs += /client/proc/rnd_check_designs
			verbs += /client/proc/CarbonCopy

		if (holder.level >= 5)//Game Admin********************************************************************
			verbs += /obj/admins/proc/view_txt_log
			verbs += /obj/admins/proc/view_atk_log
			//verbs += /client/proc/cmd_mass_modify_object_variables --Merged with view variables
			verbs += /client/proc/cmd_admin_list_open_jobs
			verbs += /client/proc/cmd_admin_direct_narrate
			verbs += /client/proc/cmd_admin_world_narrate
			verbs += /client/proc/cmd_debug_del_all
			verbs += /client/proc/cmd_debug_tog_aliens
			verbs += /client/proc/ticklag
			verbs += /client/proc/mapload
			verbs += /obj/admins/proc/spawn_atom
			verbs += /client/proc/check_words
			verbs += /client/proc/drop_bomb
			//verbs += /client/proc/give_spell --moved to view variables
			//verbs += /client/proc/cmd_admin_ninjafy		--now in view vars
			verbs += /client/proc/cmd_admin_grantfullaccess
			//verbs += /client/proc/cmd_admin_explosion		--now in view vars
			//verbs += /client/proc/cmd_admin_emp			--now in view vars
			verbs += /client/proc/jump_to_dead_group
			verbs += /client/proc/cmd_admin_drop_everything
			verbs += /client/proc/make_sound
			verbs += /client/proc/play_local_sound
			verbs += /client/proc/send_space_ninja
			verbs += /client/proc/restartcontroller //Can call via aproccall --I_hate_easy_things.jpg, Mport --Agouri
			verbs += /client/proc/Blobize//I need to remember to move/remove this later
			verbs += /client/proc/toggle_clickproc //TODO ERRORAGE (Temporary proc while the enw clickproc is being tested)
			verbs += /client/proc/toggle_gravity_on
			verbs += /client/proc/toggle_gravity_off
			// Moved over from tg's Game Master:
			verbs += /client/proc/colorooc
			verbs += /obj/admins/proc/toggle_aliens			//toggle aliens
			verbs += /obj/admins/proc/toggle_space_ninja	//toggle ninjas
			verbs += /client/proc/triple_ai
			verbs += /client/proc/object_talk
			verbs += /client/proc/strike_team
			verbs += /client/proc/admin_invis
			verbs += /client/proc/cmd_admin_godmode
			verbs += /client/proc/delbook
			verbs += /client/proc/Force_Event_admin
			verbs += /client/proc/radioalert
			verbs += /client/proc/make_tajaran
			verbs += /client/proc/CarbonCopy

		if (holder.level >= 4)//Badmin********************************************************************
			verbs += /obj/admins/proc/adrev					//toggle admin revives
			verbs += /obj/admins/proc/adspawn				//toggle admin item spawning
			verbs += /client/proc/debug_variables
			//verbs += /client/proc/cmd_modify_object_variables --Merged with view variables
			verbs += /client/proc/cmd_modify_ticker_variables
			verbs += /client/proc/Debug2					//debug toggle switch
			verbs += /client/proc/toggle_view_range
			verbs += /client/proc/Getmob
			verbs += /client/proc/Getkey
			verbs += /client/proc/sendmob
			verbs += /client/proc/Jump
			verbs += /client/proc/jumptokey
			verbs += /client/proc/jumptomob
			verbs += /client/proc/jumptoturf
			verbs += /client/proc/cmd_admin_add_freeform_ai_law
			verbs += /client/proc/cmd_admin_add_random_ai_law
			//verbs += /client/proc/cmd_admin_godmode		--now in view variables
			verbs += /client/proc/cmd_admin_rejuvenate
			//verbs += /client/proc/cmd_admin_gib --View vars menu
			verbs += /client/proc/cmd_admin_delete
			//verbs += /proc/togglebuildmode --now in view vars
			verbs += /client/proc/toggleadminhelpsound
			verbs += /client/proc/togglebuildmodeself
			verbs += /client/proc/hide_most_verbs
			verbs += /client/proc/tension_report
			verbs += /client/proc/jumptocoord

		if (holder.level >= 3)//Trial Admin********************************************************************
			verbs += /obj/admins/proc/toggleaban			//abandon mob
			verbs += /client/proc/cmd_admin_remove_plasma
			verbs += /client/proc/admin_call_shuttle
			verbs += /client/proc/admin_cancel_shuttle
			verbs += /client/proc/admin_deny_shuttle
			verbs += /obj/admins/proc/show_traitor_panel
			verbs += /client/proc/cmd_admin_dress
			verbs += /client/proc/cmd_admin_christmas
			verbs += /client/proc/respawn_character
			verbs += /client/proc/spawn_xeno
			verbs += /proc/possess
			verbs += /proc/release
			verbs += /client/proc/toggleprayers
			verbs += /client/proc/editappear

		if (holder.level >= 2)//Admin Candidate********************************************************************
			verbs += /client/proc/cmd_admin_add_random_ai_law
			verbs += /client/proc/secrets
			verbs += /client/proc/play_sound
			verbs += /client/proc/stealth


		if (holder.level >= 1)//Temp Admin********************************************************************
			//verbs += /client/proc/cmd_admin_attack_log	//use view variables
			verbs += /client/proc/cmd_admin_check_contents
			verbs += /obj/admins/proc/delay					//game start delay
			verbs += /obj/admins/proc/immreboot				//immediate reboot
			verbs += /obj/admins/proc/restart				//restart
			verbs += /client/proc/cmd_admin_create_centcom_report
			verbs += /client/proc/toggle_hear_deadcast
			verbs += /client/proc/toggle_hear_radio
			verbs += /client/proc/cmd_admin_change_custom_event

		if (holder.level >= 0)//Mod********************************************************************
			verbs += /obj/admins/proc/toggleAI				//Toggle the AI
			verbs += /obj/admins/proc/toggleenter			//Toggle enterting
//			verbs += /obj/admins/proc/toggleguests			//Toggle guests entering
			verbs += /obj/admins/proc/toggleooc				//toggle ooc
			verbs += /obj/admins/proc/toggleoocdead         //toggle ooc for dead/unc
			verbs += /obj/admins/proc/voteres 				//toggle votes
			verbs += /client/proc/deadchat					//toggles deadchat
			verbs += /client/proc/cmd_admin_mute
			verbs += /client/proc/cmd_admin_pm
			verbs += /client/proc/cmd_admin_subtle_message
			verbs += /client/proc/warn
			verbs += /obj/admins/proc/announce
			verbs += /obj/admins/proc/startnow
			verbs += /client/proc/dsay
			verbs += /client/proc/admin_play
			verbs += /client/proc/admin_observe
			verbs += /client/proc/game_panel
//			verbs += /client/proc/player_panel
			verbs += /client/proc/player_panel_new
			verbs += /client/proc/unban_panel
			verbs += /client/proc/jobbans
			verbs += /client/proc/playernotes
			verbs += /obj/admins/proc/show_skills
			verbs += /obj/admins/proc/vmode
			verbs += /obj/admins/proc/votekill
			verbs += /client/proc/voting
			verbs += /obj/admins/proc/show_player_panel
			//verbs += /client/proc/cmd_admin_prison --in player panel
			//verbs += /obj/admins/proc/unprison  --in player panel
			verbs += /client/proc/hide_verbs
			verbs += /client/proc/general_report
			verbs += /client/proc/air_report


		if (holder.level >= -1)//Admin Observer
			verbs += /client/proc/cmd_admin_say
			verbs += /client/proc/cmd_admin_gib_self

		if (holder.level == -3)//Retired Admin, skips banned
			verbs += /client/proc/cmd_admin_say


/client/proc/clear_admin_verbs()
	deadchat = 0

	verbs -= /client/proc/hide_verbs
	verbs -= /client/proc/hide_most_verbs
	verbs -= /client/proc/show_verbs
	verbs -= /client/proc/colorooc
	verbs -= /obj/admins/proc/toggle_aliens			//toggle aliens
	verbs -= /obj/admins/proc/toggle_space_ninja	//toggle ninjas
	verbs -= /obj/admins/proc/adjump
	verbs -= /client/proc/triple_ai
	verbs -= /client/proc/get_admin_state
	verbs -= /client/proc/reload_admins
	verbs -= /client/proc/kill_air
	verbs -= /client/proc/cmd_debug_make_powernets
	verbs -= /client/proc/object_talk
	verbs -= /client/proc/strike_team
	verbs -= /obj/admins/proc/view_txt_log
	//verbs -= /client/proc/cmd_mass_modify_object_variables  --Merged with view variables
	verbs -= /client/proc/cmd_admin_list_open_jobs
	verbs -= /client/proc/cmd_admin_direct_narrate
	verbs -= /client/proc/cmd_admin_world_narrate
	verbs -= /client/proc/callproc
	verbs -= /client/proc/Cell
	verbs -= /client/proc/cmd_debug_del_all
	verbs -= /client/proc/cmd_debug_tog_aliens
	verbs -= /client/proc/ticklag
	verbs -= /client/proc/mapload
	verbs -= /obj/admins/proc/spawn_atom
	verbs -= /client/proc/check_words
	verbs -= /client/proc/drop_bomb
	//verbs -= /client/proc/give_spell --moved to view variables
	//verbs -= /client/proc/cmd_admin_ninjafy --now in view vars
	verbs -= /client/proc/cmd_admin_grantfullaccess
	//verbs -= /client/proc/cmd_admin_explosion		--now in view vars
	//verbs -= /client/proc/cmd_admin_emp			--now in view vars
	verbs -= /client/proc/cmd_admin_drop_everything
	verbs -= /client/proc/make_sound
	verbs -= /client/proc/only_one
	verbs -= /client/proc/send_space_ninja
	verbs -= /obj/admins/proc/adrev					//toggle admin revives
	verbs -= /obj/admins/proc/adspawn				//toggle admin item spawning
	verbs -= /obj/admins/proc/toggleaban			//abandon mob
	verbs -= /client/proc/debug_variables
	//verbs -= /client/proc/cmd_modify_object_variables --merged with view variables
	verbs -= /client/proc/cmd_modify_ticker_variables
	verbs -= /client/proc/Debug2					//debug toggle switch
	verbs -= /client/proc/toggle_view_range
	verbs -= /client/proc/Getmob
	verbs -= /client/proc/Getkey
	verbs -= /client/proc/sendmob
	verbs -= /client/proc/Jump
	verbs -= /client/proc/jumptokey
	verbs -= /client/proc/jumptomob
	verbs -= /client/proc/jumptoturf
	verbs -= /client/proc/cmd_admin_add_freeform_ai_law
	verbs -= /client/proc/cmd_admin_add_random_ai_law
	//verbs -= /client/proc/cmd_admin_godmode		--now in view variables
	verbs -= /client/proc/cmd_admin_rejuvenate
	//verbs -= /client/proc/cmd_admin_gib --view vars menu
	verbs -= /client/proc/cmd_admin_delete
	//verbs -= /proc/togglebuildmode --now in view vars
	verbs -= /client/proc/toggleadminhelpsound
	verbs -= /client/proc/togglebuildmodeself
	verbs -= /client/proc/cmd_admin_remove_plasma
	verbs -= /client/proc/admin_call_shuttle
	verbs -= /client/proc/admin_cancel_shuttle
	verbs -= /client/proc/admin_deny_shuttle
	verbs -= /obj/admins/proc/show_traitor_panel
	verbs -= /client/proc/cmd_admin_dress
	verbs -= /client/proc/cmd_admin_christmas
	verbs -= /client/proc/respawn_character
	verbs -= /client/proc/spawn_xeno
	verbs -= /proc/possess
	verbs -= /proc/release
	verbs -= /client/proc/cmd_admin_add_random_ai_law
	verbs -= /client/proc/secrets
	verbs -= /client/proc/play_sound
	verbs -= /client/proc/stealth
	//verbs -= /client/proc/cmd_admin_attack_log	//use view variables
	verbs -= /client/proc/cmd_admin_check_contents
	verbs -= /obj/admins/proc/delay					//game start delay
	verbs -= /obj/admins/proc/immreboot				//immediate reboot
	verbs -= /obj/admins/proc/restart				//restart
	verbs -= /client/proc/cmd_admin_create_centcom_report
	verbs -= /obj/admins/proc/toggleAI				//Toggle the AI
	verbs -= /obj/admins/proc/toggleenter			//Toggle enterting
//	verbs -= /obj/admins/proc/toggleguests			//Toggle guests entering
	verbs -= /obj/admins/proc/toggleooc				//toggle ooc
	verbs -= /obj/admins/proc/toggleoocdead         //toggle ooc for dead/unc
	verbs -= /obj/admins/proc/voteres 				//toggle votes
	verbs -= /client/proc/deadchat					//toggles deadchat
	verbs -= /client/proc/cmd_admin_mute
	verbs -= /client/proc/cmd_admin_pm
	verbs -= /client/proc/cmd_admin_say
	verbs -= /client/proc/cmd_admin_subtle_message
	verbs -= /client/proc/warn
	verbs -= /obj/admins/proc/announce
	verbs -= /obj/admins/proc/startnow
	verbs -= /client/proc/dsay
	verbs -= /client/proc/admin_play
	verbs -= /client/proc/admin_observe
	verbs -= /client/proc/game_panel
//	verbs -= /client/proc/player_panel
	verbs -= /client/proc/player_panel_new
	verbs -= /client/proc/unban_panel
	verbs -= /client/proc/jobbans
	verbs -= /client/proc/playernotes
	verbs -= /obj/admins/proc/show_skills
	verbs -= /obj/admins/proc/vmode
	verbs -= /obj/admins/proc/votekill
	verbs -= /client/proc/voting
	verbs -= /obj/admins/proc/show_player_panel
	//verbs -= /client/proc/cmd_admin_prison --in player panel
	//verbs -= /obj/admins/proc/unprison --in player panel
	verbs -= /client/proc/hide_verbs
	verbs -= /client/proc/general_report
	verbs -= /client/proc/air_report
	verbs -= /client/proc/cmd_admin_say
	verbs -= /client/proc/cmd_admin_gib_self
	verbs -= /client/proc/restartcontroller
	verbs -= /client/proc/play_local_sound
	verbs -= /client/proc/enable_mapping_debug
	verbs -= /client/proc/toggleprayers
	verbs -= /client/proc/editappear
	verbs -= /client/proc/jump_to_dead_group
	verbs -= /client/proc/Blobize
	verbs -= /client/proc/toggle_clickproc //TODO ERRORAGE (Temporary proc while the enw clickproc is being tested)
	verbs -= /client/proc/toggle_hear_deadcast
	verbs -= /client/proc/toggle_hear_radio
	verbs -= /client/proc/tension_report
	verbs -= /client/proc/toggle_gravity_on
	verbs -= /client/proc/toggle_gravity_off
	verbs -= /client/proc/cmd_admin_change_custom_event
	verbs -= /client/proc/admin_invis
	verbs -= /client/proc/callprocgen
	verbs -= /client/proc/callprocobj
	verbs -= /client/proc/cmd_admin_godmode
	verbs -= /client/proc/delbook
	verbs -= /client/proc/Force_Event_admin
	verbs -= /client/proc/radioalert
	verbs -= /client/proc/rnd_check_designs
	verbs -= /client/proc/make_tajaran
	verbs -= /client/proc/CarbonCopy

	return


/client/proc/admin_observe()
	set category = "Admin"
	set name = "Set Observe"
	if(!holder)
		alert("You are not an admin")
		return

	verbs -= /client/proc/admin_play
	spawn( 1200 )
		verbs += /client/proc/admin_play
	var/rank = holder.rank
	clear_admin_verbs()
	holder.state = 2
	update_admins(rank)
	if(!istype(mob, /mob/dead/observer))
		mob.admin_observing = 1
		mob.adminghostize(1)
	src << "\blue You are now observing"

/client/proc/admin_play()
	set category = "Admin"
	set name = "Set Play"
	if(!holder)
		alert("You are not an admin")
		return
	verbs -= /client/proc/admin_observe
	spawn( 1200 )
		verbs += /client/proc/admin_observe
	var/rank = holder.rank
	clear_admin_verbs()
	holder.state = 1
	update_admins(rank)
	if(istype(mob, /mob/dead/observer))
		mob:reenter_corpse()
	src << "\blue You are now playing"

/client/proc/get_admin_state()
	set name = "Get Admin State"
	set category = "Debug"
	for(var/mob/M in world)
		if(M.client && M.client.holder)
			if(M.client.holder.state == 1)
				src << "[M.key] is playing - [M.client.holder.state]"
			else if(M.client.holder.state == 2)
				src << "[M.key] is observing - [M.client.holder.state]"
			else
				src << "[M.key] is undefined - [M.client.holder.state]"


///client/proc/player_panel()
//	set name = "Player Panel-Old"
//	set category = "Admin"
//	if(holder)
//		holder.player_panel_old()
//	return

/client/proc/player_panel_new()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()
	return

/client/proc/jobbans()
	set name = "Unjobban Panel"
	set category = "Admin"
	if(holder)
		holder.Jobbans()
	return

/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin"
	if(holder)
		holder.PlayerNotes()
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if (holder)
		holder.unbanpanel()
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if (holder)
		holder.Game()
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	return

/client/proc/voting()
	set name = "Voting"
	set category = "Admin"
	if (holder)
		holder.Voting()

/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	return

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(!holder)
		src << "Only administrators may use this command."
		return
	stealth = !stealth
	if(stealth)
		var/new_key = trim(input("Enter your desired display name.", "Fake Key", key))
		if(!new_key)
			stealth = 0
			return
		new_key = strip_html(new_key)
		if(length(new_key) >= 26)
			new_key = copytext(new_key, 1, 26)
		fakekey = new_key
	else
		fakekey = null
	log_admin("[key_name(usr)] has turned stealth mode [stealth ? "ON" : "OFF"]")
	message_admins("[key_name_admin(usr)] has turned stealth mode [stealth ? "ON" : "OFF"]", 1)

#define AUTOBANTIME 10
/client/proc/warn(var/mob/M in world)
	set category = "Special Verbs"
	set name = "Warn"
	// If you've edited AUTOBANTIME, change the below desc.
	set desc = "Warn a player. If player is already warned, they will be autobanned for 10 minutes."
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(M.client && M.client.holder && (M.client.holder.level >= holder.level))
		alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
		return
	if(!M.client.warned)
		M << "\red <B>You have been warned by an administrator. This is the only warning you will recieve.</B>"
		M.client.warned = 1
		message_admins("\blue [ckey] warned [M.ckey].")
	else
		AddBan(M.ckey, M.computer_id, "Autobanning due to previous warn", ckey, 1, AUTOBANTIME)
		M << "\red<BIG><B>You have been autobanned by [ckey]. This is what we in the biz like to call a \"second warning\".</B></BIG>"
		M << "\red This is a temporary ban; it will automatically be removed in [AUTOBANTIME] minutes."
		log_admin("[ckey] warned [M.ckey], resulting in a [AUTOBANTIME] minute autoban.")
		ban_unban_log_save("[ckey] warned [M.ckey], resulting in a [AUTOBANTIME] minute autoban.")
		message_admins("\blue [ckey] warned [M.ckey], resulting in a [AUTOBANTIME] minute autoban.")
		feedback_inc("ban_warn",1)

		del(M.client)


/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as num
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as num
			var/light_impact_range = input("Light impact range (in tiles):") as num
			var/flash_range = input("Flash range (in tiles):") as num
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("\blue [ckey] creating an admin explosion at [epicenter.loc].")

/client/proc/give_spell(mob/T as mob in world) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/obj/effect/proc_holder/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S) return
	T.spell_list += new S

/client/proc/make_sound(var/obj/O in world) // -- TLE
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = input("What do you want the message to be?", "Make Sound") as text|null
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(message, 2)

/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)

/client/proc/toggleadminhelpsound()
	set name = "Toggle Adminhelp Sound"
	set category = "Admin"
	sound_adminhelp = !sound_adminhelp
	if(sound_adminhelp)
		usr << "You will now hear a sound when adminhelps arrive"
	else
		usr << "You will no longer hear a sound when adminhelps arrive"

/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)

/client/proc/kill_air() // -- TLE
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"
	if(kill_air)
		kill_air = 0
		usr << "<b>Enabled air processing.</b>"
	else
		kill_air = 1
		usr << "<b>Disabled air processing.</b>"

/client/proc/show_verbs()
	set name = "Toggle admin verb visibility"
	set category = "Admin"
	src << "Restoring admin verbs back"

	var/temp = deadchat
	clear_admin_verbs()
	update_admins(holder.rank)
	deadchat = temp

/client/proc/toggle_clickproc() //TODO ERRORAGE (This is a temporary verb here while I test the new clicking proc)
	set name = "Toggle NewClickProc"
	set category = "Admin"

	if(!holder) return
	using_new_click_proc = !using_new_click_proc
	world << "Testing of new click proc [using_new_click_proc ? "enabled" : "disabled"]"

/client/proc/toggle_hear_deadcast()
	set name = "Toggle Hear Deadcast"
	set category = "Admin"

	if(!holder) return
	STFU_ghosts = !STFU_ghosts
	usr << "You will now [STFU_ghosts ? "hear" : "not hear"] ghosts"

/client/proc/toggle_hear_radio()
	set name = "Toggle Hear Radio"
	set category = "Admin"

	if(!holder) return
	STFU_radio = !STFU_radio
	usr << "You will now [STFU_radio ? "hear" : "not hear"] radio chatter from nearby radios or speakers"

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Toggle most admin verb visibility"
	set category = "Admin"
	src << "Hiding most admin verbs"

	var/temp = deadchat
	clear_admin_verbs()
	deadchat = temp
	verbs -= /client/proc/hide_verbs
	verbs -= /client/proc/hide_most_verbs
	verbs += /client/proc/show_verbs

	if(holder.level >= 6)//Game Master********************************************************************
		verbs += /client/proc/colorooc

	if(holder.level >= 4)//Badmin********************************************************************
		verbs += /client/proc/debug_variables
		//verbs += /client/proc/cmd_modify_object_variables --merged with view vairiables
		verbs += /client/proc/Jump
		verbs += /client/proc/jumptoturf
		verbs += /client/proc/togglebuildmodeself

	verbs += /client/proc/dsay
	verbs += /client/proc/admin_play
	verbs += /client/proc/admin_observe
	verbs += /client/proc/game_panel
//	verbs += /client/proc/player_panel
	verbs += /client/proc/cmd_admin_subtle_message
	verbs += /client/proc/cmd_admin_pm
	verbs += /client/proc/cmd_admin_gib_self
	verbs += /client/proc/admin_invis

	verbs += /client/proc/deadchat					//toggles deadchat
	verbs += /obj/admins/proc/toggleooc				//toggle ooc
	verbs += /client/proc/cmd_admin_say//asay
	verbs += /client/proc/toggleadminhelpsound
	return


/client/proc/hide_verbs()
	set name = "Toggle admin verb visibility"
	set category = "Admin"
	src << "Hiding almost all admin verbs"

	var/temp = deadchat
	clear_admin_verbs()
	deadchat = temp
	verbs -= /client/proc/hide_verbs
	verbs -= /client/proc/hide_most_verbs
	verbs += /client/proc/show_verbs

	verbs += /client/proc/deadchat					//toggles deadchat
	verbs += /obj/admins/proc/toggleooc				//toggle ooc
	verbs += /client/proc/cmd_admin_say//asay
	return

/client/proc/admin_invis()
	set category = "Admin"
	set name = "Invisibility"
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	src.admin_invis =! src.admin_invis
	if(src.mob)
		var/mob/m = src.mob//probably don't need this cast, but I'm too lazy to check if /client.mob is of type /mob or not
		m.update_clothing()
	log_admin("[key_name(usr)] has turned their invisibility [src.admin_invis ? "ON" : "OFF"]")
	message_admins("[key_name_admin(usr)] has turned their invisibility [src.admin_invis ? "ON" : "OFF"]", 1)

/client/proc/cmd_admin_godmode(mob/M as mob in world)
	set category = "Admin"
	set name = "Toggle Godmode"
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	if (M.nodamage == 1)
		M.nodamage = 0
		usr << "\blue Toggled OFF"
	else
		M.nodamage = 1
		usr << "\blue Toggled ON"

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.nodamage ? "On" : "Off")]")
	message_admins("[key_name_admin(usr)] has toggled [key_name_admin(M)]'s nodamage to [(M.nodamage ? "On" : "Off")]", 1)

/client/proc/editappear(mob/living/carbon/human/M as mob in world)
	set name = "Edit Appearance"
	set category = "Fun"
	if(!istype(M, /mob/living/carbon/human))
		usr << "\red You can only do this to humans!"
		return
	switch(alert("You sure you wish to edit this mob's appearance?",,"Yes","No"))
		if("No")
			return
	if(istype(M,/mob/living/carbon/human/tajaran))
		usr << "\red Tajarans do not have an editable appearance... yet!"
	else
		var/new_facial = input("Please select facial hair color.", "Character Generation") as color
		if(new_facial)
			M.r_facial = hex2num(copytext(new_facial, 2, 4))
			M.g_facial = hex2num(copytext(new_facial, 4, 6))
			M.b_facial = hex2num(copytext(new_facial, 6, 8))

		var/new_hair = input("Please select hair color.", "Character Generation") as color
		if(new_facial)
			M.r_hair = hex2num(copytext(new_hair, 2, 4))
			M.g_hair = hex2num(copytext(new_hair, 4, 6))
			M.b_hair = hex2num(copytext(new_hair, 6, 8))

		var/new_eyes = input("Please select eye color.", "Character Generation") as color
		if(new_eyes)
			M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

		var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

		if (new_tone)
			M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
			M.s_tone =  -M.s_tone + 35

		// hair
		var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
		var/list/hairs = list()

		// loop through potential hairs
		for(var/x in all_hairs)
			var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
			hairs.Add(H.name) // add hair name to hairs
			del(H) // delete the hair after it's all done

		var/new_style = input("Please select hair style", "Character Generation")  as null|anything in hairs

		// if new style selected (not cancel)
		if (new_style)
			M.h_style = new_style

			for(var/x in all_hairs) // loop through all_hairs again. Might be slightly CPU expensive, but not significantly.
				var/datum/sprite_accessory/hair/H = new x // create new hair datum
				if(H.name == new_style)
					M.hair_style = H // assign the hair_style variable a new hair datum
					break
				else
					del(H) // if hair H not used, delete. BYOND can garbage collect, but better safe than sorry

		// facial hair
		var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
		var/list/fhairs = list()

		for(var/x in all_fhairs)
			var/datum/sprite_accessory/facial_hair/H = new x
			fhairs.Add(H.name)
			del(H)

		new_style = input("Please select facial style", "Character Generation")  as null|anything in fhairs

		if(new_style)
			M.f_style = new_style
			for(var/x in all_fhairs)
				var/datum/sprite_accessory/facial_hair/H = new x
				if(H.name == new_style)
					M.facial_hair_style = H
					break
				else
					del(H)

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	M.update_body()
	M.update_face()
	M.update_clothing()
	M.check_dna(M)


/client/proc/radioalert()
	set category = "Fun"
	set name = "Create Radio Alert"
	var/message = input("Choose a message! (Don't forget the \"says, \" or similar at the start.)", "Message") as text|null
	var/from = input("From whom? (Who's saying this?)", "From") as text|null
	if(message && from)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
		a.autosay(message,from)
		del(a)

/client/proc/CarbonCopy(atom/movable/O as mob|obj in world)
	set category = "Admin"
	var/atom/movable/NewObj = new O.type(usr.loc)
	for(var/V in O.vars)
		if (issaved(O.vars[V]))
			if(V == "contents")
				for(var/atom/movable/C in O.contents)
					C.CarbonCopy2(NewObj)
			else
				NewObj.vars[V] = O.vars[V]
	return NewObj

/atom/proc/CarbonCopy2(atom/movable/O as mob|obj in world)
	var/atom/movable/NewObj = new type(O)
	for(var/V in vars)
		if (issaved(vars[V]))
			if(V == "contents")
				for(var/atom/movable/C in contents)
					C.CarbonCopy2(NewObj)
			else
				NewObj.vars[V] = vars[V]
	return NewObj
