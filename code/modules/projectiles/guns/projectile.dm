/obj/item/weapon/gun/projectile
	name = "gun"
	desc = "A gun that fires bullets."
	icon_state = "revolver"
	caliber = "357"
	origin_tech = "combat=2;materials=2"
	w_class = 3
	matter = list("metal" = 1000)
	recoil = 1

	var/eject_casings = 1 //experimental: for guns that don't eject casings, like revolvers.
	var/load_method = SINGLE_CASING|SPEEDLOADER //1 = Single shells, 2 = box or quick loader, 3 = magazine

	//For SINGLE_CASING or SPEEDLOADER guns
	var/max_shells = 0
	var/ammo_type = null
	var/list/loaded = list()

	//For MAGAZINE guns
	var/magazine_type = null
	var/obj/item/ammo_magazine/ammo_magazine = null
	var/auto_eject = 0 //if the magazine should automatically eject itself when empty.

/obj/item/weapon/gun/projectile/New()
	..()

	if(load_method & (SINGLE_CASING|SPEEDLOADER))
		for(var/i in 1 to max_shells)
			loaded += new ammo_type(src)
	if(load_method & MAGAZINE)
		ammo_magazine = new magazine_type(src)

	update_icon()

//This proc is badly named. There is no "chamber." Would be better to call this get_next_projectile() or something.
/obj/item/weapon/gun/projectile/load_into_chamber()
	if(in_chamber)
		return 1 //{R}

	var/obj/item/ammo_casing/C = null
	if(loaded.len)
		C = loaded[1] //load next casing.
		loaded -= C
	else if(ammo_magazine && ammo_magazine.stored_ammo.len)
		C = ammo_magazine.stored_ammo[1]
		ammo_magazine.stored_ammo -= C

	if(istype(C))
		if(eject_casings)
			C.loc = get_turf(src) //Eject casing onto ground.
		else
			//cycle it to the end
			if(ammo_magazine)
				ammo_magazine.stored_ammo += C
			else
				loaded += C
		
		if(C.BB)
			in_chamber = C.BB
			C.BB.loc = src  //Set projectile loc to gun.
			C.BB = null
			return 1

	return 0

//Attempts to load A into src, depending on the type of thing being loaded and the load_method
/obj/item/weapon/gun/projectile/proc/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method & AM.mag_type) || caliber != AM.caliber)
			return //incompatible

		switch(AM.mag_type)
			if(MAGAZINE)
				if(ammo_magazine)
					user << "<span class='warning'>[src] already has a magazine loaded!</span>" //already a magazine here
					return
				user.remove_from_mob(AM)
				AM.loc = src
				ammo_magazine = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src]!</span>")
			if(SPEEDLOADER)
				if(loaded.len >= max_shells)
					user << "<span class='warning'>[src] is full!</span>"
					return
				var/count = 0
				for(var/obj/item/ammo_casing/C in AM.stored_ammo)
					if(loaded.len >= max_shells)
						break
					if(C.caliber == caliber)
						C.loc = src
						loaded += C
						AM.stored_ammo -= C //should probably go inside an ammo_magazine proc, but I guess less proc calls this way...
						count++
				if(count)
					user.visible_message("[user] reloads [src].", "<span class='notice'>You load [count] round\s into [src]!</span>")
		AM.update_icon()
		update_icon()
		return

	else if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || caliber != C.caliber)
			return //incompatible
		if(loaded.len >= max_shells)
			user << "<span class='warning'>[src] is full!</span>"
			return

		user.remove_from_mob(C)
		C.loc = src
		loaded.Insert(C, 1) //add to the head of the list
		user.visible_message("[user] inserts \a [C] into [src].", "<span class='notice'>You insert \a [C] into [src]!</span>")
		update_icon()
		return

//attempts to unload src
/obj/item/weapon/gun/projectile/proc/unload_ammo(mob/user)
	if(ammo_magazine)
		user.put_in_hands(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", "<span class='notice'>You remove [ammo_magazine] from [src]!</span>")
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon()

	else if(loaded.len)
		//presumably, if it can be speed-loaded, it can be speed-unloaded.
		if(load_method & SPEEDLOADER)
			var/count = 0
			var/turf/T = get_turf(user)
			if(T)
				for(var/obj/item/ammo_casing/C in loaded)
					C.loc = T
					count++
				loaded.Cut()
			if(count)
				user.visible_message("[user] unloads [src].", "<span class='notice'>You unload [count] round\s from [src]!</span>")
		else if(load_method & SINGLE_CASING)
			var/obj/item/ammo_casing/C = loaded[loaded.len]
			loaded.len--
			user.put_in_hands(C)
			user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src]!</span>")
		update_icon()

	else
		user << "<span class='warning'>[src] is empty!</span>"

/obj/item/weapon/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	load_ammo(A, user)

/obj/item/weapon/gun/projectile/attack_self(mob/user as mob)
	if (target) //TODO replace untargeting with a hotkey
		return ..()
	unload_ammo(user)

/obj/item/weapon/gun/projectile/attack_hand(mob/user as mob)
	//allow guns with both SPEEDLOADER and SINGLE_CASING a way to remove casings without dumping everything on the floor
	if((load_method & SINGLE_CASING) && loaded.len && (src in user))
		var/obj/item/ammo_casing/C = loaded[loaded.len]
		loaded.len--
		user.put_in_hands(C)
		user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src]!</span>")
	else
		return ..()

/obj/item/weapon/gun/projectile/afterattack(atom/A, mob/living/user)
	..()
	if(auto_eject && !ammo_magazine.stored_ammo.len)
		eject_magazine(user)

//called when the magazine auto-ejects
/obj/item/weapon/gun/projectile/proc/eject_magazine(mob/user)
	if(ammo_magazine)
		ammo_magazine.loc = get_turf(src.loc)
		user.visible_message(
			"[ammo_magazine] falls out and clatters on the floor!",
			"<span class='notice'>[ammo_magazine] falls out and clatters on the floor!</span>"
			)
		ammo_magazine = null
		update_icon()

/obj/item/weapon/gun/projectile/examine(mob/user)
	..(user)
	user << "Has [getAmmo()] round\s remaining."
	if(ammo_magazine)
		user << "It has \a [ammo_magazine] loaded."
//		if(in_chamber && !loaded.len)
//			user << "However, it has a chambered round."
//		if(in_chamber && loaded.len)
//			user << "It also has a chambered round." {R}
	return

/obj/item/weapon/gun/projectile/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += ammo_magazine.stored_ammo.len
	return bullets
