/datum/computer_file/program/innie_comms
	filename = "base_comms"
	filedesc = "Rabbit Hole Base Communications"
	program_icon_state = "comm"
	nanomodule_path = /datum/nano_module/program/innie_comms
	extended_desc = "An interface for communicating on encrypted channels over long distances."
	size = 15
	available_on_ntnet = 0
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_COMMUNICATION
	available_on_ntnet = 0
	available_on_syndinet = 1
	required_access = access_innie

/datum/computer_file/program/innie_comms/process_tick()
	//dont do this
	NM:process_tick()

/datum/nano_module/program/innie_comms
	name = "Rabbit Hole Base Communications"
	var/screen = 1		//1 = comms list, 2 = hail, 3 = quest
	var/datum/faction/selected_faction
	var/list/faction_names = list()
	var/list/faction_contents = list()
	var/list/loaded_factions = list()
	var/list/faction_quests = list()
	var/time_last_msg = 0
	var/idle_interval_min = 6 SECONDS
	var/idle_interval_current = 8 SECONDS
	var/idle_interval_max = 14 SECONDS

/datum/nano_module/program/innie_comms/New()
	. = ..()
	reload_contacts()

/datum/nano_module/program/innie_comms/proc/process_tick()
	if(selected_faction && world.time > time_last_msg + idle_interval_current)
		say_message(selected_faction.leader_name, selected_faction.hail_idle())
		idle_interval_current = rand(idle_interval_min, idle_interval_max)

/datum/nano_module/program/innie_comms/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/is_admin = check_access(user, access_innie_boss)

	data["is_admin"] = is_admin
	data["screen"] = screen
	data["credits"] = "[GLOB.INSURRECTION.money_account.money]"
	switch(screen)
		if(1)// Communications
			data["factions"] = faction_names
			//update reputation counters
			for(var/list/cur_faction in faction_contents)
				var/datum/faction/F = GLOB.factions_by_name[cur_faction["name"]]
				cur_faction["reputation"] = F.get_faction_reputation("Insurrection")
			data["faction_contents"] = faction_contents

		if(2)// Hail
			data["selected_faction"] = selected_faction.name
			data["leader_name"] = selected_faction.leader_name
			data["reputation"] = selected_faction.get_faction_reputation("Insurrection")
			data["faction_quests"] = faction_quests
			data["faction_blurb"] = selected_faction.blurb
			if(!selected_faction.locked_rep_rewards.len && !selected_faction.unlocked_rep_rewards.len)
				selected_faction.generate_rep_rewards()
			data["locked_rewards"] = selected_faction.locked_rep_rewards
			data["unlocked_rewards"] = selected_faction.unlocked_rep_rewards

		if(3)// Quests
			data["selected_faction"] = selected_faction.name
			for(var/list/cur_quest in faction_quests)
				var/datum/npc_quest/Q = locate(cur_quest["quest_ref"])
				//cur_faction["reputation"] = F.get_faction_reputation("Insurrection")
				cur_quest["time_left"] = Q.get_time_left()
			data["faction_quests"] = faction_quests

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "comms_innie.tmpl", name, 1100, 800, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/innie_comms/proc/reload_faction_quests(var/active = 1)
	faction_quests = list()

	if(selected_faction)
		for(var/datum/npc_quest/Q in active ? selected_faction.active_quests : selected_faction.completed_quests)

			faction_quests.Add(list(list(\
				"desc_text" = Q.desc_text,\
				"favour_reward" = Q.favour_reward,\
				"credit_reward" = Q.credit_reward,\
				"difficulty_desc" = Q.get_difficulty_text(),\
				"location_name" = Q.location_name + " ([Q.map_references[Q.map_path]])",\
				"status_desc" = Q.get_status_text(),\
				"target" = Q.enemy_faction,\
				"time_left" = Q.get_time_left(),\
				"quest_ref" = "\ref[Q]"\
			)))

