#define FIREDOOR_MAX_PRESSURE_DIFF 25 // kPa
#define FIREDOOR_MAX_TEMP 50 // °C
#define FIREDOOR_MIN_TEMP 0

// Bitflags
#define FIREDOOR_ALERT_HOT      1
#define FIREDOOR_ALERT_COLD     2

/obj/machinery/door/firedoor
	name = "emergency shutter"
	desc = "An emergency air-tight shutter, capable of sealing off breached areas."
	icon = 'icons/obj/doors/hazard/door.dmi'
	var/panel_file = 'icons/obj/doors/hazard/panel.dmi'
	var/welded_file = 'icons/obj/doors/hazard/welded.dmi'
	icon_state = "open"
	req_access = list(list(access_atmospherics, access_engine_equip))
	autoset_access = FALSE
	opacity = FALSE
	density = FALSE
	layer = BELOW_DOOR_LAYER
	open_layer = BELOW_DOOR_LAYER
	closed_layer = ABOVE_WINDOW_LAYER
	movable_flags = MOVABLE_FLAG_Z_INTERACT
	pry_mod = 0.75
	atom_flags = ATOM_FLAG_ADJACENT_EXCEPTION
	var/locked = FALSE //If the door is forced open, it will not close again until the next atmosphere alert in the area

	//These are frequently used with windows, so make sure zones can pass.
	//Generally if a firedoor is at a place where there should be a zone boundery then there will be a regular door underneath it.
	block_air_zones = FALSE

	var/blocked = FALSE // Whether or not the door is welded shut.
	var/lockdown = FALSE // When the door has detected a problem, it locks.
	var/closing = FALSE
	var/hatch_open = FALSE

	var/pdiff = 0 // Pressure differential. Set to the difference between highest and lowest adjacent pressures in Process()
	var/pdiff_alert = FALSE // If this firedoor has an active alert for pressure differential.

	var/nextstate = null
	var/net_id
	var/list/areas_added
	var/list/users_to_open = new
	var/next_process_time = 0
	var/open_sound = 'sound/machines/blastdoor_open.ogg'
	var/close_sound = 'sound/machines/blastdoor_close.ogg'

	power_channel = ENVIRON
	idle_power_usage = 5

	var/list/tile_info[4]
	var/list/dir_alerts[4] // 4 dirs, bitflags

	turf_hand_priority = 2 //Lower priority than normal doors to prevent interference

	// MUST be in same order as FIREDOOR_ALERT_*
	var/list/ALERT_STATES=list(
		"hot",
		"cold"
	)

	blend_objects = list(/obj/machinery/door/firedoor, /obj/structure/wall_frame, /turf/unsimulated/wall, /obj/structure/window) // Objects which to blend with

/obj/machinery/door/firedoor/autoset
	autoset_access = TRUE	//subtype just to make mapping away sites with custom access usage
	req_access = list()

/obj/machinery/door/firedoor/Initialize()
	. = ..()
	for(var/obj/machinery/door/firedoor/F in loc)
		if(F != src)
			return INITIALIZE_HINT_QDEL
	var/area/A = get_area(src)
	ASSERT(istype(A))

	LAZYADD(A.all_doors, src)
	areas_added = list(A)

	for(var/direction in GLOB.cardinal)
		A = get_area(get_step(src,direction))
		if(istype(A) && !(A in areas_added))
			LAZYADD(A.all_doors, src)
			areas_added += A

/obj/machinery/door/firedoor/Destroy()
	for(var/area/A in areas_added)
		LAZYREMOVE(A.all_doors, src)
	. = ..()

/obj/machinery/door/firedoor/get_material()
	return SSmaterials.get_material_by_name(MATERIAL_STEEL)

