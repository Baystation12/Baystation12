/obj/item/weapon/circuitboard/atmoscontrol
	name = "\improper Central Atmospherics Computer Circuitboard"
	build_path = /obj/machinery/computer/atmoscontrol

/obj/machinery/computer/atmoscontrol
	name = "\improper Central Atmospherics Computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer_generic"
	density = 1
	anchored = 1.0
	circuit = "/obj/item/weapon/circuitboard/atmoscontrol"
	var/obj/machinery/alarm/current
	var/overridden = 0 //not set yet, can't think of a good way to do it
	req_access = list(access_ce)
	var/list/monitored_alarm_ids = null
	var/list/monitored_alarms = null

/obj/machinery/computer/atmoscontrol/laptop
	name = "Atmospherics Laptop"
	desc = "Cheap Nanotrasen Laptop."
	icon_state = "medlaptop"
	density = 0

/obj/machinery/computer/atmoscontrol/initialize()
	..()
	if(!monitored_alarms && monitored_alarm_ids)
		monitored_alarms = new
		for(var/obj/machinery/alarm/alarm in machines)
			if(alarm.alarm_id && alarm.alarm_id in monitored_alarm_ids)
				monitored_alarms += alarm
		// machines may not yet be ordered at this point
		monitored_alarms = dd_sortedObjectList(monitored_alarms)

/obj/machinery/computer/atmoscontrol/attack_ai(var/mob/user as mob)
	return interact(user)

/obj/machinery/computer/atmoscontrol/attack_hand(mob/user)
	if(..())
		return
	return interact(user)

/obj/machinery/computer/atmoscontrol/interact(mob/user)
	user.set_machine(src)
	if(allowed(user))
		overridden = 1
	else if(!emagged)
		overridden = 0
	var/dat = "<a href='?src=\ref[src]&reset=1'>Main Menu</a><hr>"
	if(monitored_alarms && monitored_alarms.len == 1)
		current = monitored_alarms[1]
	if(current)
		dat += specific()
	else
		for(var/obj/machinery/alarm/alarm in monitored_alarms ? monitored_alarms : machines)
			dat += "<a href='?src=\ref[src]&alarm=\ref[alarm]'>"
			switch(max(alarm.danger_level, alarm.alarm_area.atmosalm))
				if (0)
					dat += "<font color=green>"
				if (1)
					dat += "<font color=blue>"
				if (2)
					dat += "<font color=red>"
			dat += "[sanitize(alarm.name)]</font></a><br/>"
	user << browse(dat, "window=atmoscontrol")

/obj/machinery/computer/atmoscontrol/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user.visible_message("\red \The [user] swipes \a [I] through \the [src], causing the screen to flash!",\
			"\red You swipe your [I] through \the [src], the screen flashing as you gain full control.",\
			"You hear the swipe of a card through a reader, and an electronic warble.")
		emagged = 1
		overridden = 1
		return
	return ..()

/obj/machinery/computer/atmoscontrol/proc/specific()
	if(!current)
		return ""
	var/dat = "<h3>[current.name]</h3><hr>"
	dat += current.return_status()
	if(current.remote_control || overridden)
		dat += "<hr>[current.return_controls(src)]"
	return dat

//a bunch of this is copied from atmos alarms
/obj/machinery/computer/atmoscontrol/Topic(href, href_list)
	if(..())
		return
	if(href_list["reset"])
		current = null
	if(href_list["alarm"])
		current = locate(href_list["alarm"])
	else if(current)
		current.Topic(href, href_list, 1, 1)
	interact(usr)
