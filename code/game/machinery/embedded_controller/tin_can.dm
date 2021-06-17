// Designed for one-room vessel with an door to an exterior (no cycleable airlock).
// Expects the following equipment:
// src, with id_tag = example
// Airlock(s), all with id_tag = example_outer
// A set of pumps or possibly other atmos objs, with the property that if they are all on they will evacuate the atmosphere in the room, all with id_tag = example_pump_out_external
// Same, wtih the property if they are all on they will equalize the atmosphere with the exterior, all with id_tag = example_pump_out_internal
// An air sensor, with id_tag = example_exterior_sensor, outside the room
// An air sensor, with id_tag = example_interior_sensor, inside the room

#define STATE_FILL     1
#define STATE_EVACUATE 2
#define STATE_SEALED   3

/obj/machinery/embedded_controller/radio/airlock/tin_can
	program = /datum/computer/file/embedded_program/airlock/tin_can
	cycle_to_external_air = TRUE // Some kind of legacy var needed for proper init
	scrubber_assist = TRUE

/obj/machinery/embedded_controller/radio/airlock/tin_can/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/nanoui/master_ui = null, datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	var/datum/computer/file/embedded_program/airlock/tin_can/our_program = program
	data = list(
		"chamber_pressure" = round(program.memory["internal_sensor_pressure"]),
		"door_safety" = our_program.door_safety,
		"state" = our_program.state
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "tin_can.tmpl", name, 470, 290, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// We piggyback off this for the utility procs and data aquisition, mostly
/datum/computer/file/embedded_program/airlock/tin_can
	var/door_safety = TRUE // Whether you can open the airlock if the atmos on either side don't match
	state = STATE_FILL

/datum/computer/file/embedded_program/airlock/tin_can/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(signal.data["tag"] == id_tag) // Does things we don't want to our state.
		return
	..()

/datum/computer/file/embedded_program/airlock/tin_can/receive_user_command(command)
	. = TRUE
	switch(command)
		if("toggle_door_safety")
			door_safety = !door_safety
			if(!door_safety)
				signalDoor(tag_exterior_door, "unlock")
		if("evacuate_atmos")
			if(state == STATE_EVACUATE)
				return
			state = STATE_EVACUATE
			toggleDoor(memory["exterior_status"], tag_exterior_door, door_safety, "close")
			signalPump(tag_pump_out_internal, 1, 0, 0) // Interior pump, target is a vaccum
			signalPump(tag_pump_out_external, 1, 1, 10000) // Exterior pump, target is infinite 
			signalPump(tag_pump_out_scrubber, 1) // Get the pump to assist us in scrubbing the air out
		if("fill_atmos")
			if(state == STATE_FILL)
				return
			state = STATE_FILL
			toggleDoor(memory["exterior_status"], tag_exterior_door, door_safety, "close")
			signalPump(tag_pump_out_internal, 1, 1, memory["external_sensor_pressure"]) // Interior pump, target is exterior pressure
			signalPump(tag_pump_out_external, 1, 0, 0) // Exterior pump, target is zero, to intake
			signalPump(tag_pump_out_scrubber, 0) // make sure the scrubber isn't fighting us
		if("seal")
			if(state == STATE_SEALED)
				return
			state = STATE_SEALED
			toggleDoor(memory["exterior_status"], tag_exterior_door, door_safety, "close")
			signalPump(tag_pump_out_internal, 0)
			signalPump(tag_pump_out_external, 0)
			signalPump(tag_pump_out_scrubber, 0)
		else
			. = FALSE

/datum/computer/file/embedded_program/airlock/tin_can/process()
	if(door_safety)
		var/safe_to_open = safe_to_open()
		if(safe_to_open && memory["exterior_status"]["lock"] == "locked")
			signalDoor(tag_exterior_door, "unlock")
		else if(!safe_to_open && memory["exterior_status"]["lock"] == "unlocked")
			signalDoor(tag_exterior_door, "secure_close") // close and lock

/datum/computer/file/embedded_program/airlock/tin_can/proc/safe_to_open()
	. = TRUE
	if(abs(memory["external_sensor_pressure"] - memory["internal_sensor_pressure"]) > 1)
		return FALSE

#undef STATE_FILL
#undef STATE_EVACUATE
#undef STATE_SEALED