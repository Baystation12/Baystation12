	//////////
	//TCOMMS//
	//////////

/obj/machinery/telecomms/hub/presetsent
	id = "Patrol Hub"
	network = "senttcommsat"
	autolinkers = list("sentHub", "sentrelay", "albrelay", "senttroops", "sentmedical", "sentcommon", "sentcommand",
	 "receiverSent", "broadcasterSent")

/obj/machinery/telecomms/relay/preset/sent
	id = "Patrol Relay"
	network = "senttcommsat"
	autolinkers = list("sentrelay")

/obj/machinery/telecomms/relay/preset/sentalb
	id = "Albatross Relay"
	network = "senttcommsat"
	autolinkers = list("albrelay")

/obj/machinery/telecomms/receiver/preset_sent
	id = "Patrol Receiver"
	network = "senttcommsat"
	autolinkers = list("receiverSent")
	freq_listening = list(ERT_FREQ, MED_FREQ, COMM_FREQ, PUB_FREQ)

/obj/machinery/telecomms/bus/preset_sent1
	id = "Patrol Bus 1"
	network = "senttcommsat"
	freq_listening = list(ERT_FREQ, COMM_FREQ)
	autolinkers = list("processorsent1", "senttroops", "sentcommand")

/obj/machinery/telecomms/bus/preset_sent2
	id = "Patrol Bus 2"
	network = "senttcommsat"
	freq_listening = list(MED_FREQ, PUB_FREQ)
	autolinkers = list("processorsent2", "sentmedical", "sentcommon")

/obj/machinery/telecomms/bus/preset_sent2/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == PUB_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/processor/preset_sent1
	id = "Patrol Processor 1"
	network = "senttcommsat"
	autolinkers = list("processorsent1")

/obj/machinery/telecomms/processor/preset_sent2
	id = "Patrol Processor 2"
	network = "senttcommsat"
	autolinkers = list("processorsent2")

/obj/machinery/telecomms/broadcaster/preset_sent
	id = "Patrol Broadcaster"
	network = "senttcommsat"
	autolinkers = list("broadcasterSent")

/obj/machinery/telecomms/server/presets/sentinel/common
	id = "Patrol Common Server"
	freq_listening = list(PUB_FREQ) // AI Private and Common
	network = "senttcommsat"
	autolinkers = list("sentcommon")

/obj/machinery/telecomms/server/presets/sentinel/command
	id = "Patrol Command Server"
	freq_listening = list(COMM_FREQ)
	network = "senttcommsat"
	autolinkers = list("sentcommand")

/obj/machinery/telecomms/server/presets/sentinel/troops
	id = "Patrol Troops Server"
	freq_listening = list(ERT_FREQ)
	network = "senttcommsat"
	autolinkers = list("senttroops")

/obj/machinery/telecomms/server/presets/sentinel/medical
	id = "Patrol Medical Server"
	freq_listening = list(MED_FREQ)
	network = "senttcommsat"
	autolinkers = list("sentmedical")

		////////
		//SMES//
		////////

/obj/machinery/power/smes/buildable/preset/patrol/engine_main
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil/super_capacity = 1,
									/obj/item/stock_parts/smes_coil = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/machinery/power/smes/buildable/preset/patrol/engine_gyrotron
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil = 1,
									/obj/item/stock_parts/smes_coil/super_io = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/machinery/power/smes/buildable/preset/patrol/shuttle
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/machinery/power/smes/buildable/preset/patrol/laser
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil = 1,
									/obj/item/stock_parts/smes_coil = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE
