//Handles the control of airlocks

#define STATE_IDLE			0
#define STATE_PREPARE		1
#define STATE_DEPRESSURIZE	2
#define STATE_PRESSURIZE	3

#define TARGET_NONE			0
#define TARGET_INOPEN		-1
#define TARGET_OUTOPEN		-2

#define SENSOR_TOLERANCE 1

/datum/computer/file/embedded_program/airlock
	var/tag_exterior_door
	var/tag_interior_door
	var/tag_airpump
	var/tag_chamber_sensor
	var/tag_exterior_sensor
	var/tag_interior_sensor
	var/tag_airlock_mech_sensor
	var/tag_shuttle_mech_sensor

	var/state = STATE_IDLE
	var/target_state = TARGET_NONE

	var/cycle_to_external_air = 0
	var/tag_pump_out_external
	var/tag_pump_out_internal

	var/tag_air_alarm

/datum/computer/file/embedded_program/airlock/New(var/obj/machinery/embedded_controller/M)
	..(M)

	memory["chamber_sensor_pressure"] = ONE_ATMOSPHERE
	memory["external_sensor_pressure"] = 0					//assume vacuum for simple airlock controller
	memory["internal_sensor_pressure"] = ONE_ATMOSPHERE
	memory["exterior_status"] = list(state = "closed", lock = "locked")		//assume closed and locked in case the doors dont report in
	memory["interior_status"] = list(state = "closed", lock = "locked")
	memory["pump_status"] = "unknown"
	memory["target_pressure"] = ONE_ATMOSPHERE
	memory["purge"] = 0
	memory["secure"] = 0

	if (istype(M, /obj/machinery/embedded_controller/radio/airlock))	//if our controller is an airlock controller than we can auto-init our tags
		var/obj/machinery/embedded_controller/radio/airlock/controller = M
		cycle_to_external_air = controller.cycle_to_external_air
		if(cycle_to_external_air)
			tag_pump_out_external = "[id_tag]_pump_out_external"
			tag_pump_out_internal = "[id_tag]_pump_out_internal"
		tag_exterior_door = controller.tag_exterior_door? controller.tag_exterior_door : "[id_tag]_outer"
		tag_interior_door = controller.tag_interior_door? controller.tag_interior_door : "[id_tag]_inner"
		tag_airpump = controller.tag_airpump? controller.tag_airpump : "[id_tag]_pump"
		tag_chamber_sensor = controller.tag_chamber_sensor? controller.tag_chamber_sensor : "[id_tag]_sensor"
		tag_exterior_sensor = controller.tag_exterior_sensor || "[id_tag]_exterior_sensor"
		tag_interior_sensor = controller.tag_interior_sensor || "[id_tag]_interior_sensor"
		tag_airlock_mech_sensor = controller.tag_airlock_mech_sensor? controller.tag_airlock_mech_sensor : "[id_tag]_airlock_mech"
		tag_shuttle_mech_sensor = controller.tag_shuttle_mech_sensor? controller.tag_shuttle_mech_sensor : "[id_tag]_shuttle_mech"
		tag_air_alarm = controller.tag_air_alarm || "[id_tag]_alarm"
		memory["secure"] = controller.tag_secure

		spawn(10)
			signalDoor(tag_exterior_door, "update")		//signals connected doors to update their status
			signalDoor(tag_interior_door, "update")

