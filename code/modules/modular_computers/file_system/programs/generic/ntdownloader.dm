/datum/computer_file/program/ntnetdownload
	filename = "ntndownloader"
	filedesc = "NTNet Software Download Tool"
	program_icon_state = "generic"
	extended_desc = "This program allows downloads of software from official NT repositories"
	unsendable = 1
	undeletable = 1
	size = 4
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_SOFTWAREDOWNLOAD
	available_on_ntnet = 0
	nanomodule_path = /datum/nano_module/program/computer_ntnetdownload/
	ui_header = "downloader_finished.gif"
	var/datum/computer_file/program/downloaded_file = null
	var/hacked_download = 0
	var/download_completion = 0 //GQ of downloaded data.
	var/download_netspeed = 0
	var/downloaderror = ""

/datum/computer_file/program/ntnetdownload/kill_program()
	..()
	downloaded_file = null
	download_completion = 0
	download_netspeed = 0
	downloaderror = ""
	ui_header = "downloader_finished.gif"


/datum/computer_file/program/ntnetdownload/proc/begin_file_download(var/filename)
	if(downloaded_file)
		return 0

	var/datum/computer_file/program/PRG = ntnet_global.find_ntnet_file_by_name(filename)

	if(!PRG || !istype(PRG))
		return 0

	// Attempting to download antag only program, but without having emagged computer. No.
	if(PRG.available_on_syndinet && !computer_emagged)
		return 0

	if(!computer || !computer.hard_drive || !computer.hard_drive.try_store_file(PRG))
		return 0

	ui_header = "downloader_running.gif"

	if(PRG in ntnet_global.available_station_software)
		generate_network_log("Began downloading file [PRG.filename].[PRG.filetype] from NTNet Software Repository.")
		hacked_download = 0
	else if(PRG in ntnet_global.available_antag_software)
		generate_network_log("Began downloading file **ENCRYPTED**.[PRG.filetype] from unspecified server.")
		hacked_download = 1
	else
		generate_network_log("Began downloading file [PRG.filename].[PRG.filetype] from unspecified server.")
		hacked_download = 0

	downloaded_file = PRG.clone()

/datum/computer_file/program/ntnetdownload/proc/abort_file_download()
	if(!downloaded_file)
		return
	generate_network_log("Aborted download of file [hacked_download ? "**ENCRYPTED**" : downloaded_file.filename].[downloaded_file.filetype].")
	downloaded_file = null
	download_completion = 0
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/ntnetdownload/proc/complete_file_download()
	if(!downloaded_file)
		return
	generate_network_log("Completed download of file [hacked_download ? "**ENCRYPTED**" : downloaded_file.filename].[downloaded_file.filetype].")
	if(!computer || !computer.hard_drive || !computer.hard_drive.store_file(downloaded_file))
		// The download failed
		downloaderror = "I/O ERROR - Unable to save file. Check whether you have enough free space on your hard drive and whether your hard drive is properly connected. If the issue persists contact your system administrator for assistance."
	downloaded_file = null
	download_completion = 0
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/ntnetdownload/process_tick()
	if(!downloaded_file)
		return
	if(download_completion >= downloaded_file.size)
		complete_file_download()
	// Download speed according to connectivity state. NTNet server is assumed to be on unlimited speed so we're limited by our local connectivity
	download_netspeed = 0
	// Speed defines are found in misc.dm
	switch(ntnet_status)
		if(1)
			download_netspeed = NTNETSPEED_LOWSIGNAL
		if(2)
			download_netspeed = NTNETSPEED_HIGHSIGNAL
		if(3)
			download_netspeed = NTNETSPEED_ETHERNET
	download_completion += download_netspeed

/datum/computer_file/program/ntnetdownload/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["PRG_downloadfile"])
		if(!downloaded_file)
			begin_file_download(href_list["PRG_downloadfile"])
		return 1
	if(href_list["PRG_reseterror"])
		if(downloaderror)
			download_completion = 0
			download_netspeed = 0
			downloaded_file = null
			downloaderror = ""
		return 1
	return 0

/datum/nano_module/program/computer_ntnetdownload
	name = "Network Downloader"
	var/obj/item/modular_computer/my_computer = null

/datum/nano_module/program/computer_ntnetdownload/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	if(program)
		my_computer = program.computer

	if(!istype(my_computer))
		return

	var/list/data = list()
	var/datum/computer_file/program/ntnetdownload/prog = program
	// For now limited to execution by the downloader program
	if(!prog || !istype(prog))
		return
	if(program)
		data = program.get_header_data()

	// This IF cuts on data transferred to client, so i guess it's worth it.
	if(prog.downloaderror) // Download errored. Wait until user resets the program.
		data["error"] = prog.downloaderror
	else if(prog.downloaded_file) // Download running. Wait please..
		data["downloadname"] = prog.downloaded_file.filename
		data["downloaddesc"] = prog.downloaded_file.filedesc
		data["downloadsize"] = prog.downloaded_file.size
		data["downloadspeed"] = prog.download_netspeed
		data["downloadcompletion"] = round(prog.download_completion, 0.1)
	else // No download running, pick file.
		data["disk_size"] = my_computer.hard_drive.max_capacity
		data["disk_used"] = my_computer.hard_drive.used_capacity
		var/list/all_entries[0]
		for(var/datum/computer_file/program/P in ntnet_global.available_station_software)
			// Only those programs our user can run will show in the list
			if(!P.can_run(user) && P.requires_access_to_download)
				continue
			all_entries.Add(list(list(
			"filename" = P.filename,
			"filedesc" = P.filedesc,
			"fileinfo" = P.extended_desc,
			"size" = P.size
			)))
		data["hackedavailable"] = 0
		if(prog.computer_emagged) // If we are running on emagged computer we have access to some "bonus" software
			var/list/hacked_programs[0]
			for(var/datum/computer_file/program/P in ntnet_global.available_antag_software)
				data["hackedavailable"] = 1
				hacked_programs.Add(list(list(
				"filename" = P.filename,
				"filedesc" = P.filedesc,
				"fileinfo" = P.extended_desc,
				"size" = P.size
				)))
			data["hacked_programs"] = hacked_programs

		data["downloadable_programs"] = all_entries
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_downloader.tmpl", "NTNet Download Program", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
