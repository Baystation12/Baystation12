
/datum/nano_module/program/experimental_analyzer
	var/list/ui_SelectedTech = list("selected" = "None")
	//var/dirty_SelectedTech = FALSE

/datum/nano_module/program/experimental_analyzer/proc/SelectTech(var/datum/techprint/new_select, var/can_research = TRUE)
	selected_techprint = new_select
	ui_SelectedTech = list()
	if(selected_techprint)
		ui_SelectedTech["selected"] = selected_techprint.name
		ui_SelectedTech["desc"] = selected_techprint.desc
		ui_SelectedTech["percent"] = selected_techprint.GetPercent()
		ui_SelectedTech["design_unlocks"] = selected_techprint.GetDesignsString()
		ui_SelectedTech["consumables"] = selected_techprint.GetConsumablesString()
		ui_SelectedTech["reqs"] = selected_techprint.GetReqsString()
		ui_SelectedTech["can_research"] = can_research \
			&& selected_techprint.consumables_satisfied() \
			&& selected_techprint.prereqs_satisfied()
		ui_SelectedTech["time"] = selected_techprint.ticks_max

	else
		ui_SelectedTech["selected"] = "None"
	//dirty_SelectedTech = FALSE

/datum/nano_module/program/experimental_analyzer/proc/uiData_SelectedTech()
	return ui_SelectedTech
