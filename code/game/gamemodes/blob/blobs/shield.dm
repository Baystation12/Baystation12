/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "Some blob creature thingy"
	density = 1
	opacity = 0
	anchored = 1
	health = 60
	brute_resist = 1
	fire_resist = 2


	update_icon()
		if(health <= 0)
			playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
			qdel(src)
			return
		return


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(istype(mover) && mover.checkpass(PASSBLOB))	return 1
		return !density

/obj/effect/blob/shield/New()
	..()
	update_nearby_tiles()

/obj/effect/blob/shield/Destroy()
	density = 0
	update_nearby_tiles()
	..()
