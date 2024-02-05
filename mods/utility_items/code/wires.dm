// Multitool wires solving function - Just too big

// Wire solve functions

/datum/wires/proc/name_by_type()
	var/name_by_type
	if(istype(src, /datum/wires/airlock))
		name_by_type = "Airlock"
	if(istype(src, /datum/wires/apc))
		name_by_type = "APC"
	if(istype(src, /datum/wires/robot))
		name_by_type = "Cyborg"
	if(istype(src, /datum/wires/fabricator))
		name_by_type = "Autolathe"
	if(istype(src, /datum/wires/alarm))
		name_by_type = "Air Alarm"
	if(istype(src, /datum/wires/camera))
		name_by_type = "Camera"
	if(istype(src, /datum/wires/explosive))
		name_by_type = "C4 Bomb"
	if(istype(src, /datum/wires/nuclearbomb))
		name_by_type = "Nuclear Bomb"
	if(istype(src, /datum/wires/particle_acc))
		name_by_type = "Particle Accelerator"
	if(istype(src, /datum/wires/radio))
		name_by_type = "Radio"
	if(istype(src, /datum/wires/vending))
		name_by_type = "Vending Machine"
	return name_by_type

/datum/wires/proc/SolveWires()
	var/list/unsolved_wires = src.wires.Copy()
	var/colour_function
	var/solved_colour_function

	var/name_by_type = name_by_type()

	var/solved_txt = "[name_by_type] wires:<br>"

	for(var/colour in src.wires)
		if(unsolved_wires[colour]) //unsolved_wires[red]
			colour_function = unsolved_wires[colour] //unsolved_wires[red] = 1 so colour_index = 1
			solved_colour_function = SolveWireFunction(colour_function) //unsolved_wires[red] = 1, 1 = AIRLOCK_WIRE_IDSCAN
			solved_txt += "the [colour] wire connected to [solved_colour_function]<br>" //the red wire is the ID wire

	solved_txt += "<br>"

	return solved_txt

/datum/wires/proc/SolveWireFunction(WireFunction)
	return WireFunction //Default returns the original number, so it still "works"

/datum/wires/airlock/SolveWireFunction(function)
	var/sf = ""
	var/obj/machinery/door/airlock/AIRL = holder
	switch(function)
		if(AIRLOCK_WIRE_IDSCAN)
			sf = "Port A"
		if(AIRLOCK_WIRE_MAIN_POWER1)
			sf = "Port B"
		if(AIRLOCK_WIRE_MAIN_POWER2)
			sf = "Port C"
		if(AIRLOCK_WIRE_DOOR_BOLTS)
			sf = "Port D"
		if(AIRLOCK_WIRE_BACKUP_POWER1)
			sf = "Port E"
		if(AIRLOCK_WIRE_BACKUP_POWER2)
			sf = "Port F"
		if(AIRLOCK_WIRE_OPEN_DOOR)
			sf = "Port G"
		if(AIRLOCK_WIRE_AI_CONTROL)
			sf = "Port H (NTNet ID = [AIRL.NTNet_id])"
		if(AIRLOCK_WIRE_ELECTRIFY)
			sf = "Port I"
		if(AIRLOCK_WIRE_SAFETY)
			sf = "Port J"
		if(AIRLOCK_WIRE_SPEED)
			sf = "Port K"
		if(AIRLOCK_WIRE_LIGHT)
			sf = "Port L"

	return sf

/datum/wires/alarm/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(AALARM_WIRE_IDSCAN)
			sf = "Port A"
		if(AALARM_WIRE_POWER)
			sf = "Port B"
		if(AALARM_WIRE_SYPHON)
			sf = "Port C"
		if(AALARM_WIRE_AI_CONTROL)
			sf = "Port D"
		if(AALARM_WIRE_AALARM)
			sf = "Port E"

	return sf

