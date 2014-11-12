/*
********** SENSOR MONITOR **********
- Remotely monitors sensors around the station and displays their readings.
- Should filter out most duplicities.
*/

/obj/machinery/power/monitor
	name = "Power Monitor"
	desc = "Computer designed to remotely monitor power levels around the station"
	icon = 'icons/obj/computer.dmi'
	icon_state = "power"

	//computer stuff
	density = 1
	anchored = 1.0
	var/circuit = /obj/item/weapon/circuitboard/powermonitor
	var/list/grid_sensors = null
	var/update_counter = 0 // Next icon update when this reaches 5 (ie every 5 ticks)
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300

	// Update icon every 5 ticks.
/obj/machinery/power/monitor/process()
	update_counter++
	if(update_counter > 4)
		update_icon()

/obj/machinery/power/monitor/New()
	..()
	refresh_sensors()


/obj/machinery/power/monitor/proc/refresh_sensors()
	grid_sensors = list()
	for(var/obj/machinery/power/sensor/S in machines)
		if((S.loc.z == src.loc.z) || (S.long_range)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			grid_sensors += S

/obj/machinery/power/monitor/attack_ai(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=powcomp")
			return

	if((!grid_sensors) || (!grid_sensors.len)) 						// No sensors in list. Refresh just in case.
		refresh_sensors()



	user.set_machine(src)
	var/t = "<TT><B>Station Power Monitoring</B><HR>"

	t += "<BR><HR><A href='?src=\ref[src];update=1'>Refresh</A>"
	t += "<BR><HR><A href='?src=\ref[src];reset=1'>Reset Sensor List</A>"
	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A><br>"

	if((!grid_sensors) || (!grid_sensors.len))
		t += "<b> ERROR - No Sensors Connected. </b>"
	else
		var/list/reported_nets = list()
		var/duplicities = 0 // Duplicity prevention (substations in Bypass mode)


		for(var/obj/machinery/power/sensor/S in grid_sensors)			// Show all data from current Z level.
			if(S.powernet && (S.powernet in reported_nets)) // We already reported this powernet. Ignore it.
				duplicities++
				continue

			t += "<br><br><hr>  <b>[S.name_tag]  - Sensor Reading</b>  <br>"
			t += S.ReturnReading() 										// Sensors already make quite decent HTML table by themselves.
			if(S.powernet)
				reported_nets += S.powernet
		if(duplicities)
			t += "<br><b><i>Ignored [duplicities] duplicite readings</i></b>"
	user << browse(t, "window=powcomp;size=600x900")
	onclose(user, "powcomp")


/obj/machinery/power/monitor/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=powcomp")
		usr.unset_machine()
		return
	if( href_list["update"] )
		src.updateDialog()
		return
	if( href_list["reset"] )
		refresh_sensors()
		return

/obj/machinery/power/monitor/update_icon()
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

/obj/machinery/power/monitor/proc/check_warnings()
	var/warn = 0
	if(grid_sensors)
		for(var/obj/machinery/power/sensor/S in grid_sensors)
			if(S.check_grid_warning())
				warn = 1
	return warn


/obj/machinery/power/monitor/power_change()
	..()

	// Leaving this here to preserve that delayed shutdown effect when power goes out.
	if (stat & NOPOWER)
		spawn(rand(0, 15))
			update_icon()
	else
		update_icon()


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