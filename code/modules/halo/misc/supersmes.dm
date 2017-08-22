
/obj/machinery/power/smes/advanced
	name = "heavy duty power storage unit"
	desc = "An advanced high-capacity superconducting magnetic energy storage (ASMES) unit."
	icon = 'code/modules/halo/misc/SuperSMES.dmi'
	icon_state = "SMES"
	bound_width = 96
	bound_height = 96

	capacity = 10e6 // maximum charge
	charge = 2e6 // actual charge

	input_level_max = 400000 	// cap on input_level
	output_level_max = 400000	// cap on output_level

	should_be_mapped = 1 // If this is set to 0 it will send out warning on New()

/obj/machinery/power/smes/advanced/update_icon()
	//todo: overlays showing power level
	return
