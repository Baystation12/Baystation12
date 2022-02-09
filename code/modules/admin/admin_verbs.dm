//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/datum/admins/proc/show_player_panel, //shows an interface for individual players, with various links (links require additional flags), right-click player panel,
	/client/proc/player_panel,
	/client/proc/secrets,
	/client/proc/deadmin_self,			//destroys our own admin datum so we can play as a regular player,
	/client/proc/hide_verbs,			//hides all our adminverbs,
	/client/proc/hide_most_verbs,		//hides all our hideable adminverbs,
	/client/proc/debug_variables,		//allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify,
	/client/proc/watched_variables,
	/client/proc/debug_global_variables,//as above but for global variables,
//	/client/proc/check_antagonists,		//shows all antags,
	/client/proc/cmd_check_new_players
//	/client/proc/deadchat				//toggles deadchat on/off,
	)
var/list/admin_verbs_admin = list(
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
	/client/proc/free_slot_crew,			//frees slot for chosen job,
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
	/datum/admins/proc/setroundlength,
	/datum/admins/proc/toggleroundendvote
)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/jobbans
	)
var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound
	)

var/list/admin_verbs_fun = list(
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
	/datum/admins/proc/ai_hologram_set,
	/client/proc/toggle_film_grain
	)

var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_fruit,
	/datum/admins/proc/spawn_fluid_verb,
	/datum/admins/proc/spawn_custom_item,
	/datum/admins/proc/check_custom_items,
	/datum/admins/proc/spawn_plant,
	/datum/admins/proc/spawn_atom,		// allows us to spawn instances,
	/datum/admins/proc/spawn_artifact,
	/client/proc/spawn_chemdisp_cartridge,
	/datum/admins/proc/mass_debug_closet_icons
	)
var/list/admin_verbs_server = list(
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
var/list/admin_verbs_debug = list(
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
	/datum/admins/proc/submerge_map,
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
	/client/proc/spawn_exoplanet
	)

var/list/admin_verbs_paranoid_debug = list(
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/debug_controller
	)

var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)
var/list/admin_verbs_rejuv = list(
	)

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
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
var/list/admin_verbs_mod = list(
	/client/proc/cmd_admin_pm_context,	// right-click adminPM interface,
	/client/proc/cmd_admin_pm_panel,	// admin-pm list,
	/client/proc/debug_variables,		// allows us to -see- the variables of any instance in the game.,
	/client/proc/watched_variables,
	/client/proc/debug_global_variables,// as above but for global variables,
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

	to_chat(src, "<span class='interface'>Most of your adminverbs have been hidden.</span>")
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	to_chat(src, "<span class='interface'>Almost all of your adminverbs have been hidden.</span>")
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	to_chat(src, "<span class='interface'>All of your adminverbs are now visible.</span>")





/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(isghost(mob))
		var/mob/observer/ghost/ghost = mob
		ghost.reenter_corpse()

	else if(istype(mob,/mob/new_player))
		to_chat(src, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>")
	else
		//ghostize
		var/mob/body = mob
		var/mob/observer/ghost/ghost = body.ghostize(1)
		if (!ghost)
			to_chat(src, FONT_COLORED("red", "You are already admin-ghosted."))
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
			to_chat(mob, "<span class='danger'>Invisimin off. Invisibility reset.</span>")
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.set_invisibility(INVISIBILITY_OBSERVER)
			to_chat(mob, "<span class='notice'>Invisimin on. You are now as invisible as a ghost.</span>")
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
	if(!can_select_ooc_color(src)) // INF, was	if(!check_rights(R_FUN))
		return

	var/client/C
	if(alert(src, "Change for yourself or someone else?", "User pick", "For myself", "For another player") == "For another player")
		C = input(src, "Please select a player.", "Player select") as null|anything in (GLOB.clients - src)
	else
		C = src
	if(!C)
		return

	var/response = alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change [C] OOC color", "Pick new color", "Reset to default", "Cancel")
	if(response == "Pick new color")
		C.prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		C.prefs.ooccolor = initial(C.prefs.ooccolor)
	else
		return
	if(C && C != src)
		to_chat(C, SPAN_NOTICE("[src] changed your OOC color to [C.prefs.ooccolor == initial(C.prefs.ooccolor) ? "default" : C.prefs.ooccolor]."))
	log_and_message_admins("changed [C == src ? "his own" : "[C]"] OOC color to [C.prefs.ooccolor == initial(C.prefs.ooccolor) ? "default" : C.prefs.ooccolor].")
	SScharacter_setup.queue_preferences_save(C.prefs)
	return


/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))
		return
	if(!warned_ckey || !istext(warned_ckey))
		return
	if(warned_ckey in admin_datums)
		to_chat(usr, "<font color='red'>Error: warn(): You can't warn admins.</font>")
		return
	var/datum/preferences/D
	var/client/C = GLOB.ckey_directory[warned_ckey]
	if(C)
		D = C.prefs
	else
		D = SScharacter_setup.preferences_datums[warned_ckey]
	if(!D)
		to_chat(src, "<font color='red'>Error: warn(): No such ckey found.</font>")
		return
	++D.warns
	if (config.warn_autoban_threshold && D.warns >= config.warn_autoban_threshold)
		var/mins_readable = minutes_to_readable(config.warn_autoban_duration)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [mins_readable] autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [mins_readable] ban.")
			to_chat(C, "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [mins_readable].</font>")
			qdel(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [mins_readable] ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, config.warn_autoban_duration)
	else
		if(C)
			to_chat(C, "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>")
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
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as num|null
			if (isnull(devastation_range))
				return
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as num|null
			if (isnull(heavy_impact_range))
				return
			var/light_impact_range = input("Light impact range (in tiles):") as num|null
			if (isnull(light_impact_range))
				return
			var/flash_range = input("Flash range (in tiles):") as num|null
			if (isnull(flash_range))
				return
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	log_and_message_admins("created an admin explosion at [epicenter.loc].")

