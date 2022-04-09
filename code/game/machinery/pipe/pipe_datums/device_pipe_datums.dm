/datum/pipe/pipe_dispenser/device
	category = "Devices"
	colorable = FALSE
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_WHITE

/datum/pipe/pipe_dispenser/device/universaladapter
	name = "universal pipe adapter"
	desc = "an adapter designed to fit any type of pipe."
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_HE
	build_icon_state = "universal"
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/universal
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/device/connector
	name = "connector"
	desc = "a connector for canisters."
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "connector"
	constructed_path = /obj/machinery/atmospherics/portables_connector
	pipe_class = PIPE_CLASS_UNARY

/datum/pipe/pipe_dispenser/device/unaryvent
	name = "unary vent"
	desc = "a unary vent"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL
	build_icon_state = "uvent"
	constructed_path = /obj/machinery/atmospherics/unary/vent_pump
	pipe_class = PIPE_CLASS_UNARY

/datum/pipe/pipe_dispenser/device/unaryvent/large
	name = "high volume unary vent"
	desc = "a high volume unary vent"
	constructed_path = /obj/machinery/atmospherics/unary/vent_pump/high_volume

/datum/pipe/pipe_dispenser/device/gaspump
	name = "gas pump"
	desc = "a pump. For gasses."
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "pump"
	constructed_path = /obj/machinery/atmospherics/binary/pump
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/device/pressureregulator
	name = "pressure regulator"
	desc = "a device that regulates pressure."
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "passivegate"
	constructed_path = /obj/machinery/atmospherics/binary/passive_gate
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/device/hpgaspump
	name = "high powered gas pump"
	desc = "a high powered pump. For gasses."
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "volumepump"
	constructed_path = /obj/machinery/atmospherics/binary/pump/high_power
	pipe_class = PIPE_CLASS_BINARY

/datum/pipe/pipe_dispenser/device/scrubber
	name = "scrubber"
	desc = "scrubs out undesirable gasses"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER
	build_icon_state = "scrubber"
	constructed_path = /obj/machinery/atmospherics/unary/vent_scrubber
	pipe_class = PIPE_CLASS_UNARY

/datum/pipe/pipe_dispenser/device/meter
	name = "meter"
	desc = "a meter that monitors pressure and temperature on the attached pipe."
	build_path = /obj/item/machine_chassis/pipe_meter
	pipe_color = null
	connect_types = null
	colorable = FALSE
	build_icon_state = "meter"
	constructed_path = /obj/machinery/meter
	pipe_class = PIPE_CLASS_OTHER

/datum/pipe/pipe_dispenser/device/omnimixer
	name = "omni gas mixer"
	desc = "a device that takes in two or three gasses and mixes them into a precise output."
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "omni_mixer"
	constructed_path = /obj/machinery/atmospherics/omni/mixer
	pipe_class = PIPE_CLASS_OMNI

/datum/pipe/pipe_dispenser/device/omnifilter
	name = "omni gas filter"
	desc = "a device that filters out undesireable elements"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "omni_filter"
	constructed_path = /obj/machinery/atmospherics/omni/filter
	pipe_class = PIPE_CLASS_OMNI

/datum/pipe/pipe_dispenser/device/manualvalve
	name = "manual valve"
	desc = "a valve that has to be manipulated by hand"
	build_path = /obj/item/pipe
	build_icon_state = "mvalve"
	constructed_path = /obj/machinery/atmospherics/valve
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/device/digitalvalve
	name = "digital valve"
	desc = "a valve controlled electronically"
	build_path = /obj/item/pipe
	build_icon_state = "dvalve"
	constructed_path = /obj/machinery/atmospherics/valve/digital
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR

/datum/pipe/pipe_dispenser/device/mtvalve
	name = "manual t-valve"
	desc = "a three-way valve. T-shaped."
	build_path = /obj/item/pipe
	build_icon_state = "mtvalve"
	constructed_path = /obj/machinery/atmospherics/tvalve
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/device/mtvalvem
	name = "manual t-valve (mirrored)"
	desc = "a three-way valve. T-shaped."
	build_path = /obj/item/pipe
	build_icon_state = "mtvalvem"
	constructed_path = /obj/machinery/atmospherics/tvalve/mirrored
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/device/dtvalve
	name = "digital t-valve"
	desc = "a three-way valve. T-shaped. This one can be controlled electronically."
	build_path = /obj/item/pipe
	build_icon = 'icons/atmos/digital_tvalve.dmi'
	build_icon_state = "map_tvalve0"
	constructed_path = /obj/machinery/atmospherics/tvalve/digital
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/device/dtvalvem
	name = "digital t-valve (mirrored)"
	desc = "a three-way valve. T-shaped. This one can be controlled electronically."
	build_path = /obj/item/pipe
	build_icon = 'icons/atmos/digital_tvalve.dmi'
	build_icon_state = "map_tvalvem0"
	constructed_path = /obj/machinery/atmospherics/tvalve/mirrored/digital
	pipe_class = PIPE_CLASS_TRINARY

/datum/pipe/pipe_dispenser/device/air_sensor
	name = "gas sensor"
	desc = "a sensor. It detects gasses."
	build_path = /obj/item/machine_chassis/air_sensor
	build_icon_state = "gsensor1"
	build_icon = 'icons/obj/stationobjs.dmi'
	pipe_color = null
	connect_types = null
	colorable = FALSE
	constructed_path = /obj/machinery/air_sensor
	pipe_class = PIPE_CLASS_OTHER

/datum/pipe/pipe_dispenser/device/outlet_injector
	name = "injector"
	desc = "Passively injects gas into its surroundings. Has a valve attached to it that can control flow rate."
	build_icon = 'icons/atmos/injector.dmi'
	build_icon_state = "map_injector"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	colorable = FALSE
	pipe_color = null
	constructed_path = /obj/machinery/atmospherics/unary/outlet_injector
	pipe_class = PIPE_CLASS_UNARY

/datum/pipe/pipe_dispenser/device/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	build_icon = 'icons/obj/drain.dmi'
	build_icon_state = "drain"
	build_path = /obj/item/drain
	connect_types = null
	colorable = FALSE
	pipe_color = null
	constructed_path = /obj/structure/hygiene/drain
	pipe_class = PIPE_CLASS_OTHER

/datum/pipe/pipe_dispenser/device/drain/bath
	name = "sealable gutter"
	desc = "You probably can't get sucked down the plughole. Specially not when it's closed!"
	build_icon = 'icons/obj/drain.dmi'
	build_icon_state = "drain_bath"
	build_path = /obj/item/drain/bath
	connect_types = null
	colorable = FALSE
	pipe_color = null
	constructed_path = /obj/structure/hygiene/drain/bath
	pipe_class = PIPE_CLASS_OTHER

/datum/pipe/pipe_dispenser/device/tank
	name = "pressure tank"
	desc = "A large vessel containing pressurized gas."
	build_icon = 'icons/atmos/tank.dmi'
	build_icon_state = "air"
	build_path = /obj/item/pipe/tank
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/unary/tank
	pipe_class = PIPE_CLASS_UNARY
	colorable = TRUE

/datum/pipe/pipe_dispenser/device/pipesparker
	name = "pipe sparker"
	desc = "A pipe sparker. Useful for starting pipe fires."
	build_icon = 'icons/atmos/pipe-sparker.dmi'
	build_icon_state = "pipe-igniter"
	build_path = /obj/item/pipe
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/cap/sparker/visible
	pipe_class = PIPE_CLASS_UNARY
	pipe_color = null
	colorable = FALSE