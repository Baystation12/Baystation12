
/datum/computer_file/program/innie_shuttle
	filename = "shuttle_control"
	filedesc = "Shuttle Control Program"
	program_icon_state = "shuttle"
	nanomodule_path = /datum/nano_module/program/innie_shuttle
	extended_desc = "An interface program for controlling short range shuttlecraft."
	size = 40
	available_on_ntnet = 0
	requires_ntnet = 0
	available_on_ntnet = 0
	available_on_syndinet = 1
	required_access = access_innie

/datum/nano_module/program/innie_shuttle
	name = "Shuttle Control Program"
	var/datum/shuttle/autodock/ferry/geminus_innie_transport/my_shuttle
	var/list/loaded_coords = list()

/datum/nano_module/program/innie_shuttle/New()
	. = ..()

	//attempt to locate the shuttle we are positioned in
	//todo: genericize this so the shuttle control program can be used for any shuttle
	var/area/cur_area = get_area(nano_host())
	for(var/shuttle_name in shuttle_controller.shuttles)
		var/datum/shuttle/S = shuttle_controller.shuttles[shuttle_name]
		if(cur_area in S.shuttle_area)
			my_shuttle = S
			break

	if(my_shuttle)
		reload_coords()

/datum/nano_module/program/innie_shuttle/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/is_admin = check_access(user, access_innie_boss)

	data["is_admin"] = is_admin
	data["shuttle_connected"] = my_shuttle ? 1 : 0
	if(my_shuttle)
		data["atmos_speed"] = my_shuttle.atmos_speed
		data["fuel_left"] = my_shuttle.held_fuel ? my_shuttle.held_fuel.fuel_left : 0
		data["fuel_max"] = my_shuttle.held_fuel ? my_shuttle.held_fuel.max_fuel : 0
		data["fuel_efficiency"] = my_shuttle.fuel_efficiency
		//
		data["shuttle_status"] = get_shuttle_status()
		data["location"] = my_shuttle.current_name
		data["on_quest"] = my_shuttle.location
		var/area/cur_area = get_area(nano_host())
		var/obj/machinery/power/apc/apc = cur_area.get_apc()
		if(apc && apc.cell)
			data["power"] = apc.cell.charge
			data["powermax"] = apc.cell.maxcharge
		else
			data["power"] = 0
			data["powermax"] = 0
		//
		data["target_coords"] = my_shuttle.next_name
		data["target_dist"] = my_shuttle.next_distance
		//
		if(GLOB.factions_controller.active_quest_coords.len != loaded_coords.len)
			reload_coords()
		data["loaded_coords"] = loaded_coords

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shuttle_innie.tmpl", name, 950, 600, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/innie_shuttle/proc/reload_coords()
	if(Debug2)
		testing(" /datum/nano_module/program/innie_shuttle/proc/reload_coords()")
	/*
	//grab some stuff from our host computer
	var/datum/computer_file/program/filemanager/PRG = program
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = PRG.computer.hard_drive
	var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = PRG.computer.portable_drive
	var/list/filestorage = list() + (HDD ? HDD.stored_files : list()) + (RHDD ? RHDD.stored_files : list())
	*/

	//reset these
	loaded_coords = list()

	. = 1

	for(var/datum/computer_file/data/coord/coords in GLOB.factions_controller.active_quest_coords)
		if(Debug2)
			testing("found: [coords.filename]")
		if(!coords.data_integrity())
			. = 0
			testing("[coords.filename] no integrity")
			continue
		loaded_coords.Add(list(list(
			"name" = coords.quest.location_name,\
			"filename" = "[coords.filename].[coords.filetype]",\
			"dist" = coords.quest.dist,\
			"expired" = coords.quest.is_expired(),\
			"questref" = "\ref[coords.quest]"\
		)))

