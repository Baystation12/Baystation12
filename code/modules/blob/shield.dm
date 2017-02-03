/obj/structure/blob/proc/make_shield()
	var/obj/structure/blob/shield/new_blob = new(src.loc)
	new_blob.health = health
	new_blob.update_icon()
	qdel(src)

/obj/structure/blob/shield
	name = "strong blob"
	max_health = 100
	regen_rate = 20

/obj/structure/blob/shield/update_icon()
	if(health > max_health * 2 / 3)
		icon_state = "blob_idle"
	else if(health > max_health / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/structure/blob/shield/shieldable()
	return 0
