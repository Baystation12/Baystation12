//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/global/list/admin_verbs_default = list(
	// [SIERRA-ADD] - sierra-tweaks,
	/client/proc/getserverlog,
	// [/SIERRA-ADD],
	/datum/admins/proc/show_player_panel, //shows an interface for individual players, with various links (links require additional flags), right-click player panel,
	/client/proc/player_panel,
	/client/proc/secrets,
	/client/proc/deadmin_self,			//destroys our own admin datum so we can play as a regular player,
	/client/proc/hide_verbs,			//hides all our adminverbs,
	/client/proc/hide_most_verbs,		//hides all our hideable adminverbs,
	/client/proc/debug_variables,		//allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify,
	/client/proc/watched_variables,
//	/client/proc/check_antagonists,		//shows all antags,
	/client/proc/cmd_check_new_players
//	/client/proc/deadchat				//toggles deadchat on/off,
	)
var/global/list/admin_verbs_admin = list(
	/client/proc/invisimin,				//allows our mob to go invisible/visible,
//	/datum/admins/proc/show_traitor_panel,	//interface which shows a mob's mind, -Removed due to rare practical use. Moved to debug verbs ~Errorage,
	/datum/admins/proc/show_game_mode,  //Configuration window for the current game mode.,
	/datum/admins/proc/force_mode_latespawn, //Force the mode to try a latespawn proc,
	/datum/admins/proc/force_antag_latespawn, //Force a specific template to try a latespawn proc,
	/datum/admins/proc/toggleenter,		//toggles whether people can join the current game,
	/datum/admins/proc/toggleguests,	//toggles whether guests can join the current game,
	/datum/admins/proc/announce,		//priority announce something to all clients.,
	/client/proc/colorooc,				//allows us to set a custom colour for everythign we say in ooc,
	/client/proc/admin_ghost,			//allows us to ghost/reenter body at will,
	/client/proc/toggle_view_range,		//changes how far we can see,
	/client/proc/cmd_admin_pm_context,	//right-click adminPM interface,
	/client/proc/cmd_admin_pm_panel,	//admin-pm list,
	/client/proc/cmd_admin_delete,		//delete an instance/object/mob/etc,
	/client/proc/cmd_admin_check_contents,	//displays the contents of an instance,
	/datum/admins/proc/access_news_network,	//allows access of newscasters,
	/client/proc/jumptocoord,			//we ghost and jump to a coordinate,
	/client/proc/Getmob,				//teleports a mob to our location,
	/client/proc/Getkey,				//teleports a mob with a certain ckey to our location,
//	/client/proc/sendmob,				//sends a mob somewhere, -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage,
	/client/proc/Jump,
	/client/proc/jumptokey,				//allows us to jump to the location of a mob with a certain ckey,
	/client/proc/jumptomob,				//allows us to jump to a specific mob,
	/client/proc/jumptoturf,			//allows us to jump to a specific turf,
	/client/proc/admin_call_shuttle,	//allows us to call the emergency shuttle,
	/client/proc/admin_cancel_shuttle,	//allows us to cancel the emergency shuttle, sending it back to centcomm,
	/client/proc/cmd_admin_narrate,
	/client/proc/cmd_admin_direct_narrate,	//send text directly to a player with no padding. Useful for narratives and fluff-text,
	/client/proc/cmd_admin_visible_narrate,
	/client/proc/cmd_admin_audible_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/cmd_admin_world_narrate,	//sends text to all players with no padding,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/check_ai_laws,			//shows AI and borg laws,
	/client/proc/rename_silicon,		//properly renames silicons,
	/client/proc/manage_silicon_laws,	// Allows viewing and editing silicon laws. ,
	/client/proc/check_antagonists,
	/client/proc/admin_memo,			//admin memo system. show/delete/write. +SERVER needed to delete admin memos of others,
	/client/proc/dsay,					//talk in deadchat using our ckey
//	/client/proc/toggle_hear_deadcast,	//toggles whether we hear deadchat,
	/client/proc/investigate_show,		//various admintools for investigation. Such as a singulo grief-log,
	/datum/admins/proc/toggle_allowlists,
	/datum/admins/proc/toggleooc,		//toggles ooc on/off for everyone,
	/datum/admins/proc/toggleaooc,		//toggles aooc on/off for everyone,
	/datum/admins/proc/togglelooc,		//toggles looc on/off for everyone,
	/datum/admins/proc/toggleoocdead,	//toggles ooc on/off for everyone who is dead,
	/datum/admins/proc/toggledsay,		//toggles dsay on/off for everyone,
	/client/proc/game_panel,			//game panel, allows to change game-mode etc,
	/client/proc/cmd_admin_say,			//admin-only ooc chat,
	/datum/admins/proc/togglehubvisibility, //toggles visibility on the BYOND Hub,
	/datum/admins/proc/PlayerNotes,
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/free_slot_submap,
	/client/proc/close_slot_submap,
	/client/proc/free_slot_crew,
	/client/proc/close_slot_crew,			//frees slot for chosen job,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/toggleghostwriters,
	/client/proc/toggledrones,
	/datum/admins/proc/show_skills, //Right click skill menu,
	/client/proc/man_up,
	/client/proc/global_man_up,
	/client/proc/response_team, // Response Teams admin verb,
	/client/proc/toggle_antagHUD_use,
	/client/proc/toggle_antagHUD_restrictions,
	/client/proc/allow_character_respawn,    // Allows a ghost to respawn ,
	/client/proc/event_manager_panel,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/aooc,
	/client/proc/change_human_appearance_admin,	// Allows an admin to change the basic appearance of human-based mobs ,
	/client/proc/change_human_appearance_self,	// Allows the human-based mob itself change its basic appearance ,
	/client/proc/change_security_level,
	/client/proc/view_chemical_reaction_logs,
	/client/proc/makePAI,
	/client/proc/fixatmos,
	/client/proc/list_traders,
	/client/proc/add_trader,
	/client/proc/remove_trader,
	/datum/admins/proc/sendFax,
	/client/proc/check_fax_history,
	/client/proc/cmd_admin_notarget,
	/datum/admins/proc/SetRoundLength,
	/datum/admins/proc/ToggleContinueVote,
	/datum/admins/proc/togglemoderequirementchecks,
	/client/proc/delete_crew_record
)
var/global/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/jobbans
	)
