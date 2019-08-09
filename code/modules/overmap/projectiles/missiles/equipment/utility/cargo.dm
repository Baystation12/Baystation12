// Passenger compartment, for the very brave and stupid
/obj/item/missile_equipment/cargo
	name = "cargo compartment"
	desc = "A standard cargo compartment."
	icon_state = "cargo"

	var/max_w_class = ITEM_SIZE_NORMAL
	var/cargo_capacity = ITEM_SIZE_NORMAL * 5 // holds 5 normal sized objects

/obj/item/missile_equipment/cargo/proc/get_used_weight()
	var/weight = 0
	for(var/obj/item/I in contents)
		weight += I.w_class
	return weight

/obj/item/missile_equipment/cargo/attackby(var/obj/item/I, var/mob/user)
	if(I.w_class <= max_w_class && (I.w_class + get_used_weight()) <= cargo_capacity)
		if(!user.unEquip(I))
			return
		I.forceMove(src)
		to_chat(user, "You put \the [I] into \the [src].")
		return

	..()

/obj/item/missile_equipment/cargo/attack_self(var/mob/user)
	var/obj/item/to_remove = input("Select an item to remove") as null|obj in contents

	if(!to_remove)
		return

	to_chat(user, "You remove \the [to_remove] from \the [src].")
	user.put_in_hands(to_remove)
	
	..()

/obj/item/missile_equipment/cargo/on_missile_activated(var/obj/effect/overmap/projectile/P)
	P.set_enter_zs(TRUE)

/obj/item/missile_equipment/cargo/on_touch_map_edge(var/obj/effect/overmap/projectile/P)
	var/obj/structure/missile/M = loc
	if(!istype(M))
		return

	if(!M.active)
		for(var/obj/item/I in contents)
			qdel(I)

/obj/item/missile_equipment/cargo/on_trigger()
	eject_cargo()

/obj/item/missile_equipment/cargo/proc/eject_cargo()
	if(!contents.len)
		return

	var/turf/location = get_turf(src)

	var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, location, null)
	S.start()

	for(var/obj/item/I in contents)
		I.forceMove(location)
		I.throw_at_random(FALSE, 2, 1)
