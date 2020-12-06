/obj/item/weapon/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	var/active = 0
	var/det_time = 50
	var/fail_det_time = 5 // If you are clumsy and fail, you get this time.
	var/arm_sound = 'sound/weapons/armbomb.ogg'

/obj/item/weapon/grenade/proc/clown_check(var/mob/living/user)
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")
		det_time = fail_det_time
		activate(user)
		add_fingerprint(user)
		return 0
	return 1

/obj/item/weapon/grenade/examine(mob/user, distance)
	. = ..()
	if(distance <= 0)
		if(det_time > 1)
			to_chat(user, "The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The [src] is set for instant detonation.")

/obj/item/weapon/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>")
			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()

/obj/item/weapon/grenade/proc/activate(mob/user)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, arm_sound, 75, 0, -3)
	addtimer(CALLBACK(src, .proc/detonate), det_time)

/obj/item/weapon/grenade/proc/detonate()
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)

/obj/item/weapon/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	..()

/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()