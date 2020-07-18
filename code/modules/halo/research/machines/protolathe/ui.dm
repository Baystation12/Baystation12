
/obj/machinery/research/protolathe
	var/list/uiData_Queue = list()
	var/list/uiData_Designs = list()
	var/list/uiData_SelectedDesign = list()

/obj/machinery/research/protolathe/proc/ui_AddDesign(var/datum/research_design/D)

	//grab the UI data
	var/list/ui_list = list("name" = D.name)

	//add it to the end
	uiData_Designs.len += 1
	uiData_Designs[uiData_Designs.len] = ui_list

/obj/machinery/research/protolathe/proc/ui_AddQueue(var/datum/craft_entry/E, var/status = 1)

	//status
	//0 = red (not enough resources)
	//1 = clear (enough resources)
	//2 = green (crafting started)

	//grab the UI data
	var/list/ui_list = list(\
		"name" = E.my_design.name,\
		"index" = uiData_Queue.len + 1,\
		"status" = status,\
		"progress" = 0)

	//add it to the end
	uiData_Queue.len += 1
	uiData_Queue[uiData_Queue.len] = ui_list

/obj/machinery/research/protolathe/proc/ui_SetProgress(var/progress_index, var/new_progress)

	var/list/entry_list = uiData_Queue[progress_index]
	entry_list["progress"] = new_progress

	//not sure if this is needed
	//uiData_Queue[new_index] = entry_list

/obj/machinery/research/protolathe/proc/ui_SetStatus(var/progress_index, var/new_status)

	var/list/entry_list = uiData_Queue[progress_index]
	entry_list["status"] = new_status

/obj/machinery/research/protolathe/proc/ui_UnQueue(var/cut_index)
	uiData_Queue.Cut(cut_index, cut_index + 1)
	for(var/new_index = 1, new_index <= uiData_Queue.len, new_index++)
		var/list/entry_list = uiData_Queue[new_index]
		entry_list["index"] = new_index

		//not sure if this is needed
		//uiData_Queue[new_index] = entry_list

/obj/machinery/research/protolathe/proc/ui_SelectDesign(var/datum/research_design/D)
	uiData_SelectedDesign = list()
	if(D)
		uiData_SelectedDesign = list(\
			"name" = D.name,\
			"complexity" = D.complexity,\
			"desc" = D.desc ? D.desc : "",\
			"consume" = D.GetConsumablesString(mat_efficiency))

	else
		uiData_SelectedDesign["name"] = 0
