/obj/machinery/door/unpowered/simple
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/icon_base
	hitsound = 'sound/weapons/genhit.ogg'
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.
	autoset_access = FALSE // Doesn't even use access
	pry_mod = 0.1

/obj/machinery/door/unpowered/simple/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/machinery/door/unpowered/simple/proc/TemperatureAct(temperature)
	take_damage(100*material.combustion_effect(get_turf(src),temperature, 0.3))

/obj/machinery/door/unpowered/simple/New(var/newloc, var/material_name, var/locked)
	..()
	if(!material_name)
		material_name = MATERIAL_STEEL
	material = SSmaterials.get_material_by_name(material_name)
	if(!material)
		return INITIALIZE_HINT_QDEL
	maxhealth = max(100, material.integrity*2)
	health = maxhealth
	if(!icon_base)
		icon_base = material.door_icon_base
	hitsound = material.hitsound
	name = "[material.display_name] door"
	color = material.icon_colour
	if(initial_lock_value)
		locked = initial_lock_value
	if(locked)
		lock = new(src,locked)
	if(material.luminescence)
		set_light(0.5, 1, material.luminescence, l_color = material.icon_colour)

	if(material.opacity < 0.5)
		glass = 1
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

/obj/machinery/door/unpowered/simple/bullet_act(var/obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()
	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100))

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

/obj/machinery/door/unpowered/simple/inoperable(var/additional_flags = 0)
	return (stat & (BROKEN|additional_flags))

/obj/machinery/door/unpowered/simple/close(var/forced = 0)
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

/obj/machinery/door/unpowered/simple/open(var/forced = 0)
	if(!can_open(forced))
		return
	playsound(src.loc, material.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/set_broken(var/new_state, var/cause = MACHINE_BROKEN_GENERIC)
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

/obj/machinery/door/unpowered/simple/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			set_broken(TRUE)
		if(EX_ACT_HEAVY)
			if(prob(25))
				set_broken(TRUE)
			else
				take_damage(300)
		if(EX_ACT_LIGHT)
			if(prob(20))
				take_damage(150)


/obj/machinery/door/unpowered/simple/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user, 0, I)
	if(istype(I, /obj/item/key) && lock)
		var/obj/item/key/K = I
		if(!lock.toggle(I))
			to_chat(user, "<span class='warning'>\The [K] does not fit in the lock!</span>")
		return
	if(lock && lock.pick_lock(I,user))
		return

	if(istype(I,/obj/item/material/lock_construct))
		if(lock)
			to_chat(user, "<span class='warning'>\The [src] already has a lock.</span>")
		else
			var/obj/item/material/lock_construct/L = I
			lock = L.create_lock(src,user)
		return

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(stat & BROKEN)
			to_chat(user, "<span class='notice'>It looks like \the [src] is pretty busted. It's going to need more than just patching up now.</span>")
			return
		if(health >= maxhealth)
			to_chat(user, "<span class='notice'>Nothing to fix!</span>")
			return
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
			return

		//figure out how much metal we need
		var/obj/item/stack/stack = I
		var/amount_needed = Ceil((maxhealth - health)/DOOR_REPAIR_AMOUNT)
		var/used = min(amount_needed,stack.amount)
		if (used)
			to_chat(user, "<span class='notice'>You fit [used] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>")
			stack.use(used)
			health = clamp(health + used * DOOR_REPAIR_AMOUNT, health, maxhealth)
		return

	if (check_force(I, user))
		return

	if(src.operating) return

	if(lock && lock.isLocked())
		to_chat(user, "\The [src] is locked!")

	if(operable())
		if(src.density)
			open()
		else
			close()
		return

	return

/obj/machinery/door/unpowered/simple/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && lock)
		to_chat(user, "<span class='notice'>It appears to have a lock.</span>")

/obj/machinery/door/unpowered/simple/can_open()
	if(!..() || (lock && lock.isLocked()))
		return 0
	return 1

/obj/machinery/door/unpowered/simple/Destroy()
	QDEL_NULL(lock)
	return ..()

/obj/machinery/door/unpowered/simple/iron/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_IRON, complexity)

/obj/machinery/door/unpowered/simple/silver/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_SILVER, complexity)

/obj/machinery/door/unpowered/simple/gold/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_GOLD, complexity)

/obj/machinery/door/unpowered/simple/uranium/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_URANIUM, complexity)

/obj/machinery/door/unpowered/simple/sandstone/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_SANDSTONE, complexity)

/obj/machinery/door/unpowered/simple/diamond/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_DIAMOND, complexity)

/obj/machinery/door/unpowered/simple/wood/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_WOOD, complexity)

/obj/machinery/door/unpowered/simple/mahogany/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_MAHOGANY, complexity)

/obj/machinery/door/unpowered/simple/maple/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_MAPLE, complexity)

/obj/machinery/door/unpowered/simple/ebony/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_EBONY, complexity)

/obj/machinery/door/unpowered/simple/walnut/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_WALNUT, complexity)

/obj/machinery/door/unpowered/simple/plastic/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_PLASTIC, complexity)

/obj/machinery/door/unpowered/simple/plastic/open
	density = FALSE

/obj/machinery/door/unpowered/simple/glass/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_GLASS, complexity)

/obj/machinery/door/unpowered/simple/cult/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_CULT, complexity)

/obj/machinery/door/unpowered/simple/supermatter/New(var/newloc,var/material_name,var/complexity)
	..(newloc, MATERIAL_SUPERMATTER, complexity)
