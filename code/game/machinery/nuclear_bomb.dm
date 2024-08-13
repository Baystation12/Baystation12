var/global/bomb_set

/obj/machinery/nuclearbomb
	name = "nuclear fission explosive"
	desc = "Uh oh. RUN!"
	icon = 'icons/obj/machines/nuke.dmi'
	icon_state = "idle"
	density = TRUE
	use_power = POWER_USE_OFF
	uncreated_component_parts = null
	unacidable = TRUE
	interact_offline = TRUE

	var/evacuate = FALSE
	var/deployable = 0
	var/extended = 0
	var/lighthack = 0
	var/timeleft = 120 SECONDS
	var/minTime = 120 SECONDS
	var/maxTime = 600 SECONDS
	var/timing = 0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0
	var/safety = 1
	var/obj/item/disk/nuclear/auth = null
	var/removal_stage = 0 // 0 is no removal, 1 is covers removed, 2 is covers open, 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.
	var/lastentered
	var/previous_level = ""
	wires = /datum/wires/nuclearbomb
	var/singleton/security_level/original_level

/obj/machinery/nuclearbomb/New()
	..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.

/obj/machinery/nuclearbomb/Destroy()
	qdel(auth)
	auth = null
	return ..()

/obj/machinery/nuclearbomb/Process()
	if(timing)
		playsound(loc, 'sound/items/timer.ogg',50)
		if(world.time > timeleft)
			addtimer(new Callback(src, .proc/explode), 0)
		SSnano.update_uis(src)

/obj/machinery/nuclearbomb/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(isScrewdriver(O))
		ClearOverlays()
		if(auth)
			if(panel_open == 0)
				panel_open = 1
				AddOverlays("panel_open")
				to_chat(user, "You unscrew the control panel of [src].")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			else
				panel_open = 0
				to_chat(user, "You screw the control panel of [src] back on.")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		else
			if(panel_open == 0)
				to_chat(user, "\The [src] emits a buzzing noise, the panel staying locked in.")
			if(panel_open == 1)
				panel_open = 0
				to_chat(user, "You screw the control panel of \the [src] back on.")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			flick("lock", src)
		return TRUE

	if(panel_open && isMultitool(O) || isWirecutter(O))
		return attack_hand(user)

	if(extended)
		if(istype(O, /obj/item/disk/nuclear))
			if(!user.unEquip(O, src))
				return TRUE
			auth = O
			return attack_hand(user)

	if(anchored)
		switch(removal_stage)
			if(0)
				if(isWelder(O))
					var/obj/item/weldingtool/WT = O
					if(!WT.can_use(5, user))
						return TRUE

					user.visible_message(
						SPAN_NOTICE("\The [user] starts cutting loose the anchoring bolt covers on \the [src]."),
						SPAN_NOTICE("You start cutting loose the anchoring bolt covers on \the [src] with \the [O].")
					)

					if(do_after(user, (O.toolspeed * 4) SECONDS, src, DO_REPAIR_CONSTRUCT))
						if(!src || !user || !WT.remove_fuel(5, user)) return TRUE
						user.visible_message(
							SPAN_NOTICE("\The [user] cuts through the bolt covers on \the [src]."),
							SPAN_NOTICE("You cut through the bolt covers on \the [src].")
						)
						removal_stage = 1
					return TRUE

			if(1)
				if(isCrowbar(O))
					user.visible_message(
						SPAN_NOTICE("\The [user] starts forcing open the bolt covers on \the [src]."),
						SPAN_NOTICE("You start forcing open the anchoring bolt covers on \the [src] with \the [O].")
					)

					if(do_after(user, (O.toolspeed * 1.5) SECONDS, src, DO_REPAIR_CONSTRUCT))
						if(!src || !user) return TRUE
						user.visible_message(
							SPAN_NOTICE("\The [user] forces open the bolt covers on \the [src]."),
							SPAN_NOTICE("You force open the bolt covers.")
						)
						removal_stage = 2
					return TRUE

			if(2)
				if(isWelder(O))
					var/obj/item/weldingtool/WT = O
					if(!WT.can_use(5, user))
						return TRUE

					user.visible_message(
						SPAN_NOTICE("\The [user] starts cutting apart the anchoring system sealant on \the [src]."),
						SPAN_NOTICE("You start cutting apart the anchoring system's sealant on \the [src] with \the [O].")
					)

					if(do_after(user, (O.toolspeed * 4) SECONDS, src, DO_REPAIR_CONSTRUCT))
						if(!src || !user || !WT.remove_fuel(5, user)) return TRUE
						user.visible_message(
							SPAN_NOTICE("\The [user] cuts apart the anchoring system sealant on \the [src]."),
							SPAN_NOTICE("You cut apart the anchoring system's sealant.")
						)
						removal_stage = 3
					return TRUE

			if(3)
				if(isWrench(O))
					user.visible_message(
						SPAN_NOTICE("\The [user] begins unwrenching the anchoring bolts on \the [src]."),
						SPAN_NOTICE("You begin unwrenching the anchoring bolts on \the [src].")
					)
					if(do_after(user, (O.toolspeed * 5) SECONDS, src, DO_REPAIR_CONSTRUCT))
						if(!src || !user) return TRUE
						user.visible_message("[user] unwrenches the anchoring bolts on [src].", "You unwrench the anchoring bolts.")
						removal_stage = 4
					return TRUE

			if(4)
				if(isCrowbar(O))
					user.visible_message(
						SPAN_NOTICE("\The [user] begins lifting \the [src] off of its anchors."),
						SPAN_NOTICE("You begin lifting \the [src] off its anchors.")
						)
					if(do_after(user, (O.toolspeed * 8) SECONDS, src, DO_REPAIR_CONSTRUCT))
						if(!src || !user) return TRUE
						user.visible_message(
							SPAN_NOTICE("\The [user] crowbars \the [src] off of the anchors. It can now be moved."),
							SPAN_NOTICE("You jam the crowbar under \the [src] and lift it off its anchors. You can now move it!")
						)
						anchored = FALSE
						removal_stage = 5
					return TRUE
	return ..()

