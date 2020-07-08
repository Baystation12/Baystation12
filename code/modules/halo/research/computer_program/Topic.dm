
/datum/nano_module/program/experimental_analyzer/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["set_screen"])
		cur_screen = text2num(href_list["set_screen"])
		return 1

	if(href_list["start_research"])
		attempt_start_selected(usr)
		return 1

	if(href_list["do_destruct"])
		analyzing_techprint = selected_techprint
		activate_destruct()
		return 1

	if(href_list["eject_destruct"])
		eject_destruct()
		return 1

	if(href_list["select_tech"])
		var/datum/techprint/T = loaded_research.techprints_by_name[href_list["select_tech"]]
		SelectTech(T, TRUE)
		return 1

	if(href_list["select_tech_future"])
		var/datum/techprint/T = loaded_research.techprints_by_name[href_list["select_tech_future"]]
		SelectTech(T, FALSE)
		return 1

	if(href_list["link_destructer"])
		autolink_destruct()
		return 1

	if(href_list["file_new"])
		save_file_as(usr, TRUE)
		return 1

	if(href_list["file_load"])
		browse_file(usr)
		return 1

	if(href_list["file_load_auto"])
		autofind_database(usr)
		return 1

	if(href_list["file_save_as"])
		save_file_as(usr)
		return 1

	if(href_list["file_merge"])
		browse_file(usr, TRUE)
		return 1

	if(href_list["file_unload"])
		unload_file(usr)
		return 1

	if(href_list["file_wipe"])
		unload_file(usr, TRUE)
		return 1

	if(href_list["transmit_designs"])
		transmit_designs(usr)
		return 1