/obj/machinery/door/firedoor/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if(locked)
		to_chat(user, SPAN_WARNING("A light on the control mechanism is flashing red, indicating it is locked open."))
	if(!density)
		return

	if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
		to_chat(user, SPAN_WARNING("WARNING: Current pressure differential is [pdiff] kPa! Opening door may result in injury!"))
	to_chat(user, "<b>Sensor readings:</b>")
	for(var/index = 1; index <= tile_info.len; index++)
		var/o = "&nbsp;&nbsp;"
		switch(index)
			if(1)
				o += "NORTH: "
			if(2)
				o += "SOUTH: "
			if(3)
				o += "EAST: "
			if(4)
				o += "WEST: "
		if(tile_info[index] == null)
			o += SPAN_WARNING("DATA UNAVAILABLE")
			to_chat(user, o)
			continue
		var/celsius = convert_k2c(tile_info[index][1])
		var/pressure = tile_info[index][2]
		o += "<span class='[(dir_alerts[index] & (FIREDOOR_ALERT_HOT|FIREDOOR_ALERT_COLD)) ? "warning" : "color:blue"]'>"
		o += "[celsius]&deg;C</span> "
		o += "<span style='color:blue'>"
		o += "[pressure]kPa</span></li>"
		to_chat(user, o)
	if(islist(users_to_open) && users_to_open.len)
		var/users_to_open_string = users_to_open[1]
		if(users_to_open.len >= 2)
			for(var/i = 2 to users_to_open.len)
				users_to_open_string += ", [users_to_open[i]]"
		to_chat(user, "These people have opened \the [src] during an alert: [users_to_open_string].")

/obj/machinery/door/firedoor/Bumped(atom/AM)
	if(p_open || operating)
		return
	if(!density)
		return ..()
	return 0

/obj/machinery/door/firedoor/proc/get_alarm()
	for(var/area/A in areas_added) //Checks if there are fire alarms in any areas associated with that firedoor
		if(A.fire || A.air_doors_activated)
			return TRUE
	return FALSE

/obj/machinery/door/firedoor/attack_generic(var/mob/user, var/damage)
	playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
	if(stat & BROKEN)
		qdel(src)
	..()

