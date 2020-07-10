
/obj/machinery/research/destructive_analyzer
	name = "destructive analyzer"
	desc = "Assists technology research by destroying things."
	icon_state = "d_analyzer"
	state_base = "d_analyzer"
	state_loaded = "d_analyzer_l"
	state_loading = "d_analyzer_la"
	active_power_usage = 10000
	idle_power_usage = 100

	var/recycle_rate = 0
	var/busy = FALSE

/obj/machinery/research/destructive_analyzer/examine(var/mob/user)
	. = ..()
	var/out_text = ""
	out_text += "It has a matter recycling rate of [round(100 * recycle_rate)]%. "
	to_chat(user,"<span class='info'>[out_text]</span>")

/obj/machinery/research/destructive_analyzer/can_load_item(var/obj/item/I, var/mob/user as mob)

	if(busy)
		to_chat(user,"\icon[src] <span class='warning'>[src] is busy right now.</span>")
		return FALSE

	//automation is a hardware upgrade, but we still need the control software for it to work
	if(automated && controller)
		if(controller.can_destruct_object(I))
			return TRUE

		to_chat(user,"\icon[src] <span class='warning'>[src] does not want that right now.</span>")
		return FALSE

	return TRUE

/obj/machinery/research/destructive_analyzer/attempt_load_item(var/obj/item/I, var/mob/user as mob)
	. = ..()

	if(.)
		busy = TRUE
		playsound(src, 'sound/machines/BoltsUp.ogg', 100, 1)

		//give time for the loading animation to finish
		spawn(10)
			busy = FALSE

			//automation is a hardware upgrade, but we still need the control software for it to work
			if(automated && controller)
				//tell the controller to activate us
				controller.activate_destruct()

/obj/machinery/research/destructive_analyzer/attack_hand(var/mob/user)
	if(busy)
		to_chat(user,"\icon[src] <span class='warning'>[src] is busy right now.</span>")
		return

	if(loaded_item)
		eject_item()
	else
		to_chat(user,"\icon[src] <span class='warning'>[src] has nothing loaded right now.</span>")

/obj/machinery/research/destructive_analyzer/proc/eject_item()
	if(loaded_item && !busy)
		playsound(src, 'sound/machines/BoltsDown.ogg', 100, 1)
		icon_state = "d_analyzer"
		loaded_item.loc = src.loc
		loaded_item = null

/obj/machinery/research/destructive_analyzer/proc/activate_destruct()
	//only the control software should be calling this proc
	if(loaded_item && !busy)
		use_power(active_power_usage)
		playsound(src, 'sound/machines/blender.ogg', 100, 1)
		icon_state = "d_analyzer"
		flick("d_analyzer_process", src)
		busy = TRUE
		spawn(24)
			busy = FALSE
			finish_destruct()
		return 1

/obj/machinery/research/destructive_analyzer/proc/finish_destruct()
	if(controller)
		controller.obj_destruct(loaded_item)

		//if it's a container, empty it and eject it for reuse
		var/obj/item/weapon/reagent_containers/R = loaded_item
		if(istype(R))
			R.reagents.clear_reagents()
			R.loc = src.loc
		else
			//chance to recycle some materials
			if(recycle_rate && loaded_item.matter && loaded_item.matter.len)
				//grab a random material for recycling
				var/mat_name = pick(loaded_item.matter)

				//get the materials datum
				var/material/M = get_material_by_name(mat_name)
				if(!M)
					to_debug_listeners("TECH ERROR: invalid material id in var/matter for [loaded_item.type]: \'[mat_name]\'\
						in [src.type]")
				else
					//work out how much we are going to recycle
					var/recycle_amount = loaded_item.matter[mat_name]

					//material stacks have different amount handling
					if(istype(loaded_item, /obj/item/stack))
						var/obj/item/stack/old = loaded_item
						recycle_amount = old.amount

					//a chance to fail recycling
					//higher amounts of matter = higher chance of recycling
					var/recycle_chance = recycle_amount * 10
					recycle_chance += 100 * recycle_rate
					if(prob(recycle_chance))
						//create the material stack
						var/obj/item/stack/S = new M.stack_type(get_turf(src))
						S.amount = 0

						//return a portion
						recycle_amount *= recycle_rate
						recycle_amount = max(round(recycle_amount), 1)
						S.add(recycle_amount)
						visible_message("<span class='info'>[src] recycles \icon[S] [S] x [S.amount].</span>")

			qdel(loaded_item)
		loaded_item = null
	else
		eject_item()
		visible_message("\icon[src] <span class='notice'>Contact lost with control software.</span>")

/obj/machinery/research/destructive_analyzer/RefreshParts()
	. = ..()

	recycle_rate = 0
	for(var/obj/item/weapon/stock_parts/scanning_module/M in component_parts)
		recycle_rate += M.rating
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts)
		recycle_rate += M.rating

	//average of these parts... there should be exactly 3 total
	recycle_rate /= 3

	//dont recycle anything with stock parts
	recycle_rate -= 1
	recycle_rate = max(recycle_rate, 0)

	//change to a %
	recycle_rate /= 100

	//having max tier stock parts results in a recycle rate of 3% so lets boost that a bit
	recycle_rate *= 10

	recycle_rate = round(recycle_rate, 0.01)
