
#define FIREDOOR_MAX_PRESSURE_DIFF 25 // kPa
#define FIREDOOR_MAX_TEMP 50 // °C
#define FIREDOOR_MIN_TEMP 0

// Bitflags
#define FIREDOOR_ALERT_HOT      1
#define FIREDOOR_ALERT_COLD     2
// Not used #define FIREDOOR_ALERT_LOWPRESS 4

/obj/machinery/door/firedoor
	name = "\improper Emergency Shutter"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas."
	icon = 'icons/obj/doors/hazard/door.dmi'
	var/panel_file = 'icons/obj/doors/hazard/panel.dmi'
	var/welded_file = 'icons/obj/doors/hazard/welded.dmi'
	icon_state = "open"
	req_access = list(list(access_atmospherics, access_engine_equip))
	autoset_access = FALSE
	opacity = 0
	density = 0
	layer = BELOW_DOOR_LAYER
	open_layer = BELOW_DOOR_LAYER
	closed_layer = ABOVE_WINDOW_LAYER
	movable_flags = MOVABLE_FLAG_Z_INTERACT
	pry_mod = 0.75

	//These are frequenly used with windows, so make sure zones can pass.
	//Generally if a firedoor is at a place where there should be a zone boundery then there will be a regular door underneath it.
	block_air_zones = 0

	var/blocked = 0
	var/lockdown = 0 // When the door has detected a problem, it locks.
	var/pdiff_alert = 0
	var/pdiff = 0
	var/nextstate = null
	var/net_id
	var/list/areas_added
	var/list/users_to_open = new
	var/next_process_time = 0

	var/hatch_open = 0

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
	if(distance > 1 || !density)
		return

	if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
		to_chat(user, "<span class='warning'>WARNING: Current pressure differential is [pdiff]kPa! Opening door may result in injury!</span>")
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
			o += "<span class='warning'>DATA UNAVAILABLE</span>"
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

/obj/machinery/door/firedoor/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(blocked)
		to_chat(user, "<span class='warning'>\The [src] is welded solid!</span>")
		return

	var/alarmed = lockdown
	for(var/area/A in areas_added)		//Checks if there are fire alarms in any areas associated with that firedoor
		if(A.fire || A.air_doors_activated)
			alarmed = 1

	var/answer = alert(user, "Would you like to [density ? "open" : "close"] this [src.name]?[ alarmed && density ? "\nNote that by doing so, you acknowledge any damages from opening this\n[src.name] as being your own fault, and you will be held accountable under the law." : ""]",\
	"\The [src]", "Yes, [density ? "open" : "close"]", "No")
	if(answer == "No")
		return
	var/mob/living/carbon/human/H = locate() in get_turf(src)
	if(H)
		user.visible_message("Someone is blocking the [src]")
		return
	if(user.incapacitated() || (get_dist(src, user) > 1  && !issilicon(user)))
		to_chat(user, "Sorry, you must remain able bodied and close to \the [src] in order to use it.")
		return
	if(density && (stat & (BROKEN|NOPOWER))) //can still close without power
		to_chat(user, "\The [src] is not functioning, you'll have to force it open manually.")
		return
	if(alarmed && density && lockdown && !allowed(user))
		to_chat(user, "<span class='warning'>Access denied. Please wait for authorities to arrive, or for the alert to clear.</span>")
		return
	else
		user.visible_message("<span class='notice'>\The [src] [density ? "open" : "close"]s for \the [user].</span>",\
		"\The [src] [density ? "open" : "close"]s.",\
		"You hear a beep, and a door opening.")

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
			close()

	if(needs_to_close)
		spawn(50)
			alarmed = 0
			for(var/area/A in areas_added)		//Just in case a fire alarm is turned off while the firedoor is going through an autoclose cycle
				if(A.fire || A.air_doors_activated)
					alarmed = 1
			if(alarmed)
				nextstate = FIREDOOR_CLOSED
				close()

