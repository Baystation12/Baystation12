/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 300
	active_power_usage = 300
	construct_state = /singleton/machine_construction/default/panel_closed/computer
	uncreated_component_parts = null
	stat_immune = 0
	frame_type = /obj/machinery/constructable_frame/computerframe/deconstruct
	var/processing = 0

	health_max = 80
	damage_hitsound = 'sound/weapons/smash.ogg'

	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_max_bright_on = 0.2
	var/light_inner_range_on = 0.1
	var/light_outer_range_on = 2
	var/overlay_layer
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	clicksound = "keyboard"

/obj/machinery/computer/New()
	overlay_layer = layer
	..()

/obj/machinery/computer/Initialize()
	. = ..()
	update_icon()

/obj/machinery/computer/can_damage_health(damage, damage_type)
	if (!can_use_tools)
		return FALSE
	. = ..()

/obj/machinery/computer/on_death()
	..()
	visible_message(SPAN_WARNING("\The [src] breaks!"))

/obj/machinery/computer/on_update_icon()
	overlays.Cut()
	icon = initial(icon)
	icon_state = initial(icon_state)

	// Connecting multiple computers in a row
	if(initial(icon_state) == "computer")
		var/append_string = ""
		var/left = turn(dir, 90)
		var/right = turn(dir, -90)
		var/turf/L = get_step(src, left)
		var/turf/R = get_step(src, right)
		var/obj/machinery/computer/LC = locate() in L
		var/obj/machinery/computer/RC = locate() in R
		if(LC && LC.dir == dir && initial(LC.icon_state) == "computer")
			append_string += "_L"
		if(RC && RC.dir == dir && initial(RC.icon_state) == "computer")
			append_string += "_R"
		icon_state = "computer[append_string]"


	if(reason_broken & MACHINE_BROKEN_NO_PARTS)
		set_light(0)
		icon = 'icons/obj/computer.dmi'
		icon_state = "wired"
		var/screen = get_component_of_type(/obj/item/stock_parts/console_screen)
		var/keyboard = get_component_of_type(/obj/item/stock_parts/keyboard)
		if(screen)
			overlays += "comp_screen"
		if(keyboard)
			overlays += icon_keyboard ? "[icon_keyboard]_off" : "keyboard"
		return

	if(!is_powered())
		set_light(0)
		if(icon_keyboard)
			overlays += image(icon,"[icon_keyboard]_off", overlay_layer)
		return
	else
		set_light(light_max_bright_on, light_inner_range_on, light_outer_range_on, 2, light_color)

	if(MACHINE_IS_BROKEN(src))
		overlays += image(icon,"[icon_state]_broken", overlay_layer)
	else
		overlays += get_screen_overlay()

	overlays += get_keyboard_overlay()

/obj/machinery/computer/proc/get_screen_overlay()
	return overlay_image(icon,icon_screen, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)

/obj/machinery/computer/proc/get_keyboard_overlay()
	if(icon_keyboard)
		overlays += image(icon, icon_keyboard, overlay_layer)

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/dismantle(mob/user)
	if(MACHINE_IS_BROKEN(src))
		to_chat(user, SPAN_NOTICE("The broken glass falls out."))
		for(var/obj/item/stock_parts/console_screen/screen in component_parts)
			qdel(screen)
			new /obj/item/material/shard(loc)
	else
		to_chat(user, SPAN_NOTICE("You disconnect the monitor."))
	return ..()
