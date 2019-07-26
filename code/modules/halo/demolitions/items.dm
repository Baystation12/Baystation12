/obj/item/weapon/pinpointer/demolition
	name = "demolitions pinpointer"
	desc = "Scans for structural weaknesses that may be exploited"
	var/turf/simulated/wall/r_wall/demo/D

/obj/item/weapon/pinpointer/demolition/workdisk()
	if(!active)
		return
	if(!D || !istype(D))
		for(var/turf/simulated/wall/r_wall/demo/P in GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"].linked_targets)
			if(!istype(P))
				continue
			D = P
			break
	set_dir(get_dir(src, D))
	switch(get_dist(src,D))
		if(0 to 1)
			icon_state = "pinondirect"
		if(2 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5)
		.()

/obj/item/weapon/pinpointer/demolition/examine(mob/user)
	. = ..(user)
	if(GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"].demolished)
		to_chat(user, "Warning! Structural collapse imminent")