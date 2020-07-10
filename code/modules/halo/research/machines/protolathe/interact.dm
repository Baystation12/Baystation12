
/obj/machinery/research/protolathe/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/research/protolathe/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/data[0]
	data["avail_designs"] = uiData_Designs
	data["design_queue"] = uiData_Queue
	data += uiData_SelectedDesign
	data["reagents"] = reagents_string
	data["materials"] = ui_materials
	data["components"] = ui_components
	data["accepting_reagents"] = accepting_reagents
	data["resources"] = "matter: [components_storage_used + material_storage_used] out of [max_storage] sheets, \
		reagents: [reagents.total_volume] out of [reagents.maximum_volume] units"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "protolathe.tmpl", "[src.name]", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/research/protolathe/attempt_load_item(var/obj/item/I, var/mob/user as mob)
	. = FALSE

	if(can_load_item(I, user))
		//do we have custom handling for reagent containers?
		if(I.is_open_container())
			return attempt_load_reagent_container(I, user)

		else
			if(istype(I, /obj/item/stack/material))
				return load_material(I, user)

			else
				return attempt_load_component(I, user)

/obj/machinery/research/protolathe/verb/cycle_output_dir()
	set src in view(1)
	set category = "Object"
	set name = "Cycle product output direction"

	if(output_dir)
		output_dir *= 2
	else
		output_dir = 1

	var/dir_text
	if(output_dir == 16)
		output_dir = 0
		dir_text = "its own tile"
	else
		dir_text = "the [dir2text(output_dir)]"

	to_chat(usr, "\icon[src] <span class='info'>[src] will now try to output finished products to [dir_text].</span>")

/obj/machinery/research/protolathe/examine(var/mob/user)
	. = ..()
	var/out_text = ""
	if(output_dir)
		out_text += "It is set to output to the [dir2text(output_dir)]. "
	else
		out_text += "It is set to output to it's own tile. "

	out_text += "It has a crafting speed of [round(100 * speed)]%. "
	out_text += "It can craft [craft_parallel] items in parallel. "
	out_text += "Its material consumption rate is [round(100 * mat_efficiency)]%. "

	to_chat(user,"<span class='info'>[out_text]</span>")
