#define ON 1
#define OFF 0

/obj/machinery/space_battle/computer/communication
	name = "communication computer"
	screen_icon = "console"
	var/list/communications = list()
	var/list/logs = list()
	var/ui_state = "home"
	var/new_message = 0
	var/transponder = ON


	var/obj/machinery/space_battle/missile_sensor/dish/sensor

/obj/machinery/space_battle/computer/communication/initialize()
	var/area/ship_battle/A = get_area(src)
	if(A && istype(A))
		req_access = list(A.team*10 - SPACE_COMMAND)
	spawn(10)
		reconnect()
	..()

/obj/machinery/space_battle/computer/communication/Destroy()
	communications.Cut()
	logs.Cut()
	return ..()

/obj/machinery/space_battle/computer/communication/update_icon()
	if(stat & (BROKEN|NOPOWER)) return ..()
	if(new_message)
		screen_icon = "alert"
	else
		screen_icon = "console"
	return ..()

/obj/machinery/space_battle/computer/communication/reconnect()
	..()
	communications.Cut()
	for(var/obj/machinery/space_battle/computer/communication/C in world)
		if(C.z != src.z && C.transponder == ON)
			var/obj/effect/overmap/linked = map_sectors["[C.z]"]
			if(linked && !(linked in communications))
				communications += linked.name
				communications["[linked.name]"] = C
	for(var/obj/machinery/space_battle/missile_sensor/dish/D in linked.fire_sensors)
		if(D.sensor_id == src.id_tag)
			sensor = D

/obj/machinery/space_battle/computer/communication/attack_hand(var/mob/user)
	new_message = 0
	update_icon()
	if(operational())
		ui_interact(user)
		icon_state = initial(icon_state)
	else
		user << "<span class='warning'>\The [src] is not responding!</span>"

/obj/machinery/space_battle/computer/communication/proc/operational()
	if(!(stat & (BROKEN|NOPOWER)))
		if(sensor && sensor.can_sense() == 1)
			return 1
	return 0

/obj/machinery/space_battle/computer/communication/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/list/consoles = list()
	for(var/I in communications)
		consoles += I
	if(sensor && sensor.can_sense() == 1)
		data["functional"] = 1
	else
		data["functional"] = 0
	data["consoles"] = consoles
	data["menu"] = ui_state
	data["logs"] = logs
	data["transponder"] = transponder ? "ON" : "OFF"

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "comms.tmpl", "Communication", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/space_battle/computer/communication/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["communication"])
		ui_state = "communication"
	if(href_list["messaging"])
		ui_state = "messaging"
	if(href_list["refresh"])
		reconnect()
		updateUsrDialog()
	if(href_list["logs"])
		ui_state = logs
	if(href_list["transponder"])
		transponder = !transponder
	if(href_list["msg"])
		var/obj/machinery/space_battle/computer/communication/console
		for(var/i=1 to communications.len)
			var/N = communications[i]
			if(href_list["msg"] == N)
				console = communications[N]
		if(!console || !console.operational() || !console.transponder)
			usr << "<span class='warning'>It seems to be offline!</span>"
		else
			var/obj/effect/overmap/them = map_sectors["[console.z]"]
			var/obj/effect/overmap/us = map_sectors["[src.z]"]
			if(them && us)
				var/msg = input(usr, "What message would you like to send?", "Message")
				if(msg)
					msg = RadioChat(usr, msg, (100 - get_efficiency(1,1)), (transponder ? get_efficiency(-1, 1) : 3*get_efficiency(-1,1)), get_dist(them, us), 1)
					console.logs += "<font color='#006600'>RECEIVED MESSAGE < \[[stationtime2text()]\] [transponder ? "[us.name]" : "[RadioChat("Unknown", 100, 100, 1)]"] - \"[msg]\"</font>"
					src.logs += "<font color='#800000'><i>SENT MESSAGE > \[[stationtime2text()]\] [them.name] - \"[msg]\"</i></font>"
					console.visible_message("<span class='notice'>\icon[console.icon_state] \The [console] beeps, \"Message received!\"</span>")
					console.new_message = 1
					console.update_icon()
			else
				usr << "<span class='warning'>It is not registered to a ship!</span>"
	return 1

#undef ON
#undef OFF