/datum/nano_module/program/innie_comms/proc/reload_contacts()
	/*
	//grab some stuff from our host computer
	var/datum/computer_file/program/filemanager/PRG = program
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = PRG.computer.hard_drive
	var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = PRG.computer.portable_drive
	var/list/filestorage = list() + (HDD ? HDD.stored_files : list()) + (RHDD ? RHDD.stored_files : list())
	*/

	//reset these
	faction_names = list()
	faction_contents = list()
	loaded_factions = list()

	. = 1
	for(var/datum/faction/F in GLOB.innie_factions)
		var/datum/computer_file/data/com/contact_details = F.faction_contact_data
		if(!contact_details.data_integrity())
			. = 0
			continue
		loaded_factions.Add(F)
		faction_names.Add(F.name)
		faction_contents.Add(list(list(
			"name" = F.name,
			"filename" = "[contact_details.filename].[contact_details.filetype]",\
			"leadername" = F.leader_name,
			"reputation" = F.get_faction_reputation("Insurrection")
		)))

/datum/nano_module/program/innie_comms/proc/export_contacts()
	//grab some stuff from our host computer
	var/datum/computer_file/program/filemanager/PRG = program
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = PRG.computer.hard_drive

	. = 1
	for(var/datum/faction/F in loaded_factions)
		//grab their pre-generated contact details and attempt to save them
		if(!HDD.store_file(F.faction_contact_data))
			//something went wrong! we couldnt save the file
			//no info is provided on why it went wrong... just that it did. could be out of memory, or the file could already exist etc
			. = 0

//ripped from mob code
/datum/nano_module/program/innie_comms/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

