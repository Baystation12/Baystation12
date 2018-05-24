/datum/report_field
	var/datum/computer_file/report/owner //The report to which this field belongs.
	var/name = "generic field"     //The name the field will be labeled with.
	var/value                      //Only used internally.
	var/can_edit = 1               //Whether the field gives the user the option to edit it.
	var/required = 0               //Whether the field is required to submit the report.
	var/ID                         //A unique (per report) id; don't set manually.
	var/needs_big_box = 0          //Suggests that the output won't look good in-line. Useful in nanoui logic.
	var/ignore_value = 0           //Suggests that the value should not be displayed.
	var/list/access_edit = list(list())  //The access required to edit the field.
	var/list/access = list(list())       //The access required to view the field.

/datum/report_field/New(datum/computer_file/report/report)
	owner = report
	..()

/datum/report_field/Destroy()
	owner = null
	. = ..()

//Access stuff. Can be given access constants or lists. See report access procs for documentation.
/datum/report_field/proc/set_access(access, access_edit, override = 1)
	if(access)
		if(!islist(access))
			access = list(access)
		override ? (src.access = list(access)) : (src.access += list(access))
	if(access_edit)
		if(!islist(access_edit))
			access_edit = list(access_edit)
		override ? (src.access_edit = list(access_edit)) : (src.access_edit += list(access_edit))

/datum/report_field/proc/verify_access(given_access)
	return has_access_pattern(access, given_access)

/datum/report_field/proc/verify_access_edit(given_access)
	if(!verify_access(given_access))
		return
	return has_access_pattern(access_edit, given_access)

//Assumes the old and new fields are of the same type. Override if the field stores information differently.
/datum/report_field/proc/copy_value(datum/report_field/old_field)
	value = old_field.value
	access = old_field.access
	access_edit = old_field.access_edit

//Gives the user prompts to fill out the field.
/datum/report_field/proc/ask_value(mob/user)

//Sanitizes and sets the value from input.
/datum/report_field/proc/set_value(given_value)
	value = given_value

//Exports the contents of the field into html for viewing. 
/datum/report_field/proc/get_value()
	return value

//In case the name needs to be displayed dynamically.
/datum/report_field/proc/display_name()
	return name

/*
Basic field subtypes.
*/

//For information between fields.
/datum/report_field/instruction
	can_edit = 0
	ignore_value = 1

//Basic text field, for short strings.
/datum/report_field/simple_text
	value = ""

/datum/report_field/simple_text/set_value(given_value)
	if(istext(given_value))
		value = sanitize(given_value) || ""

/datum/report_field/simple_text/ask_value(mob/user)
	var/input = input(user, "[display_name()]:", "Form Input", html_decode(get_value())) as null|text
	set_value(input)

//Inteded for sizable text blocks.
/datum/report_field/pencode_text
	value = ""
	needs_big_box = 1

/datum/report_field/pencode_text/get_value()
	return pencode2html(value)

/datum/report_field/pencode_text/set_value(given_value)
	if(istext(given_value))
		value = sanitize(replacetext(given_value, "\n", "\[br\]"), MAX_PAPER_MESSAGE_LEN) || ""

/datum/report_field/pencode_text/ask_value(mob/user)
	set_value(input(user, "[display_name()] (You may use HTML paper formatting tags):", "Form Input", replacetext(html_decode(value), "\[br\]", "\n")) as null|message)

//Uses hh:mm format for times.
/datum/report_field/time
	value = "00:00"

/datum/report_field/time/set_value(given_value)
	if(istext(given_value))
		value = sanitize_time(given_value)

/datum/report_field/time/ask_value(mob/user)
	set_value(input(user, "[display_name()] (time as hh:mm):", "Form Input", get_value()) as null|text)

//Will prompt for numbers.
/datum/report_field/number
	value = 0

/datum/report_field/number/set_value(given_value)
	if(isnum(given_value))
		value = given_value

/datum/report_field/number/ask_value(mob/user)
	set_value(input(user, "[display_name()]:", "Form Input", get_value()) as null|num)

//Gives a list of choices to pick one from.
/datum/report_field/options/proc/get_options()

/datum/report_field/options/set_value(given_value)
	if(given_value in get_options())
		value = given_value

/datum/report_field/options/ask_value(mob/user)
	set_value(input(user, "[display_name()] (select one):", "Form Input", get_value()) as null|anything in get_options())