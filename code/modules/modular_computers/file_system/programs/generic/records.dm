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
	var/list/user_access = get_record_access(user)

	data["message"] = message
	if(active_record)
		user << browse_rsc(active_record.photo_front, "front_[active_record.uid].png")
		user << browse_rsc(active_record.photo_side, "side_[active_record.uid].png")
		data["pic_edit"] = check_access(user, access_heads) 
		data["uid"] = active_record.uid
		var/list/fields = list()
		for(var/record_field/F in active_record.fields)
			if(F.can_see(user_access))
				fields.Add(list(list(
					"key" = F.type, 
					"name" = F.name, 
					"val" = F.get_display_value(), 
					"editable" = F.can_edit(user_access),
					"large" = (F.valtype == EDIT_LONGTEXT)
				)))
		data["fields"] = fields
	else
		var/list/all_records = list()

		for(var/datum/computer_file/crew_record/R in GLOB.all_crew_records)
			all_records.Add(list(list(
				"name" = R.get_name(),
				"rank" = R.get_job(),
				"milrank" = R.get_rank(),
				"id" = R.uid
			)))
		data["all_records"] = all_records
		data["creation"] = check_access(user, access_heads) 
		data["dnasearch"] = check_access(user, access_medical) 
		data["fingersearch"] = check_access(user, access_security) 

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crew_records.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/records/proc/get_record_access(var/mob/user)
	var/list/user_access = user.GetAccess()

	var/obj/item/modular_computer/PC = nano_host()
	if(istype(PC) && PC.computer_emagged)
		user_access = user_access.Copy()
		user_access |= access_syndicate
	
	return user_access

/datum/nano_module/records/proc/edit_field(var/mob/user, var/field)
	var/datum/computer_file/crew_record/R = active_record
	if(!R)
		return
	var/record_field/F = locate(field) in R.fields
	if(!F)
		return

	if(!F.can_edit(get_record_access(user)))
		to_chat(user, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return

	var/newValue
	switch(F.valtype)
		if(EDIT_SHORTTEXT)
			newValue = input(user, "Enter [F.name]:", "Record edit", html_decode(F.get_value())) as null|text
		if(EDIT_LONGTEXT)
			newValue = replacetext(input(user, "Enter [F.name]. You may use HTML paper formatting tags:", "Record edit", replacetext(html_decode(F.get_value()), "\[br\]", "\n")) as null|message, "\n", "\[br\]")
		if(EDIT_NUMERIC)
			newValue = input(user, "Enter [F.name]:", "Record edit", F.get_value()) as null|num
		if(EDIT_LIST)
			var/options = F.get_options()
			newValue = input(user,"Pick [F.name]:", "Record edit", F.get_value()) as null|anything in options

	if(active_record != R)
		return
	if(!F.can_edit(get_record_access(user)))
		to_chat(user, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return
	if(newValue)
		return F.set_value(newValue)

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
	if(href_list["new_record"])
		if(!check_access(usr, access_heads))
			to_chat(usr, "Access Denied.")
			return
		active_record = new/datum/computer_file/crew_record()
		GLOB.all_crew_records.Add(active_record)
		return 1
	if(href_list["print_active"])
		if(!active_record)
			return
		print_text(record_to_html(active_record, get_record_access(usr)), usr)
		return 1
	if(href_list["search"])
		var/field = text2path(href_list["search"])
		var/search = sanitize(input("Enter the value for search for.") as null|text)
		if(!search)
			return
		for(var/datum/computer_file/crew_record/R in GLOB.all_crew_records)
			if(lowertext(R.get_field(field)) == lowertext(search))
				active_record = R
				return 1
		message = "Unable to find record containing '[search]'"
		return 1

	var/datum/computer_file/crew_record/R = active_record
	if(!istype(R))
		return 1
	if(href_list["edit_photo_front"])
		var/photo = get_photo(usr)
		if(photo && active_record)
			active_record.photo_front = photo
		return 1
	if(href_list["edit_photo_side"])
		var/photo = get_photo(usr)
		if(photo && active_record)
			active_record.photo_side = photo
		return 1
	if(href_list["edit_field"])
		edit_field(usr, text2path(href_list["edit_field"]))
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