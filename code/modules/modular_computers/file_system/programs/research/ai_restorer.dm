/datum/computer_file/program/aidiag
	filename = "aidiag"
	filedesc = "AI Maintenance Utility"
	program_icon_state = "generic"
	program_menu_icon = "person"
	extended_desc = "This program is capable of reconstructing damaged AI systems. It can also be used to upload basic laws to the AI. Requires direct AI connection via inteliCard slot."
	size = 12
	requires_ntnet = 0
	required_access = access_heads
	requires_access_to_run = 0
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/computer_aidiag/
	var/restoring = 0

/datum/computer_file/program/aidiag/proc/get_ai()
	if(computer && computer.ai_slot && computer.ai_slot.check_functionality() && computer.ai_slot.enabled && computer.ai_slot.stored_card && computer.ai_slot.stored_card.carded_ai)
		return computer.ai_slot.stored_card.carded_ai
	return null

/datum/computer_file/program/aidiag/Topic(href, href_list)
	if(..())
		return 1
	var/mob/living/silicon/ai/A = get_ai()
	if(!A)
		return 0
	if(href_list["PRG_beginReconstruction"])
		if((A.hardware_integrity() < 100) || (A.backup_capacitor() < 100))
			restoring = 1
		return 1

	// Following actions can only be used by non-silicon users, as they involve manipulation of laws.
	if(issilicon(usr))
		return 0
	if(href_list["PRG_purgeAiLaws"])
		A.laws.clear_zeroth_laws()
		A.laws.clear_ion_laws()
		A.laws.clear_inherent_laws()
		A.laws.clear_supplied_laws()
		to_chat(A, "<span class='danger'>All laws purged.</span>")
		return 1
	if(href_list["PRG_resetLaws"])
		A.laws.clear_ion_laws()
		A.laws.clear_supplied_laws()
		to_chat(A, "<span class='danger'>Non-core laws reset.</span>")
		return 1
	if(href_list["PRG_uploadDefault"])
		A.laws = new GLOB.using_map.default_law_type
		to_chat(A, "<span class='danger'>All laws purged. Default lawset uploaded.</span>")
		return 1
	if(href_list["PRG_addCustomSuppliedLaw"])
		var/law_to_add = sanitize(input("Please enter a new law for the AI.", "Custom Law Entry"))
		var/sector = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)") as num
		sector = between(MIN_SUPPLIED_LAW_NUMBER, sector, MAX_SUPPLIED_LAW_NUMBER)
		A.add_supplied_law(sector, law_to_add)
		to_chat(A, "<span class='danger'>Custom law uploaded to sector [sector]: [law_to_add].</span>")
		return 1


/datum/computer_file/program/aidiag/process_tick()
	var/mob/living/silicon/ai/A = get_ai()
	if(!A || !restoring)
		restoring = 0	// If the AI was removed, stop the restoration sequence.
		return
	A.adjustFireLoss(-4)
	A.adjustBruteLoss(-4)
	A.adjustOxyLoss(-4)
	A.updatehealth()
	// If the AI is dead, revive it.
	if (A.health >= -100 && A.stat == DEAD)
		A.set_stat(CONSCIOUS)
		A.lying = 0
		A.switch_from_dead_to_living_mob_list()
		A.add_ai_verbs()
		A.update_icon()
		var/obj/item/weapon/aicard/AC = A.loc
		if(AC)
			AC.update_icon()
	// Finished restoring
	if((A.hardware_integrity() == 100) && (A.backup_capacitor() == 100))
		restoring = 0

/datum/nano_module/program/computer_aidiag
	name = "AI Maintenance Utility"

/datum/nano_module/program/computer_aidiag/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/mob/living/silicon/ai/A
	// A shortcut for getting the AI stored inside the computer. The program already does necessary checks.
	if(program && istype(program, /datum/computer_file/program/aidiag))
		var/datum/computer_file/program/aidiag/AD = program
		A = AD.get_ai()

	if(!A)
		data["error"] = "No AI located"
	else
		data["ai_name"] = A.name
		data["ai_integrity"] = A.hardware_integrity()
		data["ai_capacitor"] = A.backup_capacitor()
		data["ai_isdamaged"] = (A.hardware_integrity() < 100) || (A.backup_capacitor() < 100)
		data["ai_isdead"] = (A.stat == DEAD)

		var/list/all_laws[0]
		for(var/datum/ai_law/L in A.laws.all_laws())
			all_laws.Add(list(list(
			"index" = L.index,
			"text" = L.law
			)))

		data["ai_laws"] = all_laws

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "aidiag.tmpl", "AI Maintenance Utility", 600, 400, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)