/obj/machinery/computer/HolodeckControl
	name = "holodeck control console"
	desc = "A computer used to control a nearby holodeck."
	icon_keyboard = "tech_key"
	icon_screen = "holocontrol"
	machine_name = "holodeck control console"
	machine_desc = "Holodecks are immensely complicated and delicate machines, and holodeck control consoles are the devices used to calibrate and modify them."
	var/lock_access = list(access_bridge)
	var/islocked = 0

	active_power_usage = 8000 //8kW for the scenery + 500W per holoitem

	var/item_power_usage = 500

	var/area/linkedholodeck = null
	var/linkedholodeck_area
	var/active = 0
	var/list/holographic_objs = list()
	var/list/holographic_mobs = list()
	var/damaged = 0
	var/safety_disabled = 0
	var/mob/last_to_emag = null
	var/last_change = 0
	var/last_gravity_change = 0
	var/programs_list_id = null
	var/list/supported_programs = list()
	var/list/restricted_programs = list()

/obj/machinery/computer/HolodeckControl/New()
	..()
	linkedholodeck = locate(linkedholodeck_area)
	if (programs_list_id in GLOB.using_map.holodeck_supported_programs)
		supported_programs |= GLOB.using_map.holodeck_supported_programs[programs_list_id]
	if (programs_list_id in GLOB.using_map.holodeck_restricted_programs)
		restricted_programs |= GLOB.using_map.holodeck_restricted_programs[programs_list_id]