var/global/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound
	)

var/global/list/admin_verbs_fun = list(
	/client/proc/object_talk,
	/datum/admins/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/toggle_random_events,
	/client/proc/editappear,
	/client/proc/roll_dices,
	/datum/admins/proc/call_supply_drop,
	/datum/admins/proc/call_drop_pod,
	/client/proc/create_dungeon,
	/client/proc/cmd_admin_simulate_distant_explosion,
	/datum/admins/proc/ai_hologram_set,
	/client/proc/bombard_zlevel,
	/client/proc/rename_shuttle
	)

var/global/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_fruit,
	/datum/admins/proc/spawn_fluid_verb,
	/datum/admins/proc/spawn_custom_item,
	/datum/admins/proc/check_custom_items,
	/datum/admins/proc/spawn_plant,
	/datum/admins/proc/spawn_atom,		// allows us to spawn instances,
	/datum/admins/proc/spawn_artifact,
	/client/proc/spawn_chemdisp_cartridge,
	// [SIERRA-ADD] - CLIENT_VERBS - ,
	/client/proc/respawn_as_self,
	// [/SIERRA-ADD] - CLIENT_VERBS ,
	/datum/admins/proc/mass_debug_closet_icons
	)
var/global/list/admin_verbs_server = list(
	/datum/admins/proc/capture_map_part,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/endnow,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/datum/admins/proc/immreboot,
	/client/proc/cmd_admin_delete,		// delete an instance/object/mob/etc,
	/client/proc/cmd_debug_del_all,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/client/proc/toggle_random_events,
	/client/proc/nanomapgen_DumpImage
	)
