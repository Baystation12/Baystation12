/*
********** POWERNET SENSOR **********
- Simple machine which detects power levels in cables under it.
- Used with power_monitor.dm to measure power levels around station.
- Can have ID tag for organisation purposes.
*/

/obj/machinery/power/sensor
	name = "Powernet Sensor"
	desc = "Small machine which transmits data about specific powernet"
	anchored = 1
	density = 0
	layer = 2.46 // Above cables, but should be below floors.
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon" // If anyone wants to make better sprite, feel free to do so without asking me.

	var/name_tag = "#UNKN#" // ID tag displayed in list of powernet sensors. Each sensor should have it's own tag!
	var/long_range = 0		// If 1, sensor reading will show on all computers, regardless of Zlevel

/obj/machinery/power/sensor/New()
	..()
	name = "[name_tag] - Powernet Sensor" // Auto-name according to name_tag

/obj/machinery/power/sensor/proc/RefreshGrid()
	connect_to_network()

/obj/machinery/power/sensor/proc/ReturnReading()
	var/out = ""
	RefreshGrid() // First try to refresh the grid.
	if(!powernet) // No powernet.
		out = "# SYSTEM ERROR - NO POWERNET #"
		return out

	// Attempt to locate APCs in powernet
	var/list/L = list()
	for(var/obj/machinery/power/terminal/term in powernet.nodes)
		if(istype(term.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = term.master
			L += A

	if(L.len <= 0) 	// No APCs found.
		out = "<b>No APCs located in connected powernet!</b>"
	else			// APCs found. Create very ugly (but working!) HTML table.
		var/total_load = 0
		out += "<table><tr><th>Name<th>EQUIP<th>LIGHT<th>ENVIRON<th>CELL<th>LOAD"

		// These lists are used as replacement for number based APC settings
		var/list/S = list("M-OFF","A-OFF","M-ON", "A-ON")
		var/list/chg = list("N","C","F")

		// Split to multiple lines to make it more readable
		for(var/obj/machinery/power/apc/A in L)
			out += "<tr><td>\The [A.area]" 															// Add area name
			out += "<td>[S[A.equipment+1]]<td>[S[A.lighting+1]]<td>[S[A.environ+1]]" 				// Show status of channels
			if(A.cell)
				out += "<td>[round(A.cell.percent())]% - [chg[A.charging+1]]"
			else
				out += "<td>NO CELL"
			var/load = A.lastused_total // Load.
			total_load += load
			if(load > 1000)
				load = "~[round(load/100)/10]kW"														// If above 1000W convert to Kilowatts.
			else
				load = "[round(load)]W"																// Below 1000W, leave it in Watts
			out += "<td>[load]"																		// Add load info

		if (total_load > 1000)
			total_load = "~[round(total_load/100)/10] kW"
		else
			total_load = "[round(total_load)] W"

		out += "</table><br><b>TOTAL GRID LOAD: [total_load]</b>"

	var/textavail = powernet.avail
	if(textavail > 1000)
		textavail = "[round(textavail/100)/10] kW"
	else
		textavail = "[textavail] W"
	out += "<br><b>TOTAL AVAILABLE: [textavail]</b>"

	if(powernet.problem)
		out += "<br><b>WARNING: Abnormal grid activity detected!</b>"
	return out

/obj/machinery/power/sensor/proc/check_grid_warning()
	RefreshGrid()
	if(powernet)
		if(powernet.problem)
			return 1
	return 0

// Has to be here as we need it to be in Machines list.
/obj/machinery/power/sensor/process()
	return 1