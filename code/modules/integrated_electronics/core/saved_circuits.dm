// Helpers for saving/loading integrated circuits.


// Saves type, modified name and modified inputs (if any) to a list
// The list is converted to JSON down the line.
//"Special" is not verified at any point except for by the circuit itself.
/obj/item/integrated_circuit/proc/save()
	var/list/component_params = list()
	var/init_name = initial(name)

	// Save initial name used for differentiating assemblies
	component_params["type"] = init_name

	// Save the modified name.
	if(init_name != displayed_name)
		component_params["name"] = displayed_name

	// Saving input values
	if(length(inputs))
		var/list/saved_inputs = list()

		for(var/index in 1 to inputs.len)
			var/datum/integrated_io/input = inputs[index]

			// Don't waste space saving the default values
			if(input.data == initial(input.data))
				continue

			var/list/input_value = list(index, FALSE, input.data)
			// Index, Type, Value
			// FALSE is default type used for num/text/list/null
			// TODO: support for special input types, such as internal refs and maybe typepaths

			if(islist(input.data) || isnum(input.data) || istext(input.data) || isnull(input.data))
				saved_inputs.Add(list(input_value))

		if(saved_inputs.len)
			component_params["inputs"] = saved_inputs

	var/special = save_special()
	if(!isnull(special))
		component_params["special"] = special

	return component_params

/obj/item/integrated_circuit/proc/save_special()
	return

// Verifies a list of component parameters
// Returns null on success, error name on failure
/obj/item/integrated_circuit/proc/verify_save(list/component_params)
	var/init_name = initial(name)
	// Validate name
	if(component_params["name"])
		sanitizeName(component_params["name"],allow_numbers=TRUE)
	// Validate input values
	if(component_params["inputs"])
		var/list/loaded_inputs = component_params["inputs"]
		if(!islist(loaded_inputs))
			return "Malformed input values list at [init_name]."

		var/inputs_amt = length(inputs)

		// Too many inputs? Inputs for input-less component? This is not good.
		if(!inputs_amt || inputs_amt < length(loaded_inputs))
			return "Input values list out of bounds at [init_name]."

		for(var/list/input in loaded_inputs)
			if(input.len != 3)
				return "Malformed input data at [init_name]."

			var/input_id = input[1]
			var/input_type = input[2]
			//var/input_value = input[3]

			// No special type support yet.
			if(input_type)
				return "Unidentified input type at [init_name]!"
			// TODO: support for special input types, such as typepaths and internal refs

			// Input ID is a list index, make sure it's sane.
			if(!isnum(input_id) || input_id % 1 || input_id > inputs_amt || input_id < 1)
				return "Invalid input index at [init_name]."


// Loads component parameters from a list
// Doesn't verify any of the parameters it loads, this is the job of verify_save()
/obj/item/integrated_circuit/proc/load(list/component_params)
	// Load name
	if(component_params["name"])
		displayed_name = component_params["name"]

	// Load input values
	if(component_params["inputs"])
		var/list/loaded_inputs = component_params["inputs"]

		for(var/list/input in loaded_inputs)
			var/index = input[1]
			//var/input_type = input[2]
			var/input_value = input[3]

			var/datum/integrated_io/pin = inputs[index]
			// The pins themselves validate the data.
			pin.write_data_to_pin(input_value)
			// TODO: support for special input types, such as internal refs and maybe typepaths

	if(!isnull(component_params["special"]))
		load_special(component_params["special"])

/obj/item/integrated_circuit/proc/load_special(special_data)
	return

// Saves type and modified name (if any) to a list
// The list is converted to JSON down the line.
/obj/item/device/electronic_assembly/proc/save()
	var/list/assembly_params = list()

	// Save initial name used for differentiating assemblies
	assembly_params["type"] = initial(name)

	// Save modified name
	if(initial(name) != name)
		assembly_params["name"] = name

	// Save modified description
	if(initial(desc) != desc)
		assembly_params["desc"] = desc

	// Save modified color
	if(initial(detail_color) != detail_color)
		assembly_params["detail_color"] = detail_color

	return assembly_params


// Verifies a list of assembly parameters
// Returns null on success, error name on failure
/obj/item/device/electronic_assembly/proc/verify_save(list/assembly_params)
	// Validate name and color
	if(assembly_params["name"])
		if(sanitizeName(assembly_params["name"], allow_numbers = TRUE) != assembly_params["name"])
			return "Bad assembly name."
	if(assembly_params["desc"])
		if(sanitize(assembly_params["desc"]) != assembly_params["desc"])
			return "Bad assembly description."
	if(assembly_params["detail_color"] && !(assembly_params["detail_color"] in color_whitelist))
		return "Bad assembly color."

// Loads assembly parameters from a list
// Doesn't verify any of the parameters it loads, this is the job of verify_save()
/obj/item/device/electronic_assembly/proc/load(list/assembly_params)
	// Load modified name, if any.
	if(assembly_params["name"])
		name = assembly_params["name"]

	// Load modified description, if any.
	if(assembly_params["desc"])
		desc = assembly_params["desc"]

	if(assembly_params["detail_color"])
		detail_color = assembly_params["detail_color"]

	update_icon()
