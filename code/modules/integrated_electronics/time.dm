/obj/item/integrated_circuit/time
	name = "time circuit"
	desc = "Now you can build your own clock!"
	complexity = 2
	number_of_inputs = 0
	number_of_outputs = 0

/obj/item/integrated_circuit/time/delay
	name = "two-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of two seconds."
	icon_state = "delay-20"
	number_of_activators = 2
	var/delay = 20
	activator_names = list(
		"incoming pulse",
		"outgoing pulse"
		)

/obj/item/integrated_circuit/time/delay/work()
	if(..())
		var/datum/integrated_io/out_pulse = activators[2]
		sleep(delay)
		out_pulse.push_data()

/obj/item/integrated_circuit/time/delay/five_sec
	name = "five-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of five seconds."
	icon_state = "delay-50"
	delay = 50

/obj/item/integrated_circuit/time/delay/one_sec
	name = "one-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of one second."
	icon_state = "delay-10"
	delay = 10

/obj/item/integrated_circuit/time/delay/half_sec
	name = "half-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of half a second."
	icon_state = "delay-5"
	delay = 5

/obj/item/integrated_circuit/time/delay/tenth_sec
	name = "tenth-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of 1/10th of a second."
	icon_state = "delay-1"
	delay = 1

/obj/item/integrated_circuit/time/delay/custom
	name = "custom delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit's delay can be customized, between 1/10th of a second to one hour.  The delay is updated upon receiving a pulse."
	icon_state = "delay"
	number_of_inputs = 1
	input_names = list(
		"delay time",
		)

/obj/item/integrated_circuit/time/delay/custom/work()
	var/datum/integrated_io/delay_input = inputs[1]
	if(delay_input.data && isnum(delay_input.data) )
		var/new_delay = min(delay_input.data, 1)
		new_delay = max(new_delay, 36000) //An hour.
		delay = new_delay

	..()

/obj/item/integrated_circuit/time/ticker
	name = "ticker circuit"
	desc = "This circuit sends an automatic pulse every four seconds."
	icon_state = "tick-m"
	complexity = 8
	number_of_inputs = 1
	number_of_activators = 1
	var/ticks_to_pulse = 2
	var/ticks_completed = 0
	input_names = list(
		"toggle ticking"
		)
	activator_names = list(
		"outgoing pulse"
		)

/obj/item/integrated_circuit/time/ticker/New()
	..()
	processing_objects |= src

/obj/item/integrated_circuit/time/ticker/Destroy()
	processing_objects -= src

/obj/item/integrated_circuit/time/ticker/process()
	ticks_completed++
	if( (ticks_completed % ticks_to_pulse) == 0)
		var/datum/integrated_io/pulser = activators[1]
		pulser.push_data()

/obj/item/integrated_circuit/time/ticker/fast
	name = "fast ticker"
	desc = "This advanced circuit sends an automatic pulse every two seconds."
	icon_state = "tick-f"
	complexity = 12
	ticks_to_pulse = 1

/obj/item/integrated_circuit/time/ticker/slow
	name = "slow ticker"
	desc = "This simple circuit sends an automatic pulse every six seconds."
	icon_state = "tick-s"
	complexity = 4
	ticks_to_pulse = 3


/obj/item/integrated_circuit/time/clock
	name = "integrated clock"
	desc = "Tells you what the local time is, specific to your station or planet."
	icon_state = "clock"
	number_of_inputs = 0
	number_of_outputs = 4
	number_of_activators = 1
	output_names = list(
		"time (string)",
		"hours (number)",
		"minutes (number)",
		"seconds (number)"
		)

/obj/item/integrated_circuit/time/clock/work()
	if(..())
		var/datum/integrated_io/time = outputs[1]
		var/datum/integrated_io/hour = outputs[2]
		var/datum/integrated_io/min = outputs[3]
		var/datum/integrated_io/sec = outputs[4]

		time.data = time2text(station_time_in_ticks, "hh:mm:ss")
		hour.data = text2num(time2text(station_time_in_ticks, "hh"))
		min.data = text2num(time2text(station_time_in_ticks, "mm"))
		sec.data = text2num(time2text(station_time_in_ticks, "ss"))

		for(var/datum/integrated_io/output/O in outputs)
			O.push_data()