/datum/computer/file/embedded_program/airlock/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]
	if(!receive_tag) return

	if(receive_tag==tag_chamber_sensor)
		if(signal.data["pressure"])
			memory["chamber_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_exterior_sensor)
		memory["external_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_interior_sensor)
		memory["internal_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_exterior_door)
		memory["exterior_status"]["state"] = signal.data["door_status"]
		memory["exterior_status"]["lock"] = signal.data["lock_status"]

	else if(receive_tag==tag_interior_door)
		memory["interior_status"]["state"] = signal.data["door_status"]
		memory["interior_status"]["lock"] = signal.data["lock_status"]

	else if(receive_tag==tag_airpump || receive_tag==tag_pump_out_internal)
		if(signal.data["power"])
			memory["pump_status"] = signal.data["direction"]
		else
			memory["pump_status"] = "off"

	else if(receive_tag==id_tag)
		if(istype(master, /obj/machinery/embedded_controller/radio/airlock/access_controller))
			switch(signal.data["command"])
				if("cycle_exterior")
					receive_user_command("cycle_ext_door")
				if("cycle_interior")
					receive_user_command("cycle_int_door")
				if("cycle")
					if(memory["interior_status"]["state"] == "open")		//handle backwards compatibility
						receive_user_command("cycle_ext")
					else
						receive_user_command("cycle_int")
		else
			switch(signal.data["command"])
				if("cycle_exterior")
					receive_user_command("cycle_ext")
				if("cycle_interior")
					receive_user_command("cycle_int")
				if("cycle")
					if(memory["interior_status"]["state"] == "open")		//handle backwards compatibility
						receive_user_command("cycle_ext")
					else
						receive_user_command("cycle_int")


/datum/computer/file/embedded_program/airlock/receive_user_command(command)
	var/shutdown_pump = 0
	. = TRUE
	switch(command)
		if("cycle_ext")
			//If airlock is already cycled in this direction, just toggle the doors.
			if(!memory["purge"] && IsInRange(memory["external_sensor_pressure"], memory["chamber_sensor_pressure"] - SENSOR_TOLERANCE, memory["chamber_sensor_pressure"] + SENSOR_TOLERANCE))
				toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "toggle")
			//only respond to these commands if the airlock isn't already doing something
			//prevents the controller from getting confused and doing strange things
			else if(state == target_state)
				begin_cycle_out()

		if("cycle_int")
			if(!memory["purge"] && IsInRange(memory["internal_sensor_pressure"], memory["chamber_sensor_pressure"] - SENSOR_TOLERANCE, memory["chamber_sensor_pressure"] + SENSOR_TOLERANCE))
				toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "toggle")
			else if(state == target_state)
				begin_cycle_in()

		if("cycle_ext_door")
			cycleDoors(TARGET_OUTOPEN)

		if("cycle_int_door")
			cycleDoors(TARGET_INOPEN)

		if("abort")
			stop_cycling()

		if("force_ext")
			toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "toggle")

		if("force_int")
			toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "toggle")

		if("purge")
			memory["purge"] = !memory["purge"]
			if(memory["purge"])
				close_doors()
				state = STATE_PREPARE
				target_state = TARGET_NONE

		if("secure")
			memory["secure"] = !memory["secure"]
			if(memory["secure"])
				signalDoor(tag_interior_door, "lock")
				signalDoor(tag_exterior_door, "lock")
			else
				signalDoor(tag_interior_door, "unlock")
				signalDoor(tag_exterior_door, "unlock")
		else
			. = FALSE

	if(shutdown_pump)
		signalPump(tag_airpump, 0)		//send a signal to stop pressurizing
		if(cycle_to_external_air)
			signalPump(tag_pump_out_internal, 0)
			signalPump(tag_pump_out_external, 0)



/datum/computer/file/embedded_program/airlock/process()
	if(!state) //Idle
		if(target_state)
			switch(target_state)
				if(TARGET_INOPEN)
					memory["target_pressure"] = memory["internal_sensor_pressure"]
				if(TARGET_OUTOPEN)
					memory["target_pressure"] = memory["external_sensor_pressure"]

			//lock down the airlock before activating pumps
			close_doors()

			state = STATE_PREPARE
		else
			//make sure to return to a sane idle state
			if(memory["pump_status"] != "off")	//send a signal to stop pumping
				signalPump(tag_airpump, 0)
				if(cycle_to_external_air)
					signalPump(tag_pump_out_internal, 0)
					signalPump(tag_pump_out_external, 0)

	if ((state == STATE_PRESSURIZE || state == STATE_DEPRESSURIZE) && !check_doors_secured())
		//the airlock will not allow itself to continue to cycle when any of the doors are forced open.
		stop_cycling()

	switch(state)
		if(STATE_PREPARE)
			if (check_doors_secured())
				var/chamber_pressure = memory["chamber_sensor_pressure"]
				var/target_pressure = memory["target_pressure"]

				if(memory["purge"])
					//purge apparently means clearing the airlock chamber to vacuum (then refilling, handled later)
					target_pressure = 0
					state = STATE_DEPRESSURIZE
					if(!cycle_to_external_air || target_state == TARGET_OUTOPEN) // if going outside, pump internal air into air tank
						signalPump(tag_airpump, 1, 0, target_pressure)	//send a signal to start depressurizing
					else
						signalPump(tag_pump_out_internal, 1, 0, target_pressure) // if going inside, pump external air out of the airlock
						signalPump(tag_pump_out_external, 1, 1, 1000) // make sure the air is actually going outside

				else if(chamber_pressure <= target_pressure)
					state = STATE_PRESSURIZE
					if(!cycle_to_external_air || target_state == TARGET_INOPEN) // if going inside, pump air into airlock
						signalPump(tag_airpump, 1, 1, target_pressure)	//send a signal to start pressurizing
					else
						signalPump(tag_pump_out_internal, 1, 1, target_pressure) // if going outside, fill airlock with external air
						signalPump(tag_pump_out_external, 1, 0, 0)

				else if(chamber_pressure > target_pressure)
					if(!cycle_to_external_air)
						state = STATE_DEPRESSURIZE
						signalPump(tag_airpump, 1, 0, target_pressure)	//send a signal to start depressurizing
					else
						memory["purge"] = 1 // should always purge first if using external air, chamber pressure should never be higher than target pressure here

				memory["target_pressure"] = target_pressure

		if(STATE_PRESSURIZE)
			if(memory["chamber_sensor_pressure"] >= memory["target_pressure"] - SENSOR_TOLERANCE)
				//not done until the pump has reported that it's off
				if(memory["pump_status"] != "off") //send a signal to stop pumping
					signalPump(tag_airpump, 0)
					if(cycle_to_external_air)
						signalPump(tag_pump_out_internal, 0)
						signalPump(tag_pump_out_external, 0)
				else
					cycleDoors(target_state)
					state = STATE_IDLE
					target_state = TARGET_NONE


		if(STATE_DEPRESSURIZE)
			if(memory["chamber_sensor_pressure"] <= memory["target_pressure"] + SENSOR_TOLERANCE)
				if(memory["pump_status"] != "off")
					signalPump(tag_airpump, 0)
					if(cycle_to_external_air)
						signalPump(tag_pump_out_internal, 0)
						signalPump(tag_pump_out_external, 0)
				else
					if(memory["purge"])
						memory["purge"] = 0
						memory["target_pressure"] = (target_state == TARGET_INOPEN ? memory["internal_sensor_pressure"] : memory["external_sensor_pressure"])
						if (memory["target_pressure"] > SENSOR_TOLERANCE)
							state = STATE_PREPARE
					else
						cycleDoors(target_state)
						state = STATE_IDLE
						target_state = TARGET_NONE


	memory["processing"] = (state != target_state)

	return 1

//these are here so that other types don't have to make so many assuptions about our implementation

/datum/computer/file/embedded_program/airlock/proc/begin_cycle_in()
	state = STATE_IDLE
	target_state = TARGET_INOPEN
	memory["purge"] = cycle_to_external_air
	playsound(master, 'sound/machines/warning-buzzer.ogg', 50)
	shutAlarm()

/datum/computer/file/embedded_program/airlock/proc/begin_dock_cycle()
	state = STATE_IDLE
	target_state = TARGET_INOPEN
	playsound(master, 'sound/machines/warning-buzzer.ogg', 50)
	shutAlarm()

/datum/computer/file/embedded_program/airlock/proc/begin_cycle_out()
	state = STATE_IDLE
	target_state = TARGET_OUTOPEN
	memory["purge"] = cycle_to_external_air
	playsound(master, 'sound/machines/warning-buzzer.ogg', 50)
	shutAlarm()

/datum/computer/file/embedded_program/airlock/proc/close_doors()
	toggleDoor(memory["interior_status"], tag_interior_door, 1, "close")
	toggleDoor(memory["exterior_status"], tag_exterior_door, 1, "close")

/datum/computer/file/embedded_program/airlock/proc/stop_cycling()
	state = STATE_IDLE
	target_state = TARGET_NONE

/datum/computer/file/embedded_program/airlock/proc/done_cycling()
	return (state == STATE_IDLE && target_state == TARGET_NONE)

//are the doors closed and locked?
/datum/computer/file/embedded_program/airlock/proc/check_exterior_door_secured()
	return (memory["exterior_status"]["state"] == "closed" &&  memory["exterior_status"]["lock"] == "locked")

/datum/computer/file/embedded_program/airlock/proc/check_interior_door_secured()
	return (memory["interior_status"]["state"] == "closed" &&  memory["interior_status"]["lock"] == "locked")