/obj/machinery/door/firedoor/attack_hand(mob/user)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(blocked)
		to_chat(user, SPAN_WARNING("\The [src] is welded shut!"))
		return
	if(density && (stat & (BROKEN|NOPOWER))) //can still close without power
		to_chat(user, "\The [src] is not functioning - you'll have to force it open manually.")
		return

	var/alarmed = lockdown
	alarmed = get_alarm()

	var/answer = alert(user, "Would you like to [density ? "open" : "close"] this [name]?[ alarmed && density ? "\nNote that by doing so, you acknowledge any damages from opening this\n[name] as being your own fault, and you will be held accountable under the law." : ""]",\
	"\The [src]", "Yes, [density ? "open" : "close"]", "No")
	if(answer == "No")
		return
	if(user.incapacitated() || !user.Adjacent(src) && !issilicon(user))
		to_chat(user, SPAN_WARNING("You must remain able-bodied and close to \the [src] in order to use it."))
		return
	if(alarmed && density && lockdown && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied. Please wait for authorities to arrive, or for the alert to clear."))
		return
	else
		user.visible_message(
			SPAN_NOTICE("\The [src] [density ? "open" : "close"]s for \the [user]."),
			SPAN_NOTICE("\The [src] [density ? "open" : "close"]s."),
			SPAN_ITALIC("You hear a soft beep, and a door sliding [density ? "open" : "shut"].")
		)
		playsound(loc, 'sound/piano/A#6.ogg', 50)

	var/needs_to_close = 0
	if(density)
		if(alarmed)
			// Accountability!
			users_to_open |= user.name
			needs_to_close = !issilicon(user)
		spawn()
			open()
	else
		spawn()
			locked = FALSE
			close()

	if(needs_to_close)
		addtimer(CALLBACK(src, .proc/attempt_autoclose), 10 SECONDS) //Just in case a fire alarm is turned off while the firedoor is going through an autoclose cycle

/obj/machinery/door/firedoor/attackby(obj/item/C, mob/user)
	add_fingerprint(user, 0, C)
	if(operating)
		return //Already doing something.

	if(isWelder(C) && !repairing)
		var/obj/item/weldingtool/W = C
		if(W.remove_fuel(0, user))
			user.visible_message(
				SPAN_WARNING("\The [user] starts [!blocked ? "welding \the [src] shut" : "cutting open \the [src]"]."),
				SPAN_DANGER("You start [!blocked ? "welding \the [src] closed" : "cutting open \the [src]"]."),
				SPAN_ITALIC("You hear welding.")
			)
			playsound(loc, 'sound/items/Welder.ogg', 50, TRUE)
			if(do_after(user, 2 SECONDS, src))
				if(!W.isOn())
					return
				blocked = !blocked
				user.visible_message(
					SPAN_DANGER("\The [user] [blocked ? "welds \the [src] shut" : "cuts open \the [src]"]."),
					SPAN_DANGER("You [blocked ? "weld shut" : "undo the welds on"] \the [src]."),
					SPAN_ITALIC("You hear welding.")
				)
				playsound(loc, 'sound/items/Welder2.ogg', 50, TRUE)
				update_icon()
				return

	if(density && isScrewdriver(C))
		hatch_open = !hatch_open
		user.visible_message(
			SPAN_NOTICE("\The [user] [hatch_open ? "opens" : "closes"] \the [src]'s maintenance hatch."),
			SPAN_NOTICE("You [hatch_open ? "open" : "close"] \the [src]'s maintenance hatch."),
			SPAN_ITALIC("You hear screws being adjusted.")
		)
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, TRUE)
		update_icon()
		return

	if(blocked && isCrowbar(C) && !repairing)
		if(!hatch_open)
			to_chat(user, SPAN_DANGER("You must open the maintenance hatch first!"))
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] starts removing \the [src]'s electronics."),
				SPAN_NOTICE("You start levering out \the [src]'s electronics."),
				SPAN_ITALIC("You hear metal bumping against metal.")
			)
			playsound(loc, 'sound/items/Crowbar.ogg', 100, TRUE)
			if(do_after(user, 30, src))
				if(blocked && density && hatch_open)
					playsound(loc, 'sound/items/Deconstruct.ogg', 100, TRUE)
					user.visible_message(
						SPAN_NOTICE("\The [user] removes the electronics from \the [src]!"),
						SPAN_NOTICE("You pry out \the [src]'s circuit board."),
						SPAN_ITALIC("You hear metal coming loose and clattering.")
					)
					deconstruct(user)
		return

	if(blocked)
		to_chat(user, SPAN_DANGER("\The [src] is welded shut!"))
		return

	if(isCrowbar(C) || istype(C,/obj/item/material/twohanded/fireaxe))
		if(operating)
			return

		if(blocked && isCrowbar(C))
			user.visible_message(
				SPAN_WARNING("\The [user] pries at \the [src], but it's stuck in place!"),
				SPAN_WARNING("You try to pry \the [src] [density ? "open" : "closed"], but it's been welded in place!"),
				SPAN_WARNING("You hear the unhappy sound of metal straining and groaning.")
			)
			return

		if(istype(C,/obj/item/material/twohanded/fireaxe))
			var/obj/item/material/twohanded/fireaxe/F = C
			if(!F.wielded)
				return

		user.visible_message(
			SPAN_WARNING("\The [user] wedges \the [C] into \the [src] and starts forcing it [density ? "open" : "closed"]!"),
			SPAN_DANGER("You start forcing \the [src] [density ? "open" : "shut"]."),
			SPAN_WARNING("You hear metal groaning and grinding!")
		)
		playsound(loc, 'sound/machines/airlock_creaking.ogg', 100, TRUE)
		if(do_after(user, 30, src))
			if(isCrowbar(C))
				if(stat & (BROKEN|NOPOWER) || !density)
					user.visible_message(
						SPAN_DANGER("\The [user] pries \the [src] [density ? "open" : "shut"]!"),
						SPAN_DANGER("You force [density ? "open" : "shut"] \the [src]!"),
						SPAN_WARNING("You hear metal groan as a door is forced [density ? "open" : "closed"]!")
					)
				else
					user.visible_message(
						SPAN_DANGER("\The [user] forces \the [src] [density ? "open" : "shut"]!"),
						SPAN_DANGER("You force [density ? "open" : "shut"] \the [src]!"),
						SPAN_WARNING("You hear metal shrieking as a door is forced [density ? "open" : "closed"]!")
					)
			if(density)
				spawn(0)
					open(TRUE)
					if(lockdown || get_alarm())
						locked = TRUE
			else
				spawn(0)
					locked = FALSE
					close()
			return
	return ..()

