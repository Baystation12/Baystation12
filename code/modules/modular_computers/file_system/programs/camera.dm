// Returns which access is relevant to passed network. Used by the program.
/proc/get_camera_access(var/network)
	if(!network)
		return 0

	if(network in engineering_networks)
		return access_engine

	switch(network)
		if(NETWORK_MEDICAL)
			return access_medical
		if(NETWORK_RESEARCH || NETWORK_RESEARCH_OUTPOST)
			return access_research
		if(NETWORK_MINE || NETWORK_SUPPLY)
			return access_mailsorting // Cargo office - all cargo staff should have access here.

	return access_security

/datum/computer_file/program/camera_monitor
	filename = "cammon"
	filedesc = "Camera Monitoring"
	nanomodule_path = /datum/nano_module/program/camera_monitor
	program_icon_state = "generic"
	extended_desc = "This program allows remote access to station's camera system. Some camera networks may have additional access requirements."
	size = 12
	available_on_ntnet = 1

/datum/nano_module/program/camera_monitor
	name = "Camera Monitoring program"
	var/obj/machinery/camera/current_camera = null
	var/current_network = null

/datum/nano_module/program/camera_monitor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/list/data = host.initial_data()

	data["current_camera"] = current_camera ? current_camera.nano_structure() : null
	data["current_network"] = current_network

	var/list/all_networks[0]
	for(var/network in using_map.station_networks)
		all_networks.Add(list(list(
							"tag" = network,
							"has_access" = can_access_network(usr, get_camera_access(network))
							)))

	if(current_network)
		data["cameras"] = camera_repository.cameras_in_network(current_network)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sec_camera.tmpl", "Camera Monitoring", 900, 800)
		// ui.auto_update_layout = 1 // Disabled as with suit sensors monitor - breaks the UI map. Re-enable once it's fixed somehow.

		ui.add_template("mapContent", "sec_camera_map_content.tmpl")
		ui.add_template("mapHeader", "sec_camera_map_header.tmpl")
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/camera_monitor/proc/can_access_network(var/mob/user, var/network_access)
	if(!program)
		return 0
	return program.can_run(user, 0, access_security) || program.can_run(user, 0, network_access)

/datum/nano_module/program/camera_monitor/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["switch_camera"])
		var/obj/machinery/camera/C = locate(href_list["switch_camera"]) in cameranet.cameras
		if(!C)
			return
		if(!(current_network in C.network))
			return

		switch_to_camera(usr, C)
		return 1

	else if(href_list["switch_network"])
		if(!(href_list["switch_network"] in using_map.station_networks) || !program)
			return

		// Either security access, or access to the specific camera network's department is required in order to access the network.
		if(can_access_network(usr, get_camera_access(href_list["switch_network"])))
			current_network = href_list["switch_network"]
		else
			usr << "\The [program.computer] shows an \"Network Access Denied\" error message."
		return 1

	else if(href_list["reset"])
		reset_current()
		usr.reset_view(current_camera)
		return 1

/datum/nano_module/program/camera_monitor/proc/switch_to_camera(var/mob/user, var/obj/machinery/camera/C)
	//don't need to check if the camera works for AI because the AI jumps to the camera location and doesn't actually look through cameras.
	if(isAI(user))
		var/mob/living/silicon/ai/A = user
		// Only allow non-carded AIs to view because the interaction with the eye gets all wonky otherwise.
		if(!A.is_in_chassis())
			return 0

		A.eyeobj.setLoc(get_turf(C))
		A.client.eye = A.eyeobj
		return 1

	set_current(C)
	user.machine = nano_host()
	user.reset_view(C)
	return 1

/datum/nano_module/program/camera_monitor/proc/set_current(var/obj/machinery/camera/C)
	if(current_camera == C)
		return

	if(current_camera)
		reset_current()

	current_camera = C
	if(current_camera)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_initiated()

/datum/nano_module/program/camera_monitor/proc/reset_current()
	if(current_camera)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_cancelled()
	current_camera = null

/datum/nano_module/program/camera_monitor/check_eye(var/mob/user as mob)
	if(!current_camera)
		return 0
	var/viewflag = current_camera.check_eye(user)
	if ( viewflag < 0 ) //camera doesn't work
		reset_current()
	return viewflag