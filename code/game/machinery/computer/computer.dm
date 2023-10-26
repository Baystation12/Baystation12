/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/machines/computer.dmi'
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
	var/light_power_on = 1
	var/light_range_on = 2
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
	update_glow()
	ClearOverlays()
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
		icon = 'icons/obj/machines/computer.dmi'
		icon_state = "wired"
		var/screen = get_component_of_type(/obj/item/stock_parts/console_screen)
		var/keyboard = get_component_of_type(/obj/item/stock_parts/keyboard)
		if(screen)
			AddOverlays("comp_screen")
		if(keyboard)
			AddOverlays(icon_keyboard ? "[icon_keyboard]_off" : "keyboard")
		return

	if(!is_powered())
		if(icon_keyboard)
			AddOverlays(image(icon,"[icon_keyboard]_off", overlay_layer))
		return

	if(MACHINE_IS_BROKEN(src))
		AddOverlays(image(icon,"[icon_state]_broken", overlay_layer))
	else
		AddOverlays(get_screen_overlay())

	AddOverlays(get_keyboard_overlay())
	var/screen_is_glowing = update_glow()
	if(screen_is_glowing)
		AddOverlays(emissive_appearance(icon, icon_screen))
		if(icon_keyboard)
			AddOverlays(emissive_appearance(icon, "[icon_keyboard]_mask"))

/obj/machinery/computer/proc/get_screen_overlay()
	return overlay_image(icon,icon_screen)

/obj/machinery/computer/proc/get_keyboard_overlay()
	if(icon_keyboard)
		return overlay_image(icon, icon_keyboard, overlay_layer)

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/**
 * Makes the computer emit light if the screen is on.
 * Returns TRUE if the screen is on, otherwise FALSE.
 */
/obj/machinery/computer/proc/update_glow()
	if (operable())
		set_light(light_range_on, light_power_on, light_color)
		return TRUE
	else
		set_light(0)
		return FALSE

/obj/machinery/computer/dismantle(mob/user)
	if(MACHINE_IS_BROKEN(src))
		to_chat(user, SPAN_NOTICE("The broken glass falls out."))
		for(var/obj/item/stock_parts/console_screen/screen in component_parts)
			qdel(screen)
			new /obj/item/material/shard(loc)
	else
		to_chat(user, SPAN_NOTICE("You disconnect the monitor."))
	return ..()
