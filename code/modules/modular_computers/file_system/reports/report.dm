/datum/computer_file/report
	filename = "report"
	filetype = "RPT"
	var/title = "Generic Report"                           //The name of this report type.
	var/form_name = "AB1"                                  //Form code, for maximum bureaucracy.
	var/creator                                            //The name of the mob that made the report.
	var/file_time                                          //Time submitted.
	var/list/access_edit = list(list())                    //The access required to submit the report. See documentation below.
	var/list/access = list(list())                         //The access required to view the report.
	var/list/datum/report_field/fields = list()            //A list of fields the report comes with, in order that they should be displayed.
	var/available_on_ntnet = 0                             //Whether this report type should show up on NTNet.
	var/logo                                               //Can be set to a pencode logo for use with some display methods.

/datum/computer_file/report/New()
	..()
	generate_fields()

/datum/computer_file/report/Destroy()
	QDEL_NULL_LIST(fields)
	. = ..()

/*
Access stuff. The report's access/access_edit should control whether it can be opened/submitted.
For field editing or viewing, use the field's access/access_edit permission instead.
The access system is based on "access patterns", lists of access values. 
A user needs all access values in a pattern to be granted access.
A user needs to only match one of the potentially several stored access patterns to be granted access.
You must have access to have edit access.

This proc resets the access to the report, resulting in just one access pattern for access/edit.
Arguments can be access values (numbers) or lists of access values.
If null is passed to one of the arguments, that access type is left alone. Pass list() to reset to no access needed instead.
The recursive option resets access to all fields in the report as well.
If the override option is set to 0, the access supplied will instead be added as another access pattern, rather than resetting the access.
*/
/datum/computer_file/report/proc/set_access(access, access_edit, recursive = 1, override = 1)
	if(access)
		if(!islist(access))
			access = list(access)
		override ? (src.access = list(access)) : (src.access += list(access))  //Note that this is a list of lists.
	if(access_edit)
		if(!islist(access_edit))
			access_edit = list(access_edit)
		override ? (src.access_edit = list(access_edit)) : (src.access_edit += list(access_edit))
	if(recursive)
		for(var/datum/report_field/field in fields)
			field.set_access(access, access_edit, override)

//Strongly recommended to use these procs to check for access. They can take access values (numbers) or lists of values.
/datum/computer_file/report/proc/verify_access(given_access)
	return has_access_pattern(access, given_access)

/datum/computer_file/report/proc/verify_access_edit(given_access)
	if(!verify_access(given_access))
		return //Need access for access_edit
	return has_access_pattern(access_edit, given_access)

//Looking up fields. Names might not be unique unless you ensure otherwise.
/datum/computer_file/report/proc/field_from_ID(ID)
	for(var/datum/report_field/field in fields)
		if(field.ID == ID)
			return field

/datum/computer_file/report/proc/field_from_name(name)
	for(var/datum/report_field/field in fields)
		if(field.display_name() == name)
			return field

//The place to enter fields for report subtypes, via add_field.
/datum/computer_file/report/proc/generate_fields()
	return

/datum/computer_file/report/proc/submit(mob/user)
	if(!istype(user))
		return 0
	for(var/datum/report_field/field in fields)
		if(field.required && !field.get_value())
			to_chat(user, "<span class='notice'>You are missing a required field!</span>")
			return 0
	creator = user.name
	file_time = time_stamp()
	rename_file(file_time)
	return 1

/datum/computer_file/report/proc/rename_file(append)
	append = append || time_stamp()
	append = replacetext(append, ":", "_")
	filename = "[form_name]_[append]"

//Don't add fields except through this proc.
/datum/computer_file/report/proc/add_field(field_type, name, value = null, required = 0)
	var/datum/report_field/field = new field_type(src)
	field.name = name
	if(value)
		field.value = value
	if(required)
		field.required = 1
	field.ID = sequential_id(type)
	fields += field
	return field

/datum/computer_file/report/clone()
	var/datum/computer_file/report/temp = ..()
	temp.title = title
	temp.form_name = form_name
	temp.creator = creator
	temp.file_time = file_time
	temp.access_edit = access_edit
	temp.access = access
	for(var/i = 1, i <= length(fields), i++)
		var/datum/report_field/new_field = temp.fields[i]
		new_field.copy_value(fields[i])
	return temp

/datum/computer_file/report/proc/display_name()
	return "Form [form_name]: [title]"

//if access is given, will include access information by performing checks against it.
/datum/computer_file/report/proc/generate_nano_data(list/given_access)
	. = list()
	.["name"] = display_name()
	.["uid"] = uid
	.["creator"] = creator
	.["file_time"] = file_time
	.["fields"] = list()
	if(given_access)
		.["access"] = verify_access(given_access)
		.["access_edit"] = verify_access_edit(given_access)
	for(var/datum/report_field/field in fields)
		.["fields"] += list(field.generate_nano_data(given_access))
/*
This formats the report into pencode for use with paper and printing. Setting access to null will bypass access checks.
with_fields will include a field link after the field value (useful to print fillable forms).
no_html will strip any html, possibly killing useful formatting in the process.
*/
/datum/computer_file/report/proc/generate_pencode(access, with_fields, no_html)
	. = list()
	. += "\[center\][logo]\[/center\]"
	. += "\[center\]\[h2\][display_name()]\[/h2\]\[/center\]"
	. += "\[grid\]"
	for(var/datum/report_field/F in fields)
		. += F.generate_row_pencode(access, with_fields)
	. += "\[/grid\]"
	. = JOINTEXT(.)
	if(no_html)
		. = html2pencode(.)

//recipient reports have a designated recipients field, for recieving submitted reports.
/datum/computer_file/report/recipient
	var/datum/report_field/people/list_from_manifest/recipients

/datum/computer_file/report/recipient/Destroy()
	recipients = null
	return ..()

/datum/computer_file/report/recipient/generate_fields()
	recipients = add_field(/datum/report_field/people/list_from_manifest, "Send Copies To")

/datum/computer_file/report/recipient/submit(mob/user)
	if((. = ..()))
		recipients.send_email(user)