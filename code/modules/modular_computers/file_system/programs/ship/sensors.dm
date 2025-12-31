/datum/computer_file/program/ship/sensors
	filename = "sensors"
	filedesc = "Sensors Control"
	nanomodule_path = /datum/nano_module/program/ship/sensors
	program_icon_state = "sensors"
	program_key_state = "teleport_key"
	program_menu_icon = "eject"
	extended_desc = "Used to activate, monitor, and configure a spaceship's sensors. Higher range means higher temperature; dangerously high temperatures may fry the delicate equipment."
	size = 5

/datum/nano_module/program/ship/sensors
	name = "Sensors Control"
	extra_view = 4
	var/weakref/sensor_ref
	var/list/last_scan
	var/muted = FALSE
	var/sound_off = FALSE
	var/print_language = LANGUAGE_HUMAN_EURO
	var/working_sound = 'sound/machines/sensors/sensorloop.ogg'
	var/datum/sound_token/sound_token
	var/sound_id
	var/modify_access_req = access_bridge

/datum/computer_file/program/ship/sensors/spacer
	nanomodule_path = /datum/nano_module/program/ship/sensors/spacer
	available_on_ntnet = FALSE

/datum/computer_file/program/ship/sensors/process_tick()
	..()
	var/datum/nano_module/program/ship/sensors/sensors_program = NM
	if(!istype(sensors_program))
		return
	sensors_program.relayed_process()

/datum/nano_module/program/ship/sensors/spacer
	print_language = LANGUAGE_SPACER

/datum/nano_module/program/ship/sensors/proc/get_sensors()
	var/obj/machinery/shipsensors/sensors = sensor_ref?.resolve()
	if (!istype(sensors) || QDELETED(sensors))
		sensor_ref = null
	return sensors

/datum/nano_module/program/ship/sensors/sync_linked()
	if (!(. = ..()))
		return .
	find_sensors()

/datum/nano_module/program/ship/sensors/proc/find_sensors()
	if (!linked)
		return
	for (var/obj/machinery/shipsensors/sensors in SSmachines.machinery)
		if (linked.check_ownership(sensors))
			LAZYDISTINCTADD(sensors.linked_programs, src)
			sensors.link_ship(linked)
			sensor_ref = weakref(sensors)
			break

