/*
	Camera monitoring computers

	NOTE: If we actually split the station camera network into regions that will help with sorting through the
	tediously large list of cameras.  The new camnet_key architecture lets you switch between keys easily,
	so you don't lose the capability of seeing everything, you just switch to a subnet.
*/

/obj/machinery/computer3/security
	default_prog		= /datum/file/program/security
	spawn_parts			= list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/networking/cameras)
	spawn_files 		= list(/datum/file/camnet_key)
	icon_state			= "frame-sec"


/obj/machinery/computer3/security/wooden_tv
	name				= "security cameras"
	desc				= "An old TV hooked into the stations camera network."
	icon				= 'icons/obj/computer.dmi'
	icon_state			= "security_det"

	legacy_icon			= 1
	allow_disassemble	= 0

	// No operating system
	New()
		..(built=0)
		os = program
		circuit.OS = os


/obj/machinery/computer3/security/mining
	name = "Outpost Cameras"
	desc = "Used to access the various cameras on the outpost."
	spawn_files 		= list(/datum/file/camnet_key/mining)

/*
	Camera monitoring computers, wall-mounted
*/
/obj/machinery/computer3/wall_comp/telescreen
	default_prog		= /datum/file/program/security
	spawn_parts			= list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/networking/cameras)
	spawn_files 		= list(/datum/file/camnet_key)

/obj/machinery/computer3/wall_comp/telescreen/entertainment
	desc = "Damn, they better have /tg/thechannel on these things."
	spawn_files 		= list(/datum/file/camnet_key/entertainment)


/*
	File containing an encrypted camera network key.

	(Where by encrypted I don't actually mean encrypted at all)
*/
/datum/file/camnet_key
	name = "Security Camera Network Main Key"
	var/title = "Station"
	var/desc = "Connects to station security cameras."
	var/networks = list("ALL") // A little workaround as it is not possible to place station_networks here
	var/screen = "cameras"

	execute(var/datum/file/source)
		if(istype(source,/datum/file/program/security))
			var/datum/file/program/security/prog = source
			prog.key = src
			prog.camera_list = null
			return
		if(istype(source,/datum/file/program/ntos))
			for(var/obj/item/part/computer/storage/S in list(computer.hdd,computer.floppy))
				for(var/datum/file/F in S.files)
					if(istype(F,/datum/file/program/security))
						var/datum/file/program/security/Sec = F
						Sec.key = src
						Sec.camera_list = null
						Sec.execute(source)
						return
		computer.Crash(MISSING_PROGRAM)

/datum/file/camnet_key/New()
	for(var/N in networks)
		if(N == "ALL")
			networks = station_networks
			break
	return ..()

/datum/file/camnet_key/mining
	name = "Mining Camera Network Key"
	title = "mining station"
	desc = "Connects to mining security cameras."
	networks = list(NETWORK_MINE)
	screen = "miningcameras"

/datum/file/camnet_key/research
	name = "Research Camera Network Key"
	title = "research"
	networks = list(NETWORK_RESEARCH)

/datum/file/camnet_key/bombrange
	name = "R&D Bomb Range Camera Network Key"
	title = "bomb range"
	desc = "Monitors the bomb range."
	networks = list(NETWORK_RESEARCH)

/datum/file/camnet_key/xeno
	name = "R&D Misc. Research Camera Network Key"
	title = "special research"
	networks = list(NETWORK_RESEARCH)

/datum/file/camnet_key/singulo
	name = "Singularity Camera Network Key"
	title = "singularity"
	networks = list(NETWORK_ENGINE)

/datum/file/camnet_key/entertainment
	name = "Entertainment Channel Encryption Key"
	title = "entertainment"
	desc = "Damn, I hope they have /tg/thechannel on here."
	networks = list(NETWORK_THUNDER)
	screen = "entertainment"

/datum/file/camnet_key/creed
	name = "Special Ops Camera Encryption Key"
	title = "special ops"
	desc = "Connects to special ops secure camera feeds."
	networks = list(NETWORK_ERT)

/datum/file/camnet_key/prison
	name = "Prison Camera Network Key"
	title = "prison"
	desc = "Monitors the prison."
	networks = list(NETWORK_SECURITY)

/datum/file/camnet_key/syndicate
	name = "Camera Network Key"
	title = "%!#BUFFER OVERFLOW"
	desc = "Connects to security cameras."
	networks = list("ALL")
	hidden_file = 1


/*
	Computer part needed to connect to cameras
*/

/obj/item/part/computer/networking/cameras
	name = "camera network access module"
	desc = "Connects a computer to the camera network."

	// I have no idea what the following does
	var/mapping = 0//For the overview file, interesting bit of code.

	//proc/camera_list(var/datum/file/camnet_key/key)
	get_machines(var/datum/file/camnet_key/key)
		if (!computer || computer.z > 6)
			return null

		cameranet.process_sort()

		var/list/L = list()
		for(var/obj/machinery/camera/C in cameranet.cameras)
			var/list/temp = C.network & key.networks
			if(temp.len)
				L.Add(C)

		return L
	verify_machine(var/obj/machinery/camera/C,var/datum/file/camnet_key/key = null)
		if(!istype(C) || !C.can_use())
			return 0

		if(key)
			var/list/temp = C.network & key.networks
			if(!temp.len)
				return 0
		return 1

