
/obj/machinery/research/component_dissembler
	name = "component dissembler"
	desc = "Breaks things down into their components."
	icon = 'code/modules/halo/research/machines/heavy_lathe.dmi'
	icon_state = "h_lathe"
	state_base = "h_lathe"
	state_loaded = "h_lathe_wloop"
	state_loading = "h_lathe_load"
	bound_width = 64	//long boy

	var/list/spawned_components = list()
	var/decon_speed = 1
	var/progress = 0
	var/max_progress = 6
	var/output_dir = WEST

/obj/machinery/research/component_dissembler/examine(var/mob/user)
	. = ..()
	var/out_text = ""
	if(output_dir != WEST)
		out_text += "It is set to output to the [dir2text(output_dir)]. "
	else
		out_text += "It is set to output to it's own tile. "

	out_text += "It has a disassembly speed of [round(100 * decon_speed)]%. "

	if(loaded_item)
		out_text += "It is currently disassembling [loaded_item] ([round(100 * progress/max_progress)]%). "

	to_chat(user,"<span class='info'>[out_text]</span>")

/obj/machinery/research/component_dissembler/can_load_item(var/obj/item/I, var/mob/user as mob)
	if((!I.matter || !I.matter.len) && \
		(!I.salvage_components || !I.salvage_components.len))
		to_chat(user, "\icon[src] <span class='info'>[I] contains nothing useful for dissassembly.</span>")
		to_debug_listeners("NOTICE: [I.type] has no var/matter or var/salvage_components for [src.type]")
		return FALSE

	if(istype(I,/obj/item/stack/material))
		to_chat(user, "\icon[src] <span class='info'>[I] can not be broken down any further.</span>")
		return FALSE

	return TRUE

/obj/machinery/research/component_dissembler/attempt_load_item(var/obj/item/I, var/mob/user as mob)
	. = ..()
	if(.)
		GLOB.processing_objects += src
		update_use_power(2)
		icon_state = "h_lathe_wloop"
		flick("h_lathe_load", src)

		//larger items take longer to take apart
		max_progress = I.w_class * 5

/obj/machinery/research/component_dissembler/process()
	. = ..()
	if(loaded_item)
		if(progress >= max_progress)
			eject_component()

			if(!spawned_components.len)
				//some final cleanup stuff
				update_use_power(1)
				qdel(loaded_item)
				loaded_item = null
				progress = 0
				GLOB.processing_objects -= src
				icon_state = "h_lathe"
		else
			progress += decon_speed
			if(progress >= max_progress)
				icon_state = "h_lathe_leave"
				finish_dissembling()
	else
		return PROCESS_KILL

/obj/machinery/research/component_dissembler/proc/finish_dissembling()
	update_use_power(1)

	//matter used to construct the thing
	if(loaded_item.matter)
		for(var/mat_name in loaded_item.matter)
			//create the materials object
			var/material/M = get_material_by_name(mat_name)
			if(!M)
				to_debug_listeners("TECH ERROR: invalid material id in var/matter for [loaded_item.type]: \'[mat_name]\'\
					in [src.type]")
				continue
			var/obj/item/stack/S = new M.stack_type(src)

			//by default it has 1, so add (amount - 1)
			var/amount = loaded_item.matter[mat_name] / SHEET_MATERIAL_AMOUNT
			if(amount < 1)
				to_debug_listeners("WARNING: [loaded_item.type] in [src.type] has produced [amount] sheets of [mat_name]")
				amount = 1
			amount = max(amount - 1, 0)
			S.add(amount)

			//track it so we can eject it later
			spawned_components.Add(S)

	if(loaded_item.salvage_components)
		for(var/comp_type in loaded_item.salvage_components)
			//create the component object
			var/obj/item/S = new comp_type(src)

			//track it so we can eject it later
			spawned_components.Add(S)

/obj/machinery/research/component_dissembler/proc/eject_component()
	if(spawned_components.len)

		//starting turf
		var/turf/spawn_turf = get_step(src, EAST)

		var/obj/O = spawned_components[1]
		spawned_components -= O
		O.loc = spawn_turf

		//WEST means eject the component onto our own turf
		if(output_dir != WEST)
			//move the item in the direction
			var/turf/exit_turf = spawn_turf
			exit_turf = get_step(exit_turf, output_dir)

			//this should respect normal movement restrictions ie walls etc
			spawn(5)
				O.Move(exit_turf)

/obj/machinery/research/component_dissembler/attack_hand(var/mob/user)
	cycle_output_dir()

/obj/machinery/research/component_dissembler/verb/cycle_output_dir()
	set src in view(1)
	set category = "Object"
	set name = "Cycle dissembly output direction"

	output_dir *= 2
	var/dir_text
	if(output_dir == 16)
		output_dir = NORTH

	if(output_dir == WEST)
		dir_text = "its own tile"
	else
		dir_text = "the [dir2text(output_dir)]"

	to_chat(usr, "\icon[src] <span class='info'>[src] will now try to output components to [dir_text].</span>")

/obj/machinery/research/component_dissembler/RefreshParts()
	. = ..()

	decon_speed = 0
	for(var/obj/item/weapon/stock_parts/M in component_parts)
		decon_speed += M.rating

	decon_speed /= 2
