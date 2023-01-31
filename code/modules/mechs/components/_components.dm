/obj/item/mech_component
	icon = 'icons/mecha/mech_parts_held.dmi'
	w_class = ITEM_SIZE_HUGE
	gender = PLURAL
	color = COLOR_GUNMETAL
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED

	var/on_mech_icon = 'icons/mecha/mech_parts.dmi'
	var/exosuit_desc_string
	var/total_damage = 0
	var/brute_damage = 0
	var/burn_damage = 0
	var/max_damage = 60
	var/damage_state = 1
	var/list/has_hardpoints = list()
	var/decal
	var/power_use = 0
	matter = list(MATERIAL_STEEL = 15000, MATERIAL_PLASTIC = 1000, MATERIAL_OSMIUM = 500)
	dir = SOUTH

/obj/item/mech_component/set_color(new_colour)
	var/last_colour = color
	color = new_colour
	return color != last_colour

/obj/item/mech_component/emp_act(severity)
	take_burn_damage(rand((10 - (severity*3)),15-(severity*4)))
	for(var/obj/item/thing in contents)
		thing.emp_act(severity)
	..()

/obj/item/mech_component/examine(mob/user)
	. = ..()
	if(ready_to_install())
		to_chat(user, SPAN_NOTICE("It is ready for installation."))
	else
		show_missing_parts(user)

//These icons have multiple directions but before they're attached we only want south.
/obj/item/mech_component/set_dir()
	..(SOUTH)

/obj/item/mech_component/proc/show_missing_parts(mob/user)
	return

/obj/item/mech_component/proc/prebuild()
	return

/obj/item/mech_component/proc/install_component(obj/item/thing, mob/user)
	if(user.unEquip(thing, src))
		user.visible_message(SPAN_NOTICE("\The [user] installs \the [thing] in \the [src]."))
		return 1

/obj/item/mech_component/proc/update_health()
	total_damage = brute_damage + burn_damage
	if(total_damage > max_damage) total_damage = max_damage
	var/prev_state = damage_state
	damage_state = clamp(round((total_damage/max_damage) * 4), MECH_COMPONENT_DAMAGE_UNDAMAGED, MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
	if(damage_state > prev_state)
		if(damage_state == MECH_COMPONENT_DAMAGE_DAMAGED_BAD)
			playsound(src.loc, 'sound/mecha/internaldmgalarm.ogg', 40, 1)
		if(damage_state == MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
			playsound(src.loc, 'sound/mecha/critdestr.ogg', 50)

/obj/item/mech_component/proc/ready_to_install()
	return 1

/obj/item/mech_component/proc/repair_brute_damage(amt)
	take_brute_damage(-amt)

/obj/item/mech_component/proc/repair_burn_damage(amt)
	take_burn_damage(-amt)

/obj/item/mech_component/proc/take_brute_damage(amt)
	brute_damage = max(0, brute_damage + amt)
	update_health()
	if(total_damage == max_damage)
		take_component_damage(amt,0)

/obj/item/mech_component/proc/take_burn_damage(amt)
	burn_damage = max(0, burn_damage + amt)
	update_health()
	if(total_damage == max_damage)
		take_component_damage(0,amt)

/obj/item/mech_component/proc/take_component_damage(brute, burn)
	var/list/damageable_components = list()
	for(var/obj/item/robot_parts/robot_component/RC in contents)
		damageable_components += RC
	if(!length(damageable_components)) return
	var/obj/item/robot_parts/robot_component/RC = pick(damageable_components)
	if(RC.take_damage(brute, burn))
		qdel(RC)
		update_components()

/obj/item/mech_component/attackby(obj/item/thing, mob/user)
	if(isScrewdriver(thing))
		if(length(contents))
			//Filter non movables
			var/list/valid_contents = list()
			for(var/atom/movable/A in contents)
				if(!A.anchored)
					valid_contents += A
			if(!length(valid_contents))
				return
			var/obj/item/removed = pick(valid_contents)
			if(!(removed in contents))
				return
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [removed] from \the [src]."))
			removed.forceMove(user.loc)
			playsound(user.loc, 'sound/effects/pop.ogg', 50, 0)
			update_components()
		else
			to_chat(user, SPAN_WARNING("There is nothing to remove."))
		return
	if(isWelder(thing))
		repair_brute_generic(thing, user)
		return
	if(isCoil(thing))
		repair_burn_generic(thing, user)
		return
	if(istype(thing, /obj/item/device/robotanalyzer))
		to_chat(user, SPAN_NOTICE("Diagnostic Report for \the [src]:"))
		return_diagnostics(user)
		return

	return ..()

/obj/item/mech_component/proc/update_components()
	return

/obj/item/mech_component/proc/repair_brute_generic(obj/item/weldingtool/WT, mob/user)
	if(!istype(WT))
		return
	if(!brute_damage)
		to_chat(user, SPAN_NOTICE("You inspect \the [src] but find nothing to weld."))
		return
	if(!WT.isOn())
		to_chat(user, SPAN_WARNING("Turn \the [WT] on, first."))
		return
	if(WT.remove_fuel((SKILL_MAX + 1) - user.get_skill_value(SKILL_CONSTRUCTION), user))
		user.visible_message(
			SPAN_NOTICE("\The [user] begins welding the damage on \the [src]..."),
			SPAN_NOTICE("You begin welding the damage on \the [src]...")
		)
		var/repair_value = 10 * max(user.get_skill_value(SKILL_CONSTRUCTION), user.get_skill_value(SKILL_DEVICES))
		if(user.do_skilled(1 SECOND, SKILL_DEVICES , src, 0.6) && brute_damage)
			repair_brute_damage(repair_value)
			to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]."))
			playsound(user.loc, 'sound/items/Welder.ogg', 25, 1)

/obj/item/mech_component/proc/repair_burn_generic(obj/item/stack/cable_coil/CC, mob/user)
	if(!istype(CC))
		return
	if(!burn_damage)
		to_chat(user, SPAN_NOTICE("\The [src]'s wiring doesn't need replacing."))
		return

	var/needed_amount = 6 - user.get_skill_value(SKILL_ELECTRICAL)
	if(CC.get_amount() < needed_amount)
		to_chat(user, SPAN_WARNING("You need at least [needed_amount] unit\s of cable to repair this section."))
		return

	user.visible_message("\The [user] begins replacing the wiring of \the [src]...")

	if(user.do_skilled(1 SECOND, SKILL_DEVICES , src, 0.6) && burn_damage)
		if(QDELETED(CC) || QDELETED(src) || !CC.use(needed_amount))
			return

		repair_burn_damage(25)
		to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]'s wiring."))
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 25, 1)
	return

/obj/item/mech_component/proc/get_damage_string()
	switch(damage_state)
		if(MECH_COMPONENT_DAMAGE_UNDAMAGED)
			return SPAN_COLOR(COLOR_GREEN, "undamaged")
		if(MECH_COMPONENT_DAMAGE_DAMAGED)
			return SPAN_COLOR(COLOR_YELLOW, "damaged")
		if(MECH_COMPONENT_DAMAGE_DAMAGED_BAD)
			return SPAN_COLOR(COLOR_ORANGE, "badly damaged")
		if(MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
			return SPAN_COLOR(COLOR_RED, "almost destroyed")
	return SPAN_COLOR(COLOR_RED, "destroyed")

/obj/item/mech_component/proc/return_diagnostics(mob/user)
	to_chat(user, SPAN_NOTICE("[capitalize(src.name)]:"))
	to_chat(user, SPAN_NOTICE(" - Integrity: <b>[round((((max_damage - total_damage) / max_damage)) * 100)]%</b>" ))
