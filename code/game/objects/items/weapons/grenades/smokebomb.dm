/obj/item/grenade/smokebomb
	desc = "It is set to detonate in 2 seconds."
	name = "smoke bomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "flashbang"
	det_time = 20
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	var/datum/effect/effect/system/smoke_spread/bad/smoke
	var/smoke_times = 4

/obj/item/grenade/smokebomb/Destroy()
	QDEL_NULL(smoke)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/grenade/smokebomb/detonate(mob/living/user)
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	smoke = new /datum/effect/effect/system/smoke_spread/bad
	smoke.attach(src)
	smoke.set_up(10, 0, get_turf(src))
	START_PROCESSING(SSobj, src)
	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.damage_health(damage, DAMAGE_BURN)
		B.update_icon()
	QDEL_IN(src, 8 SECONDS)

/obj/item/grenade/smokebomb/Process()
	if(!QDELETED(smoke) && (smoke_times > 0))
		smoke_times--
		smoke.start()
		return
	return PROCESS_KILL
