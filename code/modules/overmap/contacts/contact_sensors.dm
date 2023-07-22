#define SENSORS_DISTANCE_COEFFICIENT 6
/obj/machinery/computer/ship/sensors
	var/list/objects_in_view = list() // Associative list of objects in view -> identification progress
	var/list/memorized_objects = list() // Like objects in view, but for storing data
	var/list/contact_datums = list()
	var/list/trackers = list()

/obj/machinery/computer/ship/sensors/Destroy()
	objects_in_view.Cut()
	memorized_objects.Cut()
	trackers.Cut()

	for(var/key in contact_datums)
		var/datum/overmap_contact/record = contact_datums[key]
		qdel(record)
	contact_datums.Cut()
	. = ..()

/obj/machinery/computer/ship/sensors/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	. = ..()
	if(. && linked && !contact_datums[linked])
		var/datum/overmap_contact/record = new(src, linked)
		contact_datums[linked] = record
		record.marker.alpha = 255

/obj/machinery/computer/ship/sensors/proc/reveal_contacts(mob/user)
	if(user && user.client)
		for(var/key in contact_datums)
			var/datum/overmap_contact/record = contact_datums[key]
			if(record)
				user.client.images |= record.marker

/obj/machinery/computer/ship/sensors/proc/hide_contacts(mob/user)
	if(user && user.client)
		for(var/key in contact_datums)
			var/datum/overmap_contact/record = contact_datums[key]
			if(record)
				user.client.images -= record.marker

/obj/machinery/computer/ship/sensors/proc/inaccurate_bearing(bearing, variability)
	var/bearing_estimate = round(rand(bearing - variability, bearing + variability), 5)
	if(bearing_estimate < 0)
		bearing_estimate += 360
	return bearing_estimate

