/obj/structure/wall_frame/hitby(atom/movable/AM, datum/thrownthing/TT)
	..()
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	if (isobj(AM))
		var/obj/O = AM
		tforce = O.throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return
	damage_health(tforce, DAMAGE_BRUTE)