/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"

	if(!check_rights(R_ADMIN))
		return

	if(istype(CH, /datum/click_handler/build_mode))
		CH.Exit()
		QDEL_NULL(CH)
	else
		CH = new /datum/click_handler/build_mode(src)
		CH.Enter()

/client/proc/object_talk(var/msg as text) // -- TLE
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
		to_chat(src, "<span class='interface'>You now have the keys to control the planet, or at least [GLOB.using_map.full_name].</span>")
		verbs -= /client/proc/readmin_self

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can re-admin yourself at any time.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			to_chat(src, "<span class='interface'>You are now a normal player.</span>")
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

	var/mob/living/silicon/S = input("Select silicon.", "Rename Silicon.") as null|anything in GLOB.silicon_mob_list
	if(!S) return

	var/new_name = sanitizeSafe(input(src, "Enter new name. Leave blank or as is to cancel.", "[S.real_name] - Enter new silicon name", S.real_name))
	if(new_name && new_name != S.real_name)
		log_and_message_admins("has renamed the silicon '[S.real_name]' to '[new_name]'")
		S.fully_replace_character_name(new_name)

/client/proc/manage_silicon_laws()
	set name = "Manage Silicon Laws"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Manage Silicon Laws") as null|anything in GLOB.silicon_mob_list
	if(!S) return

	var/datum/nano_module/law_manager/L = new(S)
	L.ui_interact(usr, state = GLOB.admin_state)
	log_and_message_admins("has opened [S]'s law manager.")

/client/proc/change_human_appearance_admin()
	set name = "Change Mob Appearance - Admin"
	set desc = "Allows you to change the mob appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Admin") as null|anything in GLOB.human_mob_list
	if(!H) return

	log_and_message_admins("is altering the appearance of [H].")
	H.change_appearance(APPEARANCE_ALL, FALSE, usr, state = GLOB.admin_state)