/*
	Camera monitoring program

	The following things should break you out of the camera view:
	* The computer resetting, being damaged, losing power, etc
	* The program quitting
	* Closing the window
	* Going out of range of the computer
	* Becoming incapacitated
	* The camera breaking, emping, disconnecting, etc
*/

/datum/file/program/security
	name			= "camera monitor"
	desc			= "Connects to the Nanotrasen Camera Network"
	image			= 'icons/ntos/camera.png'
	active_state	= "camera-static"

	var/datum/file/camnet_key/key = null
	var/last_pic = 1.0
	var/last_camera_refresh = 0
	var/camera_list = null

	var/obj/machinery/camera/current = null

	execute(var/datum/file/program/caller)
		..(caller)
		if(computer && !key)
			var/list/fkeys = computer.list_files(/datum/file/camnet_key)
			if(fkeys && fkeys.len)
				key = fkeys[1]
			update_icon()
			computer.update_icon()
			for(var/mob/living/L in viewers(1))
				if(!istype(L,/mob/living/silicon/ai) && L.machine == src)
					L.reset_view(null)


	Reset()
		..()
		reset_current()
		for(var/mob/living/L in viewers(1))
			if(!istype(L,/mob/living/silicon/ai) && L.machine == src)
				L.reset_view(null)

	interact()
		if(!interactable())
			return

		if(!computer.camnet)
			computer.Crash(MISSING_PERIPHERAL)
			return

		if(!key)
			var/list/fkeys = computer.list_files(/datum/file/camnet_key)
			if(fkeys && fkeys.len)
				key = fkeys[1]
			update_icon()
			computer.update_icon()
			if(!key)
				return

		if(computer.camnet.verify_machine(current))
			usr.reset_view(current)

		if(world.time - last_camera_refresh > 50 || !camera_list)
			last_camera_refresh = world.time

			var/list/temp_list = computer.camnet.get_machines(key)

			camera_list = "Network Key: [key.title] [topic_link(src,"keyselect","\[ Select key \]")]<hr>"
			for(var/obj/machinery/camera/C in temp_list)
				if(C.can_use())
					camera_list += "[C.c_tag] - [topic_link(src,"show=\ref[C]","Show")]<br>"
				else
					camera_list += "[C.c_tag] - <b>DEACTIVATED</b><br>"
			//camera_list += "<br>" + topic_link(src,"close","Close")

		popup.set_content(camera_list)
		popup.open()


	update_icon()
		if(key)
			overlay.icon_state = key.screen
			name = key.title + " Camera Monitor"
		else
			overlay.icon_state = "camera-static"
			name = initial(name)



	Topic(var/href,var/list/href_list)
		if(!interactable() || !computer.camnet || ..(href,href_list))
			return

		if("show" in href_list)
			var/obj/machinery/camera/C = locate(href_list["show"])
			if(istype(C) && C.can_use())
				set_current(C)
				usr.reset_view(C)
				interact()
				return

		if("keyselect" in href_list)
			reset_current()
			usr.reset_view(null)
			key = input(usr,"Select a camera network key:", "Key Select", null) as null|anything in computer.list_files(/datum/file/camnet_key)
			select_key(key)
			if(key)
				interact()
			else
				usr << "The screen turns to static."
			return

/datum/file/program/security/proc/select_key(var/selected_key)
	key = selected_key
	camera_list = null
	update_icon()
	computer.update_icon()

/datum/file/program/security/proc/set_current(var/obj/machinery/camera/C)
	if(current == C)
		return

	if(current)
		reset_current()

	src.current = C
	if(current)
		var/mob/living/L = current.loc
		if(istype(L))
			L.tracking_initiated()

/datum/file/program/security/proc/reset_current()
	if(current)
		var/mob/living/L = current.loc
		if(istype(L))
			L.tracking_cancelled()
	current = null

			// Atlantis: Required for camnetkeys to work.
/datum/file/program/security/hidden
	hidden_file = 1

/*
	Camera monitoring program

	Works much as the parent program, except:
	* It requires a camera to be found using the proximity network card.
	* It begins with all cam-access.
*/

/datum/file/program/security/syndicate
	name			= "camer# moni!%r"
	desc			= "Cons the Nanotrash Camera Network"
	var/special_key		= new/datum/file/camnet_key/syndicate
	var/camera_conn	= null

	interact()
		if(!interactable())
			return

		if(!computer.net)
			computer.Crash(MISSING_PERIPHERAL)
			return

		camera_conn = computer.net.connect_to(/obj/machinery/camera,camera_conn)

		if(!camera_conn)
			computer.Crash(NETWORK_FAILURE)
			return

		// On interact, override camera key selection
		select_key(special_key)
		..()
