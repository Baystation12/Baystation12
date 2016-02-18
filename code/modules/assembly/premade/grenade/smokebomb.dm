//Going to leave this one as is, reason being that reagent-smoke would be alot more resource consuming.
//This of course makes it non-modifiable.
/obj/item/device/assembly_holder/grenade/smokebomb
	desc = "It is set to detonate in 2 seconds."
	name = "smoke bomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "flashbang"
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	max_connections = 0
	var/datum/effect/effect/system/smoke_spread/bad/smoke

	New()
		..()
		src.smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread/bad)
		src.smoke.attach(src)

	prime()
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
