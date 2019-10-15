/obj/item/weapon/pinpointer/demolition
	name = "demolitions pinpointer"
	desc = "Scans for structural weaknesses that may be exploited"
	var/turf/simulated/wall/r_wall/demo/D
	var/wall_index = 0
	var/checks_per_tick = 2

/obj/item/weapon/pinpointer/demolition/process()
	workdisk(checks_per_tick)

	if(!active)
		GLOB.processing_objects -= src

/obj/item/weapon/pinpointer/demolition/attack_self()
	. = ..()
	if(active)
		GLOB.processing_objects += src
	else
		GLOB.processing_objects -= src

/obj/item/weapon/pinpointer/demolition/workdisk(var/max_checks = 99)
	if(!active)
		return
	icon_state = "pinonnull"
	if(!istype(D))
		D = null

	var/found_new = 0
	var/turf/T = get_turf(src)
	var/datum/demolition_manager/demo_manager = GLOB.DEMOLITION_MANAGER_LIST["[T.z]"]
	if(demo_manager && demo_manager.structural_turfs.len)
		max_checks = min(max_checks, demo_manager.structural_turfs.len)
		for(var/check = 0, check < max_checks, check++)
			wall_index++
			if(wall_index > demo_manager.structural_turfs.len)
				wall_index = 1
			var/turf/simulated/wall/r_wall/demo/P = demo_manager.structural_turfs[wall_index]
			if(P == D)
				continue
			if(!D || get_dist(src, P) < get_dist(src, D))
				D = P
				found_new = 1
	else
		D = null

	if(D)
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

	if(found_new)
		var/mob/living/M = src.loc
		if(istype(M))
			to_chat(M, "\icon[src] <span class='info'>[src] buzzes as it locates a nearby structural point.</span>")

/obj/item/weapon/pinpointer/demolition/examine(mob/user)
	. = ..(user)
	if(active && get_dist(src,user) <= 1)
		var/turf/T = get_turf(src)
		var/datum/demolition_manager/demo_manager = GLOB.DEMOLITION_MANAGER_LIST["[T.z]"]
		if(demo_manager)
			to_chat(user, "<span class='notice'>[demo_manager.get_info_string()]</span>")
