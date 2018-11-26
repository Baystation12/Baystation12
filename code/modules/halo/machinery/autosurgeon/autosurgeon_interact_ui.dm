
/obj/machinery/autosurgeon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	/*if(!can_use(user))
		if(ui)
			ui.close()
			interacting_mob = null
		return*/

	var/data[0]
	if(buckled_mob)
		data["buckled_mob"] = "\ref[buckled_mob]"
		data["name"] = "[buckled_mob.name]"
		if(ishuman(buckled_mob))
			var/mob/living/carbon/human/H = buckled_mob
			data["species"] = "[H.species.name]"
		else
			data["species"] = "Unknown"
		//
		data["fire_loss"] = buckled_mob.getFireLoss()
		data["brute_loss"] = buckled_mob.getBruteLoss()
		data["max_health"] = buckled_mob.getMaxHealth()
	//
	data["do_start_delay"] = do_start_delay
	data["start_delay"] = start_delay/10
	data["active"] = active
	data["autosurgeon_stage"] = autosurgeon_stage
	data["buckled_mob"] = buckled_mob ? 1 : 0
	//
	if(internal_bruise_pack)
		data["bruisepack_amount"] = internal_bruise_pack.amount
	else
		data["bruisepack_amount"] = 0
	if(internal_ointment)
		data["ointment_amount"] = internal_ointment.amount
	else
		data["ointment_amount"] = 0
	if(internal_splint)
		data["splint_amount"] = internal_splint.amount
	else
		data["splint_amount"] = 0
	//
	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "autosurgeon.tmpl", "Autosurgeon", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
