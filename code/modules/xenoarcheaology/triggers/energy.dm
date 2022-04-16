/datum/artifact_trigger/energy
	name = "applied high energy"
	var/static/list/energetic_things = list(
		/obj/item/melee/cultblade,
		/obj/item/card/emag,
		/obj/item/device/multitool
	)

/datum/artifact_trigger/energy/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/projectile))
		var/obj/item/projectile/P = O
		. = (P.damage_type == DAMAGE_BURN) || (P.damage_type == DAMAGE_SHOCK)
	if(istype(O,/obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		. = B.status
	else if (istype(O,/obj/item/melee/energy))
		var/obj/item/melee/energy/E = O
		. = E.active
	else if (is_type_in_list(O, energetic_things))
		. = TRUE
