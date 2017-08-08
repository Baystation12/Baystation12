/obj/machinery/power/smes/buildable/preset/
	var/_fully_charged = FALSE
	var/_input_maxed = FALSE
	var/_input_on = FALSE
	var/_output_maxed = FALSE
	var/_output_on = FALSE
	cur_coils = 0

/obj/machinery/power/smes/buildable/preset/New()
	..()
	configure_and_install_coils()
	recalc_coils()
	if(_input_maxed)
		input_level = input_level_max
	if(_output_maxed)
		output_level = output_level_max
	input_attempt = _input_on
	output_attempt = _output_on
	if(_fully_charged)
		charge = capacity

// Override and implement to customize the SMES's loadout
/obj/machinery/power/smes/buildable/preset/proc/configure_and_install_coils()
	CRASH("configure_and_install_coils() not implemented for type [type]!")
	return