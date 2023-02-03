/datum/event/ioncloud
	has_skybox_image = TRUE
	/// Base chance per `tick()` of an EMP effect triggering on a random machine. This is multiplied by event severity.
	var/base_emp_chance_per_tick = 5
	/// Randomized color rotation shift used for skybox image generation.
	var/cloud_hueshift
	/// List of machinery found during `start()`.
	var/list/victims = list()


/datum/event/ioncloud/get_skybox_image()
	if (!cloud_hueshift)
		cloud_hueshift = color_rotation(rand(-3,3)*15)
	var/image/res = overlay_image('icons/skybox/ionbox.dmi', "ions", cloud_hueshift, RESET_COLOR)
	res.blend_mode = BLEND_ADD
	return res


/datum/event/ioncloud/start()
	log_debug("ION CLOUD EVENT: Starting.")
	for (var/obj/machinery/machine in SSmachines.machinery)
		if (get_z(machine) in affecting_z)
			victims += machine
			GLOB.destroyed_event.register(machine, src, .proc/victim_deleted)
	log_debug("ION CLOUD EVENT: Found [length(victims)] potential victim\s.")
	..()


/datum/event/ioncloud/announce()
	var/degree
	switch (severity)
		if (EVENT_LEVEL_MUNDANE)
			degree = "minor"
		if (EVENT_LEVEL_MODERATE)
			degree = "moderate"
		if (EVENT_LEVEL_MAJOR)
			degree = "severe"
	command_announcement.Announce("Sensors indicate \the [location_name()] has entered \a [degree] electro-magnetic storm. Please check all electrical equipment for malfunctions.")
	..()


/datum/event/ioncloud/end()
	command_announcement.Announce("Sensors indicate \the [location_name()] has passed through the electro-magnetic storm.")
	..()


/datum/event/ioncloud/kill(reroll)
	log_debug("ION CLOUD EVENT: Ending.")
	..()


/datum/event/ioncloud/tick()
	if (!prob(base_emp_chance_per_tick * severity))
		return
	var/obj/machinery/victim = choose_victim()
	if (!victim)
		return
	// Light/Heavy EMP probabilities per event level:
	// 100/0% on mundane, 50/50% on medium, 33/66% on major
	var/emp_severity = prob(100 / severity) ? EMP_ACT_LIGHT : EMP_ACT_HEAVY
	victim.emp_act(emp_severity)
	log_debug(append_admin_tools("ION CLOUD EVENT: EMPing \the [victim] ([victim.type]) in [get_area(victim)] with severity [emp_severity].", location = get_turf(victim)))
	..()


/datum/event/ioncloud/proc/choose_victim(attempt = 1)
	log_debug("ION CLOUD EVENT: Victim selection attempt [attempt].")
	if (attempt > 5 || !length(victims))
		log_debug("ION CLOUD EVENT: Failed to find a victim. Stopping.")
		return FALSE
	var/obj/machinery/victim = pick_n_take(victims)
	if (QDELETED(victim) || !victim.use_power || victim.inoperable() || !(get_z(victim) in affecting_z))
		return choose_victim(attempt + 1)
	log_debug(append_admin_tools("ION CLOUD EVENT: Selected victim \the [victim] ([victim.type]).", location = get_turf(victim)))
	return victim


/datum/event/ioncloud/proc/victim_deleted(obj/machinery/victim)
	victims -= victim
	GLOB.destroyed_event.unregister(victim, src, .proc/victim_deleted)
