/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | NO_CLIENT_COLOR
	unacidable = TRUE
	var/obj/master = null    //A reference to the object in the slot. Grabs or items, generally.
	var/globalscreen = FALSE //Global screens are not qdeled when the holding mob is destroyed.

/obj/screen/Destroy()
	master = null
	return ..()

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/obj/screen/close
	name = "close"

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/storage))
			var/obj/item/storage/S = master
			S.close(usr)
	return 1


/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Destroy()
	..()
	owner = null

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return 1
	if(!usr.canClick())
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click(owner)
	return 1

/obj/screen/item_relayed
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/obj/item/mouse_down_on = null
	var/obj/item/hovered_on = null

	proc/find_item(params)
	proc/empty_click(atom/location, control, params)

/obj/screen/item_relayed/Click(atom/location, control, params)
	if(!usr.canClick())
		return
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return

	var/obj/item/clicked_on = find_item(params)
	if (!isnull(clicked_on))
		usr.ClickOn(clicked_on, params)
	else
		empty_click(location, control, params)

	return 1

/obj/screen/item_relayed/MouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params)
	var/obj/item/drag_on = find_item(params)

	if (!isnull(drag_on))
		var/datum/click_handler/click_handler = usr.GetClickHandler()
		click_handler.OnMouseDrag(drag_on, params)

/obj/screen/item_relayed/MouseUp(location, control, params)
	var/obj/item/up_on = find_item(params)

	if (!isnull(up_on))
		var/datum/click_handler/click_handler = usr.GetClickHandler()
		click_handler.OnMouseUp(up_on, location, control, params)

/obj/screen/item_relayed/MouseDown(location, control, params)
	var/obj/item/down_on = find_item(params)

	if (!isnull(down_on))
		var/datum/click_handler/click_handler = usr.GetClickHandler()
		click_handler.OnMouseDown(down_on, location, control, params)
		mouse_down_on = down_on

/obj/screen/item_relayed/MouseDrop(atom/over_object, src_location, over_location, src_control, over_control, params)
	if (!isnull(mouse_down_on))
		mouse_down_on.MouseDrop(over_object, src_location, over_location, src_control, over_control, params)

/obj/screen/item_relayed/MouseEntered(location, control, params)
	hovered_on = find_item(params)
	if (!isnull(hovered_on))
		hovered_on.MouseEntered(location, control, params)

/obj/screen/item_relayed/MouseMove(location, control, params)
	var/obj/item/new_hovered_on = find_item(params)

	if (hovered_on != new_hovered_on)
		if (!isnull(hovered_on))
			hovered_on.MouseExited(location, control, params)
		if (!isnull(new_hovered_on))
			new_hovered_on.MouseEntered(location, control, params)
		hovered_on = new_hovered_on
	else if (!isnull(hovered_on))
		hovered_on.MouseMove(location, control, params)

/obj/screen/item_relayed/MouseExited(location, control, params)
	if (!isnull(hovered_on))
		hovered_on.MouseExited(location, control, params)
	hovered_on = null

/obj/screen/item_relayed/storage
	name = "storage"

	var/datum/storage_ui/default/containing_ui = null

/obj/screen/item_relayed/storage/empty_click(atom/location, control, string_params)
	if (master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)

	return 1

/obj/screen/item_relayed/storage/find_item(string_params)
	if (isnull(master) || isnull(containing_ui))
		return null

	var/list/params = params2list(string_params)
	var/list/clicked_loc = splittext(params[MOUSE_SCREEN_LOC], ",")
	var/list/clicked_loc_X = splittext(clicked_loc[1],":")
	var/list/clicked_loc_Y = splittext(clicked_loc[2],":")

	if (!isnull(containing_ui.storage.storage_slots))
		var/clicked_loc_tile_X = text2num(clicked_loc_X[1])
		var/clicked_loc_pixel_X = text2num(clicked_loc_X[2])

		if (clicked_loc_pixel_X <= 16)
			clicked_loc_tile_X -= 1

		var/clicked_loc_tile_Y = text2num(clicked_loc_Y[1])
		var/clicked_loc_pixel_Y = text2num(clicked_loc_Y[2])

		if (clicked_loc_pixel_Y <= 16)
			clicked_loc_tile_Y -= 1

		var/obj/item/O = containing_ui.slot_obj_locs["[clicked_loc_tile_X],[clicked_loc_tile_Y]"]

		if (istype(O, /obj/item))
			return O
	else
		var/clicked_loc_tile_X = text2num(clicked_loc_X[1])
		var/clicked_loc_pixel_X = text2num(clicked_loc_X[2])

		var/clicked_loc_x = clicked_loc_tile_X * WORLD_ICON_SIZE + clicked_loc_pixel_X 

		for (var/i in 1 to length(containing_ui.space_obj_x_start))
			var/obj/item/O = master.contents[i]
			if (!istype(O, /obj/item))
				continue

			if (!(containing_ui.space_obj_x_start[i] <= clicked_loc_x && clicked_loc_x <= containing_ui.space_obj_x_end[i]))
				continue

			return O

	return null

