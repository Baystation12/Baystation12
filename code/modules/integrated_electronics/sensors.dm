/obj/item/integrated_circuit/sensor
	name = "sensor"
	complexity = 5
	inputs = list("active", "range" = 3)
	outputs = list("triggering ref")
	activators = list("update", "on triggered")
	category = /obj/item/integrated_circuit/sensor
	var/min_range = 0
	var/max_range = 3

/obj/item/integrated_circuit/sensor/New()
	..()

	if(min_range != max_range && max_range)
		extended_desc = "This sensor has a variable detection range from [min_range] to [max_range] meters away from its location."
	else if(min_range == max_range)
		extended_desc = "This sensor has a static detection range of [max_range] meter\s away from its location."
	if(min_range == 0)
		extended_desc += "<br>A range of 0 still includes its current location."

/obj/item/integrated_circuit/sensor/proximity
	complexity = 10
	var/sensitivity = 2  // How soon, in seconds, the proximity sensor must detect movement again to actually trigger
	var/last_trigger = 0 // And of course, memory of when it last triggered
	var/datum/proximity_trigger/proximity_trigger
	category = /obj/item/integrated_circuit/sensor/proximity

/obj/item/integrated_circuit/sensor/proximity/New()
	..()
	var/datum/integrated_io/range = inputs[2]
	range.data = between(min_range, range.data, max_range)

	if(sensitivity)
		extended_desc += "<br>This ensor will only trigger if movement is confirmed twice within [sensitivity] second\s (but not necessarily from the same source)"

/obj/item/integrated_circuit/sensor/proximity/initialize()
	..()

	var/datum/integrated_io/range = inputs[2]
	if(islist(proximity_trigger))
		var/proxy_type = proximity_trigger[1]
		var/proxy_flags = proximity_trigger[proxy_type]
		proximity_trigger = new proxy_type(src, /obj/item/integrated_circuit/sensor/proximity/proc/on_turf_entered, /obj/item/integrated_circuit/sensor/proximity/proc/on_turfs_changed, range.data, proxy_flags)
	if(ispath(proximity_trigger))
		proximity_trigger = new proximity_trigger(src, /obj/item/integrated_circuit/sensor/proximity/proc/on_turf_entered, /obj/item/integrated_circuit/sensor/proximity/proc/on_turfs_changed, range.data)

/obj/item/integrated_circuit/sensor/proximity/Destroy()
	if(istype(proximity_trigger))
		qdel(proximity_trigger)
		proximity_trigger = null
	. = ..()

/obj/item/integrated_circuit/sensor/proximity/do_work(var/activated_pin)
	if(activated_pin != activators[1])
		return

	var/active = set_pin_data(IC_INPUT, 1)
	var/range = set_pin_data(IC_INPUT, 2)

	var/do_activate = isnum(active) && active
	var/turn_on = !proximity_trigger.is_active() && do_activate
	var/turn_off = proximity_trigger.is_active() && !do_activate

	// We're doing it in this order to avoid having to do double-registrations if range/activation change in the same write
	//  As the time this code was written on_data_written() is called once per pin write instead of after all pins have been written but this is the future proof variant.
	if(turn_off)
		proximity_trigger.unregister_turfs()
	if(isnum(range))
		range = between(min_range, range, max_range)
		proximity_trigger.set_range(range)
	if(turn_on)
		proximity_trigger.register_turfs()

/obj/item/integrated_circuit/sensor/proximity/proc/on_turf_entered(var/enterer)
	if(!shall_trigger(enterer))
		return

	set_pin_data(IC_OUTPUT, 1, weakref(enterer))
	activate_pin(2)

/obj/item/integrated_circuit/sensor/proximity/proc/on_turfs_changed(var/list/old_turfs, var/list/new_turfs)
	return

/obj/item/integrated_circuit/sensor/proximity/proc/shall_trigger(var/enterer)
	if(enterer == src)
		return FALSE
	if(ismob(enterer) && !isliving(enterer))
		return FALSE
	if(enterer == loc && istype(loc, /obj/item/device/electronic_assembly))
		return FALSE
	if(!sensitivity)
		return TRUE

	if((world.time - last_trigger) <= (sensitivity SECONDS))
		. = TRUE
	last_trigger = world.time

/obj/item/integrated_circuit/sensor/proximity/ir
	name = "IR sensor"
	desc = "Reacts to movement in a straight line in front of its current facing."
	min_range = 1
	max_range = 7
	sensitivity = 0
	icon_state = "sensor_ir"
	proximity_trigger = list(/datum/proximity_trigger/line = PROXIMITY_EXCLUDE_HOLDER_TURF)
	inputs = list("active", "range" = 7, "visible beam" = FALSE)

	var/current_beam_visibility = FALSE
	var/list/seen_turfs
	var/list/beams

/obj/item/integrated_circuit/sensor/proximity/ir/initialize()
	..()
	seen_turfs = list()
	beams = list()

/obj/item/integrated_circuit/sensor/proximity/ir/on_data_written()
	..()
	var/visible_beam = get_pin_data(IC_INPUT, 3)
	if(isnum(visible_beam))
		var/new_beam_visibility = !!visible_beam
		if(current_beam_visibility != new_beam_visibility)
			current_beam_visibility = new_beam_visibility
			update_beam()

/obj/item/integrated_circuit/sensor/proximity/ir/on_turfs_changed(var/list/old_turfs, var/list/new_turfs)
	seen_turfs = new_turfs
	update_beam()

/obj/item/integrated_circuit/sensor/proximity/ir/proc/update_beam()
	create_update_and_delete_beams(proximity_trigger.is_active(), current_beam_visibility, dir, seen_turfs, beams)

/obj/item/integrated_circuit/sensor/proximity/proximity
	name = "low-sensitivity proximity sensor"
	desc = "Reacts to movement in an area around it."
	min_range = 0
	max_range = 3
	sensitivity = 2
	icon_state = "sensor_proxy"
	proximity_trigger = /datum/proximity_trigger/square

/obj/item/integrated_circuit/sensor/proximity/proximity/high
	name = "high-sensitivity proximity sensor"
	desc = "Reacts to movement directly in its location."
	min_range = 0
	max_range = 0
	sensitivity = 0

/obj/item/integrated_circuit/accelerometer
	name = "accelerometer"
	desc = "A small, square circuit with a box in the middle used to detect motion."
	icon_state = "sensor_accelerometer"
	complexity = 3
	inputs = list()
	outputs = list()
	activators = list("toggle power", "motion detected")
	outputs = list("x motion", "y motion", "z motion")
	var/list/last_location = list(0,0,0)
	var/on = 0

/obj/item/integrated_circuit/accelerometer/do_work(var/activated_pin)
	if(activated_pin != activators[1])
		return
	on = !on
	if(on)
		processing_objects.Add(src)
		var/turf/T = get_turf(src)
		if(T)
			last_location = list(T.x, T.y, T.z)
	else
		processing_objects.Remove(src)

/obj/item/integrated_circuit/accelerometer/process()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/list/cur = list(T.x, T.y, T.z)
	var/activate = 0
	for(var/i in 1 to 3)
		var/acc = cur[i] - last_location[i]
		if(acc)
			activate = 1
		set_pin_data(IC_OUTPUT, i, acc)
		last_location[i] = cur[i]
	if(activate)
		activate_pin(2)