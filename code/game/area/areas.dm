// Areas.dm

/area
	/// Integer. Global counter for `uid` values assigned to areas. Increments by one for each new area.
	var/static/global_uid = 0

	/// Integer. The area's unique ID number. set to the value of `global_uid` + 1 when the area is created.
	var/uid

	/// Bitflag (Any of `AREA_FLAG_*`). See `code\__defines\misc.dm`.
	var/area_flags

	/// A lazy list of vent pumps currently in the area
	var/list/obj/machinery/atmospherics/unary/vent_pump/vent_pumps

/area/New()
	icon_state = ""
	uid = ++global_uid

	if(!requires_power)
		power_light = 0
		power_equip = 0
		power_environ = 0

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	..()

/area/Initialize()
	. = ..()
	if(!requires_power || !apc)
		power_light = 0
		power_equip = 0
		power_environ = 0
	power_change()		// all machines set to current power level, also updates lighting icon

/area/Destroy()
	..()
	return QDEL_HINT_HARDDEL

// Changes the area of T to A. Do not do this manually.
// Area is expected to be a non-null instance.
/proc/ChangeArea(var/turf/T, var/area/A)
	if(!istype(A))
		CRASH("Area change attempt failed: invalid area supplied.")
	var/area/old_area = get_area(T)
	if(old_area == A)
		return
	A.contents.Add(T)
	if(old_area)
		old_area.Exited(T, A)
		for(var/atom/movable/AM in T)
			old_area.Exited(AM, A)  // Note: this _will_ raise exited events.
	A.Entered(T, old_area)
	for(var/atom/movable/AM in T)
		A.Entered(AM, old_area) // Note: this will _not_ raise moved or entered events. If you change this, you must also change everything which uses them.

	for(var/obj/machinery/M in T)
		M.area_changed(old_area, A) // They usually get moved events, but this is the one way an area can change without triggering one.

/// Returns list (`/obj/machinery/camera`). A list of all cameras in the area.
/area/proc/get_cameras()
	var/list/cameras = list()
	for (var/obj/machinery/camera/C in src)
		cameras += C
	return cameras

/**
 * Defines the area's atmosphere alert level.
 *
 * **Parameters**:
 * - `danger_level` Integer. The new alert danger level to set.
 * - `alarm_source` Atom. The source that's triggering the alert change.
 *
 * Returns boolean. `TRUE` if the atmosphere alarm level was changed, `FALSE` otherwise.
 */
/area/proc/atmosalert(danger_level, var/alarm_source)
	if (danger_level == 0)
		GLOB.atmosphere_alarm.clearAlarm(src, alarm_source)
	else
		GLOB.atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level)

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/obj/machinery/alarm/AA in src)
		if (!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
			danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		if (danger_level < 1 && atmosalm >= 1)
			//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
			air_doors_open()
		else if (danger_level >= 2 && atmosalm < 2)
			air_doors_close()

		atmosalm = danger_level
		for (var/obj/machinery/alarm/AA in src)
			AA.update_icon()

		return 1
	return 0

/// Sets `air_doors_activated` and sets all firedoors in `all_doors` to the closed state. Does nothing if `air_doors_activated` is already set.
/area/proc/air_doors_close()
	if(!air_doors_activated)
		air_doors_activated = 1
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_CLOSED
				else if(!E.density)
					spawn(0)
						E.close()

/// Clears `air_doors_activated` and sets all firedoors in `all_doors` to the open state. Does nothing if `air_doors_activated` is already cleared.
/area/proc/air_doors_open()
	if(air_doors_activated)
		air_doors_activated = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			E.locked = FALSE
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_OPEN
				else if(E.density)
					spawn(0)
						if(E.can_safely_open())
							E.open()


/// Sets a fire alarm in the area, if one is not already active.
/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		update_icon()
		mouse_opacity = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_CLOSED
				else if(!D.density)
					spawn()
						D.close()

/// Clears an active fire alarm from the area.
/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		update_icon()
		mouse_opacity = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/D in all_doors)
			D.locked = FALSE
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					spawn(0)
					D.open()

/// Sets an active evacuation alarm in the area, if one is not already active.
/area/proc/readyalert()
	if(!eject)
		eject = 1
		update_icon()
	return

/// Clears an active evacuation alarm from the area.
/area/proc/readyreset()
	if(eject)
		eject = 0
		update_icon()
	return

/// Sets a party alarm in the area, if one is not already active.
/area/proc/partyalert()
	if (!( party ))
		party = 1
		update_icon()
		mouse_opacity = 0
	return

/// Clears an active party alarm from the area.
/area/proc/partyreset()
	if (party)
		party = 0
		mouse_opacity = 0
		update_icon()
		for(var/obj/machinery/door/firedoor/D in src)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					spawn(0)
					D.open()
	return

/area/on_update_icon()
	if ((fire || eject || party) && (!requires_power||power_environ))//If it doesn't require power, can still activate this proc.
		if(fire && !eject && !party)
			icon_state = "blue"
		/*else if(atmosalm && !fire && !eject && !party)
			icon_state = "bluenew"*/
		else if(!fire && eject && !party)
			icon_state = "red"
		else if(party && !fire && !eject)
			icon_state = "party"
		else
			icon_state = "blue-red"
	else
	//	new lighting behaviour with obj lights
		icon_state = null

/// Sets the area's light switch state to on or off, in turn turning all lights in the area on or off.
/area/proc/set_lightswitch(var/new_switch)
	if(lightswitch != new_switch)
		lightswitch = new_switch
		for(var/obj/machinery/light_switch/L in src)
			L.sync_state()
		update_icon()
		power_change()