/datum/nano_module/program/ship/sensors/Destroy()
	if (sensor_ref)
		var/obj/machinery/shipsensors/sensor = sensor_ref.resolve()
		LAZYREMOVE(sensor.linked_programs, src)
		sensor_ref = null

	if (LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if (M)
				unlook(M)

	if (sound_token)
		QDEL_NULL(sound_token)

	. = ..()

/datum/nano_module/program/ship/sensors/proc/relayed_process()
	update_sound()

/datum/nano_module/program/ship/sensors/proc/update_sound()
	if (sound_off)
		if (sound_token)
			QDEL_NULL(sound_token)
		return
	if (!working_sound)
		return
	if (!sound_id)
		sound_id = "[type]_[sequential_id(/datum/nano_module/program/ship/sensors)]"
	var/obj/machinery/shipsensors/sensors = get_sensors()
	if (sensors && linked && sensors.use_power ** sensors.powered() && program.computer.get_component(/obj/item/stock_parts/computer/ship_interface))
		var/volume = 8
		if (!sound_token)
			sound_token = GLOB.sound_player.PlayLoopingSound(nano_host(), sound_id, working_sound, volume = volume, range = 10)
		sound_token.SetVolume(volume)
	else if (sound_token)
		QDEL_NULL(sound_token)

/datum/nano_module/program/ship/sensors/proc/state_visible(text)
	program.computer.visible_notification(text)

/datum/nano_module/program/ship/sensors/proc/alert_unknown_contact(contact_id, bearing, bearing_variability)
	if (muted)
		return
	state_visible("Unknown contact designation '[contact_id]' detected nearby, bearing [bearing], error +/- [bearing_variability]. Beginning trace.")
	program.computer.audible_notification("sound/machines/sensors/contactgeneric.ogg") //Let players know there's something nearby

/datum/nano_module/program/ship/sensors/proc/alert_contact_identified(contact_name, bearing)
	if (muted)
		return
	state_visible("New contact identified, designation [contact_name], bearing [bearing].")
	program.computer.audible_notification("sound/machines/sensors/newcontact.ogg")

/datum/nano_module/program/ship/sensors/proc/alert_contact_lost(contact_name)
	if (muted)
		return
	state_visible("Contact lost with [contact_name].")
	program.computer.audible_notification("sound/machines/sensors/contact_lost.ogg")

/datum/nano_module/program/ship/sensors/check_eye(mob/user as mob)
	if (!user)
		return -1
	if (CanUseTopic(user, GLOB.default_state) != STATUS_INTERACTIVE || !linked)
		unlook(user)
		return -1
	else
		return 0

/datum/nano_module/program/ship/sensors/proc/can_modify(mob/user)
	return program.computer.get_component(/obj/item/stock_parts/computer/ship_interface) && check_access(user, modify_access_req) && program.computer.get_hardware_flag() == PROGRAM_CONSOLE

/datum/nano_module/program/ship/sensors/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/obj/machinery/shipsensors/sensors = get_sensors()

	data["synced"] = !isnull(linked)
	data["viewing"] = viewing_overmap(user)
	data["muted"] = muted
	data["sound_off"] = sound_off
	data["allowchange"] = can_modify(user)
	var/mob/living/silicon/silicon = user
	data["viewing_silicon"] = ismachinerestricted(silicon)
	if (sensors)
		data["on"] = sensors.use_power
		data["range"] = sensors.range
		data["health"] = sensors.get_current_health()
		data["max_health"] = sensors.get_max_health()
		data["heat"] = sensors.heat
		data["critical_heat"] = sensors.critical_heat
		if (sensors.health_dead())
			data["status"] = "DESTROYED"
		else if (!sensors.powered())
			data["status"] = "NO POWER"
		else if (!sensors.in_vacuum())
			data["status"] = "VACUUM SEAL BROKEN"
		else
			data["status"] = "OK"
		var/list/known_contacts = list()
		var/list/unknown_contacts = list()

		var/list/potential_contacts = list()

		if (sensors?.use_power)
			for (var/obj/overmap/nearby in view(round(sensors.range,1), linked))
				if (nearby.requires_contact) // Some ships require.
					continue
				potential_contacts |= nearby

		for (var/obj/overmap/visitable/contact in sensors.objects_in_view)
			if (contact.scannable)
				if (contact in sensors.contact_datums)
					potential_contacts |= contact
				else
					var/bearing_variability = round(300/sensors.sensor_strength, 5)
					unknown_contacts.Add(list(list(
						"name" = contact.unknown_id,
						"bearing" = inaccurate_bearing(get_bearing(linked, contact), bearing_variability),
						"variability" = bearing_variability,
						"progress" = sensors.objects_in_view[contact]
					)))

		for (var/obj/overmap/contact in potential_contacts)
			if (linked == contact)
				continue
			known_contacts.Add(list(list(
				"name" = contact.name,
				"color" = contact.get_color(),
				"ref" = "\ref[contact]",
				"bearing" = get_bearing(linked, contact)
			)))

		if (length(unknown_contacts))
			data["unknown_contacts"] = unknown_contacts

		if (length(known_contacts))
			data["known_contacts"] = known_contacts

		data["last_scan"] = last_scan
	else
		data["status"] = "MISSING"
		data["range"] = "N/A"
		data["on"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shipsensors.tmpl", "[linked.name] Sensors Control", 420, 530, src)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/ship/sensors/Topic(href, href_list)
	if (..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	var/mob/user = usr

	if (href_list["viewing"])
		if (user)
			viewing_overmap(user) ? unlook(user) : look(user)
		return TOPIC_REFRESH

	if (href_list["link"])
		find_sensors()
		return TOPIC_REFRESH

	if (href_list["mute"])
		muted = !muted
		return TOPIC_REFRESH

	if (href_list["sound_off"])
		sound_off = !sound_off
		return TOPIC_REFRESH

	var/obj/machinery/shipsensors/sensors = get_sensors()
	if (sensors)
		if (href_list["range"] && can_modify(user))
			var/nrange = input("Set new sensors range", "Sensor range", sensors.range) as num|null
			if (!can_still_topic())
				return TOPIC_NOACTION
			if (nrange)
				sensors.set_range(clamp(round(nrange), 1, world.view))
			return TOPIC_REFRESH
		if (href_list["toggle"] && can_modify(user))
			sensors.toggle()
			return TOPIC_REFRESH

	if (href_list["scan"])
		var/obj/overmap/O = locate(href_list["scan"])
		if (istype(O) && !QDELETED(O))
			if ((O in view(7,linked))|| (O in sensors.contact_datums))
				program.computer.audible_notification("sound/effects/ping.ogg")
				LAZYSET(last_scan, "data", O.get_scan_data(user))
				LAZYSET(last_scan, "location", "[O.x],[O.y]")
				LAZYSET(last_scan, "name", "[O]")
				state_visible("Successfully scanned \the [O].")
				return TOPIC_HANDLED

		state_visible(SPAN_WARNING("Could not get a scan from \the [O]!"))
		return TOPIC_HANDLED

	if (href_list["print"])
		var/scan_data = ""
		for (var/scan in last_scan["data"])
			scan_data += scan + "\n\n"
		if (!program.computer.print_paper(scan_data, "paper (Sensor Scan - [last_scan["name"]])"))
			to_chat(usr, SPAN_NOTICE("Hardware Error: Printer was unable to print the selected file."))
		return TOPIC_HANDLED
