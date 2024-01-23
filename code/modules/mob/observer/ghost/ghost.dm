var/global/list/image/ghost_darkness_images = list() //this is a list of images for things ghosts should still be able to see when they toggle darkness
var/global/list/image/ghost_sightless_images = list() //this is a list of images for things ghosts should still be able to see even without ghost sight

/mob/observer/ghost
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	// [SIERRA-EDIT] - SSINPUT
	// appearance_flags = DEFAULT_APPEARANCE_FLAGS | KEEP_TOGETHER // SIERRA-EDIT - ORIGINAL
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | KEEP_TOGETHER | LONG_GLIDE
	// [/SIERRA-EDIT]
	blinded = 0
	anchored = TRUE	//  don't get pushed around
	universal_speak = TRUE
	pronouns = PRONOUNS_THEY_THEM
	mob_flags = MOB_FLAG_HOLY_BAD
	movement_handlers = list(/datum/movement_handler/mob/multiz_connected, /datum/movement_handler/mob/incorporeal)

	var/is_manifest = FALSE
	var/next_visibility_toggle = 0
	var/can_reenter_corpse
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghost - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/has_enabled_antagHUD = 0
	var/medHUD = 0
	var/antagHUD = 0
	var/admin_ghosted = 0
	var/anonsay = 0
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/seedarkness = 1

	var/obj/item/device/multitool/ghost_multitool
	var/list/hud_images // A list of hud images

/mob/observer/ghost/Initialize(mapload)
	see_in_dark = 100
	verbs += /mob/proc/toggle_antag_pool

	var/turf/T
	if(ismob(loc))
		var/mob/body = loc
		T = get_turf(body)               //Where is the body located?
		attack_logs_ = body.attack_logs_ //preserve our attack logs by copying them to our ghost

		set_appearance(body)
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
				else
					name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.
	else
		spawn(10) // wait for the observer mob to receive the client's key
			mind = new /datum/mind(key)
			mind.current = src
	if(!T)	T = pick(GLOB.latejoin | GLOB.latejoin_cryo | GLOB.latejoin_gateway)			//Safety in case we cannot find the body's position
	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	real_name = name

	if(GLOB.cult)
		GLOB.cult.add_ghost_magic(src)

	ghost_multitool = new(src)

	GLOB.ghost_mobs += src

	. = ..()

/mob/observer/ghost/Destroy()
	GLOB.ghost_mobs -= src
	stop_following()
	qdel(ghost_multitool)
	ghost_multitool = null
	if(hud_images)
		for(var/image/I in hud_images)
			show_hud_icon(I.icon_state, FALSE)
		hud_images = null
	return ..()

/mob/observer/ghost/OnSelfTopic(href_list, topic_status)
	if (topic_status == STATUS_INTERACTIVE)
		if (href_list["track"])
			if(istype(href_list["track"],/mob))
				var/mob/target = locate(href_list["track"]) in SSmobs.mob_list
				if(target)
					start_following(target)
			else
				var/atom/target = locate(href_list["track"])
				if(istype(target))
					start_following(target)
			return TOPIC_HANDLED
	return ..()

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/observer/ghost/Life()
	..()
	if(!loc) return
	if(!client) return 0

	handle_hud_glasses()

	if(antagHUD)
		var/list/target_list = list()
		for(var/mob/living/target in oview(src, 14))
			if(target.mind && target.mind.special_role)
				target_list += target
		if(length(target_list))
			assess_targets(target_list, src)
	if(medHUD)
		process_medHUD(src)


/mob/observer/ghost/proc/process_medHUD(mob/M)
	var/client/C = M.client
	for(var/mob/living/carbon/human/patient in oview(M, 14))
		C.images += patient.hud_list[HEALTH_HUD]
		C.images += patient.hud_list[STATUS_HUD_OOC]

