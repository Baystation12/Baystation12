
/datum/waypoint_controller

	var/squad_name = "squad1"
	var/controller_manager_device
	var/list/linked_devices = list()
	var/list/active_waypoints = list()

/datum/waypoint_controller/New(var/creator)
	controller_manager_device = creator

/datum/waypoint_controller/proc/create_waypoint(var/turf/waypoint_turf,var/mob/user)
	var/obj/effect/waypoint_holder/created_waypoint = new
	created_waypoint.loc = waypoint_turf
	active_waypoints += created_waypoint
	created_waypoint.waypoint_name = "Waypoint-[active_waypoints.Find(created_waypoint)]"
	inform_waypoint_modification(created_waypoint)
	update_linked_waypoint_locations()
	if(!(src in GLOB.processing_objects))
		GLOB.processing_objects += src

/datum/waypoint_controller/proc/cole_protocol() //This wipes the controller, removing all waypoints and linked devices before deleting itself.
	for(var/obj/item/clothing/glasses/hud/tactical/device in linked_devices)
		device.update_known_waypoints(list())
		var/mob/m = device.loc
		if(istype(m))
			to_chat(m,"<span class = 'warning'>[squad_name] Alert: Squad Management device reset. Manual re-link required.</span>")
	linked_devices.Cut()
	for(var/obj/wp in active_waypoints)
		qdel(wp)
	active_waypoints.Cut()
	controller_manager_device = null
	qdel(src)

/datum/waypoint_controller/proc/inform_waypoint_modification(var/obj/effect/waypoint_holder/waypoint,var/delete = 0,var/name_change = null)
	for(var/obj/device in linked_devices)
		if(ismob(device.loc))
			if(name_change)
				to_chat(device.loc,"<span class = 'warning'>[squad_name] Alert: Waypoint name modified, [waypoint.waypoint_name] -> [name_change]</span>")
			else
				to_chat(device.loc,"<span class = 'warning'>[squad_name] Alert: Waypoint [delete ? "deleted" : "added"], [waypoint.waypoint_name].</span>")

/datum/waypoint_controller/proc/delete_waypoint(var/obj/effect/waypoint_holder/waypoint)
	active_waypoints -= waypoint
	inform_waypoint_modification(waypoint,1)
	qdel(waypoint)
	update_linked_waypoint_locations()
	if(active_waypoints.len == 0)
		GLOB.processing_objects -= src

/datum/waypoint_controller/proc/get_waypoints()
	var/list/waypoints_by_name = list()
	for(var/obj/effect/waypoint_holder/waypoint in active_waypoints)
		waypoints_by_name += waypoint.waypoint_name
	return waypoints_by_name

/datum/waypoint_controller/proc/get_waypoint_from_name(var/wanted_name)
	for(var/obj/effect/waypoint_holder/waypoint in active_waypoints)
		if(waypoint.waypoint_name == wanted_name)
			return waypoint

/datum/waypoint_controller/proc/update_linked_waypoint_locations() //This proc updates the locations of waypoints for all linked devices.
	for(var/obj/item/clothing/glasses/hud/tactical/device in linked_devices)
		device.update_known_waypoints(active_waypoints)
		device.process_hud()

/datum/waypoint_controller/proc/process()
	update_linked_waypoint_locations()
