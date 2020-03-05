/obj/machinery/computer/persistence/registry_control
	name = "\improper Registry control"
	ui_template = "registry_control.tmpl"
	var/shuttle

/obj/machinery/computer/persistence/registry_control/Initialize()
	// Let's figure out if we can figure out what shuttle, if any we're on.
	var/area/loc_area = get_area(src)
	for(var/datum/shuttle/s_i in SSshuttle.shuttles)
		if(loc_area in s_i.shuttle_area)
			shuttle = s_i
			break
	. = ..()

/obj/machinery/computer/persistence/registry_control/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)

/obj/machinery/computer/persistence/registry_control/build_ui_data()
	. = ..()
	.["can_register"] = FALSE

	if(!isnull(shuttle))
		// We're on a shuttle, here's the data.
		.["registration_type"] = "Station"
		.["registration_id"] = "002dc3ef93"
		.["registered"] = TRUE
	else
		.["registered"] = FALSE
		.["can_register"] = can_claim()
		
/obj/machinery/computer/persistence/registry_control/proc/can_claim()
	// Whether or not a claim can be made and an area formed for this
	// location.
	for(var/datum/shuttle/s_i in SSshuttle.shuttles)
		if(s_i.current_location.z == z && s_i.stationary)
			return FALSE
	return TRUE