/datum/wires/apc/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(APC_WIRE_IDSCAN)
			sf = "Port A"
		if(APC_WIRE_MAIN_POWER1)
			sf = "Port B"
		if(APC_WIRE_MAIN_POWER2)
			sf = "Port C"
		if(APC_WIRE_AI_CONTROL)
			sf = "Port D"

	return sf

/datum/wires/camera/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(CAMERA_WIRE_FOCUS)
			sf = "Port A"
		if(CAMERA_WIRE_POWER)
			sf = "Port B"
		if(CAMERA_WIRE_LIGHT)
			sf = "Port C"
		if(CAMERA_WIRE_ALARM)
			sf = "Port D"
		if(CAMERA_WIRE_NOTHING1)
			sf = "Port E"
		if(CAMERA_WIRE_NOTHING2)
			sf = "Port F"

	return sf

/datum/wires/explosive/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(WIRE_EXPLODE)
			sf = "explosive"

	return sf

/datum/wires/nuclearbomb/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(NUCLEARBOMB_WIRE_LIGHT)
			sf = "Port A"
		if(NUCLEARBOMB_WIRE_TIMING)
			sf = "Port B"
		if(NUCLEARBOMB_WIRE_SAFETY)
			sf = "Port C"
	return sf

/datum/wires/particle_acc/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(PARTICLE_TOGGLE_WIRE)
			sf = "Port A"
		if(PARTICLE_STRENGTH_WIRE)
			sf = "Port B"
		if(PARTICLE_INTERFACE_WIRE)
			sf = "Port C"
		if(PARTICLE_LIMIT_POWER_WIRE)
			sf = "Port D"

	return sf

/datum/wires/radio/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(WIRE_SIGNAL)
			sf = "Port A"
		if(WIRE_RECEIVE)
			sf = "Port B"
		if(WIRE_TRANSMIT)
			sf = "Port C"

	return sf

/datum/wires/robot/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(BORG_WIRE_LAWCHECK)
			sf = "Port A"
		if(BORG_WIRE_MAIN_POWER)
			sf = "Port B"
		if(BORG_WIRE_LOCKED_DOWN)
			sf = "Port C"
		if(BORG_WIRE_AI_CONTROL)
			sf = "Port D"

	return sf

/datum/wires/shield_generator/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(SHIELDGEN_WIRE_POWER)
			sf = "Port A"
		if(SHIELDGEN_WIRE_HACK)
			sf = "Port B"
		if(SHIELDGEN_WIRE_CONTROL)
			sf = "Port C"
		if(SHIELDGEN_WIRE_AICONTROL)
			sf = "Port D"
		if(SHIELDGEN_WIRE_NOTHING)
			sf = "Port E"
	return sf

/datum/wires/smartfridge/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(SMARTFRIDGE_WIRE_ELECTRIFY)
			sf = "Port A"
		if(SMARTFRIDGE_WIRE_THROW)
			sf = "Port B"
		if(SMARTFRIDGE_WIRE_IDSCAN)
			sf = "Port C"
	return sf

/datum/wires/smes/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(SMES_WIRE_RCON)
			sf = "Port A"
		if(SMES_WIRE_INPUT)
			sf = "Port B"
		if(SMES_WIRE_OUTPUT)
			sf = "Port C"
		if(SMES_WIRE_GROUNDING)
			sf = "Port D"
		if(SMES_WIRE_FAILSAFES)
			sf = "Port E"
	return sf

/datum/wires/suit_storage_unit/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(SUIT_STORAGE_WIRE_ELECTRIFY)
			sf = "Port A"
		if(SUIT_STORAGE_WIRE_SAFETY)
			sf = "Port B"
		if(SUIT_STORAGE_WIRE_LOCKED)
			sf = "Port C"
	return sf

/datum/wires/vending/SolveWireFunction(function)
	var/sf = ""
	switch(function)
		if(WIRE_THROW_PRODUCTS)
			sf = "A"
		if(WIRE_SHOW_CONTRABAND)
			sf = "B"
		if(WIRE_SHOCK_USERS)
			sf = "C"
		if(WIRE_SCAN_ID)
			sf = "D"

	return sf
