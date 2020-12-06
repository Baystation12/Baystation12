/obj/item/weapon/stock_parts/circuitboard/holodeckcontrol
	name = T_BOARD("holodeck control console")
	build_path = /obj/machinery/computer/HolodeckControl
	origin_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 2)
	var/last_to_emag
	var/linkedholodeck_area
	var/list/supported_programs
	var/list/restricted_programs

/obj/item/weapon/stock_parts/circuitboard/holodeckcontrol/construct(var/obj/machinery/computer/HolodeckControl/HC)
	if (..(HC))
		HC.supported_programs	= supported_programs.Copy()
		HC.restricted_programs	= restricted_programs.Copy()
		if(linkedholodeck_area)
			HC.linkedholodeck	= locate(linkedholodeck_area)
		if(last_to_emag)
			HC.last_to_emag		= last_to_emag
			HC.emagged 			= 1
			HC.safety_disabled	= 1

/obj/item/weapon/stock_parts/circuitboard/holodeckcontrol/deconstruct(var/obj/machinery/computer/HolodeckControl/HC)
	if (..(HC))
		linkedholodeck_area		= HC.linkedholodeck_area
		supported_programs		= HC.supported_programs.Copy()
		restricted_programs 	= HC.restricted_programs.Copy()
		last_to_emag			= HC.last_to_emag
		HC.emergencyShutdown()