/datum/computer/file/embedded_program/airlock/proc/check_doors_secured()
	var/ext_closed = check_exterior_door_secured()
	var/int_closed = check_interior_door_secured()
	return (ext_closed && int_closed)

/datum/computer/file/embedded_program/airlock/proc/signalDoor(var/tag, var/command)
	var/datum/signal/signal = new
	signal.data["tag"] = tag
	signal.data["command"] = command
	post_signal(signal, RADIO_AIRLOCK)

/datum/computer/file/embedded_program/airlock/proc/shutAlarm()
	var/datum/signal/signal = new
	signal.data["alarm_id"] = tag_air_alarm
	signal.data["command"] = "shutdown"
	post_signal(signal, RADIO_TO_AIRALARM)

/datum/computer/file/embedded_program/airlock/proc/signalPump(var/tag, var/power, var/direction, var/pressure)
	var/datum/signal/signal = new
	signal.data = list(
		"tag" = tag,
		"sigtype" = "command",
		"set_power" = power,
		"set_direction" = direction ? "release" : "siphon",
		"set_external_pressure" = pressure,
		"status" = TRUE
	)
	post_signal(signal, RADIO_FROM_AIRALARM)

//this is called to set the appropriate door state at the end of a cycling process, or for the exterior buttons
/datum/computer/file/embedded_program/airlock/proc/cycleDoors(var/target)
	switch(target)
		if(TARGET_OUTOPEN)
			toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "close")
			toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "open")

		if(TARGET_INOPEN)
			toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "close")
			toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "open")
		if(TARGET_NONE)
			var/command = "unlock"
			if(memory["secure"])
				command = "lock"
			signalDoor(tag_exterior_door, command)
			signalDoor(tag_interior_door, command)

datum/computer/file/embedded_program/airlock/proc/signal_mech_sensor(var/command, var/sensor)
	var/datum/signal/signal = new
	signal.data["tag"] = sensor
	signal.data["command"] = command
	post_signal(signal)

/datum/computer/file/embedded_program/airlock/proc/enable_mech_regulation()
	signal_mech_sensor("enable", tag_shuttle_mech_sensor)
	signal_mech_sensor("enable", tag_airlock_mech_sensor)

/datum/computer/file/embedded_program/airlock/proc/disable_mech_regulation()
	signal_mech_sensor("disable", tag_shuttle_mech_sensor)
	signal_mech_sensor("disable", tag_airlock_mech_sensor)

/*----------------------------------------------------------
toggleDoor()

Sends a radio command to a door to either open or close. If
the command is 'toggle' the door will be sent a command that
reverses it's current state.
Can also toggle whether the door bolts are locked or not,
depending on the state of the 'secure' flag.
Only sends a command if it is needed, i.e. if the door is
already open, passing an open command to this proc will not
send an additional command to open the door again.
----------------------------------------------------------*/
/datum/computer/file/embedded_program/airlock/proc/toggleDoor(var/list/doorStatus, var/doorTag, var/secure, var/command)
	var/doorCommand = null

	if(command == "toggle")
		if(doorStatus["state"] == "open")
			command = "close"
		else if(doorStatus["state"] == "closed")
			command = "open"

	switch(command)
		if("close")
			if(secure)
				if(doorStatus["state"] == "open")
					doorCommand = "secure_close"
				else if(doorStatus["lock"] == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus["state"] == "open")
					if(doorStatus["lock"] == "locked")
						signalDoor(doorTag, "unlock")
					doorCommand = "close"
				else if(doorStatus["lock"] == "locked")
					doorCommand = "unlock"

		if("open")
			if(secure)
				if(doorStatus["state"] == "closed")
					doorCommand = "secure_open"
				else if(doorStatus["lock"] == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus["state"] == "closed")
					if(doorStatus["lock"] == "locked")
						signalDoor(doorTag,"unlock")
					doorCommand = "open"
				else if(doorStatus["lock"] == "locked")
					doorCommand = "unlock"

	if(doorCommand)
		signalDoor(doorTag, doorCommand)


#undef STATE_IDLE
#undef STATE_DEPRESSURIZE
#undef STATE_PRESSURIZE

#undef TARGET_NONE
#undef TARGET_INOPEN
#undef TARGET_OUTOPEN

#undef SENSOR_TOLERANCE