/obj/machinery/space_battle/communication
	name = "communication computer"
	icon_state = "computer"
	var/list/communications = list()
	var/list/logs = list()
	var/ui_state = "home"

	var/obj/machinery/space_battle/missile_sensor/dish/sensor

/obj/machinery/space_battle/communication/initialize()
	var/area/ship_battle/A = get_area(src)
	if(A && istype(A))
		req_access = list(A.team*10 - SPACE_COMMAND)
	..()

/obj/machinery/space_battle/communication/Destroy()
	communications.Cut()
	logs.Cut()
	return ..()

/obj/machinery/space_battle/communication/update_icon()
	if(stat & (BROKEN|NOPOWER)) return ..()
	return 0

/obj/machinery/space_battle/communication/reconnect()
	if(!linked) return
	communications.Cut()
	for(var/obj/machinery/space_battle/communication/C in world)
		if(!(C.stat &(BROKEN|NOPOWER)) && C.z != src.z)
			var/obj/effect/overmap/linked = map_sectors["[C.z]"]
			if(linked && !(linked in communications))
				communications += linked.name
				communications["[linked.name]"] = C
	for(var/obj/machinery/space_battle/missile_sensor/dish/D in linked.fire_sensors)
		if(D.sensor_id == src.id_tag)
			sensor = D

/obj/machinery/space_battle/communication/attack_hand(var/mob/user)
	if(!(stat & (BROKEN|NOPOWER)))
		if(!communications.len)
			reconnect()
		ui_interact(user)
		icon_state = initial(icon_state)
	else
		user << "<span class='warning'>\The [src] is not responding!</span>"

/obj/machinery/space_battle/communication/proc/operational()
	if(!(stat & (BROKEN|NOPOWER)))
		if(sensor && sensor.can_sense())
			return 1
	return 0

/obj/machinery/space_battle/communication/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/list/consoles = list()
	for(var/I in communications)
		consoles += I
	data["functional"] = sensor ? sensor.can_sense() : 0
	data["consoles"] = consoles
	data["menu"] = ui_state
	data["logs"] = logs

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "comms.tmpl", "Communication", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/space_battle/communication/Topic(href, href_list)
	if(href_list["communication"])
		ui_state = "communication"
	if(href_list["messaging"])
		ui_state = "messaging"
	if(href_list["refresh"])
		reconnect()
		updateUsrDialog()
	if(href_list["logs"])
		ui_state = logs
	if(href_list["msg"])
		var/obj/machinery/space_battle/communication/console
		for(var/i=1 to communications.len)
			var/N = communications[i]
			if(href_list["msg"] == N)
				console = communications[N]
		if(!console || !console.operational())
			usr << "<span class='warning'>It seems to be offline!</span>"
		else
			var/obj/effect/overmap/them = map_sectors["[console.z]"]
			var/obj/effect/overmap/us = map_sectors["[src.z]"]
			if(them && us)
				var/msg = input(usr, "What message would you like to send?", "Message")
				if(msg)
					msg = RadioChat(msg, rand(80,100), 3*get_efficiency(-1,1), 1)
					console.logs += "<font color='#006600'>RECEIVED MESSAGE < \[[stationtime2text()]\] [us.name] - \"[msg]\"</font>"
					src.logs += "<font color='#800000'><i>SENT MESSAGE > \[[stationtime2text()]\] [them.name] - \"[msg]\"</i></font>"
					console.visible_message("<span class='notice'>\icon[console.icon_state] \The [console] beeps, \"Message received!\"</span>")
					console.icon_state = "alert"
			else
				usr << "<span class='warning'>It is not registered to a ship!</span>"
	nanomanager.update_uis(src)