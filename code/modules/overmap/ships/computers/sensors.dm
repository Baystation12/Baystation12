/obj/machinery/computer/ship/sensors
	name = "sensors console"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = "#77fff8"
	extra_view = 4
	silicon_restriction = STATUS_UPDATE
	machine_name = "sensors console"
	machine_desc = "Used to activate, monitor, and configure a spaceship's sensors. Higher range means higher temperature; dangerously high temperatures may fry the delicate equipment."
	health_max = 100
	var/weakref/sensor_ref
	var/list/last_scan
	var/muted = FALSE
	var/print_language = LANGUAGE_HUMAN_EURO
	var/working_sound = 'sound/machines/sensors/dradis.ogg'
	var/datum/sound_token/sound_token
	var/sound_id

/obj/machinery/computer/ship/sensors/proc/get_sensors()
	var/obj/machinery/shipsensors/sensors = sensor_ref?.resolve()
	if(!istype(sensors) || QDELETED(sensors))
		sensor_ref = null
	return sensors

/obj/machinery/computer/ship/sensors/spacer
	construct_state = /singleton/machine_construction/default/panel_closed/computer/no_deconstruct
	base_type = /obj/machinery/computer/ship/sensors
	print_language = LANGUAGE_SPACER

/obj/machinery/computer/ship/sensors/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!(. = ..()))
		return
	find_sensors()

/obj/machinery/computer/ship/sensors/proc/update_sound()
	if(!working_sound)
		return
	if(!sound_id)
		sound_id = "[type]_[sequential_id(/obj/machinery/computer/ship/sensors)]"
	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(sensors && linked && sensors.use_power ** sensors.powered())
		var/volume = 10
		if(!sound_token)
			sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, working_sound, volume = volume, range = 10)
		sound_token.SetVolume(volume)
	else if(sound_token)
		QDEL_NULL(sound_token)

/obj/machinery/computer/ship/sensors/proc/find_sensors()
	if(!linked)
		return
	for(var/obj/machinery/shipsensors/S in SSmachines.machinery)
		if(linked.check_ownership(S))
			sensor_ref = weakref(S)
			break

/obj/machinery/computer/ship/sensors/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "sensors")
		return

	var/data[0]

	var/obj/machinery/shipsensors/sensors = get_sensors()
	data["viewing"] = viewing_overmap(user)
	data["muted"] = muted
	var/mob/living/silicon/silicon = user
	data["viewing_silicon"] = ismachinerestricted(silicon)
	if(sensors)
		data["on"] = sensors.use_power
		data["range"] = sensors.range
		data["health"] = sensors.get_current_health()
		data["max_health"] = sensors.get_max_health()
		data["heat"] = sensors.heat
		data["critical_heat"] = sensors.critical_heat
		data["desired_range"] = sensors.desired_range
		data["range_choices"] = list()
		for(var/i in 1 to sensors.max_range)
			data["range_choices"] += i
		if(sensors.health_dead)
			data["status"] = "DESTROYED"
		else if(!sensors.powered())
			data["status"] = "NO POWER"
		else if(!sensors.in_vacuum())
			data["status"] = "VACUUM SEAL BROKEN"
		else
			data["status"] = "OK"



		var/list/contacts = list()

		var/list/potential_contacts = list()

		for(var/obj/effect/overmap/nearby in view(7,linked))
			if(nearby.requires_contact) // Some ships require.
				continue
			potential_contacts |= nearby

		// Effects that require contact are only added to the contacts if they have been identified.
		// Allows for coord tracking out of range of the player's view.
		for(var/obj/effect/overmap/visitable/identified_contact in contact_datums)
			potential_contacts |= identified_contact

		for(var/obj/effect/overmap/O in potential_contacts)
			if(linked == O)
				continue
			if(!O.scannable)
				continue
			var/bearing = round(90 - Atan2(O.x - linked.x, O.y - linked.y),5)
			if(bearing < 0)
				bearing += 360
			contacts.Add(list(list("name"=O.name, "color"= O.get_color(), "ref"="\ref[O]", "bearing"=bearing)))
		if(length(contacts))
			data["contacts"] = contacts
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

