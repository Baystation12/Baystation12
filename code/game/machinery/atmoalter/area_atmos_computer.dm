/obj/machinery/computer/area_atmos
	name = "Area Air Control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_keyboard = "atmos_key"
	icon_screen = "area_atmos"
	light_color = "#e6ffff"
	machine_name = "area air control console"
	machine_desc = "A larger and less complex form of air alarm that allows configuration of an area's vents and scrubbers."
	var/list/connectedscrubbers = list()
	var/status = ""
	var/range = 25
	var/zone = "This computer is working on a wireless range, the range is currently limited to 25 meters."


/obj/machinery/computer/area_atmos/Destroy()
	connectedscrubbers.Cut()
	return ..()


/obj/machinery/computer/area_atmos/New()
	..()
	spawn(10)
		scanscrubbers()


/obj/machinery/computer/area_atmos/attack_ai(mob/user)
	return attack_hand(user)


/obj/machinery/computer/area_atmos/attack_hand(mob/user)
	if(..(user))
		return
	var/dat = {"
	<html>
		<head>
			<style type="text/css">
				a.green:link { color:#00cc00; }
				a.green:visited { color:#00cc00; }
				a.green:hover { color:#00cc00; }
				a.green:active { color:#00cc00; }
				a.red:link { color:#ff0000; }
				a.red:visited { color:#ff0000; }
				a.red:hover { color:#ff0000; }
				a.red:active { color:#ff0000; }
			</style>
		</head>
		<body>
			<center><h1>Area Air Control</h1></center>
			<font color="red">[status]</font><br>
			<a href="?src=\ref[src];scan=1">Scan</a>
			<table border="1" width="90%">"}
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
		dat += {"
				<tr>
					<td>
						[scrubber.name]<br>
						Pressure: [round(scrubber.air_contents.return_pressure(), 0.01)] kPa<br>
						Flow Rate: [round(scrubber.last_flow_rate,0.1)] L/s<br>
					</td>
					<td width="150">
						<a class="green" href="?src=\ref[src];scrub=\ref[scrubber];toggle=1">Turn On</a>
						<a class="red" href="?src=\ref[src];scrub=\ref[scrubber];toggle=0">Turn Off</a><br>
						Load: [round(scrubber.last_power_draw)] W
					</td>
				</tr>"}
	dat += {"
			</table><br>
			<i>[zone]</i>
		</body>
	</html>"}
	show_browser(user, "[dat]", "window=miningshuttle;size=400x400")
	status = ""


/obj/machinery/computer/area_atmos/Topic(href, href_list)
	if (..())
		return
	usr.set_machine(src)
	if(href_list["scan"])
		scanscrubbers()
	else if(href_list["toggle"])
		var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber = locate(href_list["scrub"])
		if (!validscrubber(scrubber))
			spawn(20)
				status = "ERROR: Couldn't connect to scrubber! (timeout)"
				connectedscrubbers -= scrubber
				updateUsrDialog()
			return
		scrubber.update_use_power(text2num(href_list["toggle"]) ? POWER_USE_ACTIVE : POWER_USE_IDLE)
		scrubber.update_icon()


/obj/machinery/computer/area_atmos/proc/validscrubber(obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if (!istype(scrubber))
		return FALSE
	if (scrubber.z != z)
		return FALSE
	if (get_dist(scrubber, src) > range)
		return FALSE
	return TRUE

/obj/machinery/computer/area_atmos/proc/scanscrubbers()
	connectedscrubbers.Cut()
	for (var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in orange(range, src))
		connectedscrubbers += scrubber
	if (!connectedscrubbers.len)
		status = "ERROR: No scrubber found!"
	updateUsrDialog()


/obj/machinery/computer/area_atmos/area
	zone = "This computer is working in a wired network limited to this area."


/obj/machinery/computer/area_atmos/area/validscrubber(obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if (!istype(scrubber))
		return FALSE
	var/area/A = get_area(src)
	if (!A)
		return FALSE
	var/area/B = get_area(scrubber)
	if (!B)
		return FALSE
	if (A != B)
		return FALSE
	return TRUE


/obj/machinery/computer/area_atmos/area/scanscrubbers()
	connectedscrubbers.Cut()
	var/area/A = get_area(src)
	if (!A)
		return
	for (var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in A)
		connectedscrubbers += scrubber
	if (!connectedscrubbers.len)
		status = "ERROR: No scrubber found!"
	updateUsrDialog()
