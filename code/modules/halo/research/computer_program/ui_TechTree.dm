
/datum/nano_module/program/experimental_analyzer
	var/list/ui_TechTreeAvailable = list()
	var/list/ui_TechTreeLocked = list()
	var/list/ui_TechTreeFinished = list()

/datum/nano_module/program/experimental_analyzer/proc/ui_RebuildTechTree()
	set background = 1

	//wipe the existing tech tree
	ui_TechTreeAvailable = list()
	ui_TechTreeLocked = list()
	ui_TechTreeFinished = list()

	//rebuild it from scratch
	if(loaded_research)

		for(var/datum/techprint/cur_techprint in loaded_research.ready_techprints)
			ui_AvailTech(cur_techprint)

		for(var/datum/techprint/cur_techprint in loaded_research.locked_techprints)
			ui_LockTech(cur_techprint)

		for(var/datum/techprint/cur_techprint in loaded_research.completed_techprints)
			ui_FinishTech(cur_techprint)

/datum/nano_module/program/experimental_analyzer/proc/uiData_TechTreeAvailable()
	return list("TechTreeAvail" = ui_TechTreeAvailable)

/datum/nano_module/program/experimental_analyzer/proc/uiData_TechTreeLocked()
	return list("TechTreeLocked" = ui_TechTreeLocked)

/datum/nano_module/program/experimental_analyzer/proc/uiData_TechTreeFinished()
	return list("TechTreeFinished" = ui_TechTreeFinished)

/datum/nano_module/program/experimental_analyzer/proc/ui_AvailTech(var/datum/techprint/cur_techprint)
	var/list/entry = list(\
		"name" = cur_techprint.name,\
		"percent" = cur_techprint.GetPercent())
	ui_TechTreeAvailable.len++
	ui_TechTreeAvailable[ui_TechTreeAvailable.len] = entry

/datum/nano_module/program/experimental_analyzer/proc/ui_LockTech(var/datum/techprint/cur_techprint)
	var/list/entry = list("name" = cur_techprint.name)
	ui_TechTreeLocked.len++
	ui_TechTreeLocked[ui_TechTreeLocked.len] = entry

/datum/nano_module/program/experimental_analyzer/proc/ui_FinishTech(var/datum/techprint/cur_techprint)
	var/list/entry = list("name" = cur_techprint.name, "unlocks" = cur_techprint.GetDesignsString())
	ui_TechTreeFinished.len++
	ui_TechTreeFinished[ui_TechTreeFinished.len] = entry

/datum/nano_module/program/experimental_analyzer/proc/ui_UnlockTech(var/datum/techprint/cur_techprint)

	for(var/index = 1, index <= ui_TechTreeLocked.len, index++)
		var/check_list = ui_TechTreeLocked[index]
		if(check_list["name"] == cur_techprint.name)
			//remove it
			ui_TechTreeLocked.Cut(index, index + 1)
			return 1

	to_debug_listeners("TECH WARNING: Attempted to remove [cur_techprint.type] from ui_TechTreeLocked but I couldn't find it!")

/datum/nano_module/program/experimental_analyzer/proc/ui_UnavailTech(var/datum/techprint/cur_techprint)

	for(var/index = 1, index <= ui_TechTreeAvailable.len, index++)
		var/check_list = ui_TechTreeAvailable[index]
		if(check_list["name"] == cur_techprint.name)
			//remove it
			ui_TechTreeAvailable.Cut(index, index + 1)
			return 1

	to_debug_listeners("TECH WARNING: Attempted to remove [cur_techprint.type] from ui_TechTreeAvailable but I couldn't find it!")

//todo: this is unfinished!
/datum/nano_module/program/experimental_analyzer/proc/ui_ProgressTech(var/datum/techprint/cur_techprint)

	for(var/check_list in ui_TechTreeAvailable)
		if(check_list["name"] == cur_techprint.name)
			//update progress string
			check_list["percent"] = cur_techprint.GetPercent()
			return 1

	to_debug_listeners("TECH WARNING: Attempted to progress [cur_techprint.type] from ui_TechTreeAvailable but I couldn't find it!")