var/global/list/admin_verbs_debug = list(
	/datum/admins/proc/jump_to_fluid_source,
	/datum/admins/proc/jump_to_fluid_active,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/ZASSettings,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/debug_antagonist_template,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/air_report,
	/client/proc/reload_admins,
	/client/proc/restart_controller,
	/client/proc/print_random_map,
	/client/proc/create_random_map,
	/client/proc/apply_random_map,
	/client/proc/overlay_random_map,
	/client/proc/delete_random_map,
	/datum/admins/proc/map_template_load,
	/datum/admins/proc/map_template_load_new_z,
	/datum/admins/proc/map_template_upload,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/SDQL_query,
	/client/proc/SDQL2_query,
	/client/proc/Jump,
	/client/proc/jumptomob,
	/client/proc/jumptocoord,
	/client/proc/dsay,
	/datum/admins/proc/run_unit_test,
	/turf/proc/view_chunk,
	/turf/proc/update_chunk,
	/datum/admins/proc/capture_map,
	/datum/admins/proc/view_runtimes,
	/client/proc/cmd_analyse_health_context,
	/client/proc/cmd_analyse_health_panel,
	/client/proc/visualpower,
	/client/proc/visualpower_remove,
	/client/proc/ping_webhook,
	/client/proc/reload_webhooks,
	/client/proc/toggle_planet_repopulating,
	/client/proc/spawn_exoplanet,
	/client/proc/profiler_start
	)

var/global/list/admin_verbs_paranoid_debug = list(
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/debug_controller
	)

var/global/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/global/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)
var/global/list/admin_verbs_rejuv = list(
	)

//verbs which can be hidden - needs work
var/global/list/admin_verbs_hideable = list(
	/client/proc/deadmin_self,
//	/client/proc/deadchat,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/client/proc/colorooc,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/cmd_admin_narrate,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_visible_narrate,
	/client/proc/cmd_admin_audible_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound,
	/client/proc/object_talk,
	/datum/admins/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/toggle_random_events,
	/client/proc/cmd_admin_simulate_distant_explosion,
	/client/proc/cmd_admin_add_random_ai_law,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/endnow,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/datum/admins/proc/immreboot,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/startSinglo,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/client/proc/roll_dices,
	/proc/possess,
	/proc/release,
	/client/proc/cmd_admin_notarget
	)
var/global/list/admin_verbs_mod = list(
	/client/proc/cmd_admin_pm_context,	// right-click adminPM interface,
	/client/proc/cmd_admin_pm_panel,	// admin-pm list,
	/client/proc/debug_variables,		// allows us to -see- the variables of any instance in the game.,
	/client/proc/watched_variables,
	/datum/admins/proc/PlayerNotes,
	/client/proc/admin_ghost,			// allows us to ghost/reenter body at will,
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/dsay,
	/datum/admins/proc/show_skills,	// Right-click skill menu,
	/datum/admins/proc/show_player_panel,// right-click player panel,
	/client/proc/check_antagonists,
	/client/proc/cmd_admin_narrate,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_visible_narrate,
	/client/proc/cmd_admin_audible_narrate,
	/client/proc/cmd_admin_local_narrate,	//sends text to all players with no padding,
	/client/proc/aooc,
	/datum/admins/proc/sendFax,
	/client/proc/check_fax_history,
	/datum/admins/proc/paralyze_mob // right-click paralyze ,
)

