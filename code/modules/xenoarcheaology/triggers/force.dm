/datum/artifact_trigger/force
	name = "kinetic impact"

/datum/artifact_trigger/force/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/projectile))
		var/obj/item/projectile/P = O
		return (P.damage_type == BRUTE)
	else if(istype(O, /obj/item/weapon))
		var/obj/item/weapon/W = O
		return (W.force >= 10)

/datum/artifact_trigger/force/on_explosion(severity)
	return TRUE

/datum/artifact_trigger/force/on_bump(atom/movable/AM)
	. = ..()
	if(isobj(AM))
		var/obj/O = AM
		if(O.throwforce >= 10)
			return TRUE