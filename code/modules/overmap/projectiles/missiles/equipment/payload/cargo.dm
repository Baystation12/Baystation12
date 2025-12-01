/obj/item/missile_equipment/payload/cargo
	name = "cargo compartment"
	desc = "A standard cargo compartment."
	icon_state = "cargo"
	missile_name_override = "cargo pod"
	missile_overmap_name_override = "cargo pod"
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_STEEL = 4000)

	is_dangerous = FALSE

	var/max_w_class = ITEM_SIZE_NORMAL
	var/cargo_capacity = ITEM_SIZE_NORMAL * 5 // holds 5 normal sized objects

/obj/item/missile_equipment/payload/cargo/proc/get_used_weight()
	var/weight = 0
	for (var/obj/item/I in contents)
		weight += I.w_class
	return weight

/obj/item/missile_equipment/payload/cargo/use_tool(obj/item/tool, mob/user)
	if (tool.w_class <= max_w_class && (tool.w_class + get_used_weight()) <= cargo_capacity)
		if (!user.unEquip(tool))
			return TRUE
		tool.forceMove(src)
		to_chat(user, "You put \the [tool] into \the [src].")
		return TRUE
	return ..()

/obj/item/missile_equipment/payload/cargo/proc/remove_cargo(mob/user as mob)
	if (length(contents) > 0)
		var/obj/item/to_remove = input("Select an item to remove") as null|obj in contents
		if (!to_remove)
			return TRUE
		if (get_dist(user, src) > 1)
			to_chat(user, SPAN_WARNING("You are too far away from \the [src]!"))
			return TRUE
		to_chat(user, "You remove \the [to_remove] from \the [src].")
		user.put_in_hands(to_remove)
		return TRUE
	return FALSE

/obj/item/missile_equipment/payload/cargo/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src && remove_cargo(user))
		return TRUE
	. = ..()

/obj/item/missile_equipment/payload/cargo/MouseDrop(atom/over_atom, atom/source_loc, atom/over_loc, source_control, over_control, list/mouse_params)
	if (usr == over_atom)
		remove_cargo(usr)
		return

/obj/item/missile_equipment/payload/cargo/attack_robot(mob/user)
	if (Adjacent(user))
		remove_cargo(user)

/obj/item/missile_equipment/payload/cargo/on_touch_map_edge(obj/overmap/projectile/overmap_missile)
	var/obj/structure/missile/missile = loc
	if (!istype(missile))
		return FALSE

	if (!missile.armed)
		for (var/obj/item/item in contents)
			qdel(item)
	return TRUE

/obj/item/missile_equipment/payload/cargo/on_trigger(armed)
	if (armed)
		eject_cargo()

/obj/item/missile_equipment/payload/cargo/proc/eject_cargo()
	if (!LAZYLEN(contents))
		return

	var/turf/location = get_turf(src)

	playsound(location, 'sound/effects/magnetclamp.ogg', 50)
	var/datum/effect/smoke_spread/smoke = new/datum/effect/smoke_spread()
	smoke.set_up(5, 0, location, null)
	smoke.start()

	for (var/obj/item/item in contents)
		item.forceMove(location)
		item.throw_at_random(FALSE, 2, 1)
