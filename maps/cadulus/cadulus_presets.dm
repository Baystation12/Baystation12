var/const/NETWORK_BRIDGE      = "Bridge"

/datum/map/cadulus/get_network_access(var/network)
	switch(network)
		if(NETWORK_BRIDGE)
			return access_heads
	return get_shared_network_access(network) || ..()

/datum/map/cadulus
	// Networks that will show up as options in the camera monitor program
	station_networks = list(
		NETWORK_BRIDGE,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
	)

//
// Cameras
//

// Networks
/obj/machinery/camera/network/bridge
	network = list(NETWORK_BRIDGE)

// Motion
/obj/machinery/camera/motion/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

// All Upgrades
/obj/machinery/camera/all/command
	network = list(NETWORK_COMMAND)

//
// T-Coms
//
/*
/obj/machinery/telecomms/relay/preset/shuttle
	id = "Charon Relay"
	toggled = 0
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/exploration_shuttle
	id = "Charon Relay"
	toggled = 0
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/aquila
	id = "Aquila Relay"
	toggled = 0
	autolinkers = list("s_relay")
*/
//
// SMES units
//

// Substation SMES
/obj/machinery/power/smes/buildable/preset/cadulus/substation/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil(src)
	component_parts += new /obj/item/weapon/smes_coil(src)
	_input_maxed = TRUE
	_output_maxed = TRUE

// Main Engine output SMES
/obj/machinery/power/smes/buildable/preset/torch/engine_main/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	component_parts += new /obj/item/weapon/smes_coil/super_capacity(src)
	component_parts += new /obj/item/weapon/smes_coil/super_capacity(src)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

var/const/NETWORK_COMMAND = "Command"
var/const/NETWORK_ENGINE  = "Engine"
var/const/NETWORK_ENGINEERING_OUTPOST = "Engineering Outpost"

/datum/map/proc/get_shared_network_access(var/network)
	switch(network)
		if(NETWORK_COMMAND)
			return access_heads
		if(NETWORK_ENGINE, NETWORK_ENGINEERING_OUTPOST)
			return access_engine

/datum/map/torch/default_internal_channels()
	return list(
		num2text(PUB_FREQ)   = list(),
		num2text(AI_FREQ)    = list(access_synth),
		num2text(ENT_FREQ)   = list(),
		num2text(ERT_FREQ)   = list(access_cent_specops),
		num2text(COMM_FREQ)  = list(access_heads),
		num2text(ENG_FREQ)   = list(access_engine_equip, access_atmospherics, access_robotics),
		num2text(MED_FREQ)   = list(access_medical_equip,access_xenobiology,access_tox),
		num2text(MED_I_FREQ) = list(access_medical_equip),
		num2text(SEC_FREQ)   = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security),
		num2text(SUP_FREQ)   = list(access_cargo,access_janitor, access_hydroponics),
	)
