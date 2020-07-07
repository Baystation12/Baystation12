
/datum/nano_module/program/experimental_analyzer
	var/list/ui_Destructive = list()

/datum/nano_module/program/experimental_analyzer/proc/uiData_DestructiveAnalyzer()
	var/list/data = list(\
		"destruct_connected" = linked_destroy ? TRUE : FALSE,\
		"destruct_name" = GetDestructName(),\
		"can_destruct" = can_destruct_current())
	return data

/datum/nano_module/program/experimental_analyzer/proc/GetDestructName()
	if(linked_destroy && linked_destroy.loaded_item)
		return linked_destroy.loaded_item.name

	return "None"
