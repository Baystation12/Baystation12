/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1.0
	idle_power_usage = 300
	active_power_usage = 300
	construct_state = /decl/machine_construction/computer/built
	var/processing = 0

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

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken(TRUE)
	..()

/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				for(var/x in verbs)
					verbs -= x
				set_broken(TRUE)
		if(3.0)
			if (prob(25))
				for(var/x in verbs)
					verbs -= x
				set_broken(TRUE)

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage()))
		set_broken(TRUE)
	..()

/obj/machinery/computer/on_update_icon()
	overlays.Cut()
	if(stat & NOPOWER)
		set_light(0)
		if(icon_keyboard)
			overlays += image(icon,"[icon_keyboard]_off", overlay_layer)
		return
	else
		set_light(light_max_bright_on, light_inner_range_on, light_outer_range_on, 2, light_color)

	if(stat & BROKEN)
		overlays += image(icon,"[icon_state]_broken", overlay_layer)
	else
		overlays += image(icon,icon_screen, overlay_layer)

	if(icon_keyboard)
		overlays += image(icon, icon_keyboard, overlay_layer)

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/dismantle(mob/user)
	playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
	var/obj/structure/computerframe/A = new /obj/structure/computerframe(loc)
	A.set_dir(dir)
	A.anchored = 1

	var/obj/item/weapon/stock_parts/circuitboard/M = get_component_of_type(/obj/item/weapon/stock_parts/circuitboard)
	if(M)
		uninstall_component(M, refresh_parts = FALSE)
		M.deconstruct(src)
		M.forceMove(A)
		A.circuit = M

	for(var/I in component_parts)
		uninstall_component(I, refresh_parts = FALSE)
	while(LAZYLEN(uncreated_component_parts))
		var/path = uncreated_component_parts[1]
		uninstall_component(path, refresh_parts = FALSE)
	for(var/obj/C in src)
		C.dropInto(loc)

	if(stat & BROKEN)
		to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
		new /obj/item/weapon/material/shard(loc)
		A.set_state(3)
	else
		to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
		A.set_state(4)
	qdel(src)

	return TRUE