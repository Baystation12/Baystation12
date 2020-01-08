#define WARNING_DELAY 80			//seconds between warnings.
var/list/ship_inertial_dampers = list()

/datum/ship_inertial_damper
	var/name = "ship inertial damper"
	var/obj/machinery/holder

/datum/ship_inertial_damper/proc/get_damping_strength(var/reliable)
	return 0

/datum/ship_inertial_damper/New(var/obj/machinery/_holder)
	..()
	holder = _holder
	ship_inertial_dampers += src

/datum/ship_inertial_damper/Destroy()
	ship_inertial_dampers -= src
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.ships)
		S.inertial_dampers -= src
	holder = null
	. = ..()

/obj/machinery/inertial_damper
	name = "inertial damper"
	icon = 'icons/obj/machines/inertial_damper.dmi'
	desc = "An inertial damper, a very large machine that balances against engine thrust to prevent harm to the crew."
	density = TRUE
	icon_state = "damper_on"

	base_type = /obj/machinery/inertial_damper
	construct_state = /decl/machine_construction/default/panel_closed
	wires = /datum/wires/inertial_damper
	uncreated_component_parts = null
	stat_immune = FALSE

	var/datum/ship_inertial_damper/controller

	var/active = TRUE
	idle_power_usage = 1 KILOWATTS
	use_power = POWER_USE_ACTIVE
	anchored = TRUE
	var/damping_strength = 1 //units of Gm/h
	var/damping_modifier = 0 //modifier due to events
	var/target_strength = 1
	var/delta = 0.01
	var/max_strength = 5
	var/power_draw
	var/max_power_draw = 200 KILOWATTS
	var/lastwarning = 0
	var/warned = FALSE

	var/was_reset = FALSE //if this inertial damper was fully turned off recently (zero damping strength, no power)

	var/hacked = FALSE
	var/locked = FALSE
	var/ai_control_disabled = FALSE
	var/input_cut = FALSE

	var/current_overlay = null
	var/width = 3
	var/height = 3
	pixel_x = -32
	pixel_y = -32

/obj/machinery/inertial_damper/New()
	. = ..()
	SetBounds()
	update_nearby_tiles(locs)

/obj/machinery/inertial_damper/Initialize()
	. = ..()
	controller = new(src)

	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.ships)
		if(S.check_ownership(src))
			S.inertial_dampers |= controller

	src.overlays += "activated"

/obj/machinery/inertial_damper/Process()
	..()
	if(active && !(stat & (NOPOWER | BROKEN)) && !input_cut)
		delta = initial(delta)
		power_draw = (damping_strength / max_strength) * max_power_draw
		change_power_consumption(power_draw, POWER_USE_ACTIVE)

		// Provide a warning if our inertial damping level is decreasing past a threshold and we haven't already warned since someone last adjusted the setting
		if(!warned && damping_strength < 0.3*initial(damping_strength) && target_strength < damping_strength && lastwarning - world.timeofday >= WARNING_DELAY)
			warned = TRUE
			lastwarning = world.timeofday
			GLOB.global_announcer.autosay("WARNING: Inertial dampening level dangerously low! All crew must be secured before firing thrusters!", "inertial damper Monitor")
	else
		delta = initial(delta) * 5 // rate of dampening strength decay is higher if we have no power
		target_strength = 0
		if(!damping_strength)
			damping_modifier = initial(damping_modifier)
			was_reset = TRUE
		change_power_consumption(0, POWER_USE_OFF)

	var/overlay_state = null
	if(!active && damping_strength == 0)
		overlay_state = null //inactive and powered off
	else if(damping_strength < initial(damping_strength))
		if(target_strength != damping_strength)
			overlay_state = "startup" //lower than default strength and changing
		else
			overlay_state = "weak" //met our target but lower than default strength
	else if(target_strength > damping_strength && damping_strength >= initial(damping_strength))
		overlay_state = "activating" //rising higher than default strength
	else
		overlay_state = "activated" //met our target higher than default strength

	if(overlay_state != current_overlay)
		overlays.Cut()
		if(overlay_state)
			overlays += overlay_state
		current_overlay = overlay_state

	if(damping_strength != target_strength)
		damping_strength = damping_strength > target_strength ? max(damping_strength - delta, target_strength) : min(damping_strength + delta, target_strength)

/obj/machinery/inertial_damper/Destroy()
	QDEL_NULL(controller)
	update_nearby_tiles(locs)
	..()

/obj/machinery/inertial_damper/proc/toggle()
	active = !active
	update_icon()
	return active

/obj/machinery/inertial_damper/proc/is_on()
	return active

/obj/machinery/inertial_damper/proc/get_damping_strength(var/reliable)
	if(hacked && !reliable)
		return initial(damping_strength)
	return damping_strength + damping_modifier

/obj/machinery/inertial_damper/proc/get_status()
	return active ? "on" : "off"

/obj/machinery/inertial_damper/on_update_icon()
	..()
	icon_state = "damper_[get_status()]"

/obj/machinery/inertial_damper/proc/SetBounds()
	bound_width = width * world.icon_size
	bound_height = height * world.icon_size

/obj/machinery/inertial_damper/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/inertial_damper/CanUseTopic(var/mob/user)
	if(issilicon(user) && !Adjacent(user) && ai_control_disabled)
		return STATUS_UPDATE
	return ..()

/obj/machinery/inertial_damper/OnTopic(user, href_list, datum/topic_state/state)
	if(locked)
		to_chat(user, SPAN_WARNING("\The [src]'s controls are not responding."))
		return TOPIC_NOACTION

	if(href_list["toggle"])
		toggle()
		return TOPIC_REFRESH

	if(href_list["set_strength"])
		var/new_strength = input("Enter a new damper strength between 0 and [max_strength] Gm/h", "Modifying damper strength", get_damping_strength(TRUE)) as num
		if(!(new_strength in 0 to max_strength))
			to_chat(user, SPAN_WARNING("That's not a valid damper strength."))
			warned = FALSE
			return TOPIC_NOACTION

		target_strength = Clamp(new_strength, 0, max_strength)
		return TOPIC_REFRESH

	return TOPIC_NOACTION

/obj/machinery/inertial_damper/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["online"] = is_on()
	data["damping_strength"] = round(get_damping_strength(TRUE), 0.01)
	data["max_strength"] = max_strength
	data["hacked"] = hacked
	data["power_usage"] = round(power_draw/1e3)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)		
	if(!ui)
		ui = new(user, src, ui_key, "inertial_damper.tmpl", "Inertial Damper", 400, 400)
		ui.set_initial_data(data)		
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/inertial_damper/dismantle()
	if((. = ..()))
		update_nearby_tiles(locs)

#undef WARNING_DELAY