/obj/structure/blob/proc/make_factory()
	var/obj/structure/blob/factory/new_blob = new(src.loc)
	new_blob.health = health
	new_blob.update_icon()
	qdel(src)

/obj/structure/blob/factory
	name = "blob factory"
	icon_state = "blob_node"
	max_health = 150
	regen_rate = 1

	var/build_progress = 0

/obj/structure/blob/factory/update_icon()
	if(build_progress < SECONDARY_CORE_TOTAL_COST)
		icon_state = "blob_factory"
	icon_state = (health / max_health >= 0.5) ? "blob_node" : "blob_factory"

/obj/structure/blob/factory/get_strength()
	if((build_progress == SECONDARY_CORE_TOTAL_COST) && (health / max_health >= 0.5))
		return SECONDARY_CORE_STRENGTH
	return 0

/obj/structure/blob/factory/factorable()
	return 0

/obj/structure/blob/factory/shieldable()
	return 0
