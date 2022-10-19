// These pins only contain 0 or 1.  Null is not allowed.
/datum/integrated_io/boolean
	name = "boolean pin"
	data = FALSE

/datum/integrated_io/boolean/ask_for_pin_data(mob/user) // 'Ask' is a bit misleading, acts more like a toggle.
	var/new_data = !data
	to_chat(user, SPAN_NOTICE("You switch the data bit to [new_data ? "TRUE" : "FALSE"]."))
	write_data_to_pin(new_data)

/datum/integrated_io/boolean/write_data_to_pin(new_data)
	if(new_data == FALSE || new_data == TRUE)
		data = new_data
		holder.on_data_written()

/datum/integrated_io/boolean/scramble()
	write_data_to_pin(rand(FALSE,TRUE))
	push_data()

/datum/integrated_io/boolean/display_pin_type()
	return IC_FORMAT_BOOLEAN

/datum/integrated_io/boolean/display_data(input)
	if(data)
		return "(TRUE)"
	return "(FALSE)"