/datum/nano_module/program/innie_comms/proc/say_message(var/from, var/message)
	var/obj/item/modular_computer/MC = nano_host()
	/*var/mob/living/silicon/ai/A = new /mob/living/silicon/ai(MC, null, null, 1)
	A.fully_replace_character_name(from)
	A.say(message)
	qdel(A)*/
	var/formatted_message = "<span class='syndradio'>\icon[MC] <b>\[HAIL\]</b> <span class='name'>"
	formatted_message += from
	formatted_message += "</span> says, \"<span class='message'>"
	formatted_message += message
	formatted_message += "</span>\"</span>"
	MC.audible_message(formatted_message)
	time_last_msg = world.time

	var/speech_bubble_test = say_test(formatted_message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',MC,"h[speech_bubble_test]")
	for(var/mob/M in view(7, MC))
		show_image(M, speech_bubble)
	spawn(30) qdel(speech_bubble)

/datum/nano_module/program/innie_comms/Topic(href, href_list)
	//var/mob/user = usr
	if(..())
		return 1

	if(href_list["set_screen"])
		screen = text2num(href_list["set_screen"])
		if(screen == 3)
			say_message(selected_faction.leader_name, selected_faction.hail_quest_new())
			reload_faction_quests(1)
		else if(screen == 2)
			reload_faction_quests(0)
		return 1

	if(href_list["reload_contacts"])
		if(alert("Warning, this action may result in the loss of unsaved data","Alert","Proceed","Get me out of here!") == "Proceed")
			var/obj/item/modular_computer/MC = nano_host()
			if(reload_contacts())
				MC.audible_message("\icon[MC] <span class='notice'>[MC] beeps: \"Contacts successfully reloaded.\"</span>")
				playsound(MC.loc, 'sound/machines/ping.ogg', 25, 5)
			else
				MC.audible_message("\icon[MC] <span class='notice'>[MC] beeps: \"Warning: Some contacts were corrupted and could not be loaded\"</span>")
				playsound(MC.loc, 'sound/machines/chime.ogg', 25, 5)
			return 1

	if(href_list["export_contacts"])
		var/obj/item/modular_computer/MC = nano_host()
		if(export_contacts())
			MC.audible_message("\icon[MC] <span class='notice'>[MC] beeps: \"Contacts successfully exported.\"</span>")
			playsound(MC.loc, 'sound/machines/ping.ogg', 25, 5)
		else
			MC.audible_message("\icon[MC] <span class='notice'>[MC] beeps: \"Warning: Some contacts could not be exported.\"</span>")
			playsound(MC.loc, 'sound/machines/chime.ogg', 25, 5)
		return 1

	if(href_list["accept_quest"])
		var/datum/npc_quest/Q = locate(href_list["accept_quest"])
		Q.accept_quest(GLOB.factions_by_name["Insurrection"])
		var/accept_hail = selected_faction.hail_quest_accept()
		accept_hail = "I've uploaded the destination coordinates to your console. \
			They'll only be valid for a short while so you'll only get one shot at this. " + accept_hail
		say_message(selected_faction.leader_name, accept_hail)

		var/datum/computer_file/data/coord/coords = new()
		coords.generate_data(Q)
		Q.coords = coords
		//var/obj/item/modular_computer/MC = nano_host()
		//MC.hard_drive.store_file(coords)
		GLOB.factions_controller.active_quest_coords.Add(coords)
		reload_faction_quests(1)
		return 1

	if(href_list["reject_quest"])
		var/datum/npc_quest/Q = locate(href_list["reject_quest"])
		var/obj/item/modular_computer/MC = nano_host()

		selected_faction.reject_quest("Insurrection", Q, 1)
		var/new_rep = selected_faction.get_faction_reputation("Insurrection")
		var/reply_message
		var/reply_name = selected_faction.leader_name
		if(new_rep < 0)
			reply_message = "[selected_faction.hail_angry()]"
			selected_faction = null
			playsound(MC.loc, 'sound/machines/buttonbeep.ogg', 25, 5)
			screen = 1
		else
			reload_faction_quests(1)
			reply_message = "[selected_faction.hail_disappointed()]"
		say_message(reply_name, reply_message + " (-[Q.favour_reward * 2] rep)")
		reload_contacts()
		return 1

	if(href_list["select_faction"])
		var/datum/faction/old_faction = selected_faction
		selected_faction = GLOB.innie_factions_by_name[href_list["select_faction"]]
		var/obj/item/modular_computer/MC = nano_host()

		if(selected_faction)
			if(selected_faction.is_angry_at_faction("Insurrection"))
				say_message(selected_faction.leader_name, selected_faction.hail_angry())
				playsound(MC.loc, 'sound/machines/buzz-sigh.ogg', 25, 5)
				selected_faction = null
				screen = 1
			else
				say_message(selected_faction.leader_name, selected_faction.hail_open(selected_faction.name))
				reload_faction_quests(0)
				playsound(MC.loc, 'sound/machines/triple_beep.ogg', 25, 5)
				screen = 2

		else if(old_faction)
			say_message(old_faction.leader_name, old_faction.hail_end())
			playsound(MC.loc, 'sound/machines/buttonbeep.ogg', 25, 5)
			screen = 1

	if(href_list["activate_ability"])
		var/ability_name = href_list["activate_ability"]
		to_world("ACTIVATING: [ability_name]")

		return 1

/datum/nano_module/program/innie_comms/proc/can_print()
	var/obj/item/modular_computer/MC = nano_host()
	if(!istype(MC) || !istype(MC.nano_printer))
		return 0
	return 1

/datum/nano_module/program/innie_comms/proc/print_text(var/text, var/mob/user)
	var/obj/item/modular_computer/MC = nano_host()
	if(istype(MC))
		if(!MC.nano_printer)
			to_chat(user, "Error: No printer detected. Unable to print document.")
			return

		if(!MC.nano_printer.print_text(text))
			to_chat(user, "Error: Printer was unable to print the document. It may be out of paper.")
	else
		to_chat(user, "Error: Unable to detect compatible printer interface. Are you running NTOSv2 compatible system?")