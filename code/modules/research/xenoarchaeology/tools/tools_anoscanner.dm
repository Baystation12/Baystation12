
/obj/item/device/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "flashgun"
	item_state = "lampgreen"
	w_class = 1.0
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	var/nearest_artifact_id = "unknown"
	var/nearest_artifact_distance = -1
	var/last_scan_time = 0

/obj/item/device/ano_scanner/New()
	..()
	spawn(0)
		scan()

/obj/item/device/ano_scanner/attack_self(var/mob/user as mob)
	return src.interact(user)

/obj/item/device/ano_scanner/interact(var/mob/user as mob)
	var/message = "Background radiation levels detected."
	if(nearest_artifact_distance >= 0)
		message = "Exotic energy detected on wavelength '[nearest_artifact_id]' in a radius of [nearest_artifact_distance * 2]m"
	user << "<span class='info'>[message]</span>"
	if(world.time - last_scan_time > 50)
		spawn(0)
			scan()

/obj/item/device/ano_scanner/proc/scan()
	set background = 1

	last_scan_time = world.time
	nearest_artifact_distance = -1
	for(var/turf/simulated/mineral/T in artifact_spawning_turfs)
		if(T.artifact_find && T.z == src.z)
			var/cur_dist = get_dist(src.loc, T)
			if(nearest_artifact_distance < 0 || cur_dist < nearest_artifact_distance)
				nearest_artifact_distance = cur_dist + rand() * 2 - 1
				nearest_artifact_id = T.artifact_find.artifact_id
	src.visible_message("\icon[src] <span class='info>[src] clicks.</span>")
