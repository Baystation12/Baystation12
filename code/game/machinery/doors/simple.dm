/obj/machinery/door/unpowered/simple
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/icon_base
	hitsound = 'sound/weapons/genhit.ogg'
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.


/obj/machinery/door/unpowered/simple/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/machinery/door/unpowered/simple/proc/TemperatureAct(temperature)
	take_damage(100*material.combustion_effect(get_turf(src),temperature, 0.3))

/obj/machinery/door/unpowered/simple/New(var/newloc, var/material_name, var/locked)
	..()
	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	maxhealth = max(100, material.integrity*10)
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

	if(material.opacity < 0.5)
		glass = 1
		set_opacity(0)
	else
		set_opacity(1)
	update_icon()

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

/obj/machinery/door/unpowered/simple/update_icon()
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
	playsound(src.loc, material.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/open(var/forced = 0)
	if(!can_open(forced))
		return
	playsound(src.loc, material.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/set_broken()
	..()
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
		if(1.0)
			set_broken()
		if(2.0)
			if(prob(25))
				set_broken()
			else
				take_damage(300)
		if(3.0)
			if(prob(20))
				take_damage(150)


/obj/machinery/door/unpowered/simple/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user, 0, I)
	if(istype(I, /obj/item/weapon/key) && lock)
		var/obj/item/weapon/key/K = I
		if(!lock.toggle(I))
			to_chat(user, "<span class='warning'>\The [K] does not fit in the lock!</span>")
		return
	if(lock && lock.pick_lock(I,user))
		return

	if(istype(I,/obj/item/weapon/material/lock_construct))
		if(lock)
			to_chat(user, "<span class='warning'>\The [src] already has a lock.</span>")
		else
			var/obj/item/weapon/material/lock_construct/L = I
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
		var/amount_needed = ceil((maxhealth - health)/DOOR_REPAIR_AMOUNT)
		var/used = min(amount_needed,stack.amount)
		if (used)
			to_chat(user, "<span class='notice'>You fit [used] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>")
			stack.use(used)
			health = between(health, health + used*DOOR_REPAIR_AMOUNT, maxhealth)
		return

	//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
		var/obj/item/weapon/W = I
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			if(W.force < min_force)
				user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
			else
				user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
				playsound(src.loc, hitsound, 100, 1)
				take_damage(W.force)
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

/obj/machinery/door/unpowered/simple/examine(mob/user)
	if(..(user,1) && lock)
		to_chat(user, "<span class='notice'>It appears to have a lock.</span>")

/obj/machinery/door/unpowered/simple/can_open()
	if(!..() || (lock && lock.isLocked()))
		return 0
	return 1

/obj/machinery/door/unpowered/simple/Destroy()
	qdel(lock)
	lock = null
	..()

/obj/machinery/door/unpowered/simple/iron/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "iron", complexity)

/obj/machinery/door/unpowered/simple/silver/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "silver", complexity)

/obj/machinery/door/unpowered/simple/gold/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "gold", complexity)

/obj/machinery/door/unpowered/simple/uranium/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "uranium", complexity)

/obj/machinery/door/unpowered/simple/sandstone/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "sandstone", complexity)

/obj/machinery/door/unpowered/simple/diamond/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "diamond", complexity)

/obj/machinery/door/unpowered/simple/wood
	icon_state = "wood"
	color = "#824b28"

/obj/machinery/door/unpowered/simple/wood/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "wood", complexity)

/obj/machinery/door/unpowered/simple/wood/saloon
	icon_base = "saloon"
	autoclose = 1
	normalspeed = 0

/obj/machinery/door/unpowered/simple/wood/saloon/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "wood", complexity)
	glass = 1
	set_opacity(0)

/obj/machinery/door/unpowered/simple/resin/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "resin", complexity)

/obj/machinery/door/unpowered/simple/cult/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "cult", complexity)