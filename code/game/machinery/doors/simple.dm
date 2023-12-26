/obj/machinery/door/unpowered/simple
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/icon_base
	damage_hitsound = 'sound/weapons/genhit.ogg'
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.
	autoset_access = FALSE // Doesn't even use access
	pry_mod = 0.1

/obj/machinery/door/unpowered/simple/New(newloc, material_name, locked)
	..()
	if(!material_name)
		material_name = MATERIAL_STEEL
	material = SSmaterials.get_material_by_name(material_name)
	if(!material)
		return INITIALIZE_HINT_QDEL
	set_max_health(max(100, material.integrity * 2))
	if(!icon_base)
		icon_base = material.door_icon_base
	damage_hitsound = material.hitsound
	name = "[material.display_name] door"
	color = material.icon_colour
	if(initial_lock_value)
		locked = initial_lock_value
	if(locked)
		lock = new(src,locked)
	if(material.luminescence)
		set_light(material.luminescence, 0.5, l_color = material.icon_colour)

	if(material.opacity < 0.5)
		glass = TRUE
		alpha = 180
		set_opacity(0)

	if(!density)
		set_opacity(0)
	update_icon()

/obj/machinery/door/unpowered/simple/c_airblock(turf/other)
	return FALSE

/obj/machinery/door/unpowered/simple/requiresID()
	return 0

/obj/machinery/door/unpowered/simple/get_material()
	return material

/obj/machinery/door/unpowered/simple/get_material_name()
	return material.name

/obj/machinery/door/unpowered/simple/on_update_icon()
	update_dir()
	if(density)
		icon_state = "[icon_base]"
	else
		icon_state = "[icon_base]open"
	return

/obj/machinery/door/unpowered/simple/do_animate(animation)
	switch(animation)
		if("opening")
			flick("[icon_base]opening", src)
		if("closing")
			flick("[icon_base]closing", src)
	return

/obj/machinery/door/unpowered/simple/inoperable()
	return !!reason_broken

/obj/machinery/door/unpowered/simple/close(forced = 0)
	if(!can_close(forced))
		return

	// If the door is blocked, don't close
	for(var/turf/A in locs)
		var/turf/T = A
		var/obstruction = T.get_obstruction()
		if (obstruction)
			return

	playsound(src.loc, material.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/open(forced = 0)
	if(!can_open(forced))
		return
	playsound(src.loc, material.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/set_broken(new_state, cause = MACHINE_BROKEN_GENERIC)
	..()
	if(new_state)
		deconstruct(null)

/obj/machinery/door/unpowered/simple/deconstruct(mob/user, moved = FALSE)
	material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/machinery/door/unpowered/simple/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(Adjacent(user)) //not remotely though
			return attack_hand(user)


/obj/machinery/door/unpowered/simple/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/key) && lock)
		var/obj/item/key/K = I
		if(!lock.toggle(I))
			to_chat(user, SPAN_WARNING("\The [K] does not fit in the lock!"))
		return TRUE

	if(lock && lock.pick_lock(I,user))
		return TRUE

	if(istype(I,/obj/item/material/lock_construct))
		if(lock)
			to_chat(user, SPAN_WARNING("\The [src] already has a lock."))
		else
			var/obj/item/material/lock_construct/L = I
			lock = L.create_lock(src,user)
		return TRUE

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(MACHINE_IS_BROKEN(src))
			to_chat(user, SPAN_NOTICE("It looks like \the [src] is pretty busted. It's going to need more than just patching up now."))
			return TRUE
		if (!get_damage_value())
			to_chat(user, SPAN_NOTICE("Nothing to fix!"))
			return TRUE
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return TRUE

		//figure out how much metal we need
		var/obj/item/stack/stack = I
		var/amount_needed = ceil(get_damage_value() / DOOR_REPAIR_AMOUNT)
		var/used = min(amount_needed,stack.amount)
		if (used)
			to_chat(user, SPAN_NOTICE("You fit [stack.get_exact_name(used)] to damaged and broken parts on \the [src]."))
			stack.use(used)
			restore_health(used * DOOR_REPAIR_AMOUNT)
		return TRUE

	if(operating)
		return TRUE

	if ((. = ..()))
		return

	if(lock && lock.isLocked())
		to_chat(user, "\The [src] is locked!")
		return TRUE

	if(operable())
		if(src.density)
			open()
		else
			close()
		return TRUE


/obj/machinery/door/unpowered/simple/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && lock)
		to_chat(user, SPAN_NOTICE("It appears to have a lock."))

/obj/machinery/door/unpowered/simple/can_open()
	if(!..() || (lock && lock.isLocked()))
		return 0
	return 1

/obj/machinery/door/unpowered/simple/Destroy()
	QDEL_NULL(lock)
	return ..()

/obj/machinery/door/unpowered/simple/iron/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_IRON, complexity)

/obj/machinery/door/unpowered/simple/silver/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_SILVER, complexity)

/obj/machinery/door/unpowered/simple/gold/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_GOLD, complexity)

/obj/machinery/door/unpowered/simple/uranium/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_URANIUM, complexity)

/obj/machinery/door/unpowered/simple/sandstone/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_SANDSTONE, complexity)

/obj/machinery/door/unpowered/simple/diamond/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_DIAMOND, complexity)

/obj/machinery/door/unpowered/simple/wood/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_WOOD, complexity)

/obj/machinery/door/unpowered/simple/mahogany/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_MAHOGANY, complexity)

/obj/machinery/door/unpowered/simple/maple/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_MAPLE, complexity)

/obj/machinery/door/unpowered/simple/ebony/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_EBONY, complexity)

/obj/machinery/door/unpowered/simple/walnut/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_WALNUT, complexity)

/obj/machinery/door/unpowered/simple/plastic/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_PLASTIC, complexity)

/obj/machinery/door/unpowered/simple/plastic/open
	density = FALSE

/obj/machinery/door/unpowered/simple/glass/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_GLASS, complexity)

/obj/machinery/door/unpowered/simple/cult/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_CULT, complexity)

/obj/machinery/door/unpowered/simple/supermatter/New(newloc,material_name,complexity)
	..(newloc, MATERIAL_SUPERMATTER, complexity)
