/datum/computer_file/program/card_mod
	filename = "cardmod"
	filedesc = "ID card modification program"
	nanomodule_path = /datum/nano_module/program/card_mod
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for programming crew ID cards."
	required_access = access_change_ids
	requires_ntnet = 0
	size = 8

/datum/nano_module/program/card_mod
	name = "ID card modification program"
	var/mod_mode = 1
	var/is_centcom = 0
	var/show_assignments = 0

/datum/nano_module/program/card_mod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["src"] = "\ref[src]"
	data["station_name"] = station_name()
	data["manifest"] = html_crew_manifest()
	data["assignments"] = show_assignments
	if(program && program.computer)
		data["have_id_slot"] = !!program.computer.card_slot
		data["have_printer"] = !!program.computer.nano_printer
		data["authenticated"] = program.can_run(user)
		if(!program.computer.card_slot || !program.computer.card_slot.can_write)
			mod_mode = 0 //We can't modify IDs when there is no card reader
	else
		data["have_id_slot"] = 0
		data["have_printer"] = 0
		data["authenticated"] = 0
	data["mmode"] = mod_mode
	data["centcom_access"] = is_centcom

	if(program && program.computer && program.computer.card_slot)
		var/obj/item/weapon/card/id/id_card = program.computer.card_slot.stored_card
		data["has_id"] = !!id_card
		data["id_account_number"] = id_card ? id_card.associated_account_number : null
		data["id_email_login"] = id_card ? id_card.associated_email_login["login"] : null
		data["id_email_password"] = id_card ? stars(id_card.associated_email_login["password"], 0) : null
		data["id_rank"] = id_card && id_card.assignment ? id_card.assignment : "Unassigned"
		data["id_owner"] = id_card && id_card.registered_name ? id_card.registered_name : "-----"
		data["id_name"] = id_card ? id_card.name : "-----"

	data["command_jobs"] = format_jobs(GLOB.command_positions)
	data["support_jobs"] = format_jobs(GLOB.support_positions)
	data["engineering_jobs"] = format_jobs(GLOB.engineering_positions)
	data["medical_jobs"] = format_jobs(GLOB.medical_positions)
	data["science_jobs"] = format_jobs(GLOB.science_positions)
	data["security_jobs"] = format_jobs(GLOB.security_positions)
	data["exploration_jobs"] = format_jobs(GLOB.exploration_positions)
	data["service_jobs"] = format_jobs(GLOB.service_positions)
	data["supply_jobs"] = format_jobs(GLOB.supply_positions)
	data["civilian_jobs"] = format_jobs(GLOB.civilian_positions)
	data["centcom_jobs"] = format_jobs(get_all_centcom_jobs())

	data["all_centcom_access"] = is_centcom ? get_accesses(1) : null
	data["regions"] = get_accesses()

	if(program.computer.card_slot && program.computer.card_slot.stored_card)
		var/obj/item/weapon/card/id/id_card = program.computer.card_slot.stored_card
		if(is_centcom)
			var/list/all_centcom_access = list()
			for(var/access in get_all_centcom_access())
				all_centcom_access.Add(list(list(
					"desc" = replacetext(get_centcom_access_desc(access), " ", "&nbsp"),
					"ref" = access,
					"allowed" = (access in id_card.access) ? 1 : 0)))
			data["all_centcom_access"] = all_centcom_access
		else
			var/list/regions = list()
			for(var/i = 1; i <= 7; i++)
				var/list/accesses = list()
				for(var/access in get_region_accesses(i))
					if (get_access_desc(access))
						accesses.Add(list(list(
							"desc" = replacetext(get_access_desc(access), " ", "&nbsp"),
							"ref" = access,
							"allowed" = (access in id_card.access) ? 1 : 0)))

				regions.Add(list(list(
					"name" = get_region_accesses_name(i),
					"accesses" = accesses)))
			data["regions"] = regions

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "identification_computer.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/card_mod/proc/format_jobs(list/jobs)
	var/obj/item/weapon/card/id/id_card = program.computer.card_slot ? program.computer.card_slot.stored_card : null
	var/list/formatted = list()
	for(var/job in jobs)
		formatted.Add(list(list(
			"display_name" = replacetext(job, " ", "&nbsp"),
			"target_rank" = id_card && id_card.assignment ? id_card.assignment : "Unassigned",
			"job" = job)))

	return formatted

/datum/nano_module/program/card_mod/proc/get_accesses(var/is_centcom = 0)
	return null


