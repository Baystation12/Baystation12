/proc/register_radio(source, old_frequency, new_frequency, radio_filter)
	if(old_frequency)
		radio_controller.remove_object(source, old_frequency)
	if(new_frequency)
		return radio_controller.add_object(source, new_frequency, radio_filter)

/proc/unregister_radio(source, frequency)
	if(radio_controller)
		radio_controller.remove_object(source, frequency)

/proc/get_frequency_name(var/display_freq)
	var/freq_text

	// the name of the channel
	if(display_freq in ANTAG_FREQS)
		freq_text = "#unkn"
	else
		for(var/channel in radiochannels)
			if(radiochannels[channel] == display_freq)
				freq_text = channel
				break

	// --- If the frequency has not been assigned a name, just use the frequency as the name ---
	if(!freq_text)
		freq_text = format_frequency(display_freq)

	return freq_text

/datum/reception
	var/obj/machinery/message_server/message_server = null
	var/telecomms_reception = TELECOMMS_RECEPTION_NONE
	var/message = ""

/datum/receptions
	var/obj/machinery/message_server/message_server = null
	var/sender_reception = TELECOMMS_RECEPTION_NONE
	var/list/receiver_reception = new

/proc/get_message_server(z)
	if(message_servers)
		var/list/zlevels = GLOB.using_map.contact_levels
		if(z)
			zlevels = GetConnectedZlevels(z)
		for (var/obj/machinery/message_server/MS in message_servers)
			if(MS.active && (MS.z in zlevels))
				return MS
	return null

/proc/check_signal(var/datum/signal/signal)
	return signal && signal.data["done"]

/proc/get_sender_reception(var/atom/sender, var/datum/signal/signal)
	return check_signal(signal) ? TELECOMMS_RECEPTION_SENDER : TELECOMMS_RECEPTION_NONE

/proc/get_receiver_reception(var/receiver, var/datum/signal/signal)
	if(receiver && check_signal(signal))
		var/turf/pos = get_turf(receiver)
		if(pos && (pos.z in signal.data["level"]))
			return TELECOMMS_RECEPTION_RECEIVER
	return TELECOMMS_RECEPTION_NONE

/proc/get_reception(var/atom/sender, var/receiver, var/message = "", var/do_sleep = 1)
	var/datum/reception/reception = new

	// check if telecomms I/O route 1459 is stable
	reception.message_server = get_message_server()

	var/datum/signal/signal = sender.telecomms_process(do_sleep)	// Be aware that this proc calls sleep, to simulate transmition delays
	reception.telecomms_reception |= get_sender_reception(sender, signal)
	reception.telecomms_reception |= get_receiver_reception(receiver, signal)
	reception.message = signal && signal.data["compression"] > 0 ? Gibberish(message, signal.data["compression"] + 50) : message

	return reception

/proc/get_receptions(var/atom/sender, var/list/atom/receivers, var/do_sleep = 1)
	var/datum/receptions/receptions = new
	receptions.message_server = get_message_server()

	var/datum/signal/signal
	if(sender)
		signal = sender.telecomms_process(do_sleep)
		receptions.sender_reception = get_sender_reception(sender, signal)

	for(var/atom/receiver in receivers)
		if(!signal)
			signal = receiver.telecomms_process()
		receptions.receiver_reception[receiver] = get_receiver_reception(receiver, signal)

	return receptions
