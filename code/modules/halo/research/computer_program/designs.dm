
/datum/nano_module/program/experimental_analyzer/proc/transmit_designs(var/mob/user)
	var/obj/host = nano_host()
	var/list/designs = list()
	for(var/datum/techprint/finished_techprint in loaded_research.completed_techprints)
		designs += finished_techprint.design_unlocks

	var/result = FALSE
	for(var/obj/machinery/research/protolathe/P in view(6, host))
		if(P.add_designs(designs))
			result = TRUE

	if(result)
		to_chat(user,"<span class='info'>Designs transmitted successfully to a nearby protolathe.</span>")
	else
		to_chat(user,"<span class='info'>No new designs to transmit to a nearby protolathe.</span>")
