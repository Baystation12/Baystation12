/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"

	var/known = 1		//shows up on nav computers automatically
	var/scannable       //if set to TRUE will show up on ship sensors for detailed scans

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	return desc

/obj/effect/overmap/Initialize()
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL
	
	if(known)
		layer = ABOVE_LIGHTING_LAYER
		plane = EFFECTS_ABOVE_LIGHTING_PLANE
		for(var/obj/machinery/computer/ship/helm/H in SSmachines.machinery)
			H.get_known_sectors()

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)