// ### Preset machines  ###

//HUB

/obj/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "relay", "c_relay", "s_relay", "m_relay", "r_relay", "b_relay", "1_relay", "2_relay", "3_relay", "4_relay", "5_relay", "s_relay", "science", "medical",
	"supply", "service", "common", "command", "engineering", "security", "unused",
	"receiverA", "broadcasterA")

/obj/machinery/telecomms/hub/preset_cent
	id = "CentComm Hub"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("hub_cent", "c_relay", "s_relay", "m_relay", "r_relay",
	 "centcomm", "receiverCent", "broadcasterCent")

//Receivers

/obj/machinery/telecomms/receiver/preset_right
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ)

	//Common and other radio frequencies for people to freely use
	New()
		for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
			freq_listening |= i
		..()

/obj/machinery/telecomms/receiver/preset_cent
	id = "CentComm Receiver"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("receiverCent")
	freq_listening = list(ERT_FREQ, DTH_FREQ)


//Buses

/obj/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ)
	autolinkers = list("processor1", "science", "medical")

/obj/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(SUP_FREQ, SRV_FREQ)
	autolinkers = list("processor2", "supply", "service", "unused")

/obj/machinery/telecomms/bus/preset_two/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == AI_FREQ || i == PUB_FREQ || i == MED_I_FREQ || i == SEC_I_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(SEC_FREQ, COMM_FREQ)
	autolinkers = list("processor3", "security", "command")

/obj/machinery/telecomms/bus/preset_four
	id = "Bus 4"
	network = "tcommsat"
	freq_listening = list(ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ, MED_I_FREQ, SEC_I_FREQ)
	autolinkers = list("processor4", "engineering", "common")

/obj/machinery/telecomms/bus/preset_cent
	id = "CentComm Bus"
	network = "tcommsat"
	freq_listening = list(ERT_FREQ, DTH_FREQ, ENT_FREQ)
	produces_heat = 0
	autolinkers = list("processorCent", "centcomm")

//Processors

/obj/machinery/telecomms/processor/preset_one
	id = "Processor 1"
	network = "tcommsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

/obj/machinery/telecomms/processor/preset_two
	id = "Processor 2"
	network = "tcommsat"
	autolinkers = list("processor2")

/obj/machinery/telecomms/processor/preset_three
	id = "Processor 3"
	network = "tcommsat"
	autolinkers = list("processor3")

/obj/machinery/telecomms/processor/preset_four
	id = "Processor 4"
	network = "tcommsat"
	autolinkers = list("processor4")

/obj/machinery/telecomms/processor/preset_cent
	id = "CentComm Processor"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("processorCent")

//Servers

/obj/machinery/telecomms/server/presets

	network = "tcommsat"

/obj/machinery/telecomms/server/presets/science
	id = "Science Server"
	freq_listening = list(SCI_FREQ)
	channel_tags = list(list(SCI_FREQ, "Science", COMMS_COLOR_SCIENCE))
	autolinkers = list("science")

/obj/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(MED_FREQ)
	channel_tags = list(list(MED_FREQ, "Medical", COMMS_COLOR_MEDICAL))
	autolinkers = list("medical")

/obj/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(SUP_FREQ)
	channel_tags = list(list(SUP_FREQ, "Supply", COMMS_COLOR_SUPPLY))
	autolinkers = list("supply")

/obj/machinery/telecomms/server/presets/service
	id = "Service Server"
	freq_listening = list(SRV_FREQ)
	channel_tags = list(list(SRV_FREQ, "Service", COMMS_COLOR_SERVICE))
	autolinkers = list("service")

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list(PUB_FREQ, AI_FREQ, ENT_FREQ, MED_I_FREQ, SEC_I_FREQ) // AI Private, Common, and Departmental Intercomms
	channel_tags = list(
		list(PUB_FREQ, "Common", COMMS_COLOR_COMMON),
		list(AI_FREQ, "AI Private", COMMS_COLOR_AI),
		list(ENT_FREQ, "Entertainment", COMMS_COLOR_ENTERTAIN),
		list(MED_I_FREQ, "Medical (I)", COMMS_COLOR_MEDICAL_I),
		list(SEC_I_FREQ, "Security (I)", COMMS_COLOR_SECURITY_I)
	)
	autolinkers = list("common")

// "Unused" channels, AKA all others.
/obj/machinery/telecomms/server/presets/unused
	id = "Unused Server"
	freq_listening = list()
	autolinkers = list("unused")

/obj/machinery/telecomms/server/presets/unused/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == AI_FREQ || i == PUB_FREQ || i == MED_I_FREQ || i == SEC_I_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(COMM_FREQ)
	channel_tags = list(list(COMM_FREQ, "Command", COMMS_COLOR_COMMAND))
	autolinkers = list("command")

/obj/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(ENG_FREQ)
	channel_tags = list(list(ENG_FREQ, "Engineering", COMMS_COLOR_ENGINEER))
	autolinkers = list("engineering")

/obj/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(SEC_FREQ)
	channel_tags = list(list(SEC_FREQ, "Security", COMMS_COLOR_SECURITY))
	autolinkers = list("security")

/obj/machinery/telecomms/server/presets/centcomm
	id = "CentComm Server"
	freq_listening = list(ERT_FREQ, DTH_FREQ)
	channel_tags = list(list(ERT_FREQ, "Response Team", COMMS_COLOR_CENTCOMM), list(DTH_FREQ, "Special Ops", COMMS_COLOR_SYNDICATE))
	produces_heat = 0
	autolinkers = list("centcomm")


//Broadcasters

//--PRESET LEFT--//

/obj/machinery/telecomms/broadcaster/preset_right
	id = "Broadcaster A"
	network = "tcommsat"
	autolinkers = list("broadcasterA")

/obj/machinery/telecomms/broadcaster/preset_cent
	id = "CentComm Broadcaster"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("broadcasterCent")
