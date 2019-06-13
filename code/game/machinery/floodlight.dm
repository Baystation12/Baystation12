/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	obj_flags = OBJ_FLAG_ROTATABLE
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/power/battery
	)
	active_power_usage = 200
	power_channel = LOCAL

	var/l_max_bright = 0.8 //brightness of light when on, can be negative
	var/l_inner_range = 1 //inner range of light when on, can be negative
	var/l_outer_range = 6 //outer range of light when on, can be negative

/obj/machinery/floodlight/on_update_icon()
	overlays.Cut()
	icon_state = "flood[panel_open ? "o" : ""][panel_open && get_cell() ? "b" : ""]0[(use_power == POWER_USE_ACTIVE)]"

/obj/machinery/floodlight/power_change()
	. = ..()
	if(. && (stat & NOPOWER))
		turn_off()

// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/proc/turn_on(var/loud = 0)
	if(stat & NOPOWER)
		return FALSE
	if(use_power < POWER_USE_ACTIVE)
		update_use_power(POWER_USE_ACTIVE)
		set_light(l_max_bright, l_inner_range, l_outer_range)
		update_icon()
		if(loud)
			visible_message("\The [src] turns on.")
			playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)
	return TRUE

/obj/machinery/floodlight/proc/turn_off(var/loud = 0)
	if(use_power == POWER_USE_ACTIVE)
		update_use_power(POWER_USE_IDLE)
		set_light(0, 0)
		update_icon()
		if(loud)
			visible_message("\The [src] shuts down.")
			playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)

/obj/machinery/floodlight/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(use_power == POWER_USE_ACTIVE)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")
			playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)

/obj/machinery/floodlight/components_are_accessible(path)
	return panel_open

/obj/machinery/floodlight/attack_hand(mob/user)
	if((. = ..()))
		return
	if(use_power == POWER_USE_ACTIVE)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")
			playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)

/obj/machinery/floodlight/attackby(obj/item/weapon/W, mob/user)
	if(default_deconstruction_screwdriver(user, W))
		update_icon()
		return TRUE
	if(default_deconstruction_crowbar(user, W))
		return TRUE