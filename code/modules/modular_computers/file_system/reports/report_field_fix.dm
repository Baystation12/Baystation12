/datum/report_field/time/copy_value(datum/report_field/old_field)
	. = ..()
	if(old_field.owner in ntnet_global.available_reports)
		value = stationtime2text()

/datum/report_field/options/yes_no/ask_value(mob/user)
	if(value == "No")
		set_value("Yes")
	else
		set_value("No")

/datum/report_field/options/yes_no/generate_row_pencode(access, with_fields)
	if(!ignore_value)
		. += "\[row\]\[cell\]\[b\][display_name()]:\[/b\]"
		var/field = ((with_fields && can_edit) ? "\[field\]" : "" )
		if(!access || verify_access(access))
			. += (needs_big_box ? "\[/grid\][get_value()=="No"?"[field]":"Yes"]\[grid\]" : "\[cell\][get_value()=="No"?"[field]":"Yes"]")
		else
			. += "\[cell\]\[REDACTED\][field]"
	else
		. += "\[/grid\][display_name()]\[grid\]"
	. = JOINTEXT(.)

/datum/report_field/text_label/instruction/generate_row_pencode(access, with_fields)
	return "\[/grid\]\[small\]\[i\][display_name()]\[/i\]\[/small\]\[grid\]"
