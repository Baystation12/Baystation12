/obj/machinery/computer/HolodeckControl
	name = "holodeck control console"
	desc = "A computer used to control a nearby holodeck."
	icon_keyboard = "tech_key"
	icon_screen = "holocontrol"
	var/lock_access = list(access_bridge)
	var/islocked = FALSE

	active_power_usage = 8000 //8kW for the scenery + 500W per holoitem

	var/item_power_usage = 500

	var/area/linkedholodeck = null
	var/linkedholodeck_landmark_id = null
	var/obj/effect/landmark/linkedholodeck_corner = null
	var/linkedholodeck_area
	var/active = FALSE
	var/list/holographic_objs = list()
	var/list/holographic_mobs = list()
	var/damaged = FALSE
	var/safety_disabled = 0
	var/mob/last_to_emag = null
	var/last_change = 0
	var/last_gravity_change = 0
	var/list/supported_programs = list()
	var/list/restricted_programs = list()
	var/list/atoms_in_holoprogram = list()


/obj/machinery/computer/HolodeckControl/New()
	..()
	linkedholodeck = locate(linkedholodeck_area)
	
	if(linkedholodeck_landmark_id)
		for(var/obj/effect/landmark/L in landmarks_list)
			if(L.name == linkedholodeck_landmark_id)
				linkedholodeck_corner = L

	for(var/program in GLOB.using_map.holodeck_supported_programs)
		supported_programs[program] = SSmapping.holodeck_templates[program]
	for(var/program in GLOB.using_map.holodeck_restricted_programs)
		restricted_programs[program] = SSmapping.holodeck_templates[program]

/obj/machinery/computer/HolodeckControl/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["linkedholodeck"] = linkedholodeck
	data["islocked"] = islocked
	data["safety_disabled"] = safety_disabled
	data["has_gravity"] = linkedholodeck.has_gravity

	var/list/programs = list()
	for(var/P in supported_programs)
		programs += "[P]"

	data["supported_programs"] = programs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "holocontrol.tmpl", "Holodeck Controller", 390, 680)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/HolodeckControl/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/HolodeckControl/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if(href_list["program"])
			var/prog = href_list["program"]
			var/datum/map_template/map = SSmapping.holodeck_templates[prog]
			loadProgram(map)
			return TOPIC_REFRESH

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
			return TOPIC_REFRESH

		else if(href_list["gravity"])
			toggleGravity(get_area(linkedholodeck_corner.loc))
			return TOPIC_REFRESH

		else if(href_list["togglehololock"])
			togglelock(usr)
			return TOPIC_REFRESH
	return

/obj/machinery/computer/HolodeckControl/emag_act(var/remaining_charges, var/mob/user as mob)
	playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
	last_to_emag = user //emag again to change the owner
	if (!emagged)
		emagged = TRUE
		safety_disabled = TRUE
		update_projections()
		to_chat(user, SPAN_NOTICE("You vastly increase projector power and override the safety and security protocols."))
		to_chat(user, "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call [GLOB.using_map.company_name] maintenance and do not use the simulator.")
		log_game("[key_name(usr)] emagged the Holodeck Control Computer")
		return TRUE
		src.updateUsrDialog()
	else
		..()

/obj/machinery/computer/HolodeckControl/proc/update_projections()
	if (safety_disabled)
		item_power_usage = 2500
		for(var/obj/item/weapon/holo/esword/H in holographic_objs)
			H.damtype = BRUTE
	else
		item_power_usage = initial(item_power_usage)
		for(var/obj/item/weapon/holo/esword/H in holographic_objs)
			H.damtype = initial(H.damtype)

	for(var/mob/living/M in holographic_mobs)
		if(has_extension(M,/datum/extension/holographic))
			if(istype(M,/mob/living/simple_animal/hostile/carp/holodeck))
				var/mob/living/simple_animal/hostile/carp/holodeck/C = M
				C.set_safety(!safety_disabled)
				if (last_to_emag)
					C.friends = list(weakref(last_to_emag)) 

//This could all be done better, but it works for now.
/obj/machinery/computer/HolodeckControl/Destroy()
	emergencyShutdown()
	for(var/atom/item in atoms_in_holoprogram)
		qdel(item)
	QDEL_NULL_LIST(atoms_in_holoprogram)
	..()

/obj/machinery/computer/HolodeckControl/ex_act(severity)
	emergencyShutdown()
	..()

/obj/machinery/computer/HolodeckControl/power_change()
	. = ..()
	if (. && active && (stat & NOPOWER))
		emergencyShutdown()

