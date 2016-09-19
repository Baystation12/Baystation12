//This circuit gives information on where the machine is.
/obj/item/integrated_circuit/gps
	name = "global positioning system"
	desc = "This allows you to easily know the position of a machine containing this device."
	icon_state = "gps"
	complexity = 4
	number_of_inputs = 0
	number_of_outputs = 2
	number_of_activators = 1
	input_names = list(
		)
	output_names = list(
		"X (abs)",
		"Y (abs)"
	)
	activator_names = list(
		"get coordinates"
	)

/obj/item/integrated_circuit/gps/work()
	if(..())
		var/turf/T = get_turf(src)
		var/datum/integrated_io/result_x = outputs[1]
		var/datum/integrated_io/result_y = outputs[2]

		result_x.data = null
		result_y.data = null
		if(!T)
			return

		result_x.data = T.x
		result_y.data = T.y

		for(var/datum/integrated_io/output/O in outputs)
			O.push_data()

/obj/item/integrated_circuit/abs_to_rel_coords
	name = "abs to rel coordinate converter"
	desc = "Easily convert absolute coordinates to relative coordinates with this."
	complexity = 4
	number_of_inputs = 4
	number_of_outputs = 2
	number_of_activators = 1
	input_names = list(
		"X1 (abs)",
		"Y1 (abs)",
		"X2 (abs)",
		"Y2 (abs)"
		)
	output_names = list(
		"X (rel)",
		"Y (rel)"
	)
	activator_names = list(
		"compute rel coordinates"
	)

/obj/item/integrated_circuit/abs_to_rel_coords/work()
	var/datum/integrated_io/x1 = inputs[1]
	var/datum/integrated_io/y1 = inputs[2]

	var/datum/integrated_io/x2 = inputs[3]
	var/datum/integrated_io/y2 = inputs[4]

	var/datum/integrated_io/result_x = outputs[1]
	var/datum/integrated_io/result_y = outputs[2]

	if(x1.data && y1.data && x2.data && y2.data)
		result_x.data = x1.data - x2.data
		result_y.data = y1.data - y2.data


	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()
	..()
