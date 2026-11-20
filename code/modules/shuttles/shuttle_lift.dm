/**
 * A lift that can stop at any number of floors.
 *
 *
 */
/datum/shuttle/autodock/multi/lift
	category = /datum/shuttle/autodock/multi/lift
	warmup_time = 3
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0
	/// Landmark tag = short floor name shown on the panels, e.g. "Deck 3".
	var/list/stop_labels = list()


/datum/shuttle/autodock/multi/lift/proc/get_stop(tag)
	var/obj/shuttle_landmark/stop = SSshuttle.get_landmark(tag)
	return istype(stop) ? stop : null


/datum/shuttle/autodock/multi/lift/proc/stop_label(tag)
	if (stop_labels[tag])
		return stop_labels[tag]
	var/obj/shuttle_landmark/stop = get_stop(tag)
	return stop ? stop.name : tag


/// The landmark tag of the stop the lift is at, or heading to while it moves.
/datum/shuttle/autodock/multi/lift/proc/shown_stop_tag()
	var/obj/shuttle_landmark/stop = moving_status == SHUTTLE_IDLE ? current_location : next_location
	return stop?.landmark_tag


/datum/shuttle/autodock/multi/lift/proc/is_busy()
	return moving_status != SHUTTLE_IDLE || in_use || process_state != IDLE_STATE


/// Sends the lift to the stop with this landmark tag. Returns null on success, or a reason it can't go.
/datum/shuttle/autodock/multi/lift/proc/send_to(tag, mob/user)
	var/obj/shuttle_landmark/stop = get_stop(tag)
	if (!stop)
		return "That floor isn't responding."
	if (is_busy())
		return "The lift is already moving."
	if (current_location == stop)
		return "The lift is already on that floor."
	next_location = stop
	if (!can_launch())
		next_location = null
		return "Something is blocking the lift."
	launch(user)


/obj/machinery/computer/shuttle_control/lift_floors
	name = "lift controls"
	desc = "A small panel for sending the lift to a floor, or calling it to this one."
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = FALSE
	machine_name = "lift control panel"
	machine_desc = "Sends a multi-floor lift to whichever floor is picked."


/obj/machinery/computer/shuttle_control/lift_floors/is_valid_shuttle(datum/shuttle/shuttle)
	return istype(shuttle, /datum/shuttle/autodock/multi/lift)


/obj/machinery/computer/shuttle_control/lift_floors/proc/get_lift()
	var/datum/shuttle/autodock/multi/lift/lift = SSshuttle.shuttles[shuttle_tag]
	return istype(lift) ? lift : null


/obj/machinery/computer/shuttle_control/lift_floors/interface_interact(mob/user)
	var/datum/shuttle/autodock/multi/lift/lift = get_lift()
	if (!lift)
		to_chat(user, SPAN_WARNING("\The [src] can't find its lift."))
		return TRUE
	var/shown = lift.shown_stop_tag()
	var/list/choices = list()
	var/list/tags_by_label = list()
	for (var/tag in lift.destination_tags)
		if (!lift.get_stop(tag))
			continue
		var/label = lift.stop_label(tag)
		tags_by_label[label] = tag
		choices[label] = lift_floor_image(label, tag == shown)
	if (!length(choices))
		to_chat(user, SPAN_WARNING("\The [src] can't find any floors."))
		return TRUE
	var/picked = show_radial_menu(user, src, choices, require_near = !issilicon(user), tooltips = TRUE)
	if (!picked || !CanInteract(user, DefaultTopicState()))
		return TRUE
	var/problem = lift.send_to(tags_by_label[picked], user)
	if (problem)
		to_chat(user, SPAN_WARNING(problem))
		playsound(src, 'sound/machines/buzz-two.ogg', 30, FALSE)
	else
		to_chat(user, SPAN_NOTICE("You send the lift to [picked]."))
		playsound(src, "button", 60)
	return TRUE


/// A radial menu entry showing the floor's name, highlighted when the lift is there.
/obj/machinery/computer/shuttle_control/lift_floors/proc/lift_floor_image(label, current)
	var/image/entry = image(null)
	entry.maptext_width = 64
	entry.maptext_height = 32
	entry.maptext_x = -16
	entry.maptext_y = 10
	entry.maptext = STYLE_SMALLFONTS_OUTLINE("<center>[label]</center>", 7, current ? COLOR_YELLOW : COLOR_WHITE, COLOR_BLACK)
	entry.name = label
	return entry


