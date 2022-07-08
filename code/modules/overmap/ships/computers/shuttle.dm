//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "shuttle_control_console_exploration.tmpl"
	base_type = /obj/machinery/computer/shuttle_control/explore
	machine_name = "long range shuttle console"
	machine_desc = "Used to control spacecraft that are designed to move between local sectors in open space."

/obj/machinery/computer/shuttle_control/explore/get_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/total_gas = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				total_gas += fuel_tank.air_contents.total_moles

		var/fuel_span = "good"
		if(total_gas < shuttle.fuel_consumption * 2)
			fuel_span = "bad"

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_usage" = shuttle.fuel_consumption * 100,
			"remaining_fuel" = round(total_gas, 0.01) * 100,
			"fuel_span" = fuel_span
		)

/obj/machinery/computer/shuttle_control/explore/handle_topic_href(var/datum/shuttle/autodock/overmap/shuttle, var/list/href_list)
	if (!shuttle)
		crash_with("Shuttle controller tried to handle topic with no shuttle provided.")
		to_chat(usr, SPAN_DEBUG("Shuttle controller tried to handle topic with no shuttle provided. This is a bug and should be reported immediately, something's probably horribly broken."))
		return TOPIC_HANDLED
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
