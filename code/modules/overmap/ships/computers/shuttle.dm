//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "shuttle_control_console_exploration.tmpl"

/obj/machinery/computer/shuttle_control/explore/get_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/fuel_pressure = 0
		var/fuel_max_pressure = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/weapon/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				fuel_pressure += fuel_tank.air_contents.return_pressure()
				fuel_max_pressure += 1013

		if(fuel_max_pressure == 0) fuel_max_pressure = 1

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_port_present" = shuttle.fuel_consumption? 1 : 0,
			"fuel_pressure" = fuel_pressure,
			"fuel_max_pressure" = fuel_max_pressure,
			"fuel_pressure_status" = (fuel_pressure/fuel_max_pressure > 0.2)? "good" : "bad"
		)

/obj/machinery/computer/shuttle_control/explore/handle_topic_href(var/datum/shuttle/autodock/overmap/shuttle, var/list/href_list)	
	if(ismob(usr))
		var/mob/user = usr
		shuttle.operator_skill = user.get_skill_value(SKILL_PILOT)

	if((. = ..()) != null)
		return

	if(href_list["pick"])
		var/list/possible_d = shuttle.get_possible_destinations()
		var/D
		if(possible_d.len)
			D = input("Choose shuttle destination", "Shuttle Destination") as null|anything in possible_d
		else
			to_chat(usr,"<span class='warning'>No valid landing sites in range.</span>")
		possible_d = shuttle.get_possible_destinations()
		if(CanInteract(usr, GLOB.default_state) && (D in possible_d))
			shuttle.set_destination(possible_d[D])
		return TOPIC_REFRESH