/obj/machinery/computer/HolodeckControl/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/HolodeckControl/interact(mob/user)
	user.set_machine(src)
	var/dat

	dat += "<B>Holodeck Control System</B><BR>"
	if(!islocked)
		dat += "Holodeck is <A href='?src=\ref[src];togglehololock=1'>[SPAN_COLOR("green", "(UNLOCKED)")]</A><BR>"
	else
		dat += "Holodeck is <A href='?src=\ref[src];togglehololock=1'>[SPAN_COLOR("red", "(LOCKED)")]</A><BR>"
		show_browser(user, dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	dat += "<HR>Current Loaded Programs:<BR>"

	if(!linkedholodeck)
		dat += SPAN_DANGER("Warning: Unable to locate holodeck.<br>")
		show_browser(user, dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	if(!length(supported_programs))
		dat += SPAN_DANGER("Warning: No supported holo-programs loaded.<br>")
		show_browser(user, dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return

	for(var/prog in supported_programs)
		dat += "<A href='?src=\ref[src];program=[supported_programs[prog]]'>([prog])</A><BR>"

	dat += "<BR>"
	dat += "<A href='?src=\ref[src];program=turnoff'>(Turn Off)</A><BR>"

	dat += "<BR>"
	dat += "Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.<BR>"

	if(issilicon(user))
		dat += "<BR>"
		if(safety_disabled)
			if (emagged)
				dat += "[SPAN_COLOR("red", "<b>ERROR</b>: Cannot re-enable Safety Protocols.")]<BR>"
			else
				dat += "<A href='?src=\ref[src];AIoverride=1'>([SPAN_COLOR("green", "Re-Enable Safety Protocols?")])</A><BR>"
		else
			dat += "<A href='?src=\ref[src];AIoverride=1'>([SPAN_COLOR("red", "Override Safety Protocols?")])</A><BR>"

	dat += "<BR>"

	if(safety_disabled)
		for(var/prog in restricted_programs)
			dat += "<A href='?src=\ref[src];program=[restricted_programs[prog]]'>([SPAN_COLOR("red", "Begin [prog]")])</A><BR>"
			dat += "Ensure the holodeck is empty before testing.<BR>"
			dat += "<BR>"
		dat += "Safety Protocols are [SPAN_COLOR("red", " DISABLED ")]<BR>"
	else
		dat += "Safety Protocols are [SPAN_COLOR("green", " ENABLED ")]<BR>"

	if(linkedholodeck.has_gravity)
		dat += "Gravity is <A href='?src=\ref[src];gravity=1'>[SPAN_COLOR("green", "(ON)")]</A><BR>"
	else
		dat += "Gravity is <A href='?src=\ref[src];gravity=1'>[SPAN_COLOR("blue", "(OFF)")]</A><BR>"
	show_browser(user, dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/HolodeckControl/Topic(href, href_list)
	if(..())
		return 1
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if(href_list["program"])
			var/prog = href_list["program"]
			if(prog in GLOB.using_map.holodeck_programs)
				loadProgram(GLOB.using_map.holodeck_programs[prog])

		else if(href_list["AIoverride"])
			if(!issilicon(usr))
				return

			if(safety_disabled && emagged)
				return //if a traitor has gone through the trouble to emag the thing, let them keep it.

			safety_disabled = !safety_disabled
			update_projections()
			if(safety_disabled)
				log_and_message_admins("overrode the holodeck's safeties")
			else
				log_and_message_admins("restored the holodeck's safeties")

		else if(href_list["gravity"])
			toggleGravity(linkedholodeck)

		else if(href_list["togglehololock"])
			togglelock(usr)

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/HolodeckControl/emag_act(remaining_charges, mob/user as mob)
	playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
	last_to_emag = user //emag again to change the owner
	if (!emagged)
		emagged = TRUE
		safety_disabled = 1
		update_projections()
		to_chat(user, SPAN_NOTICE("You vastly increase projector power and override the safety and security protocols."))
		to_chat(user, "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call [GLOB.using_map.company_name] maintenance and do not use the simulator.")
		log_game("[key_name(usr)] emagged the Holodeck Control Computer")
		src.updateUsrDialog()
		return 1
	else
		..()

/obj/machinery/computer/HolodeckControl/proc/update_projections()
	if (safety_disabled)
		item_power_usage = 2500
		for(var/obj/item/holo/esword/H in linkedholodeck)
			H.damtype = DAMAGE_BRUTE
	else
		item_power_usage = initial(item_power_usage)
		for(var/obj/item/holo/esword/H in linkedholodeck)
			H.damtype = initial(H.damtype)

	for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
		C.set_safety(!safety_disabled)
		if (last_to_emag)
			C.friends = list(weakref(last_to_emag))

//This could all be done better, but it works for now.
/obj/machinery/computer/HolodeckControl/Destroy()
	emergencyShutdown()
	..()

/obj/machinery/computer/HolodeckControl/ex_act(severity)
	emergencyShutdown()
	..()

/obj/machinery/computer/HolodeckControl/power_change()
	. = ..()
	if (. && active && (!is_powered()))
		emergencyShutdown()

/obj/machinery/computer/HolodeckControl/Process()
	for(var/item in holographic_objs) // do this first, to make sure people don't take items out when power is down.
		if(!(get_turf(item) in linkedholodeck))
			derez(item, 0)

	if (!safety_disabled)
		for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
			if (get_area(C.loc) != linkedholodeck)
				holographic_mobs -= C
				C.death()

	if(!..())
		return
	if(active)
		use_power_oneoff(item_power_usage * (length(holographic_objs) + length(holographic_mobs)))

		if(!checkInteg(linkedholodeck))
			damaged = 1
			loadProgram(GLOB.using_map.holodeck_programs["turnoff"], 0)
			active = 0
			update_use_power(POWER_USE_IDLE)
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")


			for(var/turf/T in linkedholodeck)
				if(prob(30))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
				T.ex_act(EX_ACT_LIGHT)
				T.hotspot_expose(1000,500,1)

/obj/machinery/computer/HolodeckControl/proc/derez(obj/obj , silent = 1)
	holographic_objs.Remove(obj)

	if(obj == null)
		return

	if(!silent)
		var/obj/oldobj = obj
		visible_message("The [oldobj.name] fades away!")
	qdel(obj)

/obj/machinery/computer/HolodeckControl/proc/checkInteg(area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return 0

	return 1

//Why is it called toggle if it doesn't toggle?
/obj/machinery/computer/HolodeckControl/proc/togglePower(toggleOn = 0)
	if(toggleOn)
		loadProgram(GLOB.using_map.holodeck_programs["emptycourt"], 0)
	else
		loadProgram(GLOB.using_map.holodeck_programs["turnoff"], 0)

		if(!linkedholodeck.has_gravity)
			linkedholodeck.gravitychange(1)

		active = 0
		update_use_power(POWER_USE_IDLE)


/obj/machinery/computer/HolodeckControl/proc/loadProgram(datum/holodeck_program/HP, check_delay = 1)
	if(!HP)
		return
	var/area/A = locate(HP.target)
	if(!A)
		return

	if(check_delay)
		if(world.time < (last_change + 25))
			if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
				return
			for(var/mob/M in range(3,src))
				M.show_message(SPAN_WARNING("ERROR. Recalibrating projection apparatus."))
				last_change = world.time
				return

	last_change = world.time
	active = 1
	update_use_power(POWER_USE_ACTIVE)

	for(var/item in holographic_objs)
		derez(item)

	for(var/mob/living/simple_animal/hostile/carp/holodeck/C in holographic_mobs)
		holographic_mobs -= C
		C.death()

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		qdel(B)

	holographic_objs = A.copy_contents_to(linkedholodeck , 1)
	for(var/obj/holo_obj in holographic_objs)
		holo_obj.alpha *= 0.8 //give holodeck objs a slight transparency
		holo_obj.holographic = TRUE
		if(istype(holo_obj,/obj/item/storage))
			set_extension(holo_obj,/datum/extension/chameleon/backpack)
		if(istype(holo_obj,/obj/item/clothing))
			set_extension(holo_obj,/datum/extension/chameleon/clothing)

	if(HP.ambience)
		linkedholodeck.forced_ambience = HP.ambience.Copy()
	else
		LAZYCLEARLIST(linkedholodeck.forced_ambience)

	for(var/mob/living/M in mobs_in_area(linkedholodeck))
		if(M.mind)
			linkedholodeck.play_ambience(M)

	linkedholodeck.sound_env = A.sound_env

	spawn(30)
		for(var/obj/effect/landmark/L in linkedholodeck)
			if(L.name=="Atmospheric Test Start")
				spawn(20)
					var/turf/T = get_turf(L)
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
					if(T)
						T.temperature = 5000
						T.hotspot_expose(50000,50000,1)
			if(L.name=="Holocarp Spawn")
				holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(L.loc)

			if(L.name=="Holocarp Spawn Random")
				if (prob(4)) //With 4 spawn points, carp should only appear 15% of the time.
					holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(L.loc)

		update_projections()


/obj/machinery/computer/HolodeckControl/proc/toggleGravity(area/A)
	if(world.time < (last_gravity_change + 25))
		if(world.time < (last_gravity_change + 15))//To prevent super-spam clicking
			return
		for(var/mob/M in range(3,src))
			M.show_message(SPAN_WARNING("ERROR. Recalibrating gravity field."))
			last_change = world.time
			return

	last_gravity_change = world.time
	active = 1
	update_use_power(POWER_USE_IDLE)

	if(A.has_gravity)
		A.gravitychange(0,A)
	else
		A.gravitychange(1,A)

/obj/machinery/computer/HolodeckControl/proc/emergencyShutdown()
	//Turn it back to the regular non-holographic room
	loadProgram(GLOB.using_map.holodeck_programs["turnoff"], 0)

	if(!linkedholodeck.has_gravity)
		linkedholodeck.gravitychange(1,linkedholodeck)

	active = 0
	update_use_power(POWER_USE_IDLE)

// Locking system

/obj/machinery/computer/HolodeckControl/proc/togglelock(mob/user)
	if(cantogglelock(user))
		islocked = !islocked
		audible_message(SPAN_NOTICE("\The [src] emits a series of beeps to announce it has been [islocked ? null : "un"]locked."), hearing_distance = 3)
		return 0
	else
		to_chat(user, SPAN_WARNING("Access denied."))
		return 1

/obj/machinery/computer/HolodeckControl/proc/cantogglelock(mob/user)
	return has_access(lock_access, user.GetAccess())
