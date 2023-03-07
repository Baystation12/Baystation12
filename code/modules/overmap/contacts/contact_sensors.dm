#define SENSORS_DISTANCE_COEFFICIENT 5
/obj/machinery/computer/ship/sensors
	var/list/objects_in_view = list() // Associative list of objects in view -> identification process
	var/list/contact_datums = list()
	var/list/trackers = list()

/obj/machinery/computer/ship/sensors/Destroy()
	objects_in_view.Cut()
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

/obj/machinery/computer/ship/sensors/Process()
	..()
	update_sound()
	if(!linked)
		return

	// Update our own marker icon regardless of power or sensor connections.
	var/sensor_range = 0
	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(sensors?.use_power)
		sensor_range = round(sensors.range,1)
	var/datum/overmap_contact/self_record = contact_datums[linked]
	self_record.update_marker_icon(sensor_range)
	self_record.show()

	// Update our 'sensor range' (ie. overmap lighting)
	if(!sensors || !sensors.use_power || (stat & (MACHINE_STAT_NOPOWER|MACHINE_IS_BROKEN(src))))
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
				objects_in_current_view[tracked_effect] = TRUE
				objects_in_view[tracked_effect] = 100

	for(var/obj/effect/overmap/contact in view(sensor_range, linked))
		if(contact == linked)
			continue
		if(!contact.requires_contact)	   // Only some effects require contact for visibility.
			continue
		objects_in_current_view[contact] = TRUE

		if(contact.type in linked.known_ships)
			objects_in_view[contact] = 100 // Instantly identify known ships.

		if(contact.instant_contact)   // Instantly identify the object in range.
			objects_in_view[contact] = 100

		else if(!(contact in objects_in_view))
			objects_in_view[contact] = 0


	for(var/obj/effect/overmap/contact in objects_in_view) //Update everything.
		// Are we already aware of this object?
		var/datum/overmap_contact/record = contact_datums[contact]

		// Fade out and remove anything that is out of range.
		if(QDELETED(contact) || !objects_in_current_view[contact]) // Object has exited sensor range.
			if(record)
				animate(record.marker, alpha=0, 2 SECOND, 1, LINEAR_EASING)
				QDEL_IN(record, 2 SECOND) // Need to restart the search if you've lost contact with the object.
				if(contact.scannable)	  // Scannable objects are the only ones that give off notifications to prevent spam
					visible_message(SPAN_NOTICE("[src] states, 'Contact lost with [record.name]'"))
					playsound(loc, "sound/machines/sensors/contact_lost.ogg", 30, 1)
			objects_in_view -= contact
			continue

		// Generate contact information for this overmap object.
		var/bearing = round(90 - Atan2(contact.x - linked.x, contact.y - linked.y),5)
		if(bearing < 0)
			bearing += 360
		if(!record) // Begin attempting to identify ship.
			// The chance of detection decreases with distance to the target ship.

			if(contact.scannable && prob((SENSORS_DISTANCE_COEFFICIENT * contact.sensor_visibility)/max(get_dist(linked, contact), 0.5)))
				var/bearing_variability = round(30/sensors.sensor_strength, 5)
				var/bearing_estimate = round(rand(bearing-bearing_variability, bearing+bearing_variability), 5)
				if(bearing_estimate < 0)
					bearing_estimate += 360

				// Give the player an idea of where the ship is in relation to the ship.
				if(objects_in_view[contact] <= 0)
					if(!muted || !(contact.type in linked.known_ships))
						visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"Unknown contact designation '[contact.unknown_id]' detected nearby, bearing [bearing_estimate], error +/- [bearing_variability]. Beginning trace.\""))
					objects_in_view[contact] = round(sensors.sensor_strength**2)

				else
					objects_in_view[contact] += round(sensors.sensor_strength**2)
					if(!muted || !(contact.type in linked.known_ships))
						visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"Contact '[contact.unknown_id]' tracing [objects_in_view[contact]]% complete, bearing [bearing_estimate], error +/- [bearing_variability].\""))
				playsound(loc, "sound/machines/sensors/contactgeneric.ogg", 10, 1) //Let players know there's something nearby

			if(objects_in_view[contact] >= 100) // Identification complete.
				record = new /datum/overmap_contact(src, contact)
				contact_datums[contact] = record

				if(contact.scannable)
					playsound(loc, "sound/machines/sensors/newcontact.ogg", 30, 1)
					visible_message(SPAN_NOTICE("<b>\The [src]</b> states, \"New contact identified, designation [record.name], bearing [bearing].\""))
				record.show()
				animate(record.marker, alpha=255, 2 SECOND, 1, LINEAR_EASING)
			continue

		// Update identification information for this record.
		record.update_marker_icon()

		var/time_delay = max((SENSOR_TIME_DELAY * get_dist(linked, contact)),1)
		if(!record.pinged)
			addtimer(new Callback(record, .proc/ping), time_delay)

/obj/machinery/computer/ship/sensors/attackby(obj/item/I, mob/user)
	. = ..()
	var/obj/item/device/multitool/P = I
	if(!istype(P))
		return
	var/obj/item/ship_tracker/tracker = P.get_buffer()
	if(!tracker || !istype(tracker))
		return

	if(tracker in trackers)
		trackers -= tracker
		GLOB.destroyed_event.unregister(tracker, src, .proc/remove_tracker)
		to_chat(user, SPAN_NOTICE("You unlink the tracker in \the [P]'s buffer from \the [src]"))
		return
	trackers += tracker
	GLOB.destroyed_event.register(tracker, src, .proc/remove_tracker)
	to_chat(user, SPAN_NOTICE("You link the tracker in \the [P]'s buffer to \the [src]"))

/obj/machinery/computer/ship/sensors/proc/remove_tracker(obj/item/ship_tracker/tracker)
	trackers -= tracker

#undef SENSORS_DISTANCE_COEFFICIENT