/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_CHEST

/obj/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL[MOUSE_ICON_X])
	var/icon_y = text2num(PL[MOUSE_ICON_Y])
	var/new_selecting

	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					new_selecting = BP_R_FOOT
				if(17 to 22)
					new_selecting = BP_L_FOOT
				else
					return 1
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					new_selecting = BP_R_LEG
				if(17 to 22)
					new_selecting = BP_L_LEG
				else
					return 1
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					new_selecting = BP_R_HAND
				if(12 to 20)
					new_selecting = BP_GROIN
				if(21 to 24)
					new_selecting = BP_L_HAND
				else
					return 1
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					new_selecting = BP_R_ARM
				if(12 to 20)
					new_selecting = BP_CHEST
				if(21 to 24)
					new_selecting = BP_L_ARM
				else
					return 1
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				new_selecting = BP_HEAD
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							new_selecting = BP_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							new_selecting = BP_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							new_selecting = BP_EYES

	set_selected_zone(new_selecting)
	return 1

/obj/screen/zone_sel/proc/set_selected_zone(bodypart)
	var/old_selecting = selecting
	selecting = bodypart
	var/mob/living/carbon/human/user = usr
	if (istype(user) && (old_selecting == BP_MOUTH || selecting == BP_MOUTH) && user.aiming && user.aiming.active && user.aiming.aiming_at == user)
		var/obj/aiming_overlay/AO = user.aiming
		AO.aim_at(user, user.aiming.aiming_with, TRUE)
	if (old_selecting != selecting)
		update_icon()
		return TRUE

/obj/screen/zone_sel/on_update_icon()
	ClearOverlays()
	AddOverlays(image('icons/mob/zone_sel.dmi', "[selecting]"))

/obj/screen/intent
	name = "intent"
	icon = 'icons/mob/screen1_White.dmi'
	icon_state = "intent_help"
	screen_loc = ui_acti
	var/intent = I_HELP

/obj/screen/intent/Click(location, control, params)
	var/list/P = params2list(params)
	var/icon_x = text2num(P[MOUSE_ICON_X])
	var/icon_y = text2num(P[MOUSE_ICON_Y])
	intent = I_DISARM
	if(icon_x <= world.icon_size/2)
		if(icon_y <= world.icon_size/2)
			intent = I_HURT
		else
			intent = I_HELP
	else if(icon_y <= world.icon_size/2)
		intent = I_GRAB
	update_icon()
	usr.a_intent = intent

/obj/screen/intent/on_update_icon()
	icon_state = "intent_[intent]"

