/datum/computer_file/program/access_decrypter
	filename = "nt_accrypt"
	filedesc = "NTNet Access Decrypter"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "unlocked"
	extended_desc = "This highly advanced script can very slowly decrypt operational codes used in almost any network. These codes can be downloaded to an ID card to expand the available access. The system administrator will probably notice this."
	size = 34
	requires_ntnet = 1
	available_on_ntnet = 0
	available_on_syndinet = 1
	nanomodule_path = /datum/nano_module/program/access_decrypter/
	var/message = ""
	var/running = FALSE
	var/progress = 0
	var/target_progress = 300
	var/datum/access/target_access = null
	var/list/restricted_access_codes = list(access_change_ids) // access codes that are not hackable due to balance reasons
	var/list/skill_restricted_access_codes_master = list(access_network)

/datum/computer_file/program/access_decrypter/on_shutdown(var/forced)
	reset()
	..(forced)

/datum/computer_file/program/access_decrypter/proc/reset()
	running = FALSE
	message = ""
	progress = 0

/datum/computer_file/program/access_decrypter/process_tick()
	. = ..()
	if(!running)
		return
	var/obj/item/weapon/stock_parts/computer/processor_unit/CPU = computer.get_component(PART_CPU)
	var/obj/item/weapon/stock_parts/computer/card_slot/RFID = computer.get_component(PART_CARD)
	if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
		message = "A fatal hardware error has been detected."
		return
	if(!istype(RFID.stored_card))
		message = "RFID card has been removed from the device. Operation aborted."
		return

	progress += get_speed()

	if(progress >= target_progress)
		if(prob(20 * max(SKILL_ADEPT - operator_skill, 0))) // Oops
			var/list/valid_access_values = get_all_station_access()
			valid_access_values -= restricted_access_codes
			valid_access_values -= RFID.stored_card.access
			if(operator_skill < SKILL_PROF) // Don't want to randomly assign an access that we wouldn't be able to decrypt normally
				valid_access_values -= skill_restricted_access_codes_master
			target_access = get_access_by_id(pick(valid_access_values))
		RFID.stored_card.access |= target_access.id
		if(ntnet_global.intrusion_detection_enabled && !prob(get_sneak_chance()))
			ntnet_global.add_log("IDS WARNING - Unauthorised access to primary keycode database from device: [computer.get_network_tag()]  - downloaded access codes for: [target_access.desc].")
			ntnet_global.intrusion_detection_alarm = 1
		message = "Successfully decrypted and saved operational key codes. Downloaded access codes for: [target_access.desc]"
		target_access = null
		reset()

/datum/computer_file/program/access_decrypter/Topic(href, href_list)
	if(..())
		return 1
	operator_skill = usr.get_skill_value(SKILL_COMPUTER)
	if(href_list["PRG_reset"])
		reset()
		return 1
	if(href_list["PRG_execute"])
		if(running)
			return 1
		var/obj/item/weapon/stock_parts/computer/processor_unit/CPU = computer.get_component(PART_CPU)
		var/obj/item/weapon/stock_parts/computer/card_slot/RFID = computer.get_component(PART_CARD)
		if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
			message = "A fatal hardware error has been detected."
			return
		if(!istype(RFID.stored_card))
			message = "RFID card is not present in the device. Operation aborted."
			return

		var/access = href_list["PRG_execute"]
		var/obj/item/weapon/card/id/id_card = RFID.stored_card
		if(access in id_card.access)
			return 1
		if(access in restricted_access_codes)
			return 1
		if((access in skill_restricted_access_codes_master) && operator_skill < SKILL_PROF)
			return 1
		target_access = get_access_by_id(access)
		if(!target_access)
			return 1

		running = TRUE

		if(ntnet_global.intrusion_detection_enabled && !prob(get_sneak_chance()))
			ntnet_global.add_log("IDS WARNING - Unauthorised access attempt to primary keycode database from device: [computer.get_network_tag()]")
			ntnet_global.intrusion_detection_alarm = 1
		return 1

/datum/computer_file/program/access_decrypter/proc/get_sneak_chance()
	return max(operator_skill - SKILL_ADEPT, 0) * 30

/datum/computer_file/program/access_decrypter/proc/get_speed()
	var/skill_speed_modifier = 1 + (operator_skill - SKILL_ADEPT)/(SKILL_MAX - SKILL_MIN)
	var/obj/item/weapon/stock_parts/computer/processor_unit/CPU = computer.get_component(PART_CPU)
	return CPU?.processing_power * skill_speed_modifier

/datum/nano_module/program/access_decrypter
	name = "NTNet Access Decrypter"

/datum/nano_module/program/access_decrypter/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	if(!ntnet_global)
		return
	var/datum/computer_file/program/access_decrypter/PRG = program
	var/list/data = list()
	if(!istype(PRG))
		return
	data = PRG.get_header_data()

	var/obj/item/weapon/stock_parts/computer/card_slot/RFID = PRG.computer.get_component(PART_CARD)
	if(PRG.message)
		data["message"] = PRG.message
	else if(PRG.running)
		data["running"] = 1
		data["rate"] = PRG.get_speed()

		// Stolen from DOS traffic generator, generates strings of 1s and 0s
		var/percentage = (PRG.progress / PRG.target_progress) * 100
		var/list/strings[0]
		for(var/j, j<10, j++)
			var/string = ""
			for(var/i, i<20, i++)
				string = "[string][prob(percentage)]"
			strings.Add(string)
		data["dos_strings"] = strings
	else if(RFID && RFID.stored_card)
		var/obj/item/weapon/card/id/id_card = RFID.stored_card
		var/list/regions = list()
		for(var/i = ACCESS_REGION_MIN; i <= ACCESS_REGION_MAX; i++)
			var/list/accesses = list()
			for(var/access in get_region_accesses(i))
				if (get_access_desc(access))
					accesses.Add(list(list(
						"desc" = replacetext(get_access_desc(access), " ", "&nbsp"),
						"ref" = access,
						"allowed" = (access in id_card.access) ? 1 : 0,
						"blocked" = ((access in PRG.restricted_access_codes) || ((access in PRG.skill_restricted_access_codes_master) && PRG.operator_skill < SKILL_PROF)) ? 1 : 0)))

			regions.Add(list(list(
				"name" = get_region_accesses_name(i),
				"accesses" = accesses)))
		data["regions"] = regions

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "access_decrypter.tmpl", "NTNet Access Decrypter", 550, 400, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)