#define VRCONTROL_HOME 1

/datum/computer_file/program/vr_control
	filename = "vrcontrol"
	filedesc = "VR Control"
	program_icon_state = "generic"
	program_menu_icon = "image"
	extended_desc = "Maintains the active digital space used by VR pods and VR implants. Can be used to monitor occupants, change the area, or send a message to everyone inside VR."
	size = 32
	available_on_ntnet = FALSE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN
	nanomodule_path = /datum/nano_module/program/vr_control

/datum/computer_file/program/vr_control/process_tick()
	..()	
	var/datum/nano_module/program/vr_control/VRC = NM
	if(istype(VRC))
		VRC.emagged = computer.emagged()

/datum/nano_module/program/vr_control
	name = "VR Control"
	var/prog_state = VRCONTROL_HOME
	var/emagged
	var/area_cooldown = 0

/datum/nano_module/program/vr_control/Topic(href, href_list)
	if(..())
		return TRUE

	if (href_list["msg_all_occupants"])
		var/our_msg = input(usr, "Enter a message to send to all connected users.", "Message All") as null|text
		if (!our_msg)
			return TRUE
		for (var/mob/living/L in SSvirtual_reality.virtual_mobs_to_occupants)
			to_chat(L, SPAN_NOTICE(FONT_LARGE("<b><i>You hear a voice coming through speakers all around:</i></b> \"[our_msg]\"")))
		to_chat(usr, SPAN_NOTICE("Message sent to all VR users: \"[our_msg]\""))
		return TRUE
	
	if (href_list["msg_occupant"])
		var/mob/living/L = locate(href_list["msg_occupant"]) in SSvirtual_reality.virtual_mobs_to_occupants
		if (!L)
			to_chat(usr, SPAN_WARNING("The system could not find the specified user: [href_list["msg_occupant"]]"))
			return TRUE
		var/our_msg = input(usr, "Enter a message to send to [L].", "Message User") as null|text
		if (!our_msg)
			return TRUE
		to_chat(L, SPAN_NOTICE(FONT_LARGE("<b><i>A holographic message appears in front of you:</i></b> \"[our_msg]\"")))
		to_chat(usr, SPAN_NOTICE("Message sent to [L]: \"[our_msg]\""))
		return TRUE

	if (href_list["load_template"])
		var/list/the_matrix = SSvirtual_reality.virtual_occupants_to_mobs
		var/P = GLOB.vr_areas[href_list["load_template"]]
		var/area/A = locate(P)
		if (!A)
			P = GLOB.emagged_vr_areas[href_list["load_template"]]
			A = locate(P)
			if (!A) // if we still don't have our area after checking for emagged ones, throw an error
				to_chat(usr, SPAN_WARNING("The system could not find the specified template: [href_list["load_template"]]"))
				return TRUE
		if (GLOB.active_vr_area == A)
			return TRUE
		if (the_matrix.len)
			if (alert(usr, "Switching the VR area will eject [the_matrix.len] users from the simulation. Continue?", "Change Area", "Yes", "No") != "Yes")
				return TRUE
			log_and_message_admins("changed the VR area to [A.name], ejecting [the_matrix.len] occupants.", usr)
		else
			log_and_message_admins("changed the VR area to [A.name].", usr)
		GLOB.active_vr_area = A
		for (var/mob/living/L in SSvirtual_reality.virtual_occupants_to_mobs)
			SSvirtual_reality.remove_virtual_mob(L, TRUE)
		to_chat(usr, SPAN_NOTICE("Successfully loaded new area: [A.name]!"))
		playsound(program.computer.holder, 'sound/machines/ping.ogg', 50)
		area_cooldown = world.time + 30 SECONDS
		return TRUE

/datum/nano_module/program/vr_control/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["on_cooldown"] = area_cooldown > world.time
	data["occupants"] = list()
	for (var/mob/living/L in SSvirtual_reality.virtual_occupants_to_mobs)
		var/mob/living/virtual = SSvirtual_reality.get_surrogate_for(L)
		var/list/occupant_info = list()
		occupant_info["name"] = "[L.real_name] - [virtual.mind.assigned_role]"
		occupant_info["mob_ref"] = "\ref[virtual]"
		
		data["occupants"] += list(occupant_info)
	
	var/datum/map_template/MT = GLOB.active_vr_area
	data["active_template"] = MT ? MT.name : null
	data["templates"] = list()
	for (var/V in GLOB.vr_areas)
		var/list/template_data = list()
		template_data["name"] = V

		data["templates"] += list(template_data)
	
	if (emagged)
		data["emag_templates"] = list()
		for (var/V in GLOB.emagged_vr_areas)
			var/list/template_data = list()
			template_data["name"] = V

			data["emag_templates"] += list(template_data)
	
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "vr_control.tmpl", name, 450, 600, state = state)
		ui.auto_update_layout = TRUE
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

#undef VRCONTROL_HOME