/obj/screen/Click(location, control, params)
	if(!usr)	return 1
	switch(name)
		if("toggle")
			if(usr.hud_used.inventory_shown)
				usr.hud_used.inventory_shown = 0
				usr.client.screen -= usr.hud_used.other
			else
				usr.hud_used.inventory_shown = 1
				usr.client.screen += usr.hud_used.other

			usr.hud_used.hidden_inventory_update()

		if("equip")
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("Reset Machine")
			usr.unset_machine()
		if("internal")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
					if(C.internal)
						C.set_internals(null)
					else

						var/no_mask
						if(!(C.wear_mask && C.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
							var/mob/living/carbon/human/H = C
							if(!(H.head && H.head.item_flags & ITEM_FLAG_AIRTIGHT))
								no_mask = 1

						if(no_mask)
							to_chat(C, SPAN_NOTICE("You are not wearing a suitable mask or helmet."))
							return 1
						else
							var/list/nicename = null
							var/list/tankcheck = null
							var/breathes = GAS_OXYGEN    //default, we'll check later
							var/list/contents = list()
							var/from = "on"

							if(ishuman(C))
								var/mob/living/carbon/human/H = C
								breathes = H.species.breath_type
								nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
								tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
							else
								nicename = list("right hand", "left hand", "back")
								tankcheck = list(C.r_hand, C.l_hand, C.back)

							// Rigs are a fucking pain since they keep an air tank in nullspace.
							if(istype(C.back,/obj/item/rig))
								var/obj/item/rig/rig = C.back
								if(rig.air_supply)
									from = "in"
									nicename |= "hardsuit"
									tankcheck |= rig.air_supply

							for(var/i=1, i<length(tankcheck)+1, ++i)
								if(istype(tankcheck[i], /obj/item/tank))
									var/obj/item/tank/t = tankcheck[i]
									if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
										contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
										continue					//in it, so we're going to believe the tank is what it says it is
									if(t.air_contents.gas[breathes] && !t.air_contents.gas[GAS_PHORON])
										contents.Add(t.air_contents.gas[breathes])
									else
										contents.Add(0)
								else
									//no tank so we set contents to 0
									contents.Add(0)

							//Alright now we know the contents of the tanks so we have to pick the best one.

							var/best = 0
							var/bestcontents = 0
							for(var/i=1, i <  length(contents) + 1 , ++i)
								if(!contents[i])
									continue
								if(contents[i] > bestcontents)
									best = i
									bestcontents = contents[i]


							//We've determined the best container now we set it as our internals

							if(best)
								C.set_internals(tankcheck[best], "\the [tankcheck[best]] [from] your [nicename[best]]")

							if(!C.internal)
								// Finally, check for an internal air system.
								// We use this as an absolute last resort, so we don't include it in the above logic
								// There's no need to check that the gas contents are safe, because its internal logic always make sure it is
								var/obj/item/organ/internal/augment/active/internal_air_system/IAS = locate() in C.internal_organs
								if (!IAS?.activate())
									to_chat(C, SPAN_WARNING("You don't have \a [breathes] tank."))
		if("act_intent")
			usr.a_intent_change("right")

		if("pull")
			usr.stop_pulling()
		if("throw")
			if(!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr:toggle_throw_mode()
		if("drop")
			if(usr.client)
				usr.client.drop_item()

		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
//				if(R.module)
//					R.hud_used.toggle_show_robot_modules()
//					return 1
				R.pick_module()

		if("inventory")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return 1
				else
					to_chat(R, "You haven't selected a module yet.")

		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.uneq_active()
					R.hud_used.update_robot_modules_display()
				else
					to_chat(R, "You haven't selected a module yet.")

		if("module1")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(1)

		if("module2")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(2)

		if("module3")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(3)
		else
			return 0
	return 1

/obj/screen/item_relayed/inventory_slot
	var/slot_id

/obj/screen/item_relayed/inventory_slot/find_item(params)
	if (!ismob(usr))
		return null

	var/mob/C = usr
	return C.get_equipped_item(slot_id)

/obj/screen/item_relayed/inventory_slot/empty_click(atom/location, control, params)
	switch(name)
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(C.hand)
					C.activate_hand("r")
				else
					C.attack_empty_hand(BP_R_HAND)
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.hand)
					C.activate_hand("l")
				else
					C.attack_empty_hand(BP_L_HAND)
		if("swap")
			usr:swap_hand()
		if("hand")
			usr:swap_hand()
		else
			if(usr.attack_ui(slot_id))
				usr.update_inv_l_hand(0)
				usr.update_inv_r_hand(0)

/obj/screen/item_relayed/inventory_slot/Adjacent(atom/neighbor)
	return neighbor == usr

/obj/screen/item_relayed/inventory_slot/MouseDrop_T(atom/dropped, mob/living/user)
	// Hands - Transfer items to between hands with drag+drop.
	if (name == BP_R_HAND && user.l_hand == dropped)
		return user.put_in_r_hand(dropped)

	if (name == BP_L_HAND && user.r_hand == dropped)
		return user.put_in_l_hand(dropped)

	return ..()