/client/proc/change_human_appearance_self()
	set name = "Change Mob Appearance - Self"
	set desc = "Allows the mob to change its appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Self") as null|anything in GLOB.human_mob_list
	if(!H) return

	if(!H.client)
		to_chat(usr, "Only mobs with clients can alter their own appearance.")
		return

	switch(alert("Do you wish for [H] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel"))
		if("Yes")
			log_and_message_admins("has allowed [H] to change \his appearance, including races that requires whitelisting")
			H.change_appearance(APPEARANCE_COMMON, FALSE)
		if("No")
			log_and_message_admins("has allowed [H] to change \his appearance, excluding races that requires whitelisting.")
			H.change_appearance(APPEARANCE_COMMON, TRUE)

/client/proc/change_security_level()
	set name = "Set security level"
	set desc = "Sets the security level"
	set category = "Admin"

	if(!check_rights(R_ADMIN))	return

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)

	var/decl/security_level/new_security_level = input(usr, "It's currently [security_state.current_security_level.name].", "Select Security Level")  as null|anything in (security_state.all_security_levels - security_state.current_security_level)
	if(!new_security_level)
		return

	if(alert("Switch from [security_state.current_security_level.name] to [new_security_level.name]?","Change security level?","Yes","No") == "Yes")
		security_state.set_security_level(new_security_level, TRUE)


//---- bs12 verbs ----


/client/proc/editappear()
	set name = "Edit Appearance"
	set category = "Fun"

	if(!check_rights(R_FUN))	return

	var/mob/living/carbon/human/M = input("Select mob.", "Edit Appearance") as null|anything in GLOB.human_mob_list

	if(!istype(M, /mob/living/carbon/human))
		to_chat(usr, "<span class='warning'>You can only do this to humans!</span>")
		return
	switch(alert("Are you sure you wish to edit this mob's appearance? Skrell, Unathi and Vox can result in unintended consequences.",,"Yes","No"))
		if("No")
			return
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.r_facial = hex2num(copytext_char(new_facial, 2, 4))
		M.g_facial = hex2num(copytext_char(new_facial, 4, 6))
		M.b_facial = hex2num(copytext_char(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.r_hair = hex2num(copytext_char(new_hair, 2, 4))
		M.g_hair = hex2num(copytext_char(new_hair, 4, 6))
		M.b_hair = hex2num(copytext_char(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.r_eyes = hex2num(copytext_char(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext_char(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext_char(new_eyes, 6, 8))
		M.update_eyes()

	var/new_skin = input("Please select body color. This is for Unathi, and Skrell only!", "Character Generation") as color
	if(new_skin)
		M.r_skin = hex2num(copytext_char(new_skin, 2, 4))
		M.g_skin = hex2num(copytext_char(new_skin, 4, 6))
		M.b_skin = hex2num(copytext_char(new_skin, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

	if (new_tone)
		M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
		M.s_tone =  -M.s_tone + 35

	// hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in GLOB.hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in GLOB.facial_hair_styles_list
	if(new_fstyle)
		M.f_style = new_fstyle

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female", "Neuter")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else if (new_gender == "Female")
			M.gender = FEMALE
		else
			M.gender = NEUTER

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

/client/proc/free_slot_crew()
	set name = "Free Job Slot (Crew)"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in SSjobs.primary_job_datums)
			if(!J.is_position_available())
				jobs[J.title] = J
		if (!jobs.len)
			to_chat(usr, "There are no fully staffed jobs.")
			return
		var/job_title = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		var/datum/job/job = jobs[job_title]
		if(job && !job.is_position_available())
			job.make_position_available()
			message_admins("A job slot for [job_title] has been opened by [key_name_admin(usr)]")
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

	to_chat(T, "<span class='notice'><b><font size=3>Man up and deal with it.</font></b></span>")
	to_chat(T, "<span class='notice'>Move on.</span>")

	log_and_message_admins("told [key_name(T)] to man up and deal with it.")

/client/proc/global_man_up()
	set category = "Fun"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."

	for (var/mob/T as mob in SSmobs.mob_list)
		to_chat(T, "<br><center><span class='notice'><b><font size=4>Man up.<br> Deal with it.</font></b><br>Move on.</span></center><br>")
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
