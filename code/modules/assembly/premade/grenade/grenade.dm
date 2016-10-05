/obj/item/device/assembly_holder/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = 2.0
	icon = 'icons/obj/assemblies/assembly_holders.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT
	max_connections = 5
	connected_devices = list()
	var/default_grenade = 1 // Whether New() spawns the default stuff
	var/active = 0
	var/obj/item/device/assembly/explosive/explosive
	var/obj/item/device/assembly/igniter/igniter // Ease of access, reference to objects in connected_devices
	var/obj/item/device/assembly/detonator		 // Included because ex_act & inheritance
	var/obj/item/device/assembly/trigger
	var/obj/item/device/assembly/speaker/speaker

	premade_devices = list(/obj/item/device/assembly/explosive,
						   /obj/item/device/assembly/igniter,
						   /obj/item/device/assembly/timer,
						   /obj/item/device/assembly/button)

/obj/item/device/assembly_holder/grenade/New()
	..()
	if(default_grenade)
		igniter = new /obj/item/device/assembly/igniter (src)
		trigger = new /obj/item/device/assembly/button (src)
		explosive = new /obj/item/device/assembly/explosive (src)
		detonator = new /obj/item/device/assembly/timer (src)
	if(trigger) attach_device(null, trigger)
	if(detonator) attach_device(null, detonator)
	if(igniter) attach_device(null, igniter)
	if(explosive) attach_device(null, explosive)

/obj/item/device/assembly_holder/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>Huh? How does this thing work?</span>"

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1

/obj/item/device/assembly_holder/grenade/remove_connected_device(var/obj/O)
	if(O == trigger)
		trigger = null
	if(O == explosive)
		explosive = null
	if(O == igniter)
		igniter = null
	if(O == detonator)
		detonator = null
	..()

/*/obj/item/device/assembly_holder/grenade/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (istype(target, /obj/item/weapon/storage)) return ..() // Trying to put it in a full container
	if (istype(target, /obj/item/weapon/gun/grenadelauncher)) return ..()
	if((user.get_active_hand() == src) && (!active) && (clown_check(user)) && target.loc != src.loc)
		user << "<span class='warning'>You prime the [name]! [det_time/10] seconds!</span>"
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		spawn(det_time)
			prime()
			return
		user.set_dir(get_dir(user, target))
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
	return*/


/obj/item/device/assembly_holder/grenade/examine(mob/user)
	if(..(user, 0))
		if(detonator)
			if(istype(detonator, /obj/item/device/assembly/timer))
				var/obj/item/device/assembly/timer/timer = detonator
				var/det_time = timer.time
				user << "The timer is set [det_time ? "to [det_time] seconds." : "for instant detonation"]"
			else if(istype(detonator, /obj/item/stack/cable_coil))
				user << "\The [src] is set for instant detonation."
		if(explosive && istype(explosive, /obj/item/device/assembly/explosive))
			var/obj/item/device/assembly/explosive/E = explosive
			if(E.used)
				user << "It looks like it's been used.."

/obj/item/device/assembly_holder/grenade/attack_self(mob/user as mob)
	..()
	if(!active)
		if(clown_check(user))
			if(igniter && detonator && trigger)
				if(istype(detonator, /obj/item/device/assembly/timer))
					var/obj/item/device/assembly/timer/timer = detonator
					user << "<span class='warning'>You prime \the [name]! [timer.time] seconds!</span>"
				activate(user)
				add_fingerprint(user)
				if(iscarbon(user))
					var/mob/living/carbon/C = user
					C.throw_mode_on()
	return


/obj/item/device/assembly_holder/grenade/proc/activate(mob/user as mob)
	if(user && !active)
		spawn(0)
			if(trigger)
				active = 1
				trigger.activate()
		if(istype(detonator, /obj/item/device/assembly/timer))
			var/obj/item/device/assembly/timer/T = detonator
			icon_state = initial(icon_state) + "_active"
			spawn(T.time+1)
				icon_state = initial(icon_state)
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

/obj/item/device/assembly_holder/grenade/proc/prime() // Leaving this here for anything that forces detonation.
//	playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
	active = 1
	if(trigger)
		trigger.activate()


/obj/item/device/assembly_holder/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isscrewdriver(W))
		if(detonator && istype(detonator, /obj/item/device/assembly/timer) && !active)
			var/obj/item/device/assembly/timer/timer = detonator
			switch(timer.time)
				if (1)
					timer.time = 10
					user << "<span class='notice'>You set the [name] for 1 second detonation time.</span>"
				if (10)
					timer.time = 30
					user << "<span class='notice'>You set the [name] for 3 second detonation time.</span>"
				if (30)
					timer.time = 50
					user << "<span class='notice'>You set the [name] for 5 second detonation time.</span>"
				if (50)
					timer.time = 1
					user << "<span class='notice'>You set the [name] for instant detonation.</span>"
		add_fingerprint(user)
	..()
	return

/obj/item/device/assembly_holder/grenade/attack_hand()
	walk(src, null, null)
	..()
	return
