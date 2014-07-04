//Area Network Controller; acts as a wireless router for an area.
//Longrange network cables will feed into it from across the station, while shortrange ones will connect from the
// same room for a faster network connection.
//Most machinery will connect wirelessly without need for wires.

/obj/machinery/networking/anc
	name = "Area Network Controller"
	desc = "A small network router capable of serving a single room with wireless signal."

	//icon = 'icons/obj/networking.dmi'
	icon_state = "anc0"

	anchored = 1

	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 40

	var/area/area = null
	var/turf/turf = null

	var/state = NET_ANC_STATE_NONE

	var/current_z = 0

	//Definitions on the object tree for placing wall-aligned ANCs
	north
		name = "North ANC"
		dir = NORTH
	south
		name = "South ANC"
		dir = SOUTH
	east
		name = "East ANC"
		dir = EAST
	west
		name = "West ANC"
		dir = WEST

//Update display and name of the ANC, and add it to the global list.
/obj/machinery/networking/anc/New()
	..()

	//Might be temporary.  Delete ourselves if we can't find a turf to live on.
	src.turf = get_turf(src)
	if(!istype(src.turf))
		del(src)
		return

	//If we're a direcional subclass, we need to adjust our alignment from when we were added to the map.
	if(istype(src, /obj/machinery/networking/anc/north) || istype(src, /obj/machinery/networking/anc/south) || \
	   istype(src, /obj/machinery/networking/anc/east)  || istype(src, /obj/machinery/networking/anc/west))
		src.update_alignment()

	//Update our name to be descriptive of our current area.
	var/area/my_area = get_area(src)
	if(istype(my_area))
		src.area = my_area
		src.name = "[my_area.name] ANC"

	//Add ourselves to the global anc-by-zlevel list.
	src.current_z = src.z
	var/temp_z = num2text(src.z)
	if(!ancs_by_zlevel[temp_z]) //If a list doesn't exist for our zlevel, create it.
		ancs_by_zlevel[temp_z] = list()
	ancs_by_zlevel[temp_z] += src

/obj/machinery/networking/anc/Del()
	//Remove ourselves from the global anc-by-zlevel list, accounting for zlevel change (yuck).
	for(var/zlevel in ancs_by_zlevel)
		if(src in ancs_by_zlevel[zlevel])
			ancs_by_zlevel[zlevel] -= src

	..()

/obj/machinery/networking/anc/process()
	..()

	//If our zlevel has changed, update the global lists.
	if(src.z != src.current_z)
		ancs_by_zlevel[num2text(src.current_z)] -= src
		ancs_by_zlevel[num2text(src.z)] += src
		src.current_z = src.z

//Adjust pixel_(x|y) for src.dir
/obj/machinery/networking/anc/proc/update_alignment(in_dir = 0)
	if(!in_dir)
		in_dir = src.dir

	src.pixel_x = (src.dir & 3)? 0 : ((src.dir == 4)? 26 : -25)
	src.pixel_y = (src.dir & 3)? ((src.dir == 1)? 24 : -24) : 0


/obj/machinery/networking/anc/setup_network()
	//if(cablestuff... etc.) [TODO]
	if(0)
		world << "WHAT."
	else
		world << "mm"
