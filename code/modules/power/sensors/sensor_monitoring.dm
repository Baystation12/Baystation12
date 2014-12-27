/*
********** SENSOR MONITOR **********
- Remotely monitors sensors around the station and displays their readings.
- Should filter out most duplicities.
*/

/obj/machinery/computer/power_monitor
	name = "Power Monitoring Console"
	desc = "Computer designed to remotely monitor power levels around the station"
	icon = 'icons/obj/computer.dmi'
	icon_state = "power"

	//computer stuff
	density = 1
	anchored = 1.0
	circuit = /obj/item/weapon/circuitboard/powermonitor
	var/list/grid_sensors = null
	var/list/sensors_by_powernet = null
	var/update_counter = 0 		// Next icon update when this reaches 5 (ie every 5 ticks)
	var/active_sensor = null	//name_tag of the currently selected sensor
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300

	// Update icon every 5 ticks.
/obj/machinery/computer/power_monitor/process()
	update_counter++
	if(update_counter > 4)
		update_icon()

/obj/machinery/computer/power_monitor/New()
	..()
	refresh_sensors()


/obj/machinery/computer/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	sensors_by_powernet = list()
	for(var/obj/machinery/power/sensor/S in machines)
		if((S.loc.z == src.loc.z) || (S.long_range)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
				error("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
			else
				grid_sensors[S.name_tag] = S
			
				var/pnet = (S.powernet)? S.powernet : "none"
				if (pnet in sensors_by_powernet)
					sensors_by_powernet[pnet] += S
				else
					sensors_by_powernet[pnet] = list(S)


/obj/machinery/computer/power_monitor/attack_ai(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/computer/power_monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/computer/power_monitor/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=powcomp")
			return

	refresh_sensors()

	user.set_machine(src)
	var/t = "<TT><B>Station Power Monitoring</B><HR>"
	if(active_sensor)

		t += "<BR><A href='?src=\ref[src];update=1'>Refresh</A>"
		t += "<BR><A href='?src=\ref[src];clear=1'>Sensor List</A>"
		t += "<BR><A href='?src=\ref[src];close=1'>Close</A><BR><HR>"

		if(!grid_sensors)
			t += "No sensors available."
		else
			if (active_sensor in grid_sensors)
				var/obj/machinery/power/sensor/OKS = grid_sensors[active_sensor]
				t += "<B>[OKS.name_tag] - Sensor Reading</B><BR>"
				t += OKS.ReturnReading()
			else
				t += "Unable to connect to sensor!"


	else
		t += "<BR><A href='?src=\ref[src];update=1'>Refresh</A>"
		t += "<BR><A href='?src=\ref[src];close=1'>Close</A><BR><HR>"
		
		t += render_sensor_list()

	user << browse(t, "window=powcomp;size=600x900")
	onclose(user, "powcomp")

/obj/machinery/computer/power_monitor/proc/render_sensor_list()
	if((!grid_sensors) || (!grid_sensors.len))
		return "<B>ERROR - No Active Sensors Detected!</B>"
	
	var/html = "<table border='0'><tr><th>Power Network</th><th>Sensors</th></tr>"
	for (var/pnet in sensors_by_powernet)
		if (pnet && pnet != "none")
			html += "<tr><td valign='top'>[uppertext("\ref[pnet]")]</td><td>"
			for(var/obj/machinery/power/sensor/S in sensors_by_powernet[pnet])
				//really, if one of them has a warning, they all should - but the interface doesn't guarantee that so whatever
				if(S.check_grid_warning()) // Display grids with active alarms in bold text
					html += "<B><A href='?src=\ref[src];setsensor=[S.name_tag]'>[S.name]</A></B><BR>"
				else
					html += "<A href='?src=\ref[src];setsensor=[S.name_tag]'>[S.name]</A><BR>"
			html += "</td></tr>"
	
	if ("none" in sensors_by_powernet)
		html += "<tr><td>\[N/A\]</td><td>"
		for(var/obj/machinery/power/sensor/S in sensors_by_powernet["none"])
			html += "<A href='?src=\ref[src];setsensor=[S.name_tag]'>[S.name]</A><BR>"
		html += "</td></tr>"
	html += "</table>"
	
	return html

/obj/machinery/computer/power_monitor/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=powcomp")
		usr.unset_machine()
		return
	if( href_list["update"] )
		src.updateDialog()
		return
	if( href_list["clear"] )
		active_sensor = null
		src.updateDialog()
		return
	if( href_list["setsensor"] )
		active_sensor = href_list["setsensor"]
		src.updateDialog()

/obj/machinery/computer/power_monitor/update_icon()
	update_counter = 0 // Reset the icon update counter.
	if(stat & BROKEN)
		icon_state = "powerb"
		return
	if(stat & NOPOWER)
		icon_state = "power0"
		return
	if(check_warnings())
		icon_state = "power_alert"
		return

	icon_state = "power"

/obj/machinery/computer/power_monitor/proc/check_warnings()
	var/warn = 0
	if(grid_sensors)
		for(var/obj/machinery/power/sensor/S in grid_sensors)
			if(S.check_grid_warning())
				warn = 1
	return warn


/obj/machinery/computer/power_monitor/power_change()
	..()

	// Leaving this here to preserve that delayed shutdown effect when power goes out.
	if (stat & NOPOWER)
		spawn(rand(0, 15))
			update_icon()
	else
		update_icon()

/*
//copied from computer.dm
/obj/machinery/power/monitor/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver) && circuit)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/weapon/circuitboard/M = new circuit( A )
			A.circuit = M
			A.anchored = 1
			for (var/obj/C in src)
				C.loc = src.loc
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/weapon/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "4"
			M.deconstruct(src)
			del(src)
	else
		src.attack_hand(user)
	return
	*/