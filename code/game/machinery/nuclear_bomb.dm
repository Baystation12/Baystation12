var/global/bomb_set

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!"
	icon = 'icons/obj/nuke.dmi'
	icon_state = "idle"
	density = TRUE
	use_power = POWER_USE_OFF
	uncreated_component_parts = null
	unacidable = TRUE
	interact_offline = TRUE

	var/deployable = 0
	var/extended = 0
	var/lighthack = 0
	var/timeleft = 120
	var/minTime = 120
	var/maxTime = 600
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

/obj/machinery/nuclearbomb/Process(wait)
	if(timing)
		timeleft = max(timeleft - (wait / 10), 0)
		playsound(loc, 'sound/items/timer.ogg', 50)
		if(timeleft <= 0)
			addtimer(new Callback(src, .proc/explode), 0)
		SSnano.update_uis(src)


/obj/machinery/nuclearbomb/use_tool(obj/item/tool, mob/user, list/click_params)
	// Multitool & Wirecutters - Passthrough to attack_hand for the wire panel
	if (isMultitool(tool) || isWirecutter(tool))
		if (panel_open && attack_hand(user))
			return TRUE

	// Nuclear Authentication Disk - Insert disk
	if (istype(tool, /obj/item/disk/nuclear))
		if (!extended)
			to_chat(user, SPAN_WARNING("\The [src] needs to be anchored before you can insert \the [tool]."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		auth = tool
		attack_hand(user)
		return TRUE // Interaction is handled regardless of the result of attack_hand

	// Screwdriver - Toggle panel
	if (isScrewdriver(tool))
		if (!auth && !panel_open)
			flick("lock", src)
			to_chat(user, SPAN_WARNING("\The [src]'s control panel cover is locked until you insert an authentication disk."))
			return TRUE
		panel_open = !panel_open
		update_icon()
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] [panel_open ? "opens" : "closes"] \the [src]'s control panel with \a [tool]."),
			SPAN_NOTICE("You [panel_open ? "open" : "close"] \the [src]'s control panel with \the [tool].")
		)
		return TRUE

	// Remaining interactions only apply if anchored
	if (!anchored)
		// Feedback message in case someone tries to weld it.
		if (isWelder(tool))
			to_chat(user, SPAN_WARNING("\The [src] isn't anchored."))
			return TRUE
		return ..()

	// Crowbar - Removal steps 2 and 5
	if (isCrowbar(tool))
		var/step_name
		var/next_stage
		switch (removal_stage)
			if (0)
				to_chat(user, SPAN_WARNING("You need to cut \the [src]'s anchoring bolt covers loose before you can pry them open."))
				return TRUE
			if (1)
				step_name = "\the [src]'s anchoring bolt covers open"
				next_stage = 2
			if (2, 3)
				to_chat(user, SPAN_WARNING("You need cut open and unwrench the anchoring bolts before you can pry \the [src] off of them."))
				return TRUE
			if (4)
				step_name = "\the [src] off of the anchoring bolts"
				next_stage = 5
			else
				to_chat(user, SPAN_WARNING("\The [src] has already been pried off its anchoring bolts."))
				return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts prying [step_name] with \a [tool]."),
			SPAN_NOTICE("You start prying [step_name] with \the [tool].")
		)
		if (!do_after(user, 1.5 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		removal_stage = next_stage
		anchored = FALSE
		user.visible_message(
			SPAN_NOTICE("\The [user] pries [step_name] with \a [tool]. It can now be moved!"),
			SPAN_NOTICE("You pry [step_name] with \the [tool]. It can now be moved!")
		)
		return TRUE

	// Welder - Removal steps 1 and 3
	if (isWelder(tool))
		if (removal_stage == -1)
			to_chat(user, SPAN_WARNING("\The [src] can't be removed!"))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(user, 5))
			return TRUE
		var/step_name
		var/next_stage
		switch (removal_stage)
			if (0)
				step_name = "anchoring bolt covers"
				next_stage = 1
			if (1)
				to_chat(user, SPAN_WARNING("You need to open \the [src]'s anchoring bolt covers first."))
				return TRUE
			if (2)
				step_name = "anchoring system sealant"
				next_stage = 3
			else
				to_chat(user, SPAN_WARNING("\The [src] has nothing else to cut with \the [tool]."))
				return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts cutting through \the [src]'s [step_name] with \a [tool]."),
			SPAN_NOTICE("You start cutting through \the [src]'s [step_name] with \the [tool].")
		)
		if (!do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!welder.remove_fuel(5, user))
			return TRUE
		removal_stage = next_stage
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts through \the [src]'s [step_name] with \a [tool]."),
			SPAN_NOTICE("You cut through \the [src]'s [step_name] with \the [tool].")
		)
		return TRUE

	// Wrench - Removal step 4
	if (isWrench(tool))
		if (removal_stage < 3)
			to_chat(user, SPAN_WARNING("You need to open \the [src]'s anchoring bolt cover before you can access the bolts."))
			return TRUE
		if (removal_stage > 3)
			to_chat(user, SPAN_WARNING("\The [src]'s anchoring bolts have already been unwrenched."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts unwrenching \the [src]'s anchoring bolts with \a [tool]."),
			SPAN_NOTICE("You start unwrenching \the [src]'s anchoring bolts with \the [tool].")
		)
		if (!do_after(user, 5 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		removal_stage = 4
		user.visible_message(
			SPAN_NOTICE("\The [user] unwrenches \the [src]'s anchoring bolts with \a [tool]."),
			SPAN_NOTICE("You unwrenches \the [src]'s anchoring bolts with \the [tool].")
		)
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
	data["hacking"] = 0
	data["auth"] = is_auth(user)
	data["moveable_anchor"] = !istype(src, /obj/machinery/nuclearbomb/station)
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
	data["time"] = timeleft
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
					if(text2num(lastentered) == null)
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

				var/time = text2num(href_list["time"])
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
					check_cutoff()
			if(href_list["safety"])
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_SAFETY))
					to_chat(usr, SPAN_WARNING("Nothing happens, something might be wrong with the wiring."))
					return 1
				safety = !safety
				if(safety)
					secure_device()
				update_icon()
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
	timing = 1
	log_and_message_admins("activated the detonation countdown of \the [src]")
	bomb_set++ //There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	original_level = security_state.current_security_level
	security_state.set_security_level(security_state.severe_security_level, TRUE)
	update_icon()

/obj/machinery/nuclearbomb/proc/check_cutoff()
	secure_device()

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timing <= 0)
		return
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	security_state.set_security_level(original_level, TRUE)
	bomb_set--
	safety = TRUE
	timing = 0
	timeleft = clamp(timeleft, minTime, maxTime)
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

	overlays.Cut()
	if (panel_open)
		overlays += "panel_open"

