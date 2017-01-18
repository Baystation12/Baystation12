#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_BLUESPACE_JUMP "bluespace_jump"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"
#define EVAC_OPT_CANCEL_BLUESPACE_JUMP "cancel_bluespace_jump"

/datum/evacuation_controller/pods
	name = "escape pod controller"

	transfer_prep_additional_delay = 10 MINUTES

	evacuation_options = list(
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship(),
		EVAC_OPT_BLUESPACE_JUMP = new /datum/evacuation_option/bluespace_jump(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
		EVAC_OPT_CANCEL_BLUESPACE_JUMP = new /datum/evacuation_option/cancel_bluespace_jump()
	)
	var/list/bluespaced = list()

/datum/evacuation_controller/pods/finish_preparing_evac()
	. = ..()
	// Arm the escape pods.
	if (emergency_evacuation)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
			if (pod.arming_controller)
				pod.arming_controller.arm()

/datum/evacuation_controller/pods/launch_evacuation()

	state = EVAC_IN_TRANSIT

	// Launch the pods!
	if (emergency_evacuation)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
			if (!pod.arming_controller || pod.arming_controller.armed)
				pod.move_time = (evac_transit_delay/10)
				pod.launch(src)
		priority_announcement.Announce(replacetext(replacetext(using_map.emergency_shuttle_leaving_dock, "%dock_name%", "[using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
	else
		//Bluespace'd!
		priority_announcement.Announce(replacetext(replacetext(using_map.shuttle_leaving_dock, "%dock_name%", "[using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))

		world.maxz++	//create a place for stragglers
		using_map.sealed_levels |= world.maxz
		for(var/mob/living/M in mob_list)
			if(M.z in using_map.station_levels)
				var/area/A = get_area(M)
				if(istype(A,/area/space)) //straggler
					var/turf/T = locate(M.x,M.y,world.maxz)
					if(T)
						M.forceMove(T)
				else
					if(M.client)
						to_chat(M,"<span class='notice'>You feel oddly light.</span>")
						M.overlay_fullscreen("bluespace", /obj/screen/fullscreen/bluespace_overlay)
					M.incorporeal_move = 1
					bluespaced |= M

/datum/evacuation_controller/pods/finish_evacuation()
	..()
	if (emergency_evacuation)
		return
	for(var/mob/living/M in bluespaced)
		if(M.client)
			to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
			M.clear_fullscreen("bluespace")
		M.incorporeal_move = 0
		var/turf/T = get_turf(M)
		if(T.density)
			to_chat(M,"<span class='danger'>[T] suddenly appears inside you!</span>")
			M.gib()
		bluespaced -= M

/datum/evacuation_controller/pods/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_BLUESPACE_JUMP], evacuation_options[EVAC_OPT_ABANDON_SHIP])
	if (is_evacuating())
		if (emergency_evacuation)
			return list(evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])
		else
			return list(evacuation_options[EVAC_OPT_CANCEL_BLUESPACE_JUMP])

/datum/evacuation_option/abandon_ship
	option_text = "Abandon spacecraft"
	option_desc = "abandon the spacecraft"
	option_target = EVAC_OPT_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE

/datum/evacuation_option/abandon_ship/execute(mob/user)
	if (!ticker || !evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Unable to initiate escape procedures.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		to_chat(user, "Escape procedures already in progress.")
		return
	if (evacuation_controller.call_evacuation(user, 1))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated abandonment of the spacecraft.")

/datum/evacuation_option/bluespace_jump
	option_text = "Initiate bluespace jump"
	option_desc = "initiate a bluespace jump"
	option_target = EVAC_OPT_BLUESPACE_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE

/datum/evacuation_option/bluespace_jump/execute(mob/user)
	if (!ticker || !evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Unable to initiate jump preparation.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		to_chat(user, "Jump preparation already in progress.")
		return
	if (evacuation_controller.call_evacuation(user, 0))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated bluespace jump preparation.")

/datum/evacuation_option/cancel_abandon_ship
	option_text = "Cancel abandonment"
	option_desc = "cancel abandonment of the spacecraft"
	option_target = EVAC_OPT_CANCEL_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_abandon_ship/execute(mob/user)
	if (ticker && evacuation_controller && evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled abandonment of the spacecraft.")

/datum/evacuation_option/cancel_bluespace_jump
	option_text = "Cancel bluespace jump"
	option_desc = "cancel the jump preparation"
	option_target = EVAC_OPT_CANCEL_BLUESPACE_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_bluespace_jump/execute(mob/user)
	if (ticker && evacuation_controller && evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled the bluespace jump.")

/obj/screen/fullscreen/bluespace_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	color = "#FF9900"
	blend_mode = BLEND_SUBTRACT
	layer = FULLSCREEN_LAYER

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_BLUESPACE_JUMP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_BLUESPACE_JUMP