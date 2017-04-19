//Shuttle controller computer for shuttles going between sectors
var/list/sector_shuttles = list()

/datum/shuttle/ferry/var/range = 1	//how many overmap tiles can shuttle go, for picking destinatiosn and returning.
/obj/machinery/computer/shuttle_control/explore
	name = "exploration shuttle console"
	shuttle_tag = "Exploration"
	req_access = list()
	var/area/shuttle_area	//area for shuttle ship-side
	var/list/shuttle_size   // x y dimensions for shuttle
	var/obj/effect/overmap/destination //current destination
	var/obj/effect/overmap/home //home port for shuttle

/obj/machinery/computer/shuttle_control/explore/initialize()
	..()
	shuttle_tag = "[shuttle_tag]-[z]"
	if(!shuttle_controller.shuttles[shuttle_tag])
		var/datum/shuttle/ferry/shuttle = new(shuttle_tag)
		sector_shuttles += shuttle
		shuttle.warmup_time = 10
		if(ispath(shuttle_area))
			shuttle_area = locate(shuttle_area)
			shuttle_size = shuttle_area.get_dimensions()
		shuttle.area_station = shuttle_area
		shuttle.area_offsite = shuttle.area_station
		testing("Exploration shuttle '[shuttle_tag]' at zlevel [z] successfully added.")

//Sets destination to new sector. Can be null.
/obj/machinery/computer/shuttle_control/explore/proc/update_destination(area/A)
	if(A && shuttle_controller.shuttles[shuttle_tag])
		var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
		shuttle.area_offsite = A
		destination = map_sectors["[A.z]"]
		world << "<span class='notice'>Destination succeeded! [A] : [shuttle_tag]</span>"
	else
		destination = null
		world << "<span class='notice'>Destination failed! [A] : [shuttle_tag]</span>"

//Gets all sectors with landing zones in shuttle's range
/obj/machinery/computer/shuttle_control/explore/proc/get_possible_destinations()
	var/list/res = list()
	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	var/obj/effect/overmap/cur_loc = map_sectors["[shuttle.location ? shuttle.area_offsite.z : shuttle.area_station.z]"]
	if(ispath(shuttle_area))
		shuttle_area = locate(shuttle_area)
	for (var/obj/effect/overmap/S in orange(shuttle.range, cur_loc))
		for(var/A in S.landing_areas)
			var/area/LZ = locate(A)
			if(LZ && LZ.free())
				var/lz_size = LZ.get_dimensions()
				if(lz_size["x"] >= shuttle_size["x"] && lz_size["y"] >= shuttle_size["y"])
					res["[S.name] - [LZ.name]"] = LZ
		if(S == home)
			res["Return to [home]"] = shuttle_area
	return res

//Checks if current destination is still reachable
/obj/machinery/computer/shuttle_control/explore/proc/check_destination()
	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	return shuttle && destination && get_dist(home, destination) <= shuttle.range

/obj/machinery/computer/shuttle_control/explore/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	//If we are already there, or can't reach place anymore, reset destination
	if(!shuttle.location && !check_destination())
		destination = null
		world << "<span class='notice'>Destination failed 1! [shuttle_tag]</span>"
	//check if shuttle can fly at all
	var/can_go = !isnull(destination)
	if(!can_go)
		world << "<span class='notice'>Destination failed 2! [shuttle_tag]</span>"

	var/current_destination = destination && shuttle.area_offsite ? "[destination.name] - [shuttle.area_offsite.name]" : "None"
	//disable picking locations if there are none, or shuttle is already off-site
	var/list/possible_d = get_possible_destinations()
	var/can_pick = possible_d.len && shuttle.moving_status == SHUTTLE_IDLE

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else if (!shuttle.location)
				shuttle_status = "Standing-by at station."
			else
				shuttle_status = "Standing-by at offsite location."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	data = list(
		"destination_name" = current_destination,
		"can_pick" = can_pick,
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.docking_controller? 1 : 0,
		"docking_status" = shuttle.docking_controller? shuttle.docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.docking_controller? shuttle.docking_controller.override_enabled : null,
		"can_launch" = can_go && shuttle.can_launch(),
		"can_cancel" = can_go && shuttle.can_cancel(),
		"can_force" = can_go && shuttle.can_force(),
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "shuttle_control_console_exploration.tmpl", "[shuttle_tag] Shuttle Control", 470, 310)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/explore/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	if(href_list["pick"])
		var/obj/effect/overmap/self = map_sectors["[z]"]
		if(self)
			var/list/possible_d = get_possible_destinations()
			var/D
			if(possible_d.len)
				D = input("Choose shuttle destination", "Shuttle Destination") as null|anything in possible_d
			update_destination(possible_d[D])

	if(href_list["move"])
		shuttle.launch(src)
	if(href_list["force"])
		shuttle.force_launch(src)
	else if(href_list["cancel"])
		shuttle.cancel_launch(src)

/area/shuttle/mining_shuttle/destination
	name = "Mining Shuttle"
	icon_state = "shuttle1"