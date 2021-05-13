/datum/artifact_trigger/force
	name = "kinetic impact"

/datum/artifact_trigger/force/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/projectile))
		var/obj/item/projectile/P = O
		return (P.damage_type == DAMAGE_BRUTE)
	else if(istype(O, /obj/item))
		var/obj/item/I = O
		return I.force >= 10

/datum/artifact_trigger/force/on_explosion(severity)
	return TRUE

/datum/artifact_trigger/force/on_bump(atom/movable/AM)
	. = ..()
	if(isobj(AM))
		var/obj/O = AM
		if(O.throwforce >= 10)
			return TRUE
