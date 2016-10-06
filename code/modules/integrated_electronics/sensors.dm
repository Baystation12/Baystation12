/obj/item/integrated_circuit/sensor
	name = "sensor"
	complexity = 5
	inputs = list("active", "range" = 3)
	outputs = list("triggering ref")
	activators = list("on triggered")
	category = /obj/item/integrated_circuit/sensor
	var/min_range = 0
	var/max_range = 3

/obj/item/integrated_circuit/sensor/proximity
	var/datum/proximity_trigger/proximity_trigger
	category = /obj/item/integrated_circuit/sensor/proximity

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

/obj/item/integrated_circuit/sensor/proximity/on_data_written()
	var/datum/integrated_io/active = inputs[1]
	var/datum/integrated_io/range = inputs[2]

	var/do_activate = isnum(active.data) && active.data
	var/turn_on = !proximity_trigger.is_active() && do_activate
	var/turn_off = proximity_trigger.is_active() && !do_activate

	// We're doing it in this order to avoid having to do double-registrations if range/activation change in the same write
	//  As the time this code was written on_data_written() is called once per pin write instead of after all pins have been written but this is the future proof variant.
	if(turn_off)
		proximity_trigger.unregister_turfs()
	if(isnum(range.data))
		range.data = between(min_range, range.data, max_range)
		proximity_trigger.set_range(range.data)
	if(turn_on)
		proximity_trigger.register_turfs()
	..()

/obj/item/integrated_circuit/sensor/proximity/proc/on_turf_entered(var/enterer)
	if(!shall_trigger(enterer))
		return

	var/datum/integrated_io/O = outputs[1]
	var/datum/integrated_io/A = activators[1]

	O.data = weakref(enterer)
	O.push_data()
	A.push_data()

/obj/item/integrated_circuit/sensor/proximity/proc/on_turfs_changed(var/list/old_turfs, var/list/new_turfs)
	return

/obj/item/integrated_circuit/sensor/proximity/proc/shall_trigger(var/enterer)
	if(enterer == src)
		return FALSE
	if(ismob(enterer) && !isliving(enterer))
		return FALSE
	if(enterer == loc && istype(loc, /obj/item/device/electronic_assembly))
		return FALSE
	return TRUE

/obj/item/integrated_circuit/sensor/proximity/ir
	name = "IR sensor"
	desc = "Reacts to movement in a straight line in front of its current facing and trigger immediately upon detection."
	min_range = 1
	max_range = 7
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
	var/datum/integrated_io/visible_beam = inputs[3]
	if(isnum(visible_beam.data))
		var/new_beam_visibility = !!visible_beam.data
		if(current_beam_visibility != new_beam_visibility)
			current_beam_visibility = new_beam_visibility
			update_beam()

/obj/item/integrated_circuit/sensor/proximity/ir/on_turfs_changed(var/list/old_turfs, var/list/new_turfs)
	seen_turfs = new_turfs
	update_beam()

/obj/item/integrated_circuit/sensor/proximity/ir/proc/update_beam()
	create_update_and_delete_beams(proximity_trigger.is_active(), current_beam_visibility, dir, seen_turfs, beams)

/obj/item/integrated_circuit/sensor/proximity/proximity
	name = "proximity sensor"
	desc = "Reacts to movement in an area around it but will only trigger if movement is confirmed twice within 2 seconds (but not necessarily from the same source)."
	min_range = 0
	max_range = 3
	icon_state = "sensor_proxy"
	proximity_trigger = /datum/proximity_trigger/square
	var/last_trigger = 0

/obj/item/integrated_circuit/sensor/proximity/proximity/shall_trigger(var/enterer)
	if(..() && ((world.time - last_trigger) <= 2 SECONDS))
		. = TRUE
	last_trigger = world.time
