
/obj/machinery/research/component_dissembler
	name = "component dissembler"
	desc = "Breaks things down into their components."
	icon = 'code/modules/halo/research/machines/heavy_lathe.dmi'
	icon_state = "h_lathe"
	bound_width = 64	//long boy

	var/obj/item/loaded_item
	var/list/spawned_components = list()
	var/progress = 0
	var/max_progress = 6
	var/output_dir = WEST

	var/list/accepted_materials_stacks = list(\
		"steel" = /obj/item/stack/material/steel,\
		"plasteel" = /obj/item/stack/material/plasteel,\
		"gold" = /obj/item/stack/material/gold,\
		"phoron" = /obj/item/stack/material/phoron,\
		"iron" = /obj/item/stack/material/iron,\
		"diamond" = /obj/item/stack/material/diamond,\
		"uranium" = /obj/item/stack/material/uranium,\
		"plastic" = /obj/item/stack/material/plastic,\
		"uranium" = /obj/item/stack/material/platinum,\
		"osmium-carbide plasteel" = /obj/item/stack/material/ocp,\
		"glass" = /obj/item/stack/material/glass,\
		"rglass" = /obj/item/stack/material/glass/reinforced,\
		"phglass" = /obj/item/stack/material/glass/phoronglass,\
		"rphglass" = /obj/item/stack/material/glass/phoronrglass,\
		"nanolaminate" = /obj/item/stack/material/nanolaminate,\
		"duridium" = /obj/item/stack/material/duridium,\
		"kemocite" = /obj/item/stack/material/kemocite,\
		"silver" = /obj/item/stack/material/silver)

/obj/machinery/research/component_dissembler/examine(var/mob/user)
	. = ..()
	if(output_dir != WEST)
		to_chat(user,"<span class='info'>It is set to output to the [dir2text(output_dir)]</span>")
	else
		to_chat(user,"<span class='info'>It is set to output to it's own tile.</span>")

	if(loaded_item)
		to_chat(user,"<span class='info'>It is currently disassembling [loaded_item] \
			([round(100 * progress/max_progress)]%)</span>")

/obj/machinery/research/component_dissembler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	if(istype(W, /obj/item))
		if(loaded_item)
			to_chat(user, "\icon[src] <span class='warning'>[src] already has something loaded.</span>")
		else
			attempt_load_item(W, user)

/obj/machinery/research/component_dissembler/attempt_load_item(var/obj/item/I, var/mob/user as mob)
	if(!loaded_item)
		if((!I.matter || !I.matter.len) && \
			(!I.salvage_components || !I.salvage_components.len))
			to_chat(user, "\icon[src] <span class='info'>[I] contains nothing useful for dissassembly.</span>")
			return

		if(user)
			to_chat(user, "\icon[src] <span class='info'>You load [I] into [src] for dissassembly.</span>")
			user.drop_item()
		I.loc = src
		loaded_item = I
		GLOB.processing_objects += src
		icon_state = "h_lathe_wloop"
		flick("h_lathe_load", src)
		update_use_power(2)

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
			progress += 1
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
			var/stack_type = accepted_materials_stacks[mat_name]
			if(!stack_type)
				to_debug_listeners("DISSEMBLY ERROR: invalid material id in var/matter for [loaded_item.type]: \'[mat_name]\'")
				continue
			var/obj/item/stack/S = new stack_type(src)

			//by default it has 1, so add (amount - 1)
			S.add(loaded_item.matter[mat_name] - 1)

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
