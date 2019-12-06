/obj/machinery/shield_diffuser
	name = "shield diffuser"
	desc = "A small underfloor device specifically designed to disrupt energy barriers."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "fdiffuser_on"
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 100
	active_power_usage = 2000
	anchored = 1
	density = 0
	level = 1
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/alarm = 0
	var/enabled = 1

/obj/machinery/shield_diffuser/Process()
	if(alarm)
		alarm--
		if(!alarm)
			update_icon()
		return

	if(!enabled)
		return
	for(var/direction in GLOB.cardinal)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/shield/S in shielded_tile)
			S.diffuse(5)

/obj/machinery/shield_diffuser/on_update_icon()
	if(alarm)
		icon_state = "fdiffuser_emergency"
		return
	if((stat & (NOPOWER | BROKEN)) || !enabled)
		icon_state = "fdiffuser_off"
	else
		icon_state = "fdiffuser_on"

/obj/machinery/shield_diffuser/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(alarm)
		to_chat(user, "You press an override button on \the [src], re-enabling it.")
		alarm = 0
		update_icon()
		return TRUE
	enabled = !enabled
	update_use_power(enabled + 1)
	update_icon()
	to_chat(user, "You turn \the [src] [enabled ? "on" : "off"].")
	return TRUE

/obj/machinery/shield_diffuser/proc/meteor_alarm(var/duration)
	if(!duration)
		return
	alarm = round(max(alarm, duration))
	update_icon()

/obj/machinery/shield_diffuser/examine(mob/user)
	. = ..()
	to_chat(user, "It is [enabled ? "enabled" : "disabled"].")
	if(alarm)
		to_chat(user, "A red LED labeled \"Proximity Alarm\" is blinking on the control panel.")