/// Calls `set_emergency_lighting(enable)` on all `/obj/machinery/light` in src.
/area/proc/set_emergency_lighting(var/enable)
	for(var/obj/machinery/light/M in src)
		M.set_emergency_lighting(enable)


/area/Entered(A)
	..()
	if(!istype(A,/mob/living))	return

	var/mob/living/L = A
	if(!L.ckey)	return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if(oldarea.has_gravity != newarea.has_gravity)
		if(newarea.has_gravity == 1 && !MOVING_DELIBERATELY(L)) // Being ready when you change areas allows you to avoid falling.
			thunk(L)
		L.update_floating()

	play_ambience(L)
	L.lastarea = newarea


/// Handles playing ambient sounds to a given mob, including ship hum.
/area/proc/play_ambience(mob/living/living)
	if (!living?.client)
		return
	if (living.get_preference_value(/datum/client_preference/play_ambiance) != GLOB.PREF_YES)
		return
	var/turf/turf = get_turf(living)
	if (!turf)
		return

	var/vent_ambience
	if (!always_unpowered && power_environ && length(vent_pumps) && living.get_sound_volume_multiplier() > 0.2)
		for (var/obj/machinery/atmospherics/unary/vent_pump/vent as anything in vent_pumps)
			if (vent.can_pump())
				vent_ambience = TRUE
				break
	var/client/client = living.client
	if (vent_ambience)
		if (!client.playing_vent_ambience)
			var/sound = sound('sound/ambience/shipambience.ogg', repeat = TRUE, wait = 0, volume = 10, channel = GLOB.ambience_channel_vents)
			living.playsound_local(turf, sound)
			client.playing_vent_ambience = TRUE
	else
		sound_to(living, sound(null, channel = GLOB.ambience_channel_vents))
		client.playing_vent_ambience = FALSE

	if (living.lastarea != src)
		if (forced_ambience)
			var/sound = sound(pick(forced_ambience), repeat = TRUE, wait = 0, volume = 25, channel = GLOB.ambience_channel_forced)
			living.playsound_local(turf, sound)
		else
			sound_to(living, sound(null, channel = GLOB.ambience_channel_forced))

	var/time = world.time
	if (ambience && time > client.next_ambience_time)
		var/sound = sound(pick(ambience), repeat = FALSE, wait = 0, volume = 15, channel = GLOB.ambience_channel_common)
		living.playsound_local(turf, sound)
		client.next_ambience_time = time + rand(3, 5) MINUTES


/**
 * Sets the area's `has_gravity` state.
 *
 * **Parameters**:
 * - `gravitystate` Boolean, default `FALSE`. The new state to set `has_gravity` to.
 */
/area/proc/gravitychange(var/gravitystate = 0)
	has_gravity = gravitystate

	for(var/mob/M in src)
		if(has_gravity)
			thunk(M)
		M.update_floating()

/// Causes the provided mob to 'slam' down to the floor if certain conditions are not met. Primarily used for gravity changes.
/area/proc/thunk(mob/mob)
	if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
		return

	if(mob.Check_Shoegrip())
		return

	if(istype(mob,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		if(!H.buckled && prob(H.skill_fail_chance(SKILL_EVA, 100, SKILL_PROF)))
			if(!MOVING_DELIBERATELY(H))
				H.AdjustStunned(6)
				H.AdjustWeakened(6)
			else
				H.AdjustStunned(3)
				H.AdjustWeakened(3)
			to_chat(mob, "<span class='notice'>The sudden appearance of gravity makes you fall to the floor!</span>")

/// Trigger for the prison break event. Causes lighting to overload and dooes to open. Has no effect if the area lacks an APC or the APC is turned off.
/area/proc/prison_break()
	var/obj/machinery/power/apc/theAPC = get_apc()
	if(theAPC && theAPC.operating)
		for(var/obj/machinery/power/apc/temp_apc in src)
			temp_apc.overload_lighting(70)
		for(var/obj/machinery/door/airlock/temp_airlock in src)
			temp_airlock.prison_open()
		for(var/obj/machinery/door/window/temp_windoor in src)
			temp_windoor.open()

/// Returns boolean. Whether or not the area is considered to have gravity.
/area/proc/has_gravity()
	return has_gravity

/area/space/has_gravity()
	return 0

/proc/has_gravity(atom/AT, turf/T)
	if(!T)
		T = get_turf(AT)
	var/area/A = get_area(T)
	if(A && A.has_gravity())
		return 1
	return 0

/// Returns List (axis => Integer). The width and height, in tiles, of the area, indexed by axis. Axis is `"x"` or `"y"`.
/area/proc/get_dimensions()
	var/list/res = list("x"=1,"y"=1)
	var/list/min = list("x"=world.maxx,"y"=world.maxy)
	for(var/turf/T in src)
		res["x"] = max(T.x, res["x"])
		res["y"] = max(T.y, res["y"])
		min["x"] = min(T.x, min["x"])
		min["y"] = min(T.y, min["y"])
	res["x"] = res["x"] - min["x"] + 1
	res["y"] = res["y"] - min["y"] + 1
	return res

/// Returns boolean. Whether or not there are any turfs (`/turf`) in src.
/area/proc/has_turfs()
	return !!(locate(/turf) in src)

/// Returns boolean. Whether or not the area can be modified by player actions.
/area/proc/can_modify_area()
	if (src && src.area_flags & AREA_FLAG_NO_MODIFY)
		return FALSE
	return TRUE
