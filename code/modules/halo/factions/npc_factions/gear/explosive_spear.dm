


/* EXPLOSIVE SPEAR */

/obj/item/weapon/explosive_spear
	name = "Combat spear"
	icon = 'khoros.dmi'
	icon_state = "explosive_spear0"
	item_icons = list(
		slot_l_hand_str = 'khoros.dmi',
		slot_r_hand_str = 'khoros.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "explosive_spearl",
		slot_r_hand_str = "explosive_spearr",
		)
	var/active = 0
	throwforce = 25
	force = 25
	sharp = 1

/obj/item/weapon/explosive_spear/attack_self(mob/user)
	active = !active
	update_icon()
	if(active)
		to_chat(user, "<span class='warning'>You trigger [src] to explode on contact.</span>")
	else
		to_chat(user, "<span class='info'>You deactivate [src].</span>")

/obj/item/weapon/explosive_spear/update_icon()
	icon_state = "explosive_spear[active]"

/obj/item/weapon/explosive_spear/afterattack(var/atom/target,var/mob/user,adjacent,var/clickparams)
	if(active)
		var/turf/T = get_turf(src)
		var/mob/living/L = src.loc
		if(istype(L))
			L.drop_from_inventory(src, T)
		explosion(T, -1, -1, 3, 6, 0, guaranteed_damage = 50, guaranteed_damage_range = 1)
		qdel(src)

/obj/item/weapon/explosive_spear/throw_impact(atom/hit_atom, var/speed)
	. = ..()
	if(hit_atom && active)
		var/turf/T = get_turf(src)
		explosion(T, -1, -1, 3, 6, 0, guaranteed_damage = 50, guaranteed_damage_range = 1)
		qdel(src)
