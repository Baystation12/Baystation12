
/obj/vehicles/drop_pod/overmap/boarding_pod
	name = "Boarding Pod"
	desc = "A boarding pod of unknown make, model or origin."
	density = 1
	anchored = 1
	launch_arm_time = 10 SECONDS
	drop_accuracy = 5
	occupants = list(8,0)
	pod_range = 5

	vehicle_size = 128

/obj/vehicles/drop_pod/overmap/boarding_pod/update_object_sprites()
	//Enclosed, we don't need to care about the person-sprites.

/obj/vehicles/drop_pod/overmap/boarding_pod/is_on_launchbay()
	return 1

/obj/vehicles/drop_pod/overmap/boarding_pod
	name = "Class-3 Armoured Boarding Pod"
	desc = "A modified varient of the \"Bumblebee\" lifeboat, with extra armour plating to survive impact with other spacefaring vessels."
	icon = 'code/modules/halo/vehicles/bumblebee_full.dmi'
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