//====The nuclear authentication disc====
/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon = 'icons/obj/items.dmi'
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
	if(!nuke_disks.len)
		var/turf/T = pick_area_turf(/area/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
		if(T)
			var/obj/D = new /obj/item/disk/nuclear(T)
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).", location = T)
		else
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Failed to respawn disc!")
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
	R.overlays += stampoverlay
	R.stamps += "<HR><i>This paper has been stamped as 'Top Secret'.</i>"

//====vessel self-destruct system====
/obj/machinery/nuclearbomb/station
	name = "self-destruct terminal"
	desc = "For when it all gets too much to bear. Do not taunt."
	icon = 'icons/obj/nuke_station.dmi'
	anchored = TRUE
	deployable = 1
	extended = 1
	removal_stage = -1

	var/list/flash_tiles = list()
	var/list/inserters = list()
	var/last_turf_state

	var/announced = 0
	var/time_to_explosion = 0
	var/self_destruct_cutoff = 60 //Seconds
	timeleft = 300
	minTime = 300
	maxTime = 900

/obj/machinery/nuclearbomb/station/Initialize()
	. = ..()
	verbs -= /obj/machinery/nuclearbomb/verb/toggle_deployable
	for(var/turf/simulated/floor/T in get_area(src))
		if(istype(T.flooring, /singleton/flooring/reinforced/circuit/red))
			flash_tiles += T
	update_icon()
	for(var/obj/machinery/self_destruct/ch in get_area(src))
		inserters += ch

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
	visible_message(SPAN_WARNING("Warning. The self-destruct sequence override will be disabled [self_destruct_cutoff] seconds before detonation."))
	..()

/obj/machinery/nuclearbomb/station/check_cutoff()
	if(timeleft <= self_destruct_cutoff)
		visible_message(SPAN_WARNING("Self-Destruct abort is no longer possible."))
		return
	..()

/obj/machinery/nuclearbomb/station/Destroy()
	flash_tiles.Cut()
	return ..()

/obj/machinery/nuclearbomb/station/Process()
	..()
	if(timeleft > 0 && GAME_STATE < RUNLEVEL_POSTGAME)
		if(timeleft <= self_destruct_cutoff)
			if(!announced)
				priority_announcement.Announce("The self-destruct sequence has reached terminal countdown, abort systems have been disabled.", "Self-Destruct Control Computer")
				announced = 1
			if(world.time >= time_to_explosion)
				var/range
				if(timeleft <= (self_destruct_cutoff/2))
					range = rand(14, 21)
					time_to_explosion = world.time + 2 SECONDS
				else
					range = rand(9, 16)
					time_to_explosion = world.time + 5 SECONDS
				var/turf/T = pick_area_and_turf(GLOB.is_station_but_not_space_or_shuttle_area)
				explosion(T, range)

/obj/machinery/nuclearbomb/station/secure_device()
	..()
	announced = 0

/obj/machinery/nuclearbomb/station/on_update_icon()
	var/target_icon_state
	if(lighthack)
		target_icon_state = "rcircuit_off"
		icon_state = "idle"
	else if(timing == -1)
		target_icon_state = "rcircuitanim"
		icon_state = "exploding"
	else if(timing)
		target_icon_state = "rcircuitanim"
		icon_state = "urgent"
	else if(!safety)
		target_icon_state = "rcircuit"
		icon_state = "greenlight"
	else
		target_icon_state = "rcircuit_off"
		icon_state = "idle"

	if(!last_turf_state || target_icon_state != last_turf_state)
		for(var/thing in flash_tiles)
			var/turf/simulated/floor/T = thing
			if(!istype(T.flooring, /singleton/flooring/reinforced/circuit/red))
				flash_tiles -= T
				continue
			T.icon_state = target_icon_state
		last_turf_state = target_icon_state
