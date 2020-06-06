
/obj/vehicles/drop_pod/overmap/boarding_pod
	name = "Boarding Pod"
	desc = "A boarding pod of unknown make, model or origin."
	density = 1
	anchored = 1
	launch_arm_time = 5 SECONDS
	drop_accuracy = 5
	occupants = list(8,0)
	pod_range = 14
	internal_air = new

	light_color = "#E1FDFF"

/obj/vehicles/drop_pod/overmap/boarding_pod/update_object_sprites()
	//Enclosed, we don't need to care about the person-sprites.

/obj/vehicles/drop_pod/overmap/boarding_pod/is_on_launchbay()
	return 1

/obj/vehicles/drop_pod/overmap/boarding_pod/get_drop_turf(var/turf/drop_point)
	if(isnull(drop_point))
		visible_message("<span class = 'warning'>[src] blurts a warning: ERROR: NO AVAILABLE DROP-TARGETS.</span>")
		return
	var/list/valid_points = list()
	for(var/turf/t in range(drop_point,drop_accuracy))
		if(istype(t,/turf/unsimulated/floor/rock2)) //No spawning in rock walls, even if they are subtypes of /floor/
			continue
		if(istype(t,/turf/simulated/floor))
			valid_points += t
			continue
		if(istype(t,/turf/unsimulated/floor))
			valid_points += t
			continue
	if(isnull(valid_points) || valid_points.len == 0)
		error("DROP POD FAILED TO LAUNCH: COULD NOT FIND ANY VALID DROP-POINTS")
		return
	return pick(valid_points)

/obj/vehicles/drop_pod/overmap/boarding_pod/post_drop_effects(var/turf/drop_turf)
	explosion(drop_turf,-1,-1,4,10)
	var/obj/effect/overmap/om_obj = map_sectors["[drop_turf.z]"]
	if(istype(om_obj,/obj/effect/overmap/sector)) //Let's not send a message if we're dropping onto a planet.
		return
	spawn(30 SECONDS)
		for(var/mob/living/m in GLOB.mobs_in_sectors[om_obj])
			to_chat(m,"<span class = 'danger'>EXTERNAL INCURSION WARNING: BOARDING POD COLLISION DETECTED. LOCATION: [drop_turf.loc.name]</span>")

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