/obj/machinery/door/firedoor/deconstruct(mob/user, var/moved = FALSE)
	if (stat & BROKEN)
		new /obj/item/stock_parts/circuitboard/broken(loc)
	else
		new/obj/item/airalarm_electronics(loc)

	var/obj/structure/firedoor_assembly/FA = new/obj/structure/firedoor_assembly(loc)
	FA.anchored = !moved
	FA.set_density(TRUE)
	FA.wired = TRUE
	FA.update_icon()
	qdel(src)

	return FA

// CHECK PRESSURE
/obj/machinery/door/firedoor/Process()
	if(density && next_process_time <= world.time)
		next_process_time = world.time + 100		// 10 second delays between process updates
		var/changed = 0
		lockdown = FALSE
		// Pressure alerts

		pdiff = getOPressureDifferential(loc)
		if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
			lockdown = TRUE
			if(!pdiff_alert)
				pdiff_alert = TRUE
				changed = TRUE
		else
			if(pdiff_alert)
				pdiff_alert = FALSE
				changed = TRUE

		tile_info = getCardinalAirInfo(loc,list("temperature", "pressure"))
		var/old_alerts = dir_alerts
		for(var/index = 1; index <= 4; index++)
			var/list/tileinfo = tile_info[index]
			if(tileinfo == null)
				continue // Bad data.
			var/celsius = convert_k2c(tileinfo[1])

			var/alerts = 0

			// Temperatures
			if(celsius >= FIREDOOR_MAX_TEMP)
				alerts |= FIREDOOR_ALERT_HOT
				lockdown = TRUE
			else if(celsius <= FIREDOOR_MIN_TEMP)
				alerts |= FIREDOOR_ALERT_COLD
				lockdown = TRUE

			dir_alerts[index]=alerts

		if(dir_alerts != old_alerts)
			changed = TRUE
		if(changed)
			update_icon()

/obj/machinery/door/firedoor/proc/latetoggle()
	if(operating || !nextstate)
		return
	switch(nextstate)
		if(FIREDOOR_OPEN)
			nextstate = null
			open()
		if(FIREDOOR_CLOSED)
			nextstate = null
			close()
	return

/obj/machinery/door/firedoor/close()
	if(closing || locked)
		return

	closing = TRUE
	latetoggle()
	var/list/people = list()
	for(var/turf/turf in locs)
		for(var/mob/living/M in turf)
			people += M
	if(length(people))
		visible_message(
			SPAN_DANGER("\The [src] beeps ominously, get out of the way!"),
			SPAN_DANGER("You hear buzzing coming from the ceiling."),
			range = 3
		)
		playsound(loc, "sound/machines/firedoor.ogg", 50)
		sleep(2 SECONDS)
		for(var/turf/turf in locs)
			for(var/mob/living/M in turf)
				var/direction
				for(var/d in GLOB.cardinal)
					var/turf/T = get_step(src, d)
					var/area/A = get_area(T)
					if(istype(A) && !A.atmosalm && !turf_contains_dense_objects(T))
						direction = d
					if(!direction)
						T = get_step_away(src, d)
						A = get_area(T)
						if(istype(A) && !A.atmosalm && !turf_contains_dense_objects(T))
							direction = d
				if(!direction) //Let's try again but this time ignore atmos alarms
					for(var/d in GLOB.cardinal)
						var/turf/T = get_step(src, d)
						var/area/A = get_area(T)
						if(istype(A) && !turf_contains_dense_objects(T))
							direction = d
						if(!direction)
							T = get_step_away(src, d)
							A = get_area(T)
							if(istype(A) && !turf_contains_dense_objects(T))
								direction = d

				M.visible_message(
					SPAN_DANGER("\The [src] knocks \the [M] out of the way!"),
					SPAN_DANGER("\The [src] forcefully shoves you out of the way!"),
					SPAN_WARNING("You hear metal smacking into something.")
				)
				M.apply_damage(10, BRUTE, used_weapon = src)
				if(direction)
					M.Move(get_step(src, direction))
	playsound(loc, close_sound, 25, TRUE)
	closing = FALSE
	return ..()

