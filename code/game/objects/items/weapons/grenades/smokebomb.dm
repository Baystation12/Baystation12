/obj/item/weapon/grenade/smokebomb
	desc = "It is set to detonate in 2 seconds."
	name = "smoke grenade"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "grenade_smoke"
	det_time = 20
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	var/datum/effect/effect/system/smoke_spread/smoke

/obj/item/weapon/grenade/smokebomb/covenant
	name = "Type-0 Visual Occlusion Device"
	desc = "This simple device creates a protective screen of smoke. Fuse 2 seconds. Do not swallow. Prophet approved(tm)."
	icon = 'code/modules/halo/weapons/icons/Covenant Weapons.dmi'


/obj/item/weapon/grenade/smokebomb/New()
	..()
	src.smoke = new /datum/effect/effect/system/smoke_spread()
	src.smoke.attach(src)

/obj/item/weapon/grenade/smokebomb/Destroy()
	qdel(smoke)
	smoke = null
	return ..()

/obj/item/weapon/grenade/smokebomb/detonate()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	src.smoke.set_up(10, 0, usr.loc)
	spawn(0)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()

	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update_icon()
	sleep(80)
	qdel(src)
	return
