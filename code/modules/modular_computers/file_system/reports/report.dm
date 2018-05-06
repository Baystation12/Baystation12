/datum/computer_file/report
	filename = "report"
	filetype = "RPT"
	var/title = "Generic Report"                           //The name of this report type.
	var/form_name = "AB1"                                  //Form code, for maximum bureaucracy.
	var/creator                                            //The name of the mob that made the report.
	var/file_time                                          //Time submitted.
	var/list/access_edit = list()                          //The access required to submit the report.
	var/list/access = list()                               //The access required to view the report.
	var/list/datum/report_field/fields = list()            //A list of fields the report comes with, in order that they should be displayed.
	var/ID_ticker = 1                                      //Used to name fields, for internal use only.

/datum/computer_file/report/New()
	..()
	generate_fields()

/datum/computer_file/report/Destroy()
	QDEL_NULL_LIST(fields)
	. = ..()

/*
Access stuff. The report's access/access_edit should control whether it can be opened/submitted.
For field editing or viewing, use the field's access/access_edit permission instead.
Recursive will add the access to all fields as well.
*/
/datum/computer_file/report/proc/set_access(access = list(), access_edit = list(), recursive = 1)
	if(access)
		src.access = list()
		src.access += access //works whether access is a list or not.
	if(access_edit)
		src.access = list()
		src.access_edit += access_edit
	src.access_edit |= src.access
	if(recursive)
		for(var/datum/report_field/field in fields)
			field.access |= src.access
			field.access_edit |= src.access_edit

/datum/computer_file/report/proc/verify_access(given_access)
	if(!islist(given_access))
		given_access = list(given_access)
	return  has_access(access, list(), given_access)

/datum/computer_file/report/proc/verify_access_edit(given_access)
	if(!islist(given_access))
		given_access = list(given_access)
	return  has_access(access_edit, list(), given_access)

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
	file_time = stationtime2text()
	return 1

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
		var/dat = list()
		if(given_access)
			dat["access"] = field.verify_access(given_access)
			dat["access_edit"] = field.verify_access_edit(given_access)
		dat["name"] = field.display_name()
		dat["value"] = field.get_value()
		dat["can_edit"] = field.can_edit
		dat["needs_big_box"] = field.needs_big_box
		dat["ignore_value"] = field.ignore_value
		dat["ID"] = field.ID
		.["fields"] += list(dat)

//recipient reports have a designated recipitents field, for recieving submitted reports.
/datum/computer_file/report/recipient
	var/datum/report_field/people/list_from_manifest/recipients

/datum/computer_file/report/recipient/generate_fields()
	recipients = add_field(/datum/report_field/people/list_from_manifest/, "Send Copies To")

/datum/computer_file/report/recipient/submit(mob/user)
	if((. = ..()))
		recipients.send_email(user)