/obj/machinery/door/firedoor/open(var/forced = FALSE)
	if(hatch_open)
		hatch_open = FALSE
		visible_message(SPAN_NOTICE("\The [src]'s maintenance hatch falls shut as it moves."))
		update_icon()

	if(!forced)
		if(stat & (BROKEN|NOPOWER))
			return //needs power to open unless it was forced
		else
			use_power_oneoff(360)
	else
		log_and_message_admins("has forced open an emergency shutter.")
	latetoggle()
	playsound(loc, open_sound, 25, TRUE)
	return ..()

// Called ten seconds after a firedoor is opened manually during an active alert, to prevent it staying open for long.
/obj/machinery/door/firedoor/proc/attempt_autoclose()
	if(!density && get_alarm())
		nextstate = FIREDOOR_CLOSED
		close()

// Only opens when all areas connecting with our turf have an air alarm and are cleared
/obj/machinery/door/firedoor/proc/can_safely_open()
	var/turf/neighbour
	for(var/dir in GLOB.cardinal)
		neighbour = get_step(loc, dir)
		if(neighbour.c_airblock(loc) & AIR_BLOCKED)
			continue
		for(var/obj/O in loc)
			if(istype(O, /obj/machinery/door))
				continue
			. |= O.c_airblock(neighbour)
		if(. & AIR_BLOCKED)
			continue
		var/area/A = get_area(neighbour)
		if(A.atmosalm)
			return
		var/obj/machinery/alarm/alarm = locate() in A
		if(!alarm || (alarm.stat & (NOPOWER|BROKEN)))
			return
	return TRUE

/obj/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
		if("closing")
			flick("closing", src)
	return


/obj/machinery/door/firedoor/on_update_icon()
	var/icon/lights_overlay
	var/icon/panel_overlay
	var/icon/weld_overlay

	overlays.Cut()
	set_light(0)
	var/do_set_light = FALSE

	if(connections in list(NORTH, SOUTH, NORTH|SOUTH))
		if(connections in list(WEST, EAST, EAST|WEST))
			set_dir(SOUTH)
		else
			set_dir(EAST)
	else
		set_dir(SOUTH)

	if(density)
		icon_state = "closed"
		if(hatch_open)
			overlays = panel_overlay
		if(pdiff_alert)
			lights_overlay += "palert"
			do_set_light = TRUE
		if(dir_alerts)
			for(var/d=1; d<=4; d++)
				var/cdir = GLOB.cardinal[d]
				for(var/i=1; i<=ALERT_STATES.len; i++)
					if(dir_alerts[d] & (1 << (i - 1)))
						overlays += new/icon(icon, "alert_[ALERT_STATES[i]]", dir = cdir)
						do_set_light = TRUE
	else
		icon_state = "open"

	if(blocked)
		weld_overlay = welded_file

	if(do_set_light)
		set_light(0.25, 0.1, 1, 2, COLOR_SUN)

	overlays += panel_overlay
	overlays += weld_overlay
	overlays += lights_overlay
