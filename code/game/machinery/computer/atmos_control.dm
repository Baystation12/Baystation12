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
	var/overridden = 0 //not set yet, can't think of a good way to do it
	req_access = list(access_ce)
	var/list/monitored_alarm_ids = null
	var/list/monitored_alarms = null
	var/ui_ref

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
	return ui_interact(user)

/obj/machinery/computer/atmoscontrol/attack_hand(mob/user)
	if(..())
		return
	return ui_interact(user)

/obj/machinery/computer/atmoscontrol/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/alarms[0]

	// TODO: Move these to a cache, similar to cameras
	for(var/obj/machinery/alarm/alarm in (monitored_alarms ? monitored_alarms : machines))
		alarms[++alarms.len] = list("name" = sanitize(alarm.name), "ref"= "\ref[alarm]", "danger" = max(alarm.danger_level, alarm.alarm_area.atmosalm))
	data["alarms"] = alarms

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atmos_control.tmpl", src.name, 625, 625)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
	ui_ref = ui

/obj/machinery/computer/atmoscontrol/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user.visible_message("\red \The [user] swipes \a [I] through \the [src], causing the screen to flash!",\
			"\red You swipe your [I] through \the [src], the screen flashing as you gain full control.",\
			"You hear the swipe of a card through a reader, and an electronic warble.")
		emagged = 1
		overridden = 1
		return
	return ..()

//a bunch of this is copied from atmos alarms
/obj/machinery/computer/atmoscontrol/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["alarm"])
		if(ui_ref)
			var/obj/machinery/alarm/alarm = locate(href_list["alarm"]) in (monitored_alarms ? monitored_alarms : machines)
			if(alarm)
				var/datum/topic_state/TS = generate_state(alarm)
				alarm.ui_interact(usr, master_ui = ui_ref, custom_state = TS)
		return 1

/obj/machinery/computer/atmoscontrol/proc/generate_state(var/alarm)
	var/datum/topic_state/air_alarm/state = new()
	state.atmos_control = src
	state.air_alarm = alarm
	return state

/datum/topic_state/air_alarm
	flags = NANO_IGNORE_DISTANCE
	var/obj/machinery/computer/atmoscontrol/atmos_control = null
	var/obj/machinery/alarm/air_alarm	= null

/datum/topic_state/air_alarm/href_list(var/mob/user)
	var/list/extra_href = list()
	extra_href["remote_connection"] = 1
	extra_href["remote_access"] = user && (atmos_control.allowed(user) || atmos_control.emagged || air_alarm.rcon_setting == RCON_YES || (air_alarm.alarm_area.atmosalm && air_alarm.rcon_setting == RCON_AUTO))

	return extra_href
