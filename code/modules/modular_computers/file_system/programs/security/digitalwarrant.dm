LEGACY_RECORD_STRUCTURE(all_warrants, warrant)
/datum/computer_file/data/warrant/
	var/archived = FALSE

/datum/computer_file/program/digitalwarrant
	filename = "digitalwarrant"
	filedesc = "Warrant Assistant"
	extended_desc = "Official NTsec program for creation and handling of warrants."
	size = 8
	program_icon_state = "warrant"
	program_key_state = "security_key"
	program_menu_icon = "star"
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access = access_security
	nanomodule_path = /datum/nano_module/digitalwarrant/
	category = PROG_SEC

/datum/nano_module/digitalwarrant/
	name = "Warrant Assistant"
	var/datum/computer_file/data/warrant/activewarrant

/datum/nano_module/digitalwarrant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	if(activewarrant)
		data["warrantname"] = activewarrant.fields["namewarrant"]
		data["warrantjob"] = activewarrant.fields["jobwarrant"]
		data["warrantcharges"] = activewarrant.fields["charges"]
		data["warrantauth"] = activewarrant.fields["auth"]
		data["warrantidauth"] = activewarrant.fields["idauth"]
		data["type"] = activewarrant.fields["arrestsearch"]
	else
		var/list/arrestwarrants = list()
		var/list/searchwarrants = list()
		var/list/archivedwarrants = list()
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			var/charges = W.fields["charges"]
			if(length(charges) > 50)
				charges = copytext(charges, 1, 50) + "..."
			var/warrant = list(
			"warrantname" = W.fields["namewarrant"],
			"charges" = charges,
			"auth" = W.fields["auth"],
			"id" = W.uid,
			"arrestsearch" = W.fields["arrestsearch"],
			"archived" = W.archived)
			if (warrant["archived"])
				archivedwarrants.Add(list(warrant))
			else if(warrant["arrestsearch"] == "arrest")
				arrestwarrants.Add(list(warrant))
			else
				searchwarrants.Add(list(warrant))
		data["arrestwarrants"] = arrestwarrants.len ? arrestwarrants : null
		data["searchwarrants"] = searchwarrants.len ? searchwarrants : null
		data["archivedwarrants"] = archivedwarrants.len? archivedwarrants :null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "digitalwarrant.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/digitalwarrant/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["sw_menu"])
		activewarrant = null

	if(href_list["editwarrant"])
		. = 1
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			if(W.uid == text2num(href_list["editwarrant"]))
				activewarrant = W
				break

	// The following actions will only be possible if the user has an ID with security access equipped. This is in line with modular computer framework's authentication methods,
	// which also use RFID scanning to allow or disallow access to some functions. Anyone can view warrants, editing requires ID. This also prevents situations where you show a tablet
	// to someone who is to be arrested, which allows them to change the stuff there.

	var/mob/user = usr
	if(!istype(user))
		return
	var/obj/item/weapon/card/id/I = user.GetIdCard()
	if(!istype(I) || !I.registered_name || !(access_security in I.access))
		to_chat(user, "Authentication error: Unable to locate ID with apropriate access to allow this operation.")
		return

	if(href_list["sendtoarchive"])
		. = 1
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			if(W.uid == text2num(href_list["sendtoarchive"]))
				W.archived = TRUE
				break

	if(href_list["restore"])
		. = 1
		for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
			if(W.uid == text2num(href_list["restore"]))
				W.archived = FALSE
				break

	if(href_list["addwarrant"])
		. = 1
		var/datum/computer_file/data/warrant/W = new()
		if(CanInteract(user, GLOB.default_state))
			W.fields["namewarrant"] = "Unknown"
			W.fields["jobwarrant"] = "N/A"
			W.fields["auth"] = "Unauthorized"
			W.fields["idauth"] = "Unauthorized"
			W.fields["access"] = list()
			if(href_list["addwarrant"] == "arrest")
				W.fields["charges"] = "No charges present"
				W.fields["arrestsearch"] = "arrest"
			if(href_list["addwarrant"] == "search")
				W.fields["charges"] = "No reason given"
				W.fields["arrestsearch"] = "search"
			activewarrant = W

	if(href_list["savewarrant"])
		. = 1
		if(!activewarrant)
			return
		broadcast_security_hud_message("\A [activewarrant.fields["arrestsearch"]] warrant for <b>[activewarrant.fields["namewarrant"]]</b> has been [(activewarrant in GLOB.all_warrants) ? "edited" : "uploaded"].", nano_host())
		GLOB.all_warrants |= activewarrant
		activewarrant = null

	if(href_list["deletewarrant"])
		. = 1
		if(!activewarrant)
			for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
				if(W.uid == text2num(href_list["deletewarrant"]))
					activewarrant = W
					break
		GLOB.all_warrants -= activewarrant
		activewarrant = null

	if(href_list["editwarrantname"])
		. = 1
		var/namelist = list()
		for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
			namelist += "[CR.get_name()] \[[CR.get_job()]\]"
		var/new_person = sanitize(input(usr, "Please input name") as null|anything in namelist)
		if(CanInteract(user, GLOB.default_state))
			if (!new_person || !activewarrant)
				return
			// string trickery to extract name & job
			var/entry_components = splittext(new_person, " \[")
			var/name = entry_components[1]
			var/job = copytext(entry_components[2], 1, length(entry_components[2]))
			activewarrant.fields["namewarrant"] = name
			activewarrant.fields["jobwarrant"] = job

	if(href_list["editwarrantnamecustom"])
		. = 1
		var/new_name = sanitize(input("Please input name") as null|text)
		var/new_job = sanitize(input("Please input job") as null|text)
		if(CanInteract(user, GLOB.default_state))
			if (!new_name || !new_job || !activewarrant)
				return
			activewarrant.fields["namewarrant"] = new_name
			activewarrant.fields["jobwarrant"] = new_job

	if(href_list["editwarrantcharges"])
		. = 1
		var/new_charges = sanitize(input("Please input charges", "Charges", activewarrant.fields["charges"]) as null|text)
		if(CanInteract(user, GLOB.default_state))
			if (!new_charges || !activewarrant)
				return
			activewarrant.fields["charges"] = new_charges

	if(href_list["editwarrantauth"])
		. = 1
		if(!activewarrant)
			return
		activewarrant.fields["auth"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"

	if(href_list["editwarrantidauth"])
		. = 1
		if(!activewarrant)
			return
		// access-granting is only available for arrest warrants
		if(activewarrant.fields["arrestsearch"] == "search")
			return
		if(!(access_change_ids in I.access))
			to_chat(user, "Authentication error: Unable to locate ID with appropriate access to allow this operation.")
			return

		// only works if they are in the crew records with a valid job
		var/datum/computer_file/report/crew_record/warrant_subject
		var/datum/job/J = SSjobs.get_by_title(activewarrant.fields["jobwarrant"])
		if(!J)
			to_chat(user, "Lookup error: Unable to locate specified job in access database.")
			return
		for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
			if(CR.get_name() == activewarrant.fields["namewarrant"] && CR.get_job() == J.title)
				warrant_subject = CR

		if(!warrant_subject)
			to_chat(user, "Lookup error: Unable to locate specified personnel in crew records.")
			return

		var/list/warrant_access = J.get_access()
		// warrants can never grant command access
		warrant_access.Remove(get_region_accesses(ACCESS_REGION_COMMAND))

		activewarrant.fields["idauth"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"
		activewarrant.fields["access"] = warrant_access

	if(href_list["back"])
		. = 1
		activewarrant = null
