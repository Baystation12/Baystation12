/datum/computer_file/program/records
	filename = "crewrecords"
	filedesc = "Crew Records"
	extended_desc = "This program allows access to the crew's various records."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 14
	requires_ntnet = 1
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/records
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

/datum/nano_module/records
	name = "Crew Records"
	var/datum/computer_file/report/crew_record/active_record
	var/message = null

/datum/nano_module/records/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/user_access = get_record_access(user)

	data["message"] = message
	if(active_record)
		send_rsc(user, active_record.photo_front, "front_[active_record.uid].png")
		send_rsc(user, active_record.photo_side, "side_[active_record.uid].png")
		data["pic_edit"] = check_access(user, access_bridge) || check_access(user, access_security)
		data += active_record.generate_nano_data(user_access)
	else
		var/list/all_records = list()

		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			all_records.Add(list(list(
				"name" = R.get_name(),
				"rank" = R.get_job(),
				"milrank" = R.get_rank(),
				"id" = R.uid
			)))
		data["all_records"] = all_records
		data["creation"] = check_access(user, access_bridge)
		data["dnasearch"] = check_access(user, access_medical) || check_access(user, access_forensics_lockers)
		data["fingersearch"] = check_access(user, access_security)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crew_records.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/records/proc/get_record_access(var/mob/user)
	var/list/user_access = using_access || user.GetAccess()

	var/obj/PC = nano_host()
	var/datum/extension/interactive/ntos/os = get_extension(PC, /datum/extension/interactive/ntos)
	if(os && os.emagged())
		user_access = user_access.Copy()
		user_access |= access_syndicate

	return user_access

/datum/nano_module/records/proc/edit_field(var/mob/user, var/field_ID)
	var/datum/computer_file/report/crew_record/R = active_record
	if(!R)
		return
	var/datum/report_field/F = R.field_from_ID(field_ID)
	if(!F)
		return
	if(!F.verify_access_edit(get_record_access(user)))
		to_chat(user, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return
	F.ask_value(user)

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
		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			if(R.uid == ID)
				active_record = R
				break
		return 1
	if(href_list["new_record"])
		if(!check_access(usr, access_bridge))
			to_chat(usr, "Access Denied.")
			return
		active_record = new/datum/computer_file/report/crew_record()
		GLOB.all_crew_records.Add(active_record)
		return 1
	if(href_list["print_active"])
		if(!active_record)
			return
		print_text(record_to_html(active_record, get_record_access(usr)), usr)
		return 1
	if(href_list["search"])
		var/field_name = href_list["search"]
		var/search = sanitize(input("Enter the value for search for.") as null|text)
		if(!search)
			return
		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			var/datum/report_field/field = R.field_from_name(field_name)
			if(findtext(lowertext(field.get_value()), lowertext(search)))
				active_record = R
				return 1
		message = "Unable to find record containing '[search]'"
		return 1

	var/datum/computer_file/report/crew_record/R = active_record
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
		edit_field(usr, text2num(href_list["edit_field"]))
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