/client/proc/add_admin_verbs()
	if(holder)
		verbs += admin_verbs_default
		if(holder.rights & R_BUILDMODE)		verbs += /client/proc/togglebuildmodeself
		if(holder.rights & R_ADMIN)			verbs += admin_verbs_admin
		if(holder.rights & R_BAN)			verbs += admin_verbs_ban
		if(holder.rights & R_FUN)			verbs += admin_verbs_fun
		if(holder.rights & R_SERVER)		verbs += admin_verbs_server
		if(holder.rights & R_DEBUG)
			verbs += admin_verbs_debug
			if(config.debugparanoid && !(holder.rights & R_ADMIN))
				verbs.Remove(admin_verbs_paranoid_debug)			//Right now it's just callproc but we can easily add others later on.
		if(holder.rights & R_POSSESS)		verbs += admin_verbs_possess
		if(holder.rights & R_PERMISSIONS)	verbs += admin_verbs_permissions
		if(holder.rights & R_STEALTH)		verbs += /client/proc/stealth
		if(holder.rights & R_REJUVINATE)	verbs += admin_verbs_rejuv
		if(holder.rights & R_SOUNDS)		verbs += admin_verbs_sounds
		if(holder.rights & R_SPAWN)			verbs += admin_verbs_spawn
		if(holder.rights & R_MOD)			verbs += admin_verbs_mod

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		debug_verbs
		)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	to_chat(src, SPAN_CLASS("interface", "Most of your adminverbs have been hidden."))
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	to_chat(src, SPAN_CLASS("interface", "Almost all of your adminverbs have been hidden."))
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	to_chat(src, SPAN_CLASS("interface", "All of your adminverbs are now visible."))





/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(isghost(mob))
		var/mob/observer/ghost/ghost = mob
		sound_to(usr, sound(null))
		ghost.reenter_corpse()

	else if(istype(mob,/mob/new_player))
		to_chat(src, SPAN_COLOR("red", "Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first."))
	else
		//ghostize
		var/mob/body = mob
		var/mob/observer/ghost/ghost = body.ghostize(1)
		sound_to(usr, sound(null))

		if (!ghost)
			to_chat(src, SPAN_COLOR("red", "You are already admin-ghosted."))
			return
		ghost.admin_ghosted = 1
		if(body)
			body.teleop = ghost
			if(!body.key)
				body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus


/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.set_invisibility(initial(mob.invisibility))
			to_chat(mob, SPAN_DANGER("Invisimin off. Invisibility reset."))
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.set_invisibility(INVISIBILITY_OBSERVER)
			to_chat(mob, SPAN_NOTICE("Invisimin on. You are now as invisible as a ghost."))
			mob.alpha = max(mob.alpha - 100, 0)


/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel()
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
	return

/client/proc/jobbans()
	set name = "Display Job bans"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.Jobbans()
		else
			holder.DB_ban_panel()
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	return

/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	if(!holder)	return
	var/response = alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change own OOC color", "Pick new color", "Reset to default", "Cancel")
	if(response == "Pick new color")
		prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		prefs.ooccolor = initial(prefs.ooccolor)
	SScharacter_setup.queue_preferences_save(prefs)
	return