/datum/computer_file/program/card_mod/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	var/obj/item/weapon/card/id/id_card
	if (computer.card_slot)
		id_card = computer.card_slot.stored_card

	var/datum/nano_module/program/card_mod/module = NM
	switch(href_list["action"])
		if("switchm")
			if(href_list["target"] == "mod")
				module.mod_mode = 1
			else if (href_list["target"] == "manifest")
				module.mod_mode = 0
		if("togglea")
			if(module.show_assignments)
				module.show_assignments = 0
			else
				module.show_assignments = 1
		if("print")
			if(computer && computer.nano_printer) //This option should never be called if there is no printer
				if(module.mod_mode)
					if(can_run(user, 1))
						var/contents = {"<h4>Access Report</h4>
									<u>Prepared By:</u> [user_id_card.registered_name ? user_id_card.registered_name : "Unknown"]<br>
									<u>For:</u> [id_card.registered_name ? id_card.registered_name : "Unregistered"]<br>
									<hr>
									<u>Assignment:</u> [id_card.assignment]<br>
									<u>Account Number:</u> #[id_card.associated_account_number]<br>
									<u>Email account:</u> [id_card.associated_email_login["login"]]
									<u>Email password:</u> [stars(id_card.associated_email_login["password"], 0)]
									<u>Blood Type:</u> [id_card.blood_type]<br><br>
									<u>Access:</u><br>
								"}

						var/known_access_rights = get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)
						for(var/A in id_card.access)
							if(A in known_access_rights)
								contents += "  [get_access_desc(A)]"

						if(!computer.nano_printer.print_text(contents,"access report"))
							to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
							return
						else
							computer.visible_message("<span class='notice'>\The [computer] prints out paper.</span>")
				else
					var/contents = {"<h4>Crew Manifest</h4>
									<br>
									[html_crew_manifest()]
									"}
					if(!computer.nano_printer.print_text(contents,text("crew manifest ([])", stationtime2text())))
						to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
						return
					else
						computer.visible_message("<span class='notice'>\The [computer] prints out paper.</span>")
		if("eject")
			if(computer)
				if(computer.card_slot && computer.card_slot.stored_card)
					computer.proc_eject_id(user)
				else
					computer.attackby(user.get_active_hand(), user)
		if("terminate")
			if(computer && can_run(user, 1))
				id_card.assignment = "Terminated"
				remove_nt_access(id_card)
				callHook("terminate_employee", list(id_card))
		if("edit")
			if(computer && can_run(user, 1))
				if(href_list["name"])
					var/temp_name = sanitizeName(input("Enter name.", "Name", id_card.registered_name),allow_numbers=TRUE)
					if(temp_name)
						id_card.registered_name = temp_name
					else
						computer.visible_message("<span class='notice'>[computer] buzzes rudely.</span>")
				else if(href_list["account"])
					var/account_num = text2num(input("Enter account number.", "Account", id_card.associated_account_number))
					id_card.associated_account_number = account_num
				else if(href_list["elogin"])
					var/email_login = input("Enter email login.", "Email login", id_card.associated_email_login["login"])
					id_card.associated_email_login["login"] = email_login
				else if(href_list["epswd"])
					var/email_password = input("Enter email password.", "Email password")
					id_card.associated_email_login["password"] = email_password
		if("assign")
			if(computer && can_run(user, 1) && id_card)
				var/t1 = href_list["assign_target"]
				if(t1 == "Custom")
					var/temp_t = sanitize(input("Enter a custom job assignment.","Assignment", id_card.assignment), 45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t)
						id_card.assignment = temp_t
				else
					var/list/access = list()
					if(module.is_centcom)
						access = get_centcom_access(t1)
					else
						var/datum/job/jobdatum
						for(var/jobtype in typesof(/datum/job))
							var/datum/job/J = new jobtype
							if(ckey(J.title) == ckey(t1))
								jobdatum = J
								break
						if(!jobdatum)
							to_chat(usr, "<span class='warning'>No log exists for this job: [t1]</span>")
							return

						access = jobdatum.get_access()

					remove_nt_access(id_card)
					apply_access(id_card, access)
					id_card.assignment = t1
					id_card.rank = t1

				callHook("reassign_employee", list(id_card))
		if("access")
			if(href_list["allowed"] && computer && can_run(user, 1))
				var/access_type = text2num(href_list["access_target"])
				var/access_allowed = text2num(href_list["allowed"])
				if(access_type in get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM))
					id_card.access -= access_type
					if(!access_allowed)
						id_card.access += access_type
	if(id_card)
		id_card.SetName(text("[id_card.registered_name]'s ID Card ([id_card.assignment])"))

	GLOB.nanomanager.update_uis(NM)
	return 1

/datum/computer_file/program/card_mod/proc/remove_nt_access(var/obj/item/weapon/card/id/id_card)
	id_card.access -= get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)

/datum/computer_file/program/card_mod/proc/apply_access(var/obj/item/weapon/card/id/id_card, var/list/accesses)
	id_card.access |= accesses
