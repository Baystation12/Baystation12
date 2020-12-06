/obj/machinery/embedded_controller
	name = "Embedded Controller"
	anchored = 1
	idle_power_usage = 10
	var/datum/computer/file/embedded_program/program	//the currently executing program
	var/id_tag
	var/on = 1

/obj/machinery/embedded_controller/Initialize()
	if(program)
		program = new program(src)
	return ..()

/obj/machinery/embedded_controller/Destroy()
	if(istype(program))
		qdel(program) // the program will clear the ref in its Destroy
	return ..()

/obj/machinery/embedded_controller/proc/post_signal(datum/signal/signal, comm_line)
	return 0

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal || signal.encryption) return

	if(program)
		program.receive_signal(signal, receive_method, receive_param)
			//spawn(5) program.process() //no, program.process sends some signals and machines respond and we here again and we lag -rastaf0

/obj/machinery/embedded_controller/Topic(href, href_list)
	if(..())
		return
	if(usr)
		usr.set_machine(src)
	if(program)
		return program.receive_user_command(href_list["command"]) // Any further sanitization should be done in here.

/obj/machinery/embedded_controller/Process()
	if(program)
		program.process()

	update_icon()

/obj/machinery/embedded_controller/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/embedded_controller/attack_hand(mob/user as mob)
	if(!user.IsAdvancedToolUser())
		return 0
	ui_interact(user)

/obj/machinery/embedded_controller/radio
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	power_channel = ENVIRON
	density = 0
	unacidable = 1
	var/frequency = 1379
	var/radio_filter = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/embedded_controller/radio/Initialize()
	set_frequency(frequency)
	. = ..()

obj/machinery/embedded_controller/radio/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	..()

/obj/machinery/embedded_controller/radio/on_update_icon()
	if(!on || !program)
		icon_state = "airlock_control_off"
	else if(program.memory["processing"])
		icon_state = "airlock_control_process"
	else
		icon_state = "airlock_control_standby"

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal, var/radio_filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, radio_filter)
	else
		qdel(signal)

/obj/machinery/embedded_controller/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, radio_filter)