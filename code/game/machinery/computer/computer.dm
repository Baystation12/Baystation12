/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 300
	active_power_usage = 300
	construct_state = /decl/machine_construction/default/panel_closed/computer
	uncreated_component_parts = null
	stat_immune = 0
	frame_type = /obj/machinery/constructable_frame/computerframe/deconstruct
	var/processing = 0

	var/max_health = 80
	var/health
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
	health = max_health
	update_icon()

/obj/machinery/computer/emp_act(severity)
	..()
	if(prob(20/severity))
		take_damage(max_health)

/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
			return
		if(EX_ACT_HEAVY)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				for(var/x in verbs)
					verbs -= x
				take_damage(max_health)
		if(EX_ACT_LIGHT)
			if (prob(25))
				for(var/x in verbs)
					verbs -= x
				take_damage(max_health)

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	..()

/obj/machinery/computer/attackby(obj/item/I, mob/user)
	if (isScrewdriver(I) || isWrench(I) || isCrowbar(I))
		return ..() // handled by construction
	if (user.a_intent != I_HURT)
		return ..()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(src, 'sound/weapons/smash.ogg', 25, 1)
	take_damage(I.force)
	..()

/obj/machinery/computer/proc/take_damage(var/damage)
	if (health <= 0 || !can_use_tools)
		return

	health -= damage
	if(health <= 0)
		set_broken(TRUE)
		visible_message(SPAN_WARNING("\The [src] breaks!"))

/obj/machinery/computer/on_update_icon()
	overlays.Cut()
	icon = initial(icon)
	icon_state = initial(icon_state)

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
		overlays += get_screen_overlay()

	overlays += get_keyboard_overlay()

/obj/machinery/computer/proc/get_screen_overlay()
	return image(icon,icon_screen, overlay_layer)

/obj/machinery/computer/proc/get_keyboard_overlay()
	if(icon_keyboard)
		overlays += image(icon, icon_keyboard, overlay_layer)

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext_char(text, "\n", "<BR>")
	return text

/obj/machinery/computer/dismantle(mob/user)
	if(stat & BROKEN)
		to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
		for(var/obj/item/stock_parts/console_screen/screen in component_parts)
			qdel(screen)
			new /obj/item/material/shard(loc)
	else
		to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
	return ..()
