/datum/wires/inertial_damper
	holder_type = /obj/machinery/inertial_damper
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(DAMPER_WIRE_POWER, "This wire seems to be carrying a heavy current.", SKILL_EXPERT),
		new /datum/wire_description(DAMPER_WIRE_HACK, "This wire seems designed to adjust the data output cache."),
		new /datum/wire_description(DAMPER_WIRE_CONTROL, "This wire connects to the main control panel."),
		new /datum/wire_description(DAMPER_WIRE_AICONTROL, "This wire connects to automated control systems.")
	)

var/const/DAMPER_WIRE_POWER = 1			// Cut to disable power input into the generator. Pulse does nothing. Mend to restore.
var/const/DAMPER_WIRE_HACK = 2			// Pulse to hack the dampener, causing false display on engine consoles. Cut to unhack. Mend does nothing.
var/const/DAMPER_WIRE_CONTROL = 4		// Cut to lock controls. Mend to unlock them. Pulse does nothing.
var/const/DAMPER_WIRE_AICONTROL = 8		// Cut to disable AI control. Mend to restore.
var/const/DAMPER_WIRE_NOTHING = 16		// A blank wire that doesn't have any specific function

/datum/wires/inertial_damper/CanUse()
	var/obj/machinery/inertial_damper/I = holder
	if(I.panel_open)
		return TRUE
	return FALSE

/datum/wires/inertial_damper/UpdateCut(index, mended)
	var/obj/machinery/inertial_damper/I = holder
	switch(index)
		if(DAMPER_WIRE_POWER)
			I.input_cut = !mended
		if(DAMPER_WIRE_HACK)
			if(!mended)
				I.hacked = FALSE
		if(DAMPER_WIRE_CONTROL)
			I.locked = !mended
		if(DAMPER_WIRE_AICONTROL)
			I.ai_control_disabled = !mended

/datum/wires/inertial_damper/UpdatePulsed(var/index)
	var/obj/machinery/inertial_damper/I = holder
	switch(index)
		if(DAMPER_WIRE_HACK)
			I.hacked = TRUE