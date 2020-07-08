/datum/craft_entry
	var/datum/research_design/my_design
	var/progress = 0
	var/started = FALSE

/obj/machinery/research/protolathe/proc/attempt_craft(var/datum/research_design/D, var/mob/user)

	//do we have enough resources to craft it?
	//note we can still queue it without enough resources
	var/resourced = check_resources(D)

	//can we craft this instantly?
	if(resourced && craft_instant(D, user))
		to_chat(user, "<span class='info'>[src] crafts a [D.name].</span>")
		use_resources(D)
		return

	//only need to update the sprite if we aren't already crafting
	if(!design_queue.len)
		if(resourced)
			//success
			icon_state = "[icon_base]_n"
		else
			icon_state = "[icon_base]_f"

	//add it to the queue for later processing
	var/datum/craft_entry/E = new()
	E.my_design = D
	design_queue += E
	ui_AddQueue(E, resourced)

	//tell the player
	if(resourced)
		to_chat(user, "<span class='info'>You add [D.name] to [src]'s production queue.</span>")
	else
		to_chat(user, "<span class='notice'>Insufficient resources to craft [D.name], please insert more.</span>")

/obj/machinery/research/protolathe/proc/craft_instant(var/datum/research_design/D, var/mob/user)
	. = FALSE

	//do we currently have a queue of orders?
	if(!design_queue.len)

		//is it simple to make?
		if(!D.complexity || speed > D.complexity)

			//have we already instant crafted this tick?
			if(instant_ready)
				//finish instantly
				//note: we assume that we've already done a resources check here
				flick("protolathe_n", src)
				finish_crafting(D)
				instant_ready = FALSE
				return TRUE

/obj/machinery/research/protolathe/proc/finish_crafting(var/datum/research_design/D)

	//is the queue empty?
	if(!design_queue.len)
		icon_state = icon_base

	//spawn thing
	var/obj/O = new D.product_type(src.loc)

	//move it out from the protolathe's tile
	if(output_dir)
		spawn(5)
			if(O && O.loc == src.loc)
				var/turf/target_turf = get_step(src, output_dir)
				O.Move(target_turf)

/obj/machinery/research/protolathe/proc/cancel_crafting(var/cancel_index, var/mob/user)

	var/datum/craft_entry/E = design_queue[cancel_index]

	design_queue.Cut(cancel_index, cancel_index + 1)
	ui_UnQueue(cancel_index)

	//is the queue empty?
	if(!design_queue.len)
		icon_state = icon_base

	//has it consumed some resources?
	if(E.started)
		var/proportion = 1
		//have we started building it?
		if(E.my_design.complexity && E.progress)
			//dont return all resources
			proportion -= E.progress / E.my_design.complexity
			to_chat(user, "<span class='info'>You remove [E.my_design.name] from the queue. Some resources are returned.</span>")
		else
			//return all resources
			to_chat(user, "<span class='info'>You remove [E.my_design.name] from the queue. All resources are returned.</span>")
		free_resources(E.my_design, proportion)
	else
		to_chat(user, "<span class='info'>You remove [E.my_design.name] from the queue.</span>")