/obj/machinery/door/firedoor/attackby(obj/item/weapon/C as obj, mob/user as mob)
	add_fingerprint(user, 0, C)
	if(operating)
		return//Already doing something.
	if(isWelder(C) && !repairing)
		var/obj/item/weapon/weldingtool/W = C
		if(W.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 2 SECONDS, src))
				if(!W.isOn()) return
				blocked = !blocked
				user.visible_message("<span class='danger'>\The [user] [blocked ? "welds" : "unwelds"] \the [src] with \a [W].</span>",\
				"You [blocked ? "weld" : "unweld"] \the [src] with \the [W].",\
				"You hear something being welded.")
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
				update_icon()
				return
			else
				to_chat(user, SPAN_WARNING("You must remain still to complete this task."))
				return

	if(density && isScrewdriver(C))
		hatch_open = !hatch_open
		user.visible_message("<span class='danger'>[user] has [hatch_open ? "opened" : "closed"] \the [src] maintenance hatch.</span>",
									"You have [hatch_open ? "opened" : "closed"] the [src] maintenance hatch.")
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		update_icon()
		return

	if(blocked && isCrowbar(C) && !repairing)
		if(!hatch_open)
			to_chat(user, "<span class='danger'>You must open the maintenance hatch first!</span>")
		else
			user.visible_message("<span class='danger'>[user] is removing the electronics from \the [src].</span>",
									"You start to remove the electronics from [src].")
			if(do_after(user,30,src))
				if(blocked && density && hatch_open)
					playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
					user.visible_message("<span class='danger'>[user] has removed the electronics from \the [src].</span>",
										"You have removed the electronics from [src].")
					deconstruct(user)
			else
				to_chat(user, "<span class='notice'>You must remain still to remove the electronics from \the [src].</span>")
		return

	if(blocked)
		to_chat(user, "<span class='danger'>\The [src] is welded shut!</span>")
		return

	if(isCrowbar(C) || istype(C,/obj/item/weapon/material/twohanded/fireaxe))
		if(operating)
			return

		if(blocked && isCrowbar(C))
			user.visible_message("<span class='danger'>\The [user] pries at \the [src] with \a [C], but \the [src] is welded in place!</span>",\
			"You try to pry \the [src] [density ? "open" : "closed"], but it is welded in place!",\
			"You hear someone struggle and metal straining.")
			return

		if(istype(C,/obj/item/weapon/material/twohanded/fireaxe))
			var/obj/item/weapon/material/twohanded/fireaxe/F = C
			if(!F.wielded)
				return

		user.visible_message("<span class='danger'>\The [user] starts to force \the [src] [density ? "open" : "closed"] with \a [C]!</span>",\
				"You start forcing \the [src] [density ? "open" : "closed"] with \the [C]!",\
				"You hear metal strain.")
		if(do_after(user,30,src))
			if(isCrowbar(C))
				if(stat & (BROKEN|NOPOWER) || !density)
					user.visible_message("<span class='danger'>\The [user] forces \the [src] [density ? "open" : "closed"] with \a [C]!</span>",\
					"You force \the [src] [density ? "open" : "closed"] with \the [C]!",\
					"You hear metal strain, and a door [density ? "open" : "close"].")
				else
					user.visible_message("<span class='danger'>\The [user] forces \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \a [C]!</span>",\
						"You force \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \the [C]!",\
						"You hear metal strain and groan, and a door [density ? "opening" : "closing"].")
			if(density)
				spawn(0)
					open(1)
			else
				spawn(0)
					close()
			return
		else
			to_chat(user, "<span class='notice'>You must remain still to interact with \the [src].</span>")
	return ..()

/obj/machinery/door/firedoor/deconstruct(mob/user, var/moved = FALSE)
	if (stat & BROKEN)
		new /obj/item/weapon/stock_parts/circuitboard/broken(src.loc)
	else
		new/obj/item/weapon/airalarm_electronics(src.loc)

	var/obj/structure/firedoor_assembly/FA = new/obj/structure/firedoor_assembly(src.loc)
	FA.anchored = !moved
	FA.set_density(1)
	FA.wired = 1
	FA.update_icon()
	qdel(src)

	return FA

// CHECK PRESSURE
/obj/machinery/door/firedoor/Process()
	if(density && next_process_time <= world.time)
		next_process_time = world.time + 100		// 10 second delays between process updates
		var/changed = 0
		lockdown=0
		// Pressure alerts
		pdiff = getOPressureDifferential(src.loc)
		if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
			lockdown = 1
			if(!pdiff_alert)
				pdiff_alert = 1
				changed = 1 // update_icon()
		else
			if(pdiff_alert)
				pdiff_alert = 0
				changed = 1 // update_icon()

		tile_info = getCardinalAirInfo(src.loc,list("temperature","pressure"))
		var/old_alerts = dir_alerts
		for(var/index = 1; index <= 4; index++)
			var/list/tileinfo=tile_info[index]
			if(tileinfo==null)
				continue // Bad data.
			var/celsius = convert_k2c(tileinfo[1])

			var/alerts=0

			// Temperatures
			if(celsius >= FIREDOOR_MAX_TEMP)
				alerts |= FIREDOOR_ALERT_HOT
				lockdown = 1
			else if(celsius <= FIREDOOR_MIN_TEMP)
				alerts |= FIREDOOR_ALERT_COLD
				lockdown = 1

			dir_alerts[index]=alerts

		if(dir_alerts != old_alerts)
			changed = 1
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
	// if there are humans on the tile, don't close
	var/mob/living/carbon/human/H = locate() in get_turf(src)
	if(H)
		return

	latetoggle()
	return ..()

/obj/machinery/door/firedoor/open(var/forced = 0)
	if(hatch_open)
		hatch_open = 0
		visible_message("The maintenance hatch of \the [src] closes.")
		update_icon()

	if(!forced)
		if(stat & (BROKEN|NOPOWER))
			return //needs power to open unless it was forced
		else
			use_power_oneoff(360)
	else
		log_and_message_admins("has forced open an emergency shutter.")
	latetoggle()
	return ..()

// Only opens when all areas connecting with our turf have an air alarm and are cleared
/obj/machinery/door/firedoor/proc/can_safely_open()
	var/turf/neighbour
	for(var/dir in GLOB.cardinal)
		neighbour = get_step(src.loc, dir)
		if(neighbour.c_airblock(src.loc) & AIR_BLOCKED)
			continue
		for(var/obj/O in src.loc)
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
			for(var/d=1;d<=4;d++)
				var/cdir = GLOB.cardinal[d]
				for(var/i=1;i<=ALERT_STATES.len;i++)
					if(dir_alerts[d] & (1<<(i-1)))
						overlays += new/icon(icon,"alert_[ALERT_STATES[i]]", dir=cdir)
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