/obj/machinery/computer/ship/sensors/OnTopic(mob/user, list/href_list, state)
	if(..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		if(user)
			viewing_overmap(user) ? unlook(user) : look(user)
		return TOPIC_REFRESH

	if (href_list["link"])
		find_sensors()
		return TOPIC_REFRESH

	if (href_list["mute"])
		muted = !muted
		return TOPIC_REFRESH

	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(sensors)
		if (href_list["range"])
			var/nrange = input("Set new sensors range", "Sensor range", sensors.range) as num|null
			if(!CanInteract(user,state))
				return TOPIC_NOACTION
			if (nrange)
				sensors.set_desired_range(clamp(nrange, 1, sensors.max_range))
			return TOPIC_REFRESH
		if(href_list["range_choice"])
			var/nrange = text2num(href_list["range_choice"])
			if(!CanInteract(user,state))
				return TOPIC_NOACTION
			if(nrange)
				sensors.set_desired_range(clamp(nrange, 1, sensors.max_range))
		if (href_list["toggle"])
			sensors.toggle()
			return TOPIC_REFRESH

	if (href_list["scan"])
		var/obj/effect/overmap/O = locate(href_list["scan"])
		if(istype(O) && !QDELETED(O))
			if((O in view(7,linked))|| (O in contact_datums))
				playsound(loc, "sound/effects/ping.ogg", 50, 1)
				LAZYSET(last_scan, "data", O.get_scan_data(user))
				LAZYSET(last_scan, "location", "[O.x],[O.y]")
				LAZYSET(last_scan, "name", "[O]")
				to_chat(user, SPAN_NOTICE("Successfully scanned \the [O]."))
				return TOPIC_HANDLED

		to_chat(user, SPAN_WARNING("Could not get a scan from \the [O]!"))
		return TOPIC_HANDLED

	if (href_list["print"])
		playsound(loc, "sound/machines/dotprinter.ogg", 30, 1)
		new/obj/item/paper/(get_turf(src), last_scan["data"], "paper (Sensor Scan - [last_scan["name"]])", L = print_language)
		return TOPIC_HANDLED

/obj/machinery/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "sensors"
	anchored = TRUE
	density = TRUE
	construct_state = /singleton/machine_construction/default/panel_closed
	health_max = 200
	var/critical_heat = 50 // sparks and takes damage when active & above this heat
	var/heat_reduction = 1.7 // mitigates this much heat per tick
	var/sensor_strength //used for detecting ships via contacts
	var/heat = 0
	var/range = 1
	var/max_range = 10
	var/desired_range = 1 // "desired" range, that the actual range will gradually move towards to
	var/desired_range_instant = FALSE // if true, instantly changes range to desired
	idle_power_usage = 5000

/obj/machinery/shipsensors/RefreshParts()
	..()
	sensor_strength = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0, 5)

/obj/machinery/shipsensors/attackby(obj/item/W, mob/user)
	if (isWelder(W) && user.a_intent != I_HURT)
		var/damage = get_damage_value()
		var/obj/item/weldingtool/WT = W
		if (!damage)
			to_chat(user, SPAN_WARNING("\The [src] doesn't need any repairs."))
			return TRUE
		if (!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [W] needs to be turned on first."))
			return TRUE
		if (!WT.remove_fuel(0,user))
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		if(do_after(user, max(5, damage / 5), src, DO_REPAIR_CONSTRUCT) && WT?.isOn())
			to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
			revive_health()
		return TRUE

	return ..()

/obj/machinery/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1

/obj/machinery/shipsensors/on_update_icon()
	overlays.Cut()
	if(use_power)
		icon_state = "sensors"
	if(health_dead)
		icon_state = "sensors_broken"
	else
		icon_state = "sensors_off"
	if(panel_open)
		overlays += "sensors_panel"
	. = ..()

/obj/machinery/shipsensors/proc/toggle()
	if(use_power) // reset desired range when turning off
		set_desired_range(1)
	if(!use_power && (health_dead || !in_vacuum()))
		return // No turning on if broken or misplaced.
	if(!use_power) //need some juice to kickstart
		use_power_oneoff(idle_power_usage*5)
	update_use_power(!use_power)
	queue_icon_update()

/obj/machinery/shipsensors/Process()
	if(use_power) //can't run in non-vacuum
		if(!in_vacuum())
			toggle()

		check_desired_range()

		if(heat > critical_heat)
			src.visible_message(SPAN_DANGER("\The [src] violently spews out sparks!"))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()

			damage_health(rand(10, 50), DAMAGE_BURN)
			toggle()

		heat += idle_power_usage / 15000

	else if(desired_range < range)
		set_range(range-1) // if power off, only spool down

	if (heat > 0)
		heat = max(0, heat - heat_reduction)

/obj/machinery/shipsensors/power_change()
	. = ..()
	if(use_power && !powered())
		toggle()

/obj/machinery/shipsensors/proc/check_desired_range()
	if (desired_range != range)
		if(desired_range > range)
			set_range(range+1)

		else if(desired_range < range)
			set_range(range-1)

		if(desired_range-range <= -max_range/2)
			set_range(range-1) // if working hard, spool down faster too

/obj/machinery/shipsensors/proc/set_desired_range(nrange)
	desired_range = nrange
	if(desired_range_instant)
		set_range(nrange)

/obj/machinery/shipsensors/proc/set_range(nrange)
	range = nrange
	change_power_consumption(1500 * (range**2), POWER_USE_IDLE) //Exponential increase, also affects speed of overheating

/obj/machinery/shipsensors/emp_act(severity)
	if (use_power)
		toggle()
	..()

/obj/machinery/shipsensors/on_death()
	if (use_power)
		toggle()
	..()

/obj/machinery/shipsensors/RefreshParts()
	..()
	heat_reduction = round(total_component_rating_of_type(/obj/item/stock_parts/manipulator) / 3)



// For small shuttles
/obj/machinery/shipsensors/weak
	heat_reduction = 0.35 // Can sustain range 1
	heat_reduction = 1.7 // Can sustain range 4
	max_range = 7
	desc = "Miniturized gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."

/obj/machinery/shipsensors/strong
	name = "sensors suite"
	desc = "An upgrade to the standard ship-mounted sensor array, this beast has massive cooling systems running beneath it, allowing it to run hotter for much longer. Can only run in vacuum to protect delicate quantum BS elements."
	heat_reduction = 3.7 // can sustain range 6
	max_range = 14

/obj/item/stock_parts/circuitboard/shipsensors
	name = T_BOARD("broad-band sensor suite")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/shipsensors
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 5, TECH_BLUESPACE = 3)
	req_components = list(
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/treatment = 1,
							/obj/item/stock_parts/manipulator = 3)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)
