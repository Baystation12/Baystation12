var/global/obj/screen/robot_inventory

/mob/living/silicon/robot
	hud_type = /datum/hud/robot

/datum/hud/robot/FinalizeInstantiation()

	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/R = mymob

	adding = list()
	other = list()


	var/obj/screen/using

	//Radio
	using = new /obj/screen()
	using.SetName("radio")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	adding += using

	//Module select

	using = new /obj/screen()
	using.SetName("module1")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	adding += using
	R.inv1 = using

	using = new /obj/screen()
	using.SetName("module2")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	adding += using
	R.inv2 = using

	using = new /obj/screen()
	using.SetName("module3")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	adding += using
	R.inv3 = using


	//End of module select

	//Intent
	using = new /obj/screen()
	using.SetName("act_intent")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = R.a_intent
	using.screen_loc = ui_acti
	adding += using
	action_intent = using

	//Cell
	R.cells = new /obj/screen()
	R.cells.icon = 'icons/mob/screen1_robot.dmi'
	R.cells.icon_state = "charge-empty"
	R.cells.SetName("cell")
	R.cells.screen_loc = ui_toxin

	//Health
	R.healths = new /obj/screen()
	R.healths.icon = 'icons/mob/screen1_robot.dmi'
	R.healths.icon_state = "health0"
	R.healths.SetName("health")
	R.healths.screen_loc = ui_borg_health

	//Installed Module
	R.hands = new /obj/screen()
	R.hands.icon = 'icons/mob/screen1_robot.dmi'
	R.hands.icon_state = "nomod"
	R.hands.SetName("module")
	R.hands.screen_loc = ui_borg_module

	//Module Panel
	using = new /obj/screen()
	using.SetName("panel")
	using.icon = 'icons/mob/screen1_robot.dmi'
	using.icon_state = "panel"
	using.screen_loc = ui_borg_panel
	adding += using

	//Store
	R.throw_icon = new /obj/screen()
	R.throw_icon.icon = 'icons/mob/screen1_robot.dmi'
	R.throw_icon.icon_state = "store"
	R.throw_icon.SetName("store")
	R.throw_icon.screen_loc = ui_borg_store

	//Inventory
	robot_inventory = new /obj/screen()
	robot_inventory.SetName("inventory")
	robot_inventory.icon = 'icons/mob/screen1_robot.dmi'
	robot_inventory.icon_state = "inventory"
	robot_inventory.screen_loc = ui_borg_inventory

	//Temp
	R.bodytemp = new /obj/screen()
	R.bodytemp.icon = 'icons/mob/status_indicators.dmi'
	R.bodytemp.icon_state = "temp0"
	R.bodytemp.SetName("body temperature")
	R.bodytemp.screen_loc = ui_temp


	R.oxygen = new /obj/screen()
	R.oxygen.icon = 'icons/mob/screen1_robot.dmi'
	R.oxygen.icon_state = "oxy0"
	R.oxygen.SetName("oxygen")
	R.oxygen.screen_loc = ui_oxygen

	R.pullin = new /obj/screen()
	R.pullin.icon = 'icons/mob/screen1_robot.dmi'
	R.pullin.icon_state = "pull0"
	R.pullin.SetName("pull")
	R.pullin.screen_loc = ui_borg_pull

	R.fire = new /obj/screen()
	R.fire.icon = 'icons/mob/screen1_robot.dmi'
	R.fire.icon_state = "fire0"
	R.fire.SetName("fire")
	R.fire.screen_loc = ui_fire

	R.zone_sel = new /obj/screen/zone_sel()
	R.zone_sel.icon = 'icons/mob/screen1_robot.dmi'
	R.zone_sel.overlays.Cut()
	R.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[R.zone_sel.selecting]")

	//Handle the gun settings buttons
	R.gun_setting_icon = new /obj/screen/gun/mode(null)
	R.item_use_icon = new /obj/screen/gun/item(null)
	R.gun_move_icon = new /obj/screen/gun/move(null)
	R.radio_use_icon = new /obj/screen/gun/radio(null)

	R.client.screen = list()
	R.client.screen += list(R.throw_icon, R.zone_sel, R.oxygen, R.fire, R.hands, R.healths, mymob:cells, R.pullin, robot_inventory, R.gun_setting_icon)
	R.client.screen += adding + other

/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/R = mymob

	R.shown_robot_modules = !R.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!mymob?.client || !isrobot(mymob))
		return

	var/mob/living/silicon/robot/R = mymob


	if(R.shown_robot_modules)
		if(R.s_active)
			R.s_active.close(R) //Closes the inventory ui.
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!R.module)
			to_chat(usr, SPAN_DANGER("No module selected"))
			return

		if(!R.module.equipment)
			to_chat(usr, SPAN_DANGER("Selected module has no modules to select"))
			return

		if(!R.robot_modules_background)
			return

		var/display_rows = -round(-(R.module.equipment.len) / 8)
		R.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		R.client.screen += R.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(R.emagged)
			if(!(R.module.emag in R.module.equipment))
				R.module.equipment.Add(R.module.emag)
		else
			if(R.module.emag in R.module.equipment)
				R.module.equipment.Remove(R.module.emag)

		for(var/atom/movable/A in R.module.equipment)
			if (!R.IsHolding(A))
				//Module is not currently active
				R.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:[WORLD_ICON_SIZE/2],SOUTH+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:[WORLD_ICON_SIZE/2],SOUTH+[y]:7"
				A.hud_layerise()

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in R.module?.equipment)
			if (!R.IsHolding(A))
				//Module is not currently active
				R.client.screen -= A
		R.shown_robot_modules = 0
		R.client.screen -= R.robot_modules_background
