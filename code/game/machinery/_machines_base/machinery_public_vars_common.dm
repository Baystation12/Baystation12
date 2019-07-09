/*
Public vars at /obj/machinery level. Just because they are here does not mean that every machine exposes them; you must add them to the appropriate list.
*/

/obj/machinery
	var/input_toggle = FALSE

/decl/public_access/public_variable/input_toggle
	expected_type = /obj/machinery
	name = "input toggle"
	desc = "The input toggle variable does not do anything by itself. This makes it useful for having receivers trigger transmitters. Can be toggled by a public method."
	can_write = FALSE
	has_updates = TRUE

/decl/public_access/public_variable/input_toggle/access_var(obj/machinery/machine)
	return machine.input_toggle

/decl/public_access/public_variable/input_toggle/write_var(obj/machinery/machine, new_value)
	. = ..()
	if(.)
		machine.input_toggle = new_value

/decl/public_access/public_method/toggle_input_toggle
	name = "toggle input"
	desc = "Toggles the input toggle variable."
	call_proc = /obj/machinery/proc/toggle_input_toggle

/obj/machinery/proc/toggle_input_toggle()
	var/decl/public_access/public_variable/variable = decls_repository.get_decl(/decl/public_access/public_variable/input_toggle)
	variable.write_var(src, !input_toggle)