/obj/machinery/computer/shuttle_control/lift_floors/examine(mob/user, distance)
	. = ..()
	if (distance > 2 && !isobserver(user))
		return
	var/datum/shuttle/autodock/multi/lift/lift = get_lift()
	if (!lift)
		return
	var/tag = lift.shown_stop_tag()
	if (!tag)
		return
	if (lift.moving_status == SHUTTLE_IDLE)
		to_chat(user, SPAN_NOTICE("The display shows the lift waiting at [lift.stop_label(tag)]."))
	else
		to_chat(user, SPAN_NOTICE("The display shows the lift heading to [lift.stop_label(tag)]."))


/// The landmark tag of this lift's stop on z-level `z`, or null if it doesn't stop there.
/datum/shuttle/autodock/multi/lift/proc/stop_on_z(z)
	for (var/tag in destination_tags)
		var/obj/shuttle_landmark/stop = get_stop(tag)
		if (stop?.z == z)
			return tag


/obj/machinery/lift_call_button
	name = "lift call button"
	desc = "Calls the lift to this floor."
	icon = 'icons/obj/structures/turbolift.dmi'
	icon_state = "button"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_WINDOW_LAYER
	mouse_opacity = MOUSE_OPACITY_PRIORITY
	idle_power_usage = 5
	var/shuttle_tag
	var/lit = FALSE


/obj/machinery/lift_call_button/Initialize()
	. = ..()
	set_dir(dir)


/// Sits on the wall behind it, like the turbolift buttons.
/obj/machinery/lift_call_button/set_dir(new_dir)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	if (dir & NORTH)
		pixel_y = -28
	else if (dir & SOUTH)
		pixel_y = 28
	else if (dir & EAST)
		pixel_x = -28
	else if (dir & WEST)
		pixel_x = 28


/obj/machinery/lift_call_button/proc/get_lift()
	RETURN_TYPE(/datum/shuttle/autodock/multi/lift)
	var/datum/shuttle/autodock/multi/lift/lift = SSshuttle.shuttles[shuttle_tag]
	return istype(lift) ? lift : null


/obj/machinery/lift_call_button/interface_interact(mob/user)
	var/datum/shuttle/autodock/multi/lift/lift = get_lift()
	var/tag = lift?.stop_on_z(z)
	if (!tag)
		to_chat(user, SPAN_WARNING("\The [src] doesn't light up: the lift doesn't stop here."))
		return TRUE
	if (!issilicon(user))
		user.visible_message(SPAN_NOTICE("\The [user] presses \the [src]."))
	playsound(src, "button", 50)
	if (lift.moving_status == SHUTTLE_IDLE && lift.current_location?.landmark_tag == tag)
		to_chat(user, SPAN_NOTICE("The lift is already here."))
		return TRUE
	if (lit)
		return TRUE
	var/problem = lift.send_to(tag, user)
	// Busy elsewhere: the button stays lit and the lift comes once it's free.
	if (problem && !lift.is_busy())
		to_chat(user, SPAN_WARNING(problem))
		playsound(src, 'sound/machines/buzz-two.ogg', 30, FALSE)
		return TRUE
	set_lit(TRUE)
	addtimer(new Callback(src, PROC_REF(wait_for_lift), tag), 1 SECOND)
	return TRUE


/// Keeps the button lit until the lift is here, sending it on once it's free if it was busy.
/obj/machinery/lift_call_button/proc/wait_for_lift(tag)
	if (QDELETED(src) || !lit)
		return
	var/datum/shuttle/autodock/multi/lift/lift = get_lift()
	if (!lift)
		set_lit(FALSE)
		return
	if (lift.moving_status == SHUTTLE_IDLE && lift.current_location?.landmark_tag == tag)
		set_lit(FALSE)
		playsound(src, 'sound/machines/ding.ogg', 40, FALSE)
		return
	if (!lift.is_busy() && lift.send_to(tag))
		// Free, but it still can't come: something's in the way.
		set_lit(FALSE)
		return
	addtimer(new Callback(src, PROC_REF(wait_for_lift), tag), 1 SECOND)


/obj/machinery/lift_call_button/proc/set_lit(new_lit)
	lit = new_lit
	update_icon()


/obj/machinery/lift_call_button/on_update_icon()
	icon_state = lit ? "button_lit" : "button"


/obj/machinery/lift_call_button/examine(mob/user, distance)
	. = ..()
	if (distance > 2 && !isobserver(user))
		return
	var/datum/shuttle/autodock/multi/lift/lift = get_lift()
	var/tag = lift?.shown_stop_tag()
	if (!tag)
		return
	if (lift.moving_status == SHUTTLE_IDLE)
		to_chat(user, SPAN_NOTICE("The floor indicator above it shows the lift at [lift.stop_label(tag)]."))
	else
		to_chat(user, SPAN_NOTICE("The floor indicator above it shows the lift heading to [lift.stop_label(tag)]."))
