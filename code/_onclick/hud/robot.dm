var/global/obj/screen/robot_inventory

/mob/living/silicon/robot
	hud_type = /datum/hud/robot

/datum/hud/robot/FinalizeInstantiation()

	src.adding = list()
	src.other = list()

	var/obj/screen/using

	//Radio
	using = new /obj/screen()
	using.SetName("radio")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	src.adding += using

	//Module select

	using = new /obj/screen()
	using.SetName("module1")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	src.adding += using
	mymob:inv += using

	using = new /obj/screen()
	using.SetName("module2")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	src.adding += using
	mymob:inv += using

	using = new /obj/screen()
	using.SetName("module3")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	src.adding += using
	mymob:inv += using

	//End of module select

	//Intent
	using = new /obj/screen()
	using.SetName("act_intent")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	src.adding += using
	action_intent = using

	//Cell
	mymob.cells = new /obj/screen()
	mymob.cells.icon = 'icons/mob/screen1_robot.dmi'
	mymob.cells.icon_state = "charge-empty"
	mymob.cells.SetName("cell")
	mymob.cells.screen_loc = ui_toxin

	//Health
	mymob.healths = new /obj/screen()
	mymob.healths.icon = 'icons/mob/screen1_robot.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = ui_borg_health

	//Installed Module
	mymob.hands = new /obj/screen()
	mymob.hands.icon = 'icons/mob/screen1_robot.dmi'
	mymob.hands.icon_state = "nomod"
	mymob.hands.SetName("module")
	mymob.hands.screen_loc = ui_borg_module

	//Module Panel
	using = new /obj/screen()
	using.SetName("panel")
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "panel"
	using.screen_loc = ui_borg_panel
	src.adding += using

	//Store
	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = 'icons/mob/screen1_robot.dmi'
	mymob.throw_icon.icon_state = "store"
	mymob.throw_icon.SetName("store")
	mymob.throw_icon.screen_loc = ui_borg_store

	//Inventory
	robot_inventory = new /obj/screen()
	robot_inventory.SetName("inventory")
	robot_inventory.icon = 'icons/mob/screen1_robot.dmi'
	robot_inventory.icon_state = "inventory"
	robot_inventory.screen_loc = ui_borg_inventory

	//Temp
	mymob.bodytemp = new /obj/screen()
	mymob.bodytemp.icon = 'icons/mob/status_indicators.dmi'
	mymob.bodytemp.icon_state = "temp0"
	mymob.bodytemp.SetName("body temperature")
	mymob.bodytemp.screen_loc = ui_temp


	mymob.oxygen = new /obj/screen()
	mymob.oxygen.icon = 'icons/mob/screen1_robot.dmi'
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.SetName("oxygen")
	mymob.oxygen.screen_loc = ui_oxygen

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = 'icons/mob/screen1_robot.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.SetName("pull")
	mymob.pullin.screen_loc = ui_borg_pull

	mymob.fire = new /obj/screen()
	mymob.fire.icon = 'icons/mob/screen1_robot.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.SetName("fire")
	mymob.fire.screen_loc = ui_fire

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = 'icons/mob/screen1_robot.dmi'
	mymob.zone_sel.ClearOverlays()
	mymob.zone_sel.AddOverlays(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	mymob.item_use_icon = new /obj/screen/gun/item(null)
	mymob.gun_move_icon = new /obj/screen/gun/move(null)
	mymob.radio_use_icon = new /obj/screen/gun/radio(null)

	mymob.client.screen = list()
	mymob.client.screen += list(mymob.throw_icon, mymob.zone_sel, mymob.oxygen, mymob.fire, mymob.hands, mymob.healths, mymob:cells, mymob.pullin, robot_inventory, mymob.gun_setting_icon)
	mymob.client.screen += src.adding + src.other

/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!mymob?.client || !isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	if(r.shown_robot_modules)
		if(r.s_active)
			r.s_active.close(r) //Closes the inventory ui.
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			to_chat(usr, SPAN_DANGER("No module selected"))
			return

		if(!r.module.equipment)
			to_chat(usr, SPAN_DANGER("Selected module has no modules to select"))
			return

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if (r.emagged && !r.module.is_emagged)
			r.module.handle_emagged(r)

		var/display_rows = -round(-(length(r.module.equipment)) / 8)
		var/slot_count = display_rows * 8

		while (length(r.robot_module_slots) < slot_count)
			r.robot_module_slots += new /obj/screen/item_relayed/robot_module_slot
		while (length(r.robot_module_slots) > slot_count)
			var/obj/screen/item_relayed/robot_module_slot/extra = r.robot_module_slots[length(r.robot_module_slots)]
			LIST_DEC(r.robot_module_slots)
			r.client.screen -= extra
			qdel(extra)

		for (var/i in 1 to slot_count)
			var/obj/screen/item_relayed/robot_module_slot/slot = r.robot_module_slots[i]
			slot.module_item = null
			slot.hovered_on = null
			slot.mouse_down_on = null
			slot.screen_loc = robot_module_screen_loc(i)
			r.client.screen += slot

		var/slot_index = 1
		for (var/atom/movable/A in r.module.equipment)
			if (!r.IsHolding(A))
				//Module is not currently active
				r.client.screen += A
				A.screen_loc = robot_module_screen_loc(slot_index)
				A.hud_layerise()

				var/obj/screen/item_relayed/robot_module_slot/slot = r.robot_module_slots[slot_index]
				if (isitem(A))
					slot.module_item = A

				slot_index++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module?.equipment)
			if (!r.IsHolding(A))
				//Module is not currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		for (var/obj/screen/item_relayed/robot_module_slot/slot as anything in r.robot_module_slots)
			slot.module_item = null
			slot.hovered_on = null
			slot.mouse_down_on = null
			r.client.screen -= slot

/datum/hud/proc/robot_module_screen_loc(index)
	var/x = ((index - 1) % 8) - 4
	var/y = round((index - 1) / 8) + 1
	return "CENTER[x < 0 ? "[x]" : "+[x]"]:[WORLD_ICON_SIZE/2],SOUTH+[y]:7"
