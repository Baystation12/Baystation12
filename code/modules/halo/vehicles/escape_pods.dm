
/obj/vehicles/drop_pod/escape_pod
	name = "Escape Pod"
	desc = "An emergency escape pod of unknown make, model or origin."
	density = 1
	anchored = 1
	launch_arm_time = 10 SECONDS
	drop_accuracy = 10
	occupants = list(8,0)

	vehicle_size = 128

/obj/vehicles/drop_pod/escape_pod/update_object_sprites()
	//Enclosed, we don't need to care about the person-sprites.

/obj/vehicles/drop_pod/escape_pod/is_on_launchbay()
	return 1

/obj/vehicles/drop_pod/escape_pod/get_drop_turf(var/turf/drop_point)
	if(isnull(drop_point))
		visible_message("<span class = 'warning'>[src] blurts a warning: ERROR: NO AVAILABLE DROP-TARGETS.</span>")
		return
	var/list/valid_points = list()
	for(var/turf/t in range(drop_point,drop_accuracy))
		if(istype(t,/turf/simulated/floor))
			valid_points += t
		if(istype(t,/turf/unsimulated/floor))
			valid_points += t
	if(isnull(valid_points))
		return
	return pick(valid_points)

/obj/vehicles/drop_pod/escape_pod/bumblebee
	name = "Class-3 Enclosed Heavy Lifeboat"
	desc = "An enclosed environment for use in emergency evacuation procedures."
	icon = 'code/modules/halo/vehicles/bumblebee_full.dmi'
	icon_state = "escape"

	bound_width = 64
	bound_height = 96

/obj/vehicles/drop_pod/escape_pod/bumblebee/north
	bound_width = 64
	bound_height = 96
	dir = 1

/obj/vehicles/drop_pod/escape_pod/bumblebee/south
	bound_width = 64
	bound_height = 96
	dir = 2

/obj/vehicles/drop_pod/escape_pod/bumblebee/east
	bound_width = 96
	bound_height = 64
	dir = 4

/obj/vehicles/drop_pod/escape_pod/bumblebee/west
	bound_width = 96
	bound_height = 64
	dir = 8