/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))
		return
	if(!warned_ckey || !istext(warned_ckey))
		return
	if(warned_ckey in admin_datums)
		to_chat(usr, SPAN_COLOR("red", "Error: warn(): You can't warn admins."))
		return
	var/datum/preferences/D
	var/client/C = GLOB.ckey_directory[warned_ckey]
	if(C)
		D = C.prefs
	else
		D = SScharacter_setup.preferences_datums[warned_ckey]
	if(!D)
		to_chat(src, SPAN_COLOR("red", "Error: warn(): No such ckey found."))
		return
	++D.warns
	if (config.warn_autoban_threshold && D.warns >= config.warn_autoban_threshold)
		var/mins_readable = time_to_readable(config.warn_autoban_duration MINUTES)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [mins_readable] autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [mins_readable] ban.")
			to_chat(C, SPAN_COLOR("red", "<BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [mins_readable]."))
			qdel(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [mins_readable] ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, config.warn_autoban_duration)
	else
		if(C)
			to_chat(C, SPAN_COLOR("red", "<BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban."))
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [config.warn_autoban_threshold - D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [config.warn_autoban_threshold - D.warns] strikes remaining.")


/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") as null | anything in choices
	switch(choice)
		if (null)
			return
		if("Small Bomb")
			explosion(epicenter, 6)
		if("Medium Bomb")
			explosion(epicenter, 9)
		if("Big Bomb")
			explosion(epicenter, 15)
		if("Custom Bomb")
			var/range = input("Explosion radius (in tiles):") as num|null
			if (isnull(range) || range <= 0)
				return
			var/max_power_input = input("Maximum explosion power:") as null|anything in list("Devastating", "Heavy", "Light")
			if (isnull(max_power_input))
				return
			var/max_power
			switch (max_power_input)
				if ("Devastating")
					max_power = EX_ACT_DEVASTATING
				if ("Heavy")
					max_power = EX_ACT_HEAVY
				if ("Light")
					max_power = EX_ACT_LIGHT
			explosion(epicenter, range, max_power)
	log_and_message_admins("created an admin explosion at [epicenter.loc].")

/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"

	if(!check_rights(R_ADMIN))
		return

	if(!usr.RemoveClickHandler(/datum/click_handler/build_mode))
		usr.PushClickHandler(/datum/click_handler/build_mode)

/client/proc/object_talk(msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)

/client/proc/readmin_self()
	set name = "Re-Admin self"
	set category = "Admin"

	if(deadmin_holder)
		deadmin_holder.reassociate()
		log_admin("[src] re-admined themself.")
		message_admins("[src] re-admined themself.", 1)
		to_chat(src, SPAN_CLASS("interface", "You now have the keys to control the planet, or at least [GLOB.using_map.full_name]."))
		verbs -= /client/proc/readmin_self

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can re-admin yourself at any time.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			to_chat(src, SPAN_CLASS("interface", "You are now a normal player."))
			verbs |= /client/proc/readmin_self

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.log_hrefs)
			config.log_hrefs = 0
			to_chat(src, "<b>Stopped logging hrefs</b>")
		else
			config.log_hrefs = 1
			to_chat(src, "<b>Started logging hrefs</b>")

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/rename_silicon()
	set name = "Rename Silicon"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Rename Silicon.") as null|anything in GLOB.silicon_mobs
	if(!S) return

	var/new_name = sanitizeSafe(input(src, "Enter new name. Leave blank or as is to cancel.", "[S.real_name] - Enter new silicon name", S.real_name))
	if(new_name && new_name != S.real_name)
		log_and_message_admins("has renamed the silicon '[S.real_name]' to '[new_name]'")
		S.fully_replace_character_name(new_name)

/client/proc/manage_silicon_laws()
	set name = "Manage Silicon Laws"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Manage Silicon Laws") as null|anything in GLOB.silicon_mobs
	if(!S) return

	var/datum/nano_module/law_manager/L = new(S)
	L.ui_interact(usr, state = GLOB.admin_state)
	log_and_message_admins("has opened [S]'s law manager.")

/client/proc/change_human_appearance_admin()
	set name = "Change Mob Appearance - Admin"
	set desc = "Allows you to change the mob appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Admin") as null|anything in GLOB.human_mobs
	if(!H) return

	log_and_message_admins("is altering the appearance of [H].")
	H.change_appearance(APPEARANCE_ALL, usr, state = GLOB.admin_state)

/client/proc/change_human_appearance_self()
	set name = "Change Mob Appearance - Self"
	set desc = "Allows the mob to change its appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Self") as null|anything in GLOB.human_mobs
	if(!H) return

	if(!H.client)
		to_chat(usr, "Only mobs with clients can alter their own appearance.")
		return

	switch(alert("Do you wish for [H] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel"))
		if("Yes")
			log_and_message_admins("has allowed [H] to change \his appearance, ignoring allow lists.")
			H.change_appearance(APPEARANCE_COMMON | APPEARANCE_SKIP_ALLOW_LIST_CHECK)
		if("No")
			log_and_message_admins("has allowed [H] to change \his appearance, respecting allow lists.")
			H.change_appearance(APPEARANCE_COMMON)

