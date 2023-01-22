/datum/wires/smes
	holder_type = /obj/machinery/power/smes/buildable
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(SMES_WIRE_RCON, "This wire runs to a remote signaling mechanism."),
		new /datum/wire_description(SMES_WIRE_INPUT, "This seems to be the primary input.", SKILL_EXPERT),
		new /datum/wire_description(SMES_WIRE_OUTPUT, "This seems to be the primary output.", SKILL_EXPERT),
		new /datum/wire_description(SMES_WIRE_GROUNDING, "This wire appeas to connect directly to the floor.", SKILL_EXPERT),
		new /datum/wire_description(SMES_WIRE_FAILSAFES, "This wire appears to connect to a failsafe mechanism.")
	)

var/global/const/SMES_WIRE_RCON = 1		// Remote control (AI and consoles), cut to disable
var/global/const/SMES_WIRE_INPUT = 2		// Input wire, cut to disable input, pulse to disable for 60s
var/global/const/SMES_WIRE_OUTPUT = 4		// Output wire, cut to disable output, pulse to disable for 60s
var/global/const/SMES_WIRE_GROUNDING = 8	// Cut to quickly discharge causing sparks, pulse to only create few sparks
var/global/const/SMES_WIRE_FAILSAFES = 16	// Cut to disable failsafes, mend to reenable


/datum/wires/smes/CanUse(var/mob/living/L)
	var/obj/machinery/power/smes/buildable/S = holder
	if(!S.grounding && S.powernet && S.powernet.avail)
		electrocute_mob(L, S.powernet, S, S.safeties_enabled? 0.1 : 1)
	if(S.panel_open)
		return 1
	return 0


/datum/wires/smes/GetInteractWindow(mob/user)
	var/obj/machinery/power/smes/buildable/S = holder
	. += ..()
	. += "The green light is [(S.input_cut || S.input_pulsed || S.output_cut || S.output_pulsed) ? "off" : "on"]<br>"
	. += "The red light is [(S.safeties_enabled || S.grounding) ? "off" : "blinking"]<br>"
	. += "The blue light is [S.RCon ? "on" : "off"]"


/datum/wires/smes/UpdateCut(var/index, var/mended)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(index)
		if(SMES_WIRE_RCON)
			S.RCon = mended
		if(SMES_WIRE_INPUT)
			S.input_cut = !mended
		if(SMES_WIRE_OUTPUT)
			S.output_cut = !mended
		if(SMES_WIRE_GROUNDING)
			S.grounding = mended
		if(SMES_WIRE_FAILSAFES)
			S.safeties_enabled = mended


/datum/wires/smes/UpdatePulsed(var/index)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(index)
		if(SMES_WIRE_RCON)
			if(S.RCon)
				S.RCon = 0
				spawn(10)
					S.RCon = 1
		if(SMES_WIRE_INPUT)
			S.toggle_input()
		if(SMES_WIRE_OUTPUT)
			S.toggle_output()
		if(SMES_WIRE_GROUNDING)
			S.grounding = 0
		if(SMES_WIRE_FAILSAFES)
			if(S.safeties_enabled)
				S.safeties_enabled = 0
				spawn(10)
					S.safeties_enabled = 1