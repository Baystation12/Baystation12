
/obj/vehicles/drop_pod/overmap/boarding_pod
	name = "Boarding Pod"
	desc = "A boarding pod of unknown make, model or origin."
	density = 1
	anchored = 1
	launch_arm_time = 5 SECONDS
	drop_accuracy = 0
	occupants = list(8,0)
	pod_range = 14
	internal_air = new

	light_color = "#E1FDFF"

/obj/vehicles/drop_pod/overmap/boarding_pod/update_object_sprites()
	//Enclosed, we don't need to care about the person-sprites.

/obj/vehicles/drop_pod/overmap/boarding_pod/is_on_launchbay()
	return 1

/obj/vehicles/drop_pod/overmap/boarding_pod/post_drop_effects(var/turf/drop_turf)
	. = ..()
	//explosion(drop_turf,-1,-1,4,10)
	playsound(src, 'sound/effects/bamf.ogg', 100, 1)

	for(var/turf/simulated/floor/F in src.locs)
		F.break_tile_to_plating()

	var/obj/effect/overmap/om_obj = map_sectors["[drop_turf.z]"]
	if(istype(om_obj,/obj/effect/overmap/sector)) //Let's not send a message if we're dropping onto a planet.
		return
	src.visible_message("<span class='danger'>[src] bursts through the floor, sealing it behind them!</span>")
	spawn(30 SECONDS)
		var/area/A = get_area(src)
		for(var/mob/living/m in GLOB.mobs_in_sectors[om_obj])
			to_chat(m,"<span class = 'danger'>EXTERNAL INCURSION WARNING: BOARDING POD COLLISION DETECTED. LOCATION: [A.name]</span>")

/obj/vehicles/drop_pod/overmap/boarding_pod/get_overmap_targets()
	var/list/potential_om_targ = list()
	for(var/obj/effect/overmap/ship/o in (range(pod_range,map_sectors["[z]"]) - map_sectors["[z]"]))
		potential_om_targ["[o.name]"] = o
	return potential_om_targ

/obj/vehicles/drop_pod/overmap/boarding_pod
	name = "Class-3 Armoured Boarding Pod"
	desc = "A modified varient of the \"Bumblebee\" lifeboat, with extra armour plating to survive impact with other spacefaring vessels."
	icon = 'code/modules/halo/vehicles/types/bumblebee_full.dmi'
	icon_state = "boarding"

	bound_width = 64
	bound_height = 96

/obj/vehicles/drop_pod/overmap/boarding_pod/north
	bound_width = 64
	bound_height = 96
	dir = 1

/obj/vehicles/drop_pod/overmap/boarding_pod/south
	bound_width = 64
	bound_height = 96
	dir = 2

/obj/vehicles/drop_pod/overmap/boarding_pod/east
	bound_width = 96
	bound_height = 64
	dir = 4

/obj/vehicles/drop_pod/overmap/boarding_pod/west
	bound_width = 96
	bound_height = 64
	dir = 8

/obj/vehicles/drop_pod/overmap/boarding_pod/covenant
	name = "Boarding Pod"
	desc = "A modified escape pod, with extra armour plating to enable survival on impact with other spacefaring vessels."
	icon = 'code/modules/halo/vehicles/types/covenant_pods.dmi'
	icon_state = "cov_boarding"

	bound_width = 64
	bound_height = 96

	light_color = "#C1CEFF"

/obj/vehicles/drop_pod/overmap/boarding_pod/covenant/north
	bound_width = 64
	bound_height = 96
	dir = 1

/obj/vehicles/drop_pod/overmap/boarding_pod/covenant/south
	bound_width = 64
	bound_height = 96
	dir = 2

/obj/vehicles/drop_pod/overmap/boarding_pod/covenant/east
	bound_width = 96
	bound_height = 64
	dir = 4

/obj/vehicles/drop_pod/overmap/boarding_pod/covenant/west
	bound_width = 96
	bound_height = 64
	dir = 8