/obj/machinery/computer/HolodeckControl/Process()
	if(!..())
		return
	if(active)
		use_power_oneoff(item_power_usage * (holographic_objs.len + holographic_mobs.len))

		if(!checkInteg(linkedholodeck))
			damaged = TRUE
			loadProgram(supported_programs["off"], 0)
			active = FALSE
			update_use_power(POWER_USE_IDLE)
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")

			for(var/turf/T in linkedholodeck)
				if(prob(30))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
				T.ex_act(3)
				T.hotspot_expose(1000,500,1)

/obj/machinery/computer/HolodeckControl/proc/checkInteg(var/area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return FALSE
	return TRUE

//Why is it called toggle if it doesn't toggle?
/obj/machinery/computer/HolodeckControl/proc/togglePower(var/toggleOn = 0)
	if(toggleOn)
		loadProgram(supported_programs["emptycourt"], 0)
	else
		loadProgram(supported_programs["off"], 0)

		if(!linkedholodeck.has_gravity)
			linkedholodeck.gravitychange(1)

		active = FALSE
		update_use_power(POWER_USE_IDLE)

/obj/machinery/computer/HolodeckControl/proc/loadProgram(var/datum/map_template/holodeck/HP, var/check_delay = 1)
	if(!HP)
		return

	if(check_delay)
		if(world.time < (last_change + 1 MINUTE))
			if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
				return
			for(var/mob/M in range(3,src))
				M.show_message(SPAN_WARNING("ERROR. Recalibrating projection apparatus."))
				last_change = world.time
				return

	last_change = world.time
	active = TRUE
	update_use_power(POWER_USE_ACTIVE)

	var/turf/holo_base_turf = get_base_turf_by_area(linkedholodeck_corner.loc)
	if(atoms_in_holoprogram.len) //if we already loaded a program, we need to remove all its atoms first except turfs
		for(var/atom/item as mob|obj in atoms_in_holoprogram)
			if(item?.contents)
				var/datum/extension/holographic/H = get_extension(item, /datum/extension/holographic)
				H.DestroyHolographicContents()
			qdel(item)
		//for(var/turf/T in atoms_in_holoprogram)

	for(var/obj/effect/decal/cleanable/blood/B in linkedholodeck)
		qdel(B)

	for(var/turf/T in linkedholodeck)
		T.ChangeTurf(holo_base_turf)

	atoms_in_holoprogram = HP.load(linkedholodeck_corner)[1].atoms_to_initialise.Copy() //should only ever spawn one map at once with the holodeck
	if(atoms_in_holoprogram.len)
		for(var/atom/holo in atoms_in_holoprogram)
			set_extension(holo,/datum/extension/holographic)
			if(istype(holo,/obj))
				holographic_objs |= holo
			if(istype(holo,/mob))
				holographic_mobs |= holo

	if(HP.ambience)
		linkedholodeck.forced_ambience = HP.ambience
	else
		linkedholodeck.forced_ambience = list()

	update_projections()

/obj/machinery/computer/HolodeckControl/proc/toggleGravity(var/area/A)
	if(world.time < (last_gravity_change + 25))
		if(world.time < (last_gravity_change + 15))//To prevent super-spam clicking
			return
		for(var/mob/M in range(3,src))
			M.show_message(SPAN_WARNING("ERROR. Recalibrating gravity field."))
			last_change = world.time
			return

	last_gravity_change = world.time
	active = TRUE
	update_use_power(POWER_USE_IDLE)

	if(A.has_gravity)
		A.gravitychange(FALSE,A)
	else
		A.gravitychange(TRUE,A)

/obj/machinery/computer/HolodeckControl/proc/emergencyShutdown()
	//Turn it back to the regular non-holographic room
	loadProgram(supported_programs["off"], 0)

	if(!linkedholodeck.has_gravity)
		linkedholodeck.gravitychange(1,linkedholodeck)

	active = FALSE
	update_use_power(POWER_USE_IDLE)

// Locking system

/obj/machinery/computer/HolodeckControl/proc/togglelock(var/mob/user)
	if(cantogglelock(user))
		islocked = !islocked
		audible_message(SPAN_NOTICE("\The [src] emits a series of beeps to announce it has been [islocked ? null : "un"]locked."), hearing_distance = 3)
		return FALSE
	else
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

/obj/machinery/computer/HolodeckControl/proc/cantogglelock(var/mob/user)
	return has_access(lock_access, user.GetAccess())
