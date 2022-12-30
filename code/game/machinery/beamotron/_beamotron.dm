/// A particle accelerator of sorts, for research usage. The parent type is a simple segment.
/obj/machinery/beamotron
	name = "bluespace beamotron segment"
	desc = "A segment of a linear beamotron. It can recieve and deliver a beam of bluespace particles."
	icon = 'icons/obj/machines/beamotron.dmi'
	dir = NORTH
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	/// The actual beam
	var/datum/particle_beam/beam
	/// A list of adjacent beamotron parts.
	var/list/connected_segments = list()

/obj/machinery/beamotron/Initialize(mapload)
	. = ..()
	if(mapload)
		anchored = TRUE

/obj/machinery/beamotron/wrench_floor_bolts()
	. = ..()
	update_connected_segments()

/// Returns valid directions for a segment connection.
/obj/machinery/beamotron/proc/return_valid_dirs()
	return list(dir, turn(dir, 180))

/// Connects a segment to the current source, returns true or false based on success.
/obj/machinery/beamotron/proc/connect_segment(obj/machinery/beamotron/segment)
	if(segment in connected_segments) return FALSE

	for(var/connected_segment in connected_segments)
		if(connected_segments[connected_segment] == get_dir(src, segment)) return FALSE

	if(segment.anchored)
		visible_message(SPAN_BOLD("A segment [get_dist(src, segment)] turf\s away and in the [get_dir(src, segment)] direction is being added."))
		connected_segments += segment
		connected_segments[segment] = get_dir(src, segment)
		return TRUE

/// Disconnect a segment from a source.
/obj/machinery/beamotron/proc/disconnect_segment(obj/machinery/beamotron/segment)
	if(segment in connected_segments)
		connected_segments -= segment

	if(src in segment.connected_segments)
		segment.disconnect_segment(src)

/// Updates segment connections. Should always be dependent only on values of the calling segment to prevent redundant calls.
/obj/machinery/beamotron/proc/update_connected_segments()
	if(anchored)
		for(var/obj/machinery/beamotron/segment in range(1, src))
			if(get_dir(src, segment) in return_valid_dirs())
				connect_segment(segment)
	else
		for(var/connected_segment in connected_segments)
			disconnect_segment(connected_segment)

/obj/machinery/beamotron/angular
	name = "angular bluespace beamotron segment"
	icon_state = "angular"
	/// Is it mirrored?
	var/mirrored = FALSE
	/// Base icon state for more unique subtypes.
	var/base_icon_state = "angular"

/obj/machinery/beamotron/angular/physical_attack_hand(mob/user)
	if(user.a_intent == I_HELP && !anchored)
		mirrored = !mirrored
		visible_message(SPAN_NOTICE("\The [src] flips \the [src]."))
		update_icon()
	else
		..()

/obj/machinery/beamotron/angular/on_update_icon()
	icon_state = "[base_icon_state][mirrored ? "_mirrored" : null]"

/obj/machinery/beamotron/angular/return_valid_dirs()
	if(mirrored)
		return list(dir, turn(dir, 90))
	else
		return list(dir, turn(dir, -90))

/// For mapping purposes only.
/obj/machinery/beamotron/angular/mirrored
	icon_state = "angular_mirrored"
	mirrored = TRUE

/// Every beamotron has a source.
/obj/machinery/beamotron/source
	name = "bluespace beamotron source"
	desc = "A segment of a linear beamotron. It can generate a beam of bluespace particles."
	/// The type of beam generated.
	var/beam_type

/obj/machinery/beamotron/source/return_valid_dirs()
	return list(dir)