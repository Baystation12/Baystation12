/datum/wires/particle_acc/control_box
	wire_count = 5
	holder_type = /obj/machinery/particle_accelerator/control_box
	descriptions = list(
		new /datum/wire_description(PARTICLE_TOGGLE_WIRE, "This wire seems to connect to the main power toggle.", SKILL_EXPERT),
		new /datum/wire_description(PARTICLE_STRENGTH_WIRE, "This wire connects to the primary magnets."),
		new /datum/wire_description(PARTICLE_INTERFACE_WIRE, "This wire appears connected to the user panel."),
		new /datum/wire_description(PARTICLE_LIMIT_POWER_WIRE, "This wire connects to the primary magnets.")
	)

var/const/PARTICLE_TOGGLE_WIRE = 1 // Toggles whether the PA is on or not.
var/const/PARTICLE_STRENGTH_WIRE = 2 // Determines the strength of the PA.
var/const/PARTICLE_INTERFACE_WIRE = 4 // Determines the interface showing up.
var/const/PARTICLE_LIMIT_POWER_WIRE = 8 // Determines how strong the PA can be.
//var/const/PARTICLE_NOTHING_WIRE = 16 // Blank wire

/datum/wires/particle_acc/control_box/CanUse(var/mob/living/L)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	if(C.construction_state == 2)
		return 1
	return 0

/datum/wires/particle_acc/control_box/UpdatePulsed(var/index)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(index)

		if(PARTICLE_TOGGLE_WIRE)
			C.toggle_power()

		if(PARTICLE_STRENGTH_WIRE)
			C.add_strength()

		if(PARTICLE_INTERFACE_WIRE)
			C.interface_control = !C.interface_control

		if(PARTICLE_LIMIT_POWER_WIRE)
			C.visible_message("[icon2html(C, viewers(get_turf(C)))]<b>[C]</b> makes a large whirring noise.")

/datum/wires/particle_acc/control_box/UpdateCut(var/index, var/mended)
	var/obj/machinery/particle_accelerator/control_box/C = holder
	switch(index)

		if(PARTICLE_TOGGLE_WIRE)
			if(C.active == !mended)
				C.toggle_power()

		if(PARTICLE_STRENGTH_WIRE)

			for(var/i = 1; i < 3; i++)
				C.remove_strength()

		if(PARTICLE_INTERFACE_WIRE)
			C.interface_control = mended

		if(PARTICLE_LIMIT_POWER_WIRE)
			C.strength_upper_limit = (mended ? 2 : 3)
			if(C.strength_upper_limit < C.strength)
				C.remove_strength()