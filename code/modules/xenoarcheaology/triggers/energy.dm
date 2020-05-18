/datum/artifact_trigger/energy
	name = "applied high energy"
	var/global/list/energetic_things = list(
		/obj/item/weapon/melee/cultblade,
		/obj/item/weapon/card/emag,
		/obj/item/device/multitool
	)

/datum/artifact_trigger/energy/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/projectile))
		var/obj/item/projectile/P = O
		. = (P.damage_type == BURN) || (P.damage_type == ELECTROCUTE)
	if(istype(O,/obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = O 
		. = B.status
	else if (istype(O,/obj/item/weapon/melee/energy))
		var/obj/item/weapon/melee/energy/E = O
		. = E.active
	else if (is_type_in_list(O, energetic_things))
		. = TRUE