/client/proc/change_security_level()
	set name = "Set security level"
	set desc = "Sets the security level"
	set category = "Admin"

	if(!check_rights(R_ADMIN))	return

	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)

	var/singleton/security_level/new_security_level = input(usr, "It's currently [security_state.current_security_level.name].", "Select Security Level")  as null|anything in (security_state.all_security_levels - security_state.current_security_level)
	if(!new_security_level)
		return

	if(alert("Switch from [security_state.current_security_level.name] to [new_security_level.name]?","Change security level?","Yes","No") == "Yes")
		security_state.set_security_level(new_security_level, TRUE)


//---- bs12 verbs ----


/client/proc/editappear()
	set name = "Edit Appearance"
	set category = "Fun"

	if(!check_rights(R_FUN))	return

	var/mob/living/carbon/human/M = input("Select mob.", "Edit Appearance") as null|anything in GLOB.human_mobs

	if(!istype(M, /mob/living/carbon/human))
		to_chat(usr, SPAN_WARNING("You can only do this to humans!"))
		return
	switch(alert("Are you sure you wish to edit this mob's appearance? Skrell, Unathi and Vox can result in unintended consequences.",,"Yes","No"))
		if("No")
			return
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.facial_hair_color = new_facial

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_hair)
		M.head_hair_color = new_hair

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.eye_color = new_eyes
		M.update_eyes()

	var/new_skin = input("Please select body color. This is for Unathi, and Skrell only!", "Character Generation") as color
	if(new_skin)
		M.skin_color = new_skin

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

	if (new_tone)
		M.skin_tone = max(min(round(text2num(new_tone)), 220), 1)
		M.skin_tone =  -M.skin_tone + 35

	// hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in GLOB.hair_styles_list
	if(new_hstyle)
		M.head_hair_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in GLOB.facial_hair_styles_list
	if(new_fstyle)
		M.facial_hair_style = new_fstyle

	var/new_gender = input(usr, "Please select a bodytype", "Character Generation") as null|anything in all_genders_text_list
	switch(new_gender)
		if("Male")
			M.gender = MALE
		if ("Female")
			M.gender = FEMALE
		if ("Neuter")
			M.gender = NEUTER
		if ("Plural")
			M.gender = PLURAL

	M.update_hair()
	M.update_body()
	M.check_dna(M)

/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin"
	if(holder)
		holder.PlayerNotes()
	return

/client/proc/free_slot_submap()
	set name = "Free Job Slot (Submap)"
	set category = "Admin"
	if(!holder) return

	var/list/jobs = list()
	for(var/thing in SSmapping.submaps)
		var/datum/submap/submap = thing
		for(var/otherthing in submap.jobs)
			var/datum/job/submap/job = submap.jobs[otherthing]
			if(!job.is_position_available())
				jobs["[job.title] - [submap.name]"] = job

	if(!LAZYLEN(jobs))
		to_chat(usr, "There are no fully staffed offsite jobs.")
		return

	var/job_name = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
	if(job_name)
		var/datum/job/submap/job = jobs[job_name]
		if(istype(job) && !job.is_position_available())
			job.make_position_available()
			message_admins("An offsite job slot for [job_name] has been opened by [key_name_admin(usr)]")

/client/proc/close_slot_submap()
	set name = "Close Job Slot (Submap)"
	set category = "Admin"
	if(!holder) return

	var/list/jobs = list()
	for(var/thing in SSmapping.submaps)
		var/datum/submap/submap = thing
		for(var/otherthing in submap.jobs)
			var/datum/job/submap/job = submap.jobs[otherthing]
			if(job.is_position_available())
				jobs["[job.title] - [submap.name]"] = job

	var/job_name = input("Please select job slot to close", "Close job slot")  as null|anything in jobs
	if(job_name)
		var/datum/job/submap/job = jobs[job_name]
		if(istype(job) && job.is_position_available())
			job.make_position_unavailable()
			log_and_message_admins("has closed an offsite job slot for [job_name]")

