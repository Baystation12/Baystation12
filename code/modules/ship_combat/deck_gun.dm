/obj/item/weapon/gun/projectile/automatic/deck_gun
	name = "deck gun"
	desc = "A humungous deck gun."
	w_class = 20
	force = 10
	slot_flags = 0
	max_shells = 64
	caliber = "60mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 2)
	ammo_type = null
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/deck_gun/light
	invisibility = 101
	burst = 8
	burst_delay = 10
	accuracy = -3
	burst_accuracy = list(0,-1,-2,-2,-3,-3,-4,-5,-6,-7)
	dispersion = list(0.2, 1.2, 1.4, 1.6, 1.8,2.0,2.2,2.8,3.3,4.0)

	Fire()
		get_burst()
		spawn(0)
			..()

	proc/get_burst()
		if(ammo_magazine)
			if(istype(ammo_magazine, /obj/item/ammo_magazine/deck_gun))
				var/obj/item/ammo_magazine/deck_gun/M = ammo_magazine
				burst = M.burst
				burst_delay = M.burst_delay
				accuracy = M.accuracy



/obj/item/weapon/gun/projectile/automatic/deck_gun/special_check(var/mob/user)
	return 1

/obj/machinery/space_battle/deck_gun
	name = "machine gun"
	desc = "A humungous machine gun meant for ship-to-ship battles."
	icon = 'icons/obj/missile.dmi'
	icon_state = "deck_gun"
	anchored = 1
	density = 1
	var/width = 2
	var/firing = 0

	idle_power_usage = 100
	power_channel = EQUIP

	var/obj/machinery/missile/magazine/magazine
	var/obj/item/weapon/gun/projectile/automatic/deck_gun/gun

	New()
		..()
		gun = new(src)
		switch(dir)
			if(EAST, WEST)
				bound_width = width * world.icon_size
				bound_height = world.icon_size
			else
				bound_width = world.icon_size
				bound_height = width * world.icon_size
		return

/obj/machinery/space_battle/deck_gun/bullet_act(var/obj/item/P)
	src.visible_message("<span class='warning'>\The [P] richochets off of \the [src]!</span>")
	return 0

/obj/machinery/space_battle/deck_gun/ex_act(severity)
	switch(severity)
		if(1)
			return ..()
		if(2)
			if(prob(50))
				return ..()
	return 0

/obj/machinery/space_battle/deck_gun/proc/fire_at(var/turf/T, var/mob/missile_eye/eye)
	if(stat & BROKEN) return "ERROR: Gun battery damaged!"
	else if(stat & NOPOWER) return "ERROR: Gun battery unpowered!"
	if(!gun) return "ERROR: This is a bug, the gun has disappeared!"
//	var/obj/item/projectile/A = gun.consume_next_projectile()
//	if(!A) return "ERROR: Low ammo!"
	if(!isspace(get_turf(eye)))
		return "ERROR: You cannot fire through the floor!"
	gun.forceMove(T)
	gun.Fire(T, eye)
	firing = 1
	spawn(5)
		if(!(gun.ammo_magazine && gun.ammo_magazine.stored_ammo.len))
			var/obj/item/ammo_magazine/mag = gun.ammo_magazine
			if(mag)
				mag.forceMove(get_turf(src)) // Move it out of contents to delete it.
				gun.ammo_magazine = null
				src.visible_message("<span class='notice'>\The [src] clicks as it ejects the used magazine into space.</span>")
				if(eye)
					eye << "<span class='notice'>\The [src] clicks as it ejects the used magazine into space.</span>"
				icon_state = "[initial(icon_state)]_unloaded"
				qdel(mag)
		spawn(10)
			firing = 0
		use_power(rand(500, 1000))

/obj/machinery/space_battle/deck_gun/attack_hand(var/mob/user)
	if(stat & BROKEN)
		user << "The Gun battery is damaged!"
		return
	else if(stat & NOPOWER)
		user << "The Gun battery is unpowered!"
		return

	var/rdir = reverse_direction(dir)
	var/turf/T = get_step(src, rdir)
	var/obj/machinery/missile/magazine/mag = locate() in T
	if(!mag)
		T = get_step(T, rdir)
		mag = locate() in T
		if(!mag)
			user << "<span class='warning'>There is no magazine to load!</span>"
			return
	else if(gun.ammo_magazine)
		user << "<span class='warning'>There is already has a magazine loaded!</span>"
		return
	else if(!mag.magazine)
		user << "<span class='warning'>That magazine is empty!</span>"
		return
	if(mag)
		user.visible_message("<span class='notice'>[usr] begins loading \the [mag] into \the [src].</span>")
		if(do_after(user,250))
			visible_message("<span class='notice'>\The [src] clunks loudly as it loads \the [mag].</span>")
			gun.ammo_magazine = mag.magazine
			mag.magazine.forceMove(gun)
			mag.magazine = null
			spawn(1)
				qdel(mag)
				icon_state = initial(icon_state)


