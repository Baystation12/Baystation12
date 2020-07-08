
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

/obj/machinery/research/protolathe/attackby(obj/item/weapon/W as obj, var/mob/user as mob)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	if(W.is_open_container())
		if(accepting_reagents)
			//call afterattack() so that the beaker transfers reagents to us
			do_reagents_update = TRUE
			return 0
		else
			//dont call afterattack()
			//we will now attempt to eject reagents to the beaker
			if(W.reagents.get_free_space())
				if(reagents.total_volume)
					var/target_amount = 10
					if(istype(W,/obj/item/weapon/reagent_containers))
						var/obj/item/weapon/reagent_containers/R = W
						target_amount = R.amount_per_transfer_from_this
					var/amount = reagents.trans_to_holder(W.reagents, target_amount)
					if(amount)
						do_reagents_update = TRUE
					to_chat(user, "<span class='notice'>You remove [amount] units of reagents from [src] to [W].</span>")
				else
					to_chat(user, "<span class='notice'>There are no reagents left in [src].</span>")
			else
				to_chat(user, "<span class='notice'>There is no space left in [W].</span>")

			return 1

	if(istype(W, /obj/item/stack/material))
		load_material(W, user)
		return TRUE

	else
		attempt_load_obj(W, user)
		return TRUE

	. = ..()

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
