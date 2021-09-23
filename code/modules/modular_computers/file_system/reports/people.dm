//Field with people in it; has some communications procs available to it.
/datum/report_field/people/proc/send_email(mob/user)
	if(!get_value())
		return //No one to send to anyway.
	var/subject = sanitize(input(user, "Email Subject:", "Document Email", "Report Submission: [owner.display_name()]") as null|text)
	var/body = sanitize(replacetext_char(input(user, "Email Body:", "Document Email", "Please see the attached document.") as null|message, "\n", "\[br\]"), MAX_PAPER_MESSAGE_LEN)
	var/attach_report = (alert(user, "Do you wish to attach [owner.display_name()]?","Document Email", "Yes.", "No.") == "Yes.") ? 1 : 0
	if(alert(user, "Are you sure you want to send this email?","Document Email", "Yes.", "No.") == "No.")
		return
	var/datum/computer_file/data/text/report_file
	if(attach_report)
		var/list/user_access = list()
		var/obj/item/card/id/I = user.GetIdCard()
		if(I)
			user_access |= I.access
		report_file = new
		report_file.stored_data = owner.generate_pencode(user_access, no_html = 1) //TXT files can't have html; they use pencode only.
		report_file.filename = owner.filename
	if(perform_send(subject, body, report_file))
		to_chat(user, "<span class='notice'>The email has been sent.</span>")

//Helper procs.
/datum/report_field/people/proc/perform_send(subject, body, attach_report)
	return

/datum/report_field/people/proc/send_to_recipient(subject, body, attach_report, recipient)
	var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(EMAIL_DOCUMENTS)
	var/datum/computer_file/data/email_message/message = new()
	message.title = subject
	message.stored_data = body
	message.source = server.login
	message.attachment = attach_report
	server.send_mail(recipient, message)

/datum/report_field/people/proc/format_output(name, rank, milrank)
	. = list()
	if(milrank)
		. += milrank
	. += name
	if(rank)
		. += "([rank])"
	return jointext(., " ")

//Lets you select one person on the manifest.
/datum/report_field/people/from_manifest
	value = list()

/datum/report_field/people/from_manifest/get_value()
	return format_output(value["name"], value["rank"], value["milrank"])

/datum/report_field/people/from_manifest/set_value(given_value)
	if(!given_value)
		value = list()
	if(!in_as_list(given_value, flat_nano_crew_manifest()))
		return //Check for inclusion, but have to be careful when checking list equivalence.
	value = given_value

/datum/report_field/people/from_manifest/ask_value(mob/user)
	var/list/full_manifest = flat_nano_crew_manifest()
	var/list/formatted_manifest = list()
	for(var/entry in full_manifest)
		formatted_manifest[format_output(entry["name"], entry["rank"])] = entry
	if (!length(formatted_manifest))
		alert(user, "There are no candidates to add from manifest.") // in case someone somehow deletes the entire crew record database.
	else
		var/input = input(user, "[display_name()]:", "Form Input", get_value()) as null|anything in formatted_manifest
		set_value(formatted_manifest[input])

/datum/report_field/people/from_manifest/perform_send(subject, body, attach_report)
	var/login = find_email(value["name"])
	send_to_recipient(subject, body, attach_report, login)
	return 1

//Lets you select multiple people.
/datum/report_field/people/list_from_manifest
	value = list()
	needs_big_box = 1

/datum/report_field/people/list_from_manifest/get_value(in_line = 0)
	var/dat = list()
	for(var/entry in value)
		var/milrank = entry["milrank"]
		if(in_line && (GLOB.using_map.flags & MAP_HAS_RANK))
			var/datum/computer_file/report/crew_record/CR = get_crewmember_record(entry["name"])
			if(CR)
				var/datum/mil_rank/rank_obj = mil_branches.get_rank(CR.get_branch(), CR.get_rank())
				milrank = (rank_obj ? rank_obj.name_short : "")
		dat += format_output(entry["name"], in_line ? null : entry["rank"], milrank)
	return jointext(dat, in_line ? ", " : "<br>")

/datum/report_field/people/list_from_manifest/set_value(given_value)
	var/list/full_manifest = flat_nano_crew_manifest()
	var/list/new_value = list()
	if(!islist(given_value))
		return
	for(var/entry in given_value)
		if(!in_as_list(entry, full_manifest))
			return
		if(in_as_list(entry, new_value))
			continue //ignore repeats
		new_value += list(entry)
	value = new_value	

/datum/report_field/people/list_from_manifest/ask_value(mob/user)
	var/alert = alert(user, "Would you like to add or remove a name?", "Form Input", "Add", "Remove")
	var/list/formatted_manifest = list()
	switch(alert)
		if("Add")
			var/list/full_manifest = flat_nano_crew_manifest()
			for(var/entry in full_manifest)
				if(!in_as_list(entry, value)) //Only look at those not already selected.
					formatted_manifest[format_output(entry["name"], entry["rank"])] = entry
			if (!length(formatted_manifest))
				alert(user, "There are no remaining candidates to add from manifest.")
			else
				var/input = input(user, "Add to [display_name()]:", "Form Input", null) as null|anything in formatted_manifest
				set_value(value + list(formatted_manifest[input]))
		if("Remove")
			for(var/entry in value)
				formatted_manifest[format_output(entry["name"], entry["rank"])] = entry
			if (!length(formatted_manifest))
				alert(user, "There are no remaining candidates to remove from manifest.")
			else
				var/input = input(user, "Remove from [display_name()]:", "Form Input", null) as null|anything in formatted_manifest
				set_value(value - list(formatted_manifest[input]))

//Batch-emails the list.
/datum/report_field/people/list_from_manifest/perform_send(subject, body, attach_report)
	for(var/entry in value)
		var/login = find_email(entry["name"])
		send_to_recipient(subject, body, attach_report, login)
	return 1