/obj/machinery/nuclearbomb/physical_attack_hand(mob/user)
	if(!extended && deployable)
		. = TRUE
		if(removal_stage < 5)
			src.anchored = TRUE
			visible_message(SPAN_WARNING("With a steely snap, bolts slide out of [src] and anchor it to the flooring!"))
		else
			visible_message(SPAN_WARNING("\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut."))
		extended = 1
		if(!src.lighthack)
			flick("lock", src)
			update_icon()

/obj/machinery/nuclearbomb/interface_interact(mob/user as mob)
	if(extended && !panel_open)
		ui_interact(user)
		return TRUE

/obj/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[0]
	data["evacuate"] = evacuate
	data["hacking"] = 0
	data["auth"] = is_auth(user)
	data["is_regular_nuke"] = !istype(src, /obj/machinery/nuclearbomb/station)
	if(is_auth(user))
		if(yes_code)
			data["authstatus"] = timing ? "Functional/Set" : "Functional"
		else
			data["authstatus"] = "Auth. S2"
	else
		if(timing)
			data["authstatus"] = "Set"
		else
			data["authstatus"] = "Auth. S1"
	data["safe"] = safety ? "Safe" : "Engaged"
	data["time"] = timing ? round((timeleft - world.time)/10, 1) : round(timeleft/10, 1)
	data["timer"] = timing
	data["safety"] = safety
	data["anchored"] = anchored
	data["yescode"] = yes_code
	data["message"] = "AUTH"
	if(is_auth(user))
		data["message"] = code
		if(yes_code)
			data["message"] = "*****"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "nuclear_bomb.tmpl", "Nuke Control Panel", 300, 510)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/nuclearbomb/verb/toggle_deployable()
	set category = "Object"
	set name = "Toggle Deployable"
	set src in oview(1)

	if(usr.incapacitated())
		return

	if(deployable)
		to_chat(usr, SPAN_WARNING("You close several panels to make [src] undeployable."))
		deployable = 0
	else
		to_chat(usr, SPAN_WARNING("You adjust some panels to make [src] deployable."))
		deployable = 1
	return

/obj/machinery/nuclearbomb/proc/is_auth(mob/user)
	if(auth)
		return 1
	if(user.can_admin_interact())
		return 1
	return 0