/mob/observer/ghost/proc/assess_targets(list/target_list, mob/observer/ghost/U)
	var/client/C = U.client
	for(var/mob/living/carbon/human/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	for(var/mob/living/silicon/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	return 1

/mob/proc/ghostize(can_reenter_corpse = CORPSE_CAN_REENTER)
	// Are we the body of an aghosted admin? If so, don't make a ghost.
	if(teleop && istype(teleop, /mob/observer/ghost))
		var/mob/observer/ghost/G = teleop
		if(G.admin_ghosted)
			return
	if(key)
		hide_fullscreens()
		var/mob/observer/ghost/ghost = new(src)	//Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.stat == DEAD ? src.timeofdeath : world.time
		ghost.key = key
		if(ghost.client && !ghost.client.holder && !config.antag_hud_allowed)		// For new ghosts we remove the verb from even showing up if it's not allowed.
			ghost.verbs -= /mob/observer/ghost/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
		return ghost

/mob/observer/ghostize() // Do not create ghosts of ghosts.

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if (admin_paralyzed)
		to_chat(usr, SPAN_DEBUG("You cannot ghost while admin paralyzed."))
		return

	if(stat == DEAD)
		announce_ghost_joinleave(ghostize(1))
	else
		var/response
		if(src.client && src.client.holder)
			response = alert(src, "You have the ability to Admin-Ghost. The regular Ghost verb will announce your presence to dead chat. Both variants will allow you to return to your body using 'aghost'.\n\nWhat do you wish to do?", "Are you sure you want to ghost?", "Ghost", "Admin Ghost", "Stay in body")
			if(response == "Admin Ghost")
				if(!src.client)
					return
				src.client.admin_ghost()
		else if(config.respawn_delay)
			response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to play this round for another [config.respawn_delay] minute\s! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		else
			response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to return to this body! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		if(response != "Ghost")
			return
		log_and_message_admins("has ghosted.")
		ghosted = TRUE
		var/mob/observer/ghost/ghost = ghostize(0)	//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		if (ghost)
			ghost.timeofdeath = world.time // Because the living mob won't have a time of death and we want the respawn timer to work properly.
			announce_ghost_joinleave(ghost)

/mob/observer/ghost/can_use_hands()	return 0
/mob/observer/ghost/is_active()		return 0

/mob/observer/ghost/Stat()
	. = ..()
	if(statpanel("Status"))
		if(evacuation_controller)
			var/eta_status = evacuation_controller.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)
		stat("Local Time:", "[stationtime2text()]")
		stat("Local Date:", "[stationdate2text()]")

/mob/observer/ghost/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"
	if(!client)	return
	if(!(mind && mind.current && can_reenter_corpse))
		to_chat(src, SPAN_WARNING("You have no body."))
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(src, SPAN_WARNING("Another consciousness is in your body... it is resisting you."))
		return
	stop_following()
	mind.current.key = key
	mind.current.teleop = null
	mind.current.reload_fullscreen()
	if(!admin_ghosted)
		announce_ghost_joinleave(mind, 0, "They now occupy their body again.")
	return 1

/mob/observer/ghost/verb/toggle_medHUD()
	set category = "Ghost"
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD, allowing you to see how everyone is doing."
	if(!client)
		return
	if(medHUD)
		medHUD = 0
		to_chat(src, SPAN_NOTICE("Medical HUD Disabled"))
	else
		medHUD = 1
		to_chat(src, SPAN_NOTICE("Medical HUD Enabled"))

/mob/observer/ghost/verb/toggle_antagHUD()
	set category = "Ghost"
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD, allowing you to see who is the antagonist."

	if(!client)
		return
	if(!config.antag_hud_allowed && !client.holder)
		to_chat(src, SPAN_WARNING("Admins have disabled this for this round"))
		return
	var/mob/observer/ghost/M = src
	if(jobban_isbanned(M, "AntagHUD"))
		to_chat(src, SPAN_WARNING("You have been banned from using this feature"))
		return
	if(config.antag_hud_restricted && !M.has_enabled_antagHUD && !client.holder)
		var/response = alert(src, "If you turn this on, you will not be able to take any part in the round.","Are you sure you want to turn this feature on?","Yes","No")
		if(response == "No") return
		M.can_reenter_corpse = 0
	if(!M.has_enabled_antagHUD && !client.holder)
		M.has_enabled_antagHUD = 1
	if(M.antagHUD)
		M.antagHUD = 0
		to_chat(src, SPAN_NOTICE("AntagHUD Disabled"))
	else
		M.antagHUD = 1
		to_chat(src, SPAN_NOTICE("AntagHUD Enabled"))

/mob/observer/ghost/verb/dead_tele(A in area_repository.get_areas_by_z_level())
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"

	var/area/thearea = area_repository.get_areas_by_z_level()[A]
	if(!thearea)
		to_chat(src, "No area available.")
		return

	var/list/area_turfs = get_area_turfs(thearea, shall_check_if_holy() ? list(/proc/is_not_holy_turf) : list())
	if(!length(area_turfs))
		to_chat(src, SPAN_WARNING("This area has been entirely made into sacred grounds, you cannot enter it while you are in this plane of existence!"))
		return

	ghost_to_turf(pick(area_turfs))

/mob/observer/ghost/verb/dead_tele_coord(tx as num, ty as num, tz as num)
	set category = "Ghost"
	set name = "Teleport to Coordinate"
	set desc= "Teleport to a coordinate"

	var/turf/T = locate(tx, ty, tz)
	if(T)
		ghost_to_turf(T)
	else
		to_chat(src, SPAN_WARNING("Invalid coordinates."))
/mob/observer/ghost/verb/follow(datum/follow_holder/fh in get_follow_targets())
	set category = "Ghost"
	set name = "Follow"
	set desc = "Follow and haunt a mob."

	if(!fh.show_entry()) return
	start_following(fh.followed_instance)

/mob/observer/ghost/proc/ghost_to_turf(turf/target_turf)
	if(check_is_holy_turf(target_turf))
		to_chat(src, SPAN_WARNING("The target location is holy grounds!"))
		return
	stop_following()
	forceMove(target_turf)

/mob/observer/ghost/start_following(atom/a)
	..()
	to_chat(src, SPAN_NOTICE("Now following \the [following]."))

/mob/observer/ghost/stop_following()
	if(following)
		to_chat(src, SPAN_NOTICE("No longer following \the [following]"))
	..()

/mob/observer/ghost/keep_following(atom/movable/am, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if(check_is_holy_turf(T))
		to_chat(src, SPAN_WARNING("You cannot follow something standing on holy grounds!"))
		return
	..()

/mob/observer/ghost/StoreMemory()
	set hidden = 1
	to_chat(src, SPAN_WARNING("You are dead! You have no mind to store memory!"))

/mob/observer/ghost/AddMemory()
	set hidden = 1
	to_chat(src, SPAN_WARNING("You are dead! You have no mind to store memory!"))
/mob/observer/ghost/PostIncorporealMovement()
	stop_following()

/mob/observer/ghost/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	var/turf/t = get_turf(src)
	if(t)
		print_atmos_analysis(src, atmosanalyzer_scan(t))

/mob/observer/ghost/verb/check_radiation()
	set name = "Check Radiation"
	set category = "Ghost"

	var/turf/t = get_turf(src)
	if(t)
		var/rads = SSradiation.get_rads_at_turf(t)
		to_chat(src, SPAN_NOTICE("Radiation level: [rads ? rads : "0"] IU/s."))

/mob/observer/ghost/verb/scan_target()
	set name = "Scan Target"
	set category = "Ghost"
	set desc = "Analyse whatever you are following."

	if(ishuman(following))
		to_chat(src, medical_scan_results(following, 1, SKILL_MAX))

	else to_chat(src, SPAN_NOTICE("Not a scannable target."))

/mob/observer/ghost/verb/become_mouse()
	set name = "Become mouse"
	set category = "Ghost"

	if(config.disable_player_mice)
		to_chat(src, SPAN_WARNING("Spawning as a mouse is currently disabled."))
		return

	if(!MayRespawn(1, ANIMAL_SPAWN_DELAY))
		return

	var/turf/T = get_turf(src)
	if(!T || (T.z in GLOB.using_map.admin_levels))
		to_chat(src, SPAN_WARNING("You may not spawn as a mouse on this Z-level."))
		return

	var/response = alert(src, "Are you -sure- you want to become a mouse?","Are you sure you want to squeek?","Squeek!","Nope!")
	if(response != "Squeek!") return  //Hit the wrong key...again.


	//find a viable mouse candidate
	var/mob/living/simple_animal/passive/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in SSmachines.machinery)
		if(!v.welded && v.z == T.z)
			found_vents.Add(v)
	if(length(found_vents))
		vent_found = pick(found_vents)
		host = new /mob/living/simple_animal/passive/mouse(vent_found.loc)
	else
		to_chat(src, SPAN_WARNING("Unable to find any unwelded vents to spawn mice at."))
	if(host)
		if(config.uneducated_mice)
			host.universal_understand = FALSE
		announce_ghost_joinleave(src, 0, "They are now a mouse.")
		host.ckey = src.ckey
		host.status_flags |= NO_ANTAG
		to_chat(host, SPAN_INFO("You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent."))

/mob/observer/ghost/verb/view_manfiest()
	set name = "Show Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += html_crew_manifest()

	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

//This is called when a ghost is drag clicked to something.
/mob/observer/ghost/MouseDrop(atom/over)
	if(!usr || !over) return
	if(isghost(usr) && usr.client && isliving(over))
		var/mob/living/M = over
		// If they an admin, see if control can be resolved.
		if(usr.client.holder && usr.client.holder.cmd_ghost_drag(src,M))
			return
		// Otherwise, see if we can possess the target.
		if(usr == src && try_possession(M))
			return
	if(istype(over, /obj/machinery/drone_fabricator))
		if(try_drone_spawn(src, over))
			return

	return ..()

/mob/observer/ghost/proc/try_possession(mob/living/target)
	if(target.is_zombie())
		if(!config.ghosts_can_possess_zombies)
			to_chat(src, SPAN_WARNING("Ghosts are not permitted to possess zombies."))
			return 0
	else if(!config.ghosts_can_possess_animals)
		to_chat(src, SPAN_WARNING("Ghosts are not permitted to possess animals."))
		return 0
	if(!target.can_be_possessed_by(src))
		return 0
	return target.do_possession(src)

/mob/observer/ghost/pointed(atom/A as mob|obj|turf in view())
	if(!..())
		return 0
	usr.visible_message(SPAN_CLASS("deadsay", "<b>[src]</b> points to [A]"))
	return 1

/mob/observer/ghost/proc/show_hud_icon(icon_state, make_visible)
	if(!hud_images)
		hud_images = list()
	var/image/hud_image = hud_images[icon_state]
	if(!hud_image)
		hud_image = image('icons/mob/mob.dmi', loc = src, icon_state = icon_state)
		hud_images[icon_state] = hud_image

	if(make_visible)
		add_client_image(hud_image)
	else
		remove_client_image(hud_image)

/mob/observer/ghost/canface()
	return 1

/mob/proc/can_admin_interact()
	return 0

/mob/observer/ghost/can_admin_interact()
	return check_rights(R_ADMIN, 0, src)

/mob/observer/ghost/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost"
	ghostvision = !(ghostvision)
	updateghostsight()
	to_chat(src, "You [(ghostvision?"now":"no longer")] have ghost vision.")

/mob/observer/ghost/verb/set_ghost_alpha()
	set name = "Set Ghost Alpha"
	set desc = "Giving you option to enter value for custom ghost transparency"
	set category = "Ghost"
	alpha = alpha == 127 ? 0 : 127
	mouse_opacity = alpha ? 1 : 0

/mob/observer/ghost/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"
	seedarkness = !(seedarkness)
	updateghostsight()
	to_chat(src, "You [(seedarkness?"now":"no longer")] see darkness.")

/mob/observer/ghost/proc/updateghostsight()
	if (!seedarkness)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else
		set_see_invisible(ghostvision ? SEE_INVISIBLE_OBSERVER : SEE_INVISIBLE_LIVING)
	SSghost_images.queue_image_update(src)

/mob/observer/ghost/proc/updateghostimages()
	if (!client)
		return
	client.images -= ghost_sightless_images
	client.images -= ghost_darkness_images
	if(!seedarkness)
		client.images |= ghost_sightless_images
		if(ghostvision)
			client.images |= ghost_darkness_images
	else if(seedarkness && !ghostvision)
		client.images |= ghost_sightless_images
	client.images -= ghost_image //remove ourself

/mob/observer/ghost/MayRespawn(feedback = 0, respawn_time = 0)
	if(!client)
		return 0
	if(mind && mind.current && mind.current.stat != DEAD && can_reenter_corpse == CORPSE_CAN_REENTER)
		if(feedback)
			to_chat(src, SPAN_WARNING("Your non-dead body prevents you from respawning."))
		return 0
	if(config.antag_hud_restricted && has_enabled_antagHUD == 1)
		if(feedback)
			to_chat(src, SPAN_WARNING("antagHUD restrictions prevent you from respawning."))
		return 0

	var/timedifference = world.time - timeofdeath
	if(!client.holder && respawn_time && timeofdeath && timedifference < respawn_time MINUTES)
		var/timedifference_text = time2text(respawn_time MINUTES - timedifference,"mm:ss")
		to_chat(src, SPAN_WARNING("You must have been dead for [respawn_time] minute\s to respawn. You have [timedifference_text] left."))
		return 0

	return 1

/proc/isghostmind(datum/mind/player)
	return player && !isnewplayer(player.current) && (!player.current || isghost(player.current) || (isliving(player.current) && player.current.stat == DEAD) || !player.current.client)

/mob/proc/check_is_holy_turf(turf/T)
	return 0

/mob/observer/ghost/check_is_holy_turf(turf/T)
	if(shall_check_if_holy() && is_holy_turf(T))
		return TRUE

/mob/observer/ghost/proc/shall_check_if_holy()
	if(invisibility >= INVISIBILITY_OBSERVER)
		return FALSE
	if(check_rights(R_ADMIN|R_FUN, 0, src))
		return FALSE
	return TRUE

/mob/observer/ghost/proc/set_appearance(mob/target)
	ClearTransform()
	ClearOverlays()
	if (!target)
		icon = initial(icon)
		return
	icon = null
	CopyOverlays(target)


/mob/observer/ghost/verb/respawn()
	set name = "Respawn"
	set category = "OOC"

	if (!(config.abandon_allowed))
		to_chat(usr, SPAN_WARNING("Respawn is disabled."))
		return
	if (SSticker.mode)
		if (SSticker.mode.deny_respawn)
			to_chat(usr, SPAN_WARNING("Respawn is disabled for this roundtype."))
			return
		else if (!MayRespawn(TRUE, config.respawn_delay))
			return
	to_chat(usr, SPAN_NOTICE("You can respawn now, enjoy your new life!"))
	to_chat(usr, SPAN_NOTICE("<b>Make sure to play a different character, and please roleplay correctly!</b>"))
	announce_ghost_joinleave(client, 0)

	sound_to(src, sound(null))

	var/mob/new_player/M = new /mob/new_player()
	if (can_reenter_corpse != CORPSE_CAN_REENTER_AND_RESPAWN)
		M.respawned_time = world.time
	M.key = key
	log_and_message_admins("has respawned.", M)
