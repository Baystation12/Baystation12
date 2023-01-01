/// A particle accelerator of sorts, for research usage. The parent type is a simple segment.
/obj/machinery/roomotron
	name = "bluespace roomotron segment"
	desc = "A segment of a linear roomotron. It can recieve and deliver a beam of bluespace particles."
	icon = 'icons/obj/machines/roomotron.dmi'
	dir = NORTH
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	/// The actual beam
	var/datum/particle_beam/beam
	/// The beam overlay.
	var/image/beam_overlay
	/// A list of adjacent roomotron parts.
	var/list/connected_segments = list()
	/// The segment that a recieved beam will travel to.
	var/obj/machinery/roomotron/beam_exit

/obj/machinery/roomotron/Initialize(mapload)
	. = ..()
	if(mapload)
		anchored = TRUE
	beam_overlay = image(icon, "[icon_state]_beam")

/obj/machinery/roomotron/Process()
	if(beam & !overlays)
		overlays += beam_overlay
	else
		overlays -= beam_overlay

/obj/machinery/roomotron/wrench_floor_bolts()
	. = ..()
	update_connected_segments()

/// Returns valid directions for a segment connection.
/obj/machinery/roomotron/proc/return_valid_dirs()
	return list(dir, turn(dir, 180))

/// Returns the beam exit. Returns a segment or null.
/obj/machinery/roomotron/proc/return_beam_exit()
	for(var/segment in connected_segments)
		if(connected_segments[segment] == dir)
			return segment
			break
		else
			return null

/// Connects a segment to the current source, returns true or false based on success.
/obj/machinery/roomotron/proc/connect_segment(obj/machinery/roomotron/segment)
	if(segment in connected_segments) return FALSE

	for(var/connected_segment in connected_segments)
		if(connected_segments[connected_segment] == get_dir(src, segment)) return FALSE

	if(segment.anchored)
		visible_message(SPAN_BOLD("A segment [get_dist(src, segment)] turf\s away and in the [get_dir(src, segment)] direction is being added."))
		connected_segments += segment
		connected_segments[segment] = get_dir(src, segment)
		return TRUE

/// Disconnect a segment from a source.
/obj/machinery/roomotron/proc/disconnect_segment(obj/machinery/roomotron/segment)
	if(segment in connected_segments)
		connected_segments -= segment

	if(src in segment.connected_segments)
		segment.disconnect_segment(src)

/// Updates segment connections. Should always be dependent only on values of the calling segment to prevent redundant calls.
/obj/machinery/roomotron/proc/update_connected_segments()
	if(anchored)
		for(var/obj/machinery/roomotron/segment in range(1, src))
			if(get_dir(src, segment) in return_valid_dirs())
				connect_segment(segment)
	else
		for(var/connected_segment in connected_segments)
			disconnect_segment(connected_segment)
	beam_exit = return_beam_exit()

/// Moving the beam forward.
/obj/machinery/roomotron/proc/fire_beam()
	if(beam_exit)
		beam.update_position(beam_exit, src)
	else
		beam.exit_containment()

/obj/machinery/roomotron/angular
	name = "angular bluespace roomotron segment"
	icon_state = "angular"
	/// Is it mirrored?
	var/mirrored = FALSE
	/// Base icon state for more unique subtypes.
	var/base_icon_state = "angular"

/obj/machinery/roomotron/angular/physical_attack_hand(mob/user)
	if(user.a_intent == I_HELP && !anchored)
		mirrored = !mirrored
		visible_message(SPAN_NOTICE("\The [src] flips \the [src]."))
		update_icon()
	else
		..()

/obj/machinery/roomotron/angular/on_update_icon()
	icon_state = "[base_icon_state][mirrored ? "_mirrored" : null]"

/obj/machinery/roomotron/angular/return_valid_dirs()
	if(mirrored)
		return list(dir, turn(dir, 90))
	else
		return list(dir, turn(dir, -90))

/// For mapping purposes only.
/obj/machinery/roomotron/angular/mirrored
	icon_state = "angular_mirrored"
	mirrored = TRUE

/// Every roomotron has a source.
/obj/machinery/roomotron/source
	name = "bluespace roomotron source"
	desc = "A segment of a linear roomotron. It can generate a beam of bluespace particles."
	/// The type of beam generated.
	var/beam_type

/obj/machinery/roomotron/source/return_valid_dirs()
	return list(dir)