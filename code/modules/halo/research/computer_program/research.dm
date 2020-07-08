
/datum/nano_module/program/experimental_analyzer
	var/techprint_queue_max = 1		//techprint queueing is something to do later

/datum/nano_module/program/experimental_analyzer/proc/attempt_start_selected(var/mob/user)
	if(selected_techprint)
		var/obj/host = nano_host()

		if(!selected_techprint.consumables_satisfied() || \
			!selected_techprint.prereqs_satisfied(loaded_research))
			to_chat(user,"\icon[host] <span class='notice'>Techprint is not ready to research yet.</span>")
			playsound(get_turf(host), 'sound/machines/buzz-two.ogg', 100, 1)

		else if(techprint_queue.len >= techprint_queue_max)
			to_chat(user,"\icon[host] <span class='notice'>Research queue already at max.</span>")
			playsound(get_turf(host), 'sound/machines/buzz-two.ogg', 100, 1)

		else if(techprint_queue.Find(selected_techprint))
			if(techprint_queue[1] == selected_techprint)
				to_chat(user,"\icon[host] <span class='notice'>[selected_techprint.name] is currently being researched.</span>")
			else
				to_chat(user,"\icon[host] <span class='notice'>[selected_techprint.name] is already in the research queue.</span>")
			playsound(get_turf(host), 'sound/machines/buzz-two.ogg', 100, 1)

		else
			techprint_queue.Add(selected_techprint)
			to_chat(user,"\icon[host] <span class='info'>[selected_techprint.name] is now being researched.</span>")
			//playsound(get_turf(host), 'sound/machines/chime.ogg', 100, 1)
	else
		to_debug_listeners("TECH ERROR: Attempted to start research without a techprint selected!")

/datum/nano_module/program/experimental_analyzer/proc/check_finished_consumables(var/datum/techprint/check_techprint)
	. = FALSE

	if(!check_techprint.consumables_satisfied())
		return FALSE

	if(check_techprint.ticks_satisfied())
		finalise_research(check_techprint)
		return TRUE

/datum/nano_module/program/experimental_analyzer/proc/finished_timer(var/datum/techprint/check_techprint)
	if(check_techprint.consumables_satisfied())
		finalise_research(check_techprint)

/datum/nano_module/program/experimental_analyzer/proc/finalise_research(var/datum/techprint/check_techprint)
	if(loaded_research.completed_techprints.Find(check_techprint))
		to_debug_listeners("TECH ERROR: Finalising tech which is probably finished [check_techprint.type]")
	else
		loaded_research.completed_techprints += check_techprint
		ui_FinishTech(check_techprint)

	if(loaded_research.locked_techprints.Find(check_techprint))
		to_debug_listeners("TECH WARNING: Finalising tech which is locked [check_techprint.type]")
		loaded_research.locked_techprints -= check_techprint
		ui_UnlockTech(check_techprint)
	else
		loaded_research.ready_techprints -= check_techprint
		ui_UnavailTech(check_techprint)

	if(check_techprint == selected_techprint)
		SelectTech(null)

	//update the database
	var/list/new_techs = loaded_research.complete_techprint(check_techprint, src)

	//add any newly discovered techprints to the UI
	var/list/new_names = list()
	if(new_techs.len)
		for(var/datum/techprint/T in new_techs)
			new_names.Add(T.name)
			if(T.prereqs_satisfied(loaded_research))
				ui_AvailTech(T)
			else
				ui_LockTech(T)

	var/outmsg = "Techprint completed: [check_techprint.name]."
	if(new_names.len)
		outmsg += " New techprints unlocked: [english_list(new_names)]."

	var/obj/host = nano_host()
	playsound(get_turf(host), 'sound/machines/twobeep.ogg', 100, 1)
	host.visible_message("\icon[host] <span class='info'>[outmsg]</span>")

	spawn(5)
		transmit_designs()
