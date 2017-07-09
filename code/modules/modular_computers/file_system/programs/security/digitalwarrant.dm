var/warrant_uid = 0
/datum/datacore/var/list/warrants[] = list()
/datum/data/record/warrant
	var/warrant_id

/datum/data/record/warrant/New()
	..()
	warrant_id = warrant_uid++


/datum/computer_file/program/digitalwarrant
	filename = "digitalwarrant"
	filedesc = "Warrant Assistant"
	extended_desc = "Official NTsec program for creation and handling of warrants."
	size = 8
	program_icon_state = "warrant"
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access = access_security
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/digitalwarrant/

/datum/nano_module/program/digitalwarrant/
	name = "Warrant Assistant"
	var/datum/data/record/warrant/activewarrant

/datum/nano_module/program/digitalwarrant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	if(activewarrant)
		data["warrantname"] = activewarrant.fields["namewarrant"]
		data["warrantcharges"] = activewarrant.fields["charges"]
		data["warrantauth"] = activewarrant.fields["auth"]
		data["type"] = activewarrant.fields["arrestsearch"]
	else
		var/list/arrestwarrants = list()
		var/list/searchwarrants = list()
		var/list/archivedwarrants = list()
		for(var/datum/data/record/warrant/W in data_core.warrants)
			var/charges = W.fields["charges"]
			if(lentext(charges) > 50)
				charges = copytext(charges, 1, 50) + "..."
			var/warrant = list(
			"warrantname" = W.fields["namewarrant"],
			"charges" = charges,
			"auth" = W.fields["auth"],
			"id" = W.warrant_id,
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

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "digitalwarrant.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/digitalwarrant/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["sw_menu"])
		activewarrant = null

	if(href_list["editwarrant"])
		. = 1
		for(var/datum/data/record/warrant/W in data_core.warrants)
			if(W.warrant_id == text2num(href_list["editwarrant"]))
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
		for(var/datum/data/record/warrant/W in data_core.warrants)
			if(W.warrant_id == text2num(href_list["sendtoarchive"]))
				W.archived = TRUE
				break

	if(href_list["restore"])
		. = 1
		for(var/datum/data/record/warrant/W in data_core.warrants)
			if(W.warrant_id == text2num(href_list["restore"]))
				W.archived = FALSE
				break

	if(href_list["addwarrant"])
		. = 1
		var/datum/data/record/warrant/W = new()
		if(CanInteract(user, default_state))
			if(href_list["addwarrant"] == "arrest")
				W.fields["namewarrant"] = "Unknown"
				W.fields["charges"] = "No charges present"
				W.fields["auth"] = "Unauthorized"
				W.fields["arrestsearch"] = "arrest"
			if(href_list["addwarrant"] == "search")
				W.fields["namewarrant"] = "Unknown"
				W.fields["charges"] = "No reason given"
				W.fields["auth"] = "Unauthorized"
				W.fields["arrestsearch"] = "search"
			activewarrant = W

	if(href_list["savewarrant"])
		. = 1
		broadcast_holowarrant_message("\A [activewarrant.fields["arrestsearch"]] warrant for <b>[activewarrant.fields["namewarrant"]]</b> has been [(activewarrant in data_core.warrants) ? "edited" : "uploaded"].", src.program.computer)
		data_core.warrants |= activewarrant
		activewarrant = null

	if(href_list["deletewarrant"])
		. = 1
		if(!activewarrant)
			for(var/datum/data/record/warrant/W in data_core.warrants)
				if(W.warrant_id == text2num(href_list["deletewarrant"]))
					activewarrant = W
					break
		data_core.warrants -= activewarrant
		activewarrant = null

	if(href_list["editwarrantname"])
		. = 1
		var/namelist = list()
		for(var/datum/data/record/t in data_core.general)
			namelist += t.fields["name"]
		var/new_name = sanitize(input(usr, "Please input name") as null|anything in namelist)
		if(CanInteract(user, default_state))
			if (!new_name || !activewarrant)
				return
			activewarrant.fields["namewarrant"] = new_name

	if(href_list["editwarrantnamecustom"])
		. = 1
		var/new_name = sanitize(input("Please input name") as null|text)
		if(CanInteract(user, default_state))
			if (!new_name || !activewarrant)
				return
			activewarrant.fields["namewarrant"] = new_name

	if(href_list["editwarrantcharges"])
		. = 1
		var/new_charges = sanitize(input("Please input charges", "Charges", activewarrant.fields["charges"]) as null|text)
		if(CanInteract(user, default_state))
			if (!new_charges || !activewarrant)
				return
			activewarrant.fields["charges"] = new_charges

	if(href_list["editwarrantauth"])
		. = 1
		if(!activewarrant)
			return
		activewarrant.fields["auth"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"

	if(href_list["back"])
		. = 1
		activewarrant = null