/obj/machinery/computer/ship/sensors/Process()
	..()
	update_sound()
	if(!linked)
		return

	// Update our 'sensor range' (ie. overmap lighting)
	var/sensor_range = 0
	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(sensors?.use_power)
		sensor_range = round(sensors.range,1)

	// Update our own marker icon regardless of power or sensor connections.
	var/datum/overmap_contact/self_record = contact_datums[linked]
	self_record.update_marker_icon(sensor_range)
	self_record.show()

	if(!sensors || !sensors.use_power || HAS_FLAGS(stat, MACHINE_STAT_NOPOWER) || MACHINE_IS_BROKEN(src))
		// Turning off sensors is harmful
		if (length(contact_datums) > 1 || length(objects_in_view))
			for(var/key in memorized_objects)
				memorized_objects[key] = max(memorized_objects[key] - 18, 0)

		for(var/key in contact_datums)
			var/datum/overmap_contact/record = contact_datums[key]
			if(record.effect == linked)
				continue
			qdel(record) // Immediately cut records if power is lost.

		objects_in_view.Cut()
		return

	// What can we see?
	var/list/objects_in_current_view = list()

	// Find all sectors with a tracker on their z-level. Only works on ships when they are in space.
	for(var/obj/item/ship_tracker/tracker in trackers)
		if(tracker.enabled)
			var/obj/effect/overmap/visitable/tracked_effect = map_sectors["[get_z(tracker)]"]
			if(tracked_effect && istype(tracked_effect) && tracked_effect != linked && tracked_effect.requires_contact)
				objects_in_current_view.Add(tracked_effect)
				objects_in_view[tracked_effect] = 100

	for(var/obj/effect/overmap/contact in view(sensor_range, linked))
		if(contact == linked)
			continue
		if(!contact.requires_contact)	// Only some effects require contact for visibility.
			continue

		// Made like in proc/circlerangeturfs()
		// Makes the view round
		if (linked.z == contact.z)
			var/dx = contact.x - linked.x
			var/dy = contact.y - linked.y
			var/rsq = sensor_range * (sensor_range+1)
			if (dx**2 + dy**2 > rsq)
				continue

		objects_in_current_view.Add(contact)

		if(contact.type in linked.known_ships)
			objects_in_view[contact] = 100 // Instantly identify known ships.

		if(contact.instant_contact)   // Instantly identify the object in range.
			objects_in_view[contact] = 100

		else if(!(contact in objects_in_view))
			objects_in_view[contact] = -1 // Replaced by 0 after notification

	for(var/obj/effect/overmap/contact in objects_in_view) //Update everything.
		// Are we already aware of this object?
		var/datum/overmap_contact/record = contact_datums[contact]

		// Fade out and remove anything that is out of range.
		if(QDELETED(contact) || !(contact in objects_in_current_view)) // Object has exited sensor range.
			if(record)
				record.marker.alpha = 200
				animate(record.marker, alpha=0, time=1.3 SECONDS, 1, LINEAR_EASING)
				QDEL_IN(record, 1.3 SECONDS) // Need to restart the search if you've lost contact with the object.
				if(!muted && contact.scannable)	// Scannable objects are the only ones that give off notifications to prevent spam
					visible_message(SPAN_NOTICE("[src] states, 'Contact lost with [record.name]'"))
					playsound(loc, "sound/machines/sensors/contact_lost.ogg", 30, 1)
			objects_in_view -= contact
			continue

		// Generate contact information for this overmap object.
		if(!record) // Begin attempting to identify ship.
			var/bearing = get_bearing(linked, contact)

			// The chance of detection decreases with distance to the target ship.
			if(contact.scannable)
				if(objects_in_view[contact] < 0)

					if(!muted) // Give the player an idea of where the ship is in relation to the ship
						var/bearing_variability = round(300/sensors.sensor_strength, 5)
						var/bearing_estimate = inaccurate_bearing(bearing, bearing_variability)
						visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"Unknown contact designation '[contact.unknown_id]' detected nearby, bearing [bearing_estimate], error +/- [bearing_variability]. Beginning trace.\""))

						playsound(loc, "sound/machines/sensors/contactgeneric.ogg", 10, 1) //Let players know there's something nearby

					objects_in_view[contact] = 0
					if (contact in memorized_objects) // Restore the contact progress if there is anything to restore
						objects_in_view[contact] = memorized_objects[contact]
				else
					var/progress = sensors.sensor_strength * contact.sensor_visibility * SENSORS_DISTANCE_COEFFICIENT
					progress /= max(get_dist_euclidian(linked, contact), 0.5)
					objects_in_view[contact] += round(progress / 100)

					memorized_objects[contact] = min(objects_in_view[contact], 100)

			if(objects_in_view[contact] >= 100) // Identification complete.
				record = new /datum/overmap_contact(src, contact)
				contact_datums[contact] = record

				if(!muted && contact.scannable)
					playsound(loc, "sound/machines/sensors/newcontact.ogg", 30, 1)
					visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"New contact identified, designation [record.name], bearing [bearing].\""))

				record.show()
				animate(record.marker, alpha=255, 2 SECOND, 1, LINEAR_EASING)
			continue

		// Update identification information for this record.
		record.update_marker_icon()

		var/time_delay = max((SENSOR_TIME_DELAY * get_dist_euclidian(linked, contact)),1)
		addtimer(new Callback(record, .proc/ping), time_delay)

/obj/machinery/computer/ship/sensors/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (!isMultitool(tool))
		return ..()

	var/obj/item/device/multitool/mtool = tool
	var/obj/item/ship_tracker/tracker = mtool.get_buffer()
	if(!tracker || !istype(tracker))
		return

	if(tracker in trackers)
		trackers -= tracker
		GLOB.destroyed_event.unregister(tracker, src, .proc/remove_tracker)
		to_chat(user, SPAN_NOTICE("You unlink the tracker in \the [mtool]'s buffer from \the [src]"))
		return
	trackers += tracker
	GLOB.destroyed_event.register(tracker, src, .proc/remove_tracker)
	to_chat(user, SPAN_NOTICE("You link the tracker in \the [mtool]'s buffer to \the [src]"))

/obj/machinery/computer/ship/sensors/proc/remove_tracker(obj/item/ship_tracker/tracker)
	trackers -= tracker

#undef SENSORS_DISTANCE_COEFFICIENT