/client/proc/free_slot_crew()
	set name = "Free Job Slot (Crew)"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in SSjobs.primary_job_datums)
			if(!J.is_position_available())
				jobs[J.title] = J
		if (!length(jobs))
			to_chat(usr, "There are no fully staffed jobs.")
			return
		var/job_title = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		var/datum/job/job = jobs[job_title]
		if(job && !job.is_position_available())
			job.make_position_available()
			message_admins("A job slot for [job_title] has been opened by [key_name_admin(usr)]")
			return

/client/proc/close_slot_crew()
	set name = "Close Job Slot (Crew)"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in SSjobs.primary_job_datums)
			if(J.is_position_available())
				jobs[J.title] = J
		var/job_title = input("Please select job slot to close", "Close job slot")  as null|anything in jobs
		var/datum/job/job = jobs[job_title]
		if(job && job.is_position_available())
			job.make_position_unavailable()
			log_and_message_admins("has closed a job slot for [job_title]")
			return

/client/proc/toggleghostwriters()
	set name = "Toggle ghost writers"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.cult_ghostwriter)
			config.cult_ghostwriter = 0
			to_chat(src, "<b>Disallowed ghost writers.</b>")
			message_admins("Admin [key_name_admin(usr)] has disabled ghost writers.", 1)
		else
			config.cult_ghostwriter = 1
			to_chat(src, "<b>Enabled ghost writers.</b>")
			message_admins("Admin [key_name_admin(usr)] has enabled ghost writers.", 1)

/client/proc/toggledrones()
	set name = "Toggle maintenance drones"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.allow_drone_spawn)
			config.allow_drone_spawn = 0
			to_chat(src, "<b>Disallowed maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has disabled maint drones.", 1)
		else
			config.allow_drone_spawn = 1
			to_chat(src, "<b>Enabled maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has enabled maint drones.", 1)

/client/proc/man_up(mob/T as mob in SSmobs.mob_list)
	set popup_menu = FALSE
	set category = "Fun"
	set name = "Man Up"
	set desc = "Tells mob to man up and deal with it."

	to_chat(T, SPAN_NOTICE("<b>[FONT_LARGE("Man up and deal with it.")]</b>"))
	to_chat(T, SPAN_NOTICE("Move on."))

	log_and_message_admins("told [key_name(T)] to man up and deal with it.")

/client/proc/global_man_up()
	set category = "Fun"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."

	for (var/mob/T as mob in SSmobs.mob_list)
		to_chat(T, "<br><center>[SPAN_NOTICE("<b>[FONT_HUGE("Man up.<br> Deal with it.")]</b><br>Move on.")]</center><br>")
		sound_to(T, 'sound/voice/ManUp1.ogg')

	log_and_message_admins("told everyone to man up and deal with it.")

/client/proc/give_spell(mob/T as mob in SSmobs.mob_list) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S) return
	T.add_spell(new S)
	log_and_message_admins("gave [key_name(T)] the spell [S].")

/client/proc/delete_crew_record()
	set category = "Admin"
	set name = "Delete Crew Record"
	set desc = "Delete a crew record from the global crew list."

	var/list/entries = list()

	for (var/datum/computer_file/report/crew_record/entry in GLOB.all_crew_records)
		entries["[entry.get_name()], [entry.get_job()]"] = entry

	if (!length(entries))
		return

	var/choice = input("Pick a record to delete:", "Delete Crew Record") as null | anything in entries

	if (!choice)
		return

	var/check = alert("Are you sure you want to delete [choice]?", "Delete Record?", "Yes", "No")
	var/datum/computer_file/report/crew_record/record = entries[choice]

	if (check == "Yes")
		GLOB.all_crew_records.Remove(record)
		log_and_message_admins("has removed [record.get_name()], [record.get_job()]'s crew record.")