/obj/machinery/nuclearbomb/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["auth"])
		if(auth)
			auth.forceMove(loc)
			yes_code = 0
			auth = null
		else
			var/obj/item/I = usr.get_active_hand()
			if(istype(I, /obj/item/disk/nuclear))
				if(!usr.unEquip(I, src))
					return 1
				auth = I
	if(is_auth(usr))
		if(href_list["type"])
			if(href_list["type"] == "E")
				if(code == r_code)
					yes_code = 1
					code = null
					log_and_message_admins("has armed \the [src]")
				else
					code = "ERROR"
			else
				if(href_list["type"] == "R")
					yes_code = 0
					code = null
				else
					lastentered = text("[]", href_list["type"])
					if(isnull(text2num_or_default(lastentered)))
						log_and_message_admins("tried to exploit a nuclear bomb by entering non-numerical codes")
					else
						code += lastentered
						if(length(code) > 5)
							code = "ERROR"
		if(yes_code)
			if(href_list["time"])
				if(timing)
					to_chat(usr, SPAN_WARNING("Cannot alter the timing during countdown."))
					return

				var/time = text2num(href_list["time"]) SECONDS
				timeleft += time
				timeleft = clamp(timeleft, minTime, maxTime)
			if(href_list["timer"])
				if(timing == -1)
					return 1
				if(!anchored)
					to_chat(usr, SPAN_WARNING("\The [src] needs to be anchored."))
					return 1
				if(safety)
					to_chat(usr, SPAN_WARNING("The safety is still on."))
					return 1
				if(wires.IsIndexCut(NUCLEARBOMB_WIRE_TIMING))
					to_chat(usr, SPAN_WARNING("Nothing happens, something might be wrong with the wiring."))
					return 1
				if(!timing && !safety)
					start_bomb()
				else
					secure_device()
			if(href_list["safety"])
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_SAFETY))
					to_chat(usr, SPAN_WARNING("Nothing happens, something might be wrong with the wiring."))
					return 1
				safety = !safety
				if(safety)
					secure_device()
				update_icon()
			if(href_list["evacuate"])
				if(timing)
					to_chat(usr, SPAN_WARNING("Cannot alter evacuation during countdown."))
					return
				evacuate = !evacuate
			if(href_list["anchor"])
				if(removal_stage == 5)
					anchored = FALSE
					visible_message(SPAN_WARNING("\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut."))
					return 1

				if(!isinspace())
					anchored = !anchored
					if(anchored)
						visible_message(SPAN_WARNING("With a steely snap, bolts slide out of \the [src] and anchor it to the flooring."))
					else
						secure_device()
						visible_message(SPAN_WARNING("The anchoring bolts slide back into the depths of \the [src]."))
				else
					to_chat(usr, SPAN_WARNING("There is nothing to anchor to!"))
	return 1

/obj/machinery/nuclearbomb/proc/start_bomb()
	timeleft += world.time
	timing = 1
	log_and_message_admins("activated the detonation countdown of \the [src]")
	bomb_set++ //There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	original_level = security_state.current_security_level
	security_state.set_security_level(security_state.severe_security_level, TRUE)
	update_icon()

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timing <= 0)
		return
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	security_state.set_security_level(original_level, TRUE)
	bomb_set--
	safety = TRUE
	timing = 0
	timeleft = clamp(timeleft - world.time, minTime, maxTime)
	update_icon()

/obj/machinery/nuclearbomb/ex_act(severity)
	return

#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/explode()
	if (safety)
		timing = 0
		return
	timing = -1
	yes_code = 0
	safety = 1
	update_icon()

	SetUniversalState(/datum/universal_state/nuclear_explosion, arguments=list(src))

/obj/machinery/nuclearbomb/on_update_icon()
	if(lighthack)
		icon_state = "idle"
	else if(timing == -1)
		icon_state = "exploding"
	else if(timing)
		icon_state = "urgent"
	else if(extended || !safety)
		icon_state = "greenlight"
	else
		icon_state = "idle"

//====The nuclear authentication disc====
/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY


/obj/item/disk/nuclear/Initialize()
	. = ..()
	nuke_disks |= src
	// Can never be quite sure that a game mode has been properly initiated or not at this point, so always register
	GLOB.moved_event.register(src, src, /obj/item/disk/nuclear/proc/check_z_level)

/obj/item/disk/nuclear/proc/check_z_level()
	if(!(istype(SSticker.mode, /datum/game_mode/nuclear)))
		GLOB.moved_event.unregister(src, src, /obj/item/disk/nuclear/proc/check_z_level) // However, when we are certain unregister if necessary
		return
	var/turf/T = get_turf(src)
	if(!T || isNotStationLevel(T.z))
		qdel(src)

/obj/item/disk/nuclear/Destroy()
	GLOB.moved_event.unregister(src, src, /obj/item/disk/nuclear/proc/check_z_level)
	nuke_disks -= src
	if(!length(nuke_disks))
		var/turf/T = pick_area_turf(/area/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
		if(T)
			var/obj/D = new /obj/item/disk/nuclear(T)
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).", user = null, location = T)
		else
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Failed to respawn disc!", user = null)
	return ..()

//====the nuclear football (holds the disk and instructions)====
/obj/item/storage/secure/briefcase/nukedisk
	desc = "A large briefcase with a digital locking system."
	startswith = list(
		/obj/item/disk/nuclear,
		/obj/item/pinpointer,
		/obj/item/folder/envelope/nuke_instructions,
		/obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	)

/obj/item/storage/secure/briefcase/nukedisk/examine(mob/user)
	. = ..()
	to_chat(user,"On closer inspection, you see \a [GLOB.using_map.company_name] emblem is etched into the front of it.")

/obj/item/folder/envelope/nuke_instructions
	name = "instructions envelope"
	desc = "A small envelope. The label reads 'open only in event of high emergency'."