/datum/nano_module/program/innie_shuttle/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1

	if(href_list["reload_coords"])
		if(alert("Warning, this action may result in the loss of unsaved data","Alert","Proceed","Get me out of here!") == "Proceed")
			var/obj/item/modular_computer/MC = nano_host()
			if(reload_coords())
				MC.audible_message("\icon[MC] <span class='notice'>[MC] beeps: \"Coords successfully reloaded.\"</span>")
				playsound(MC.loc, 'sound/machines/ping.ogg', 25, 5)
			else
				MC.audible_message("\icon[MC] <span class='notice'>[MC] beeps: \"Warning: Some coords were corrupted and could not be loaded\"</span>")
				playsound(MC.loc, 'sound/machines/chime.ogg', 25, 5)

	if(href_list["embark"])

		if(my_shuttle.location && \
			alert("You may not be able to return. Ensure you are fully loaded before departure.","Departing","Continue","Abort") == "Abort")
			return

		var/obj/item/modular_computer/MC = nano_host()
		var/fuel_needed = 0
		if(!my_shuttle.location)
			//flights home are free
			fuel_needed = my_shuttle.next_distance / my_shuttle.fuel_efficiency

		var/fuel_left = my_shuttle.held_fuel ? my_shuttle.held_fuel.max_fuel : 0
		if(fuel_left >= fuel_needed)
			if(fuel_needed && fuel_left < 20 && alert("You are critically low on fuel. Launch anyway?","Low fuel","Continue","Abort") == "Abort")
				return

			to_chat(user, "\icon[MC] <span class='notice'>Shuttle launching...</span>")
			//playsound(MC.loc, 'sound/effects/start.ogg', 25, 5)
			my_shuttle.use_fuel(fuel_needed)

			//todo:ghost any players left here
			//

			//prepare the next location, if it isn't our home base
			/*
			if(destination_quest.location_name != "Rabbit Hole Base")
				//get the next location ready
				my_shuttle.next_location.quest = destination_quest
				my_shuttle.next_location.name = destination_quest.location_name
				*/

			//if we're heading to or from home, we'll do a real launch
			//as the program interface will ensure we never target somewhere we already are
			/*
			if(my_shuttle.current_location.name == "Rabbit Hole Base" || my_shuttle.next_location.name == "Rabbit Hole Base")
				my_shuttle.launch(user)
			else
				my_shuttle.fake_launch(user)
				*/

			my_shuttle.launch(user)

			//some quests have a limited number of attempts
			if(my_shuttle.current_name == my_shuttle.instance_quest.location_name)
				//if we are embarking from the quest location, that may trigger a quest failure
				if(my_shuttle.instance_quest.shuttle_returned())
					//this quest is finished, so its coordinates are disabled
					//the coordinates list needs to be reloaded
					reload_coords()

		else
			to_chat(user, "\icon[MC] <span class='warning'>Shuttle is out of fuel!</span>")
			playsound(MC.loc, 'sound/machines/buzz-sigh.ogg', 25, 5)

	if(href_list["set_dest"])
		var/obj/item/modular_computer/MC = nano_host()
		var/datum/npc_quest/Q = locate(href_list["set_dest"])
		//my_shuttle.next_location = my_shuttle.get_location_waypoint(1)
		my_shuttle.instance_quest = Q
		my_shuttle.next_distance = Q.dist
		my_shuttle.next_name = Q.location_name
		to_chat(user, "\icon[MC] <span class='notice'>Destination coordinates locked in.</span>")
		playsound(MC.loc, 'sound/machines/ping.ogg', 25, 5)
		return 1

/datum/nano_module/program/innie_shuttle/proc/get_shuttle_status()
	if(my_shuttle.has_arrive_time())
		return "In transit ([my_shuttle.eta_seconds()] s)"

	if (my_shuttle.can_launch())
		return "Docked"

	if(my_shuttle.moving_status == SHUTTLE_WARMUP)
		return "Launching"

	return "Docking/Undocking"
