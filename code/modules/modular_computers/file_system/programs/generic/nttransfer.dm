var/global/nttransfer_uid = 0

/datum/computer_file/program/nttransfer
	filename = "nttransfer"
	filedesc = "NTNet P2P Transfer Client"
	extended_desc = "This program allows for simple file transfer via direct peer to peer connection."
	program_icon_state = "comm_logs"
	program_key_state = "generic_key"
	program_menu_icon = "transferthick-e-w"
	size = 7
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_PEERTOPEER
	network_destination = "other device via P2P tunnel"
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_nttransfer
	category = PROG_UTIL

	/// Error message
	var/error = ""
	/// Optional password to download the file.
	var/server_password = ""
	/// File which is provided to clients.
	var/datum/computer_file/provided_file = null
	/// File which is being downloaded
	var/datum/computer_file/downloaded_file = null
	/// List of connected clients.
	var/list/connected_clients = list()
	/// Client var, specifies who are we downloading from.
	var/datum/computer_file/program/nttransfer/remote
	/// Download progress in GQ
	var/download_completion = 0
	/// Displayed in the UI, this is the actual transfer speed.
	var/actual_netspeed = 0
	/// UID of this program
	var/unique_token
	/// Whether we show the program list and upload menu
	var/upload_menu = FALSE

/datum/computer_file/program/nttransfer/New()
	unique_token = nttransfer_uid
	nttransfer_uid++
	..()

/datum/computer_file/program/nttransfer/process_tick()
	..()
	// Server mode
	if(provided_file)
		for(var/datum/computer_file/program/nttransfer/C in connected_clients)
			// Transfer speed is limited by device which uses slower connectivity.
			// We can have multiple clients downloading at same time, but let's assume we use some sort of multicast transfer
			// so they can all run on same speed.
			C.actual_netspeed = min(C.get_ntnet_speed(), get_ntnet_speed())
			C.download_completion += C.actual_netspeed
			if(C.download_completion >= provided_file.size)
				C.finish_download()
	else if(downloaded_file) // Client mode
		if(!remote)
			crash_download("Connection to remote server lost")

/// Returns the current ntnet speed of the computer the program is running on. NTTransfer needs to be able to get the speed from instances on other computers.
/datum/computer_file/program/nttransfer/proc/get_ntnet_speed()
	if(computer)
		return computer.get_ntnet_speed(computer.get_ntnet_status())
	return 0

/datum/computer_file/program/nttransfer/on_shutdown(forced = FALSE)
	if(downloaded_file) // Client mode, clean up variables for next use
		finalize_download()

	if(provided_file) // Server mode, disconnect all clients
		for(var/datum/computer_file/program/nttransfer/P in connected_clients)
			P.crash_download("Connection terminated by remote server")
		downloaded_file = null
	..(forced)

/// Finishes download and attempts to store the file on HDD
/datum/computer_file/program/nttransfer/proc/finish_download()
	if(!computer || !computer.create_file(downloaded_file))
		error = "I/O Error: Unable to save file. Check your hard drive and try again."
	finalize_download()

/// Crashes the download and displays specific error message
/datum/computer_file/program/nttransfer/proc/crash_download(message)
	error = message ? message : "An unknown error has occured during download"
	finalize_download()

/// Cleans up variables for next use
/datum/computer_file/program/nttransfer/proc/finalize_download()
	if(remote)
		remote.connected_clients.Remove(src)
	downloaded_file = null
	remote = null
	download_completion = 0


/datum/nano_module/program/computer_nttransfer
	name = "NTNet P2P Transfer Client"

/datum/nano_module/program/computer_nttransfer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	if(!program)
		return
	var/datum/computer_file/program/nttransfer/PRG = program
	if(!istype(PRG))
		return

	var/list/data = program.get_header_data()

	if(PRG.error)
		data["error"] = PRG.error
	else if(PRG.downloaded_file)
		data["downloading"] = TRUE
		data["download_size"] = PRG.downloaded_file.size
		data["download_progress"] = PRG.download_completion
		data["download_netspeed"] = PRG.actual_netspeed
		data["download_name"] = "[PRG.downloaded_file.filename].[PRG.downloaded_file.filetype]"
	else if (PRG.provided_file)
		data["uploading"] = TRUE
		data["upload_uid"] = PRG.unique_token
		data["upload_clients"] = PRG.connected_clients.len
		data["upload_haspassword"] = PRG.server_password ? TRUE : FALSE
		data["upload_filename"] = "[PRG.provided_file.filename].[PRG.provided_file.filetype]"
	else if (PRG.upload_menu)
		var/list/all_files[0]
		for(var/datum/computer_file/F in PRG.computer.get_all_files())
			all_files.Add(list(list(
				"uid" = F.uid,
				"filename" = "[F.filename].[F.filetype]",
				"size" = F.size
			)))
		data["upload_filelist"] = all_files
	else
		var/list/all_servers[0]
		for(var/datum/computer_file/program/nttransfer/P in ntnet_global.fileservers)
			if(!P.provided_file)
				continue
			all_servers.Add(list(list(
				"uid" = P.unique_token,
				"filename" = "[P.provided_file.filename].[P.provided_file.filetype]",
				"size" = P.provided_file.size,
				"haspassword" = P.server_password ? TRUE : FALSE
			)))
		data["servers"] = all_servers

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_transfer.tmpl", "NTNet P2P Transfer Client", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/computer_file/program/nttransfer/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["PRG_downloadfile"])
		. = TOPIC_HANDLED
		for(var/datum/computer_file/program/nttransfer/P in ntnet_global.fileservers)
			if("[P.unique_token]" == href_list["PRG_downloadfile"])
				remote = P
				break
		if(!remote || !remote.provided_file)
			return
		if(remote.server_password)
			var/pass = sanitize(input(usr, "Code 401 Unauthorized. Please enter password:", "Password required"))
			if(pass != remote.server_password)
				error = "Incorrect Password"
				return
		downloaded_file = remote.provided_file.clone()
		remote.connected_clients.Add(src)
		return
	if(href_list["PRG_reset"])
		. = TOPIC_HANDLED
		error = ""
		upload_menu = FALSE
		finalize_download()
		if(src in ntnet_global.fileservers)
			ntnet_global.fileservers.Remove(src)
		for(var/datum/computer_file/program/nttransfer/T in connected_clients)
			T.crash_download("Remote server has forcibly closed the connection")
		provided_file = null
		return
	if(href_list["PRG_setpassword"])
		. = TOPIC_HANDLED
		var/pass = sanitize(input(usr, "Enter new server password. Leave blank to cancel, input 'none' to disable password.", "Server security", "none"))
		if(!pass)
			return
		if(pass == "none")
			server_password = ""
			return
		server_password = pass
		return
	if(href_list["PRG_uploadfile"])
		. = TOPIC_HANDLED
		for(var/datum/computer_file/F in computer.get_all_files())
			if("[F.uid]" == href_list["PRG_uploadfile"])
				if(F.unsendable)
					error = "I/O Error: File locked."
					return
				provided_file = F
				ntnet_global.fileservers.Add(src)
				return
		error = "I/O Error: Unable to locate file on hard drive."
		return
	if(href_list["PRG_uploadmenu"])
		upload_menu = TRUE
		return TOPIC_HANDLED
	return TOPIC_NOACTION