/obj/item/folder/envelope/nuke_instructions/Initialize()
	. = ..()
	var/obj/item/paper/R = new(src)
	R.set_content("<center><img src=sollogo.png><br><br>\
	<b>Warning: Classified<br>[GLOB.using_map.station_name] Self-Destruct System - Instructions</b></center><br><br>\
	In the event of a Delta-level emergency, this document will guide you through the activation of the vessel's \
	on-board nuclear self-destruct system. Please read carefully.<br><br>\
	1) (Optional) Announce the imminent activation to any surviving crew members, and begin evacuation procedures.<br>\
	2) Notify two heads of staff, both with ID cards with access to the ship's Keycard Authentication Devices.<br>\
	3) Proceed to the self-destruct chamber, located on Deck One by the stairwell.<br>\
	4) Unbolt the door and enter the chamber.<br>\
	5) Both heads of staff should stand in front of their own Keycard Authentication Devices. On the KAD interface, select \
	Grant Nuclear Authentication Code. Both heads of staff should then swipe their ID cards simultaneously.<br>\
	6) The KAD will now display the Authentication Code. Memorize this code.<br>\
	7) Insert the nuclear authentication disk into the self-destruct terminal.<br>\
	8) Enter the code into the self-destruct terminal.<br>\
	9) Authentication procedures are now complete. Open the two cabinets containing the nuclear cylinders. They are \
	located on the back wall of the chamber.<br>\
	10) Place the cylinders upon the six nuclear cylinder inserters.<br>\
	11) Activate the inserters. The cylinders will be pulled down into the self-destruct system.<br>\
	12) Return to the terminal. Enter the desired countdown time.<br>\
	13) When ready, disable the safety switch.<br>\
	14) Start the countdown.<br><br>\
	This concludes the instructions.", "vessel self-destruct instructions")

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-hos"
	R.stamped += /obj/item/stamp
	R.AddOverlays(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped as 'Top Secret'.</i>"

//====vessel self-destruct system====
/obj/machinery/nuclearbomb/station
	name = "self-destruct terminal"
	desc = "For when it all gets too much to bear. Do not taunt."
	icon = 'icons/obj/machines/nuke_station.dmi'
	anchored = TRUE
	deployable = 1
	extended = 1

	var/list/inserters = list()
	var/last_turf_state

	var/announced = FALSE
	var/time_to_explosion = 0
	var/self_destruct_cutoff = 60 SECONDS
	timeleft = 300 SECONDS
	minTime = 300 SECONDS
	maxTime = 900 SECONDS

/obj/machinery/nuclearbomb/station/Initialize()
	..()
	verbs -= /obj/machinery/nuclearbomb/verb/toggle_deployable
	for(var/obj/machinery/self_destruct/ch in get_area(src))
		inserters += ch
	return INITIALIZE_HINT_LATELOAD


/obj/machinery/nuclearbomb/station/LateInitialize(mapload, ...)
	// Relies on turfs to have their `flooring` var set, which is done during init.
	queue_icon_update()

/obj/machinery/nuclearbomb/station/Topic(href, href_list)
	if((. = ..()))
		return

	if(href_list["anchor"])
		return

/obj/machinery/nuclearbomb/station/start_bomb()
	for(var/inserter in inserters)
		var/obj/machinery/self_destruct/sd = inserter
		if(!istype(sd) || !sd.armed)
			to_chat(usr, SPAN_WARNING("An inserter has not been armed or is damaged."))
			return
	..()
	visible_message(SPAN_WARNING("Warning. The self-destruct sequence override will be disabled [self_destruct_cutoff/10] seconds before detonation."))
	if(evacuate)
		if(!evacuation_controller)
			visible_message(SPAN_DANGER("Warning. Unable to initiate evacuation procedures."))
			return
		for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
			if(EO.abandon_ship)
				evacuation_controller.evac_prep_delay = timeleft - world.time - 2 MINUTES
				evacuation_controller.evac_launch_delay = 1.75 MINUTES //Escape pods take time to arm and eject appart from this delay. Take into account.
				evacuation_controller.handle_evac_option(EO.option_target, usr)

/obj/machinery/nuclearbomb/station/secure_device()
	if(timing && timeleft - world.time <= self_destruct_cutoff)
		visible_message(SPAN_WARNING("Self-Destruct abort is no longer possible."))
		return
	..()
	announced = FALSE
	for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
		if(EO.option_target == "cancel_abandon_ship")
			evacuation_controller.handle_evac_option(EO.option_target, usr)
			evacuation_controller.evac_prep_delay = 5 MINUTES
			evacuation_controller.evac_launch_delay = 3 MINUTES

/obj/machinery/nuclearbomb/station/Process()
	..()
	if(timing && timeleft - world.time > 0 && GAME_STATE < RUNLEVEL_POSTGAME)
		if(timeleft - world.time <= self_destruct_cutoff)
			if(!announced)
				priority_announcement.Announce("The self-destruct sequence has reached terminal countdown, abort systems have been disabled.", "Self-Destruct Control Computer")
				announced = TRUE
			if(world.time >= time_to_explosion)
				var/range
				if(timeleft - world.time <= (self_destruct_cutoff/2))
					range = rand(14, 21)
					time_to_explosion = world.time + 2 SECONDS
				else
					range = rand(9, 16)
					time_to_explosion = world.time + 5 SECONDS
				var/turf/T = pick_area_and_turf(GLOB.is_station_but_not_space_or_shuttle_area)
				explosion(T, range)

/obj/machinery/nuclearbomb/station/on_update_icon()
	var/target_icon_state
	var/turf_color = COLOR_BLACK
	if(lighthack)
		target_icon_state = "rcircuit_off"
		icon_state = "idle"
	else if(timing == -1)
		target_icon_state = "rcircuitanim"
		icon_state = "exploding"
		turf_color = COLOR_RED
	else if(timing)
		target_icon_state = "rcircuitanim"
		icon_state = "urgent"
		turf_color = COLOR_RED
	else if(!safety)
		target_icon_state = "rcircuit"
		icon_state = "greenlight"
		turf_color = COLOR_RED
	else
		target_icon_state = "rcircuit_off"
		icon_state = "idle"

	if(!last_turf_state || target_icon_state != last_turf_state)
		for (var/turf/simulated/floor/floor in get_area(src))
			if (istype(floor.flooring, /singleton/flooring/reinforced/circuit/selfdestruct))
				floor.icon_state = target_icon_state
				floor.set_light(l_color = turf_color)
		last_turf_state = target_icon_state
