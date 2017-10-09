#define EDIT_SHORTTEXT 1	// Short (single line) text input field
#define EDIT_LONGTEXT 2		// Long (multi line, papercode tag formattable) text input field
#define EDIT_NUMERIC 3		// Single-line number input field
#define EDIT_LIST 4			// Option select dialog

/datum/computer_file/program/records
	filename = "crewrecords"
	filedesc = "Crew Records"
	extended_desc = "This program allows access to the crew's various records."
	program_icon_state = "generic"
	size = 14
	requires_ntnet = 1
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/records

/datum/nano_module/records
	name = "Crew Records"
	var/datum/computer_file/crew_record/active_record
	var/message = null

/datum/nano_module/records/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/obj/item/modular_computer/PC = nano_host()

	var/access_med = check_access(user, access_medical)
	var/access_sec = check_access(user, access_security)
	var/access_empl = check_access(user, access_heads)
	var/access_antag = FALSE
	if(istype(PC) && PC.computer_emagged)
		access_antag = TRUE

	data["message"] = message
	data["has_med"] = access_med
	data["has_sec"] = access_sec
	data["has_empl"] = access_empl
	data["has_antag"] = access_antag
	if(active_record)
		user << browse_rsc(active_record.photo_front, "front_[active_record.uid].png")
		user << browse_rsc(active_record.photo_side, "side_[active_record.uid].png")
		data["uid"] = active_record.uid
		data["name"] = active_record.GetName()
		data["position"] = active_record.GetPosition()
		data["sex"] = active_record.GetSex()
		data["age"] = active_record.GetAge()
		data["status"] = active_record.GetStatus()
		data["species"] = active_record.GetSpecies()
		data["branch"] = active_record.GetBranch()
		data["rank"] = active_record.GetRank()
		// Actually transmit only the data the client can access, to prevent exploits.
		if(access_med)
			data["bloodtype"] = active_record.GetBloodtype()
			data["medrecord"] = pencode2html(active_record.GetMedRecord())
		if(access_sec)
			data["dna"] = active_record.GetDna()
			data["criminalstatus"] = active_record.GetCriminalStatus()
			data["fingerprint"] = active_record.GetFingerprint()
			data["secrecord"] = pencode2html(active_record.GetSecRecord())
		if(access_empl)
			data["emplrecord"] = pencode2html(active_record.GetEmplRecord())
			data["home_system"] = active_record.GetHomeSystem()
			data["citizenship"] = active_record.GetCitizenship()
			data["faction"] = active_record.GetFaction()
			data["religion"] = active_record.GetReligion()
		if(access_antag)
			data["antagrecord"] = pencode2html(active_record.GetAntagRecord())
	else
		var/list/all_records = list()

		for(var/datum/computer_file/crew_record/R in GLOB.all_crew_records)
			all_records.Add(list(list(
				"name" = R.GetName(),
				"rank" = R.GetPosition(),
				"milrank" = R.GetRank(),
				"id" = R.uid
			)))
		data["all_records"] = all_records

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crew_records.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/records/proc/edit_field(var/original_value, var/field_name, var/access_requirement, var/mode, var/list/options = null)
	if(!check_access(usr, access_requirement))
		to_chat(usr, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return

	var/datum/computer_file/crew_record/R = active_record
	if(!R)
		return null

	var/newValue = null
	switch(mode)
		if(EDIT_SHORTTEXT)
			newValue = sanitize(input(usr, "Enter [field_name]:", "Record edit", html_decode(original_value)) as null|text)
		if(EDIT_LONGTEXT)
			newValue = sanitize(replacetext(input(usr, "Enter [field_name]. You may use HTML paper formatting tags:", "Record edit", replacetext(html_decode(original_value), "\[br\]", "\n")) as null|message, "\n", "\[br\]"))
		if(EDIT_NUMERIC)
			newValue = input(usr, "Enter [field_name]:", "Record edit", original_value) as null|num
		if(EDIT_LIST)
			if(!options)
				CRASH("No list of options available for list selection edit type.")
			newValue = input("Pick [field_name]:", "Record edit", original_value) as null|anything in options

	if(!check_access(usr, access_requirement))
		to_chat(usr, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return null
	if(!newValue)
		return null
	if(active_record != R)
		return null
	return newValue

/datum/nano_module/records/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["clear_active"])
		active_record = null
		return 1
	if(href_list["clear_message"])
		message = null
		return 1
	if(href_list["set_active"])
		var/ID = text2num(href_list["set_active"])
		for(var/datum/computer_file/crew_record/R in GLOB.all_crew_records)
			if(R.uid == ID)
				active_record = R
				break
		return 1

	var/access_med = check_access(usr, access_medical)
	var/access_sec = check_access(usr, access_security)
	var/access_empl = check_access(usr, access_heads)		// Both for editing of Generic and Employment fields

	if(href_list["new_record"])
		if(!access_empl)
			to_chat(usr, "Access Denied.")
			return
		active_record = new/datum/computer_file/crew_record()
		GLOB.all_crew_records.Add(active_record)
		return 1
	if(href_list["print_active"])
		if(!active_record)
			return
		print_text(record_to_html(active_record, access_med, access_empl, access_sec), usr)
		return 1
	if(href_list["name_search"])
		var/name = sanitize(input("Enter full name for search.") as null|text)
		if(!name)
			return
		for(var/datum/computer_file/crew_record/R in GLOB.all_crew_records)
			if(lowertext(R.GetName()) == lowertext(name))
				active_record = R
				return 1
		message = "Unable to find record for name '[name]'"
		return 1
	if(href_list["dna_search"])
		if(!access_sec)
			to_chat(usr, "Access Denied.")
			return
		var/dna_hash = sanitize(input("Enter DNA hash for search.") as null|text)
		if(!dna_hash)
			return
		for(var/datum/computer_file/crew_record/R in GLOB.all_crew_records)
			if(lowertext(R.GetDna()) == lowertext(dna_hash))
				active_record = R
				return 1
		message = "Unable to find DNA hash '[dna_hash]'"
		return 1
	if(href_list["fingerprint_search"])
		if(!access_sec)
			to_chat(usr, "Access Denied.")
			return
		var/fingerprint_hash = sanitize(input("Enter fingerprint hash for search.") as null|text)
		if(!fingerprint_hash)
			return
		for(var/datum/computer_file/crew_record/R in GLOB.all_crew_records)
			if(lowertext(R.GetFingerprint()) == lowertext(fingerprint_hash))
				active_record = R
				return 1
		message = "Unable to find fingerprint hash '[fingerprint_hash]'"
		return 1

	var/datum/computer_file/crew_record/R = active_record
	if(!istype(R))
		return 1

	// Generic records editing
	if(href_list["edit_photo_front"])
		var/photo = get_photo(usr)
		if(photo && active_record && access_empl)
			active_record.photo_front = photo
		return 1
	if(href_list["edit_photo_side"])
		var/photo = get_photo(usr)
		if(photo && active_record && access_empl)
			active_record.photo_side = photo
		return 1

	if(href_list["edit_name"])
		var/newValue = edit_field(R.GetName(), "name", access_heads, EDIT_SHORTTEXT)
		if(newValue)
			R.SetName(newValue)
		return 1
	if(href_list["edit_sex"])
		var/list/genders = list()
		genders |= "Unset"
		for(var/G in gender_datums)
			genders |= gender2text(G)
		var/newValue = edit_field(R.GetSex(), "sex", access_heads, EDIT_LIST, genders)
		if(newValue)
			R.SetSex(newValue)
		return 1
	if(href_list["edit_age"])
		var/newValue = edit_field(R.GetAge(), "age", access_heads, EDIT_NUMERIC)
		if(newValue)
			R.SetAge(newValue)
		return 1
	if(href_list["edit_species"])
		var/newValue = edit_field(R.GetSpecies(), "species", access_heads, EDIT_SHORTTEXT)
		if(newValue)
			R.SetSpecies(newValue)
		return 1
	if(href_list["edit_position"])
		var/newValue = edit_field(R.GetPosition(), "position", access_heads, EDIT_SHORTTEXT)
		if(newValue)
			R.SetPosition(newValue)
		return 1
	if(href_list["edit_branch"])
		var/list/choices = list()
		choices |= "Unset"
		for(var/B in mil_branches.branches)
			var/datum/mil_branch/BR = mil_branches.branches[B]
			choices |= BR.name
		var/newValue = edit_field(R.GetBranch(), "branch", access_heads, EDIT_LIST, choices)
		if(newValue)
			if(R.GetBranch() != newValue)
				R.SetBranch(newValue)
				R.SetRank("Unset")
		return 1
	if(href_list["edit_rank"])
		if(!R.GetBranch() || R.GetBranch() == "Unset")
			to_chat(usr, "Rank may only be set when a branch is selected.")
			return 1
		var/datum/mil_branch/branch = mil_branches.get_branch(R.GetBranch())
		if(!branch)
			to_chat(usr, "Incorrect branch is set. Check records for corruption.")
			return 1
		var/list/choices = list()
		choices |= "Unset"
		for(var/rank in branch.ranks)
			var/datum/mil_rank/RA = branch.ranks[rank]
			choices |= RA.name
		var/newValue = edit_field(R.GetRank(), "rank", access_heads, EDIT_LIST, choices)
		if(newValue)
			R.SetRank(newValue)
		return 1

	// Medical record editing
	// Technically speaking, status is part of common crew record (so it's publicly viewable) but we want doctors to be able to edit it so it's here.
	if(href_list["edit_status"])
		var/newValue = edit_field(R.GetStatus(), "status", access_medical, EDIT_LIST, GLOB.physical_statuses)
		if(newValue)
			R.SetStatus(newValue)
		return 1
	if(href_list["edit_bloodtype"])
		var/newValue = edit_field(R.GetBloodtype(), "blood type", access_medical, EDIT_LIST, GLOB.blood_types)
		if(newValue)
			R.SetBloodtype(newValue)
		return 1
	if(href_list["edit_medrecord"])
		var/newValue = edit_field(R.GetMedRecord(), "medical record", access_medical, EDIT_LONGTEXT)
		if(newValue)
			R.SetMedRecord(newValue)
		return 1

	// Security record editing
	if(href_list["edit_criminalstatus"])
		var/newValue = edit_field(R.GetCriminalStatus(), "criminal status", access_security, EDIT_LIST, GLOB.security_statuses)
		if(newValue)
			R.SetSecRecord(newValue)
		return 1
	if(href_list["edit_dna"])
		var/newValue = edit_field(R.GetDna(), "DNA", access_security, EDIT_SHORTTEXT)
		if(newValue)
			R.SetDna(newValue)
		return 1
	if(href_list["edit_fingerprint"])
		var/newValue = edit_field(R.GetFingerprint(), "fingerprint", access_security, EDIT_SHORTTEXT)
		if(newValue)
			R.SetFingerprint(newValue)
		return 1
	if(href_list["edit_secrecord"])
		var/newValue = edit_field(R.GetSecRecord(), "security record", access_security, EDIT_LONGTEXT)
		if(newValue)
			R.SetSecRecord(newValue)
		return 1

	// Employment record editing
	if(href_list["edit_homesystem"])
		var/newValue = edit_field(R.GetHomeSystem(), "home system", access_heads, EDIT_SHORTTEXT)
		if(newValue)
			R.SetHomeSystem(newValue)
		return 1
	if(href_list["edit_citizenship"])
		var/newValue = edit_field(R.GetCitizenship(), "citizenship", access_heads, EDIT_SHORTTEXT)
		if(newValue)
			R.SetCitizenship(newValue)
		return 1
	if(href_list["edit_faction"])
		var/newValue = edit_field(R.GetFaction(), "faction", access_heads, EDIT_SHORTTEXT)
		if(newValue)
			R.SetFaction(newValue)
		return 1
	if(href_list["edit_religion"])
		var/newValue = edit_field(R.GetReligion(), "religion", access_heads, EDIT_SHORTTEXT)
		if(newValue)
			R.SetReligion(newValue)
		return 1
	if(href_list["edit_emplrecord"])
		var/newValue = edit_field(R.GetEmplRecord(), "employment record", access_heads, EDIT_LONGTEXT)
		if(newValue)
			R.SetEmplRecord(newValue)
		return 1

/datum/nano_module/records/proc/get_photo(var/mob/user)
	if(istype(user.get_active_hand(), /obj/item/weapon/photo))
		var/obj/item/weapon/photo/photo = user.get_active_hand()
		return photo.img
	if(istype(user, /mob/living/silicon))
		var/mob/living/silicon/tempAI = usr
		var/obj/item/weapon/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img

#undef EDIT_SHORTTEXT
#undef EDIT_LONGTEXT
#undef EDIT_NUMERIC
#undef EDIT_LIST