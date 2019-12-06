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
	appearance_flags = NO_CLIENT_COLOR
	unacidable = 1
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


/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.


/obj/screen/close
	name = "close"

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = master
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

	owner.ui_action_click()
	return 1

/obj/screen/storage
	name = "storage"

/obj/screen/storage/Click()
	if(!usr.canClick())
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)
	return 1

/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_CHEST

/obj/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
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
	if(old_selecting != selecting)
		update_icon()
		return TRUE

/obj/screen/zone_sel/on_update_icon()
	overlays.Cut()
	overlays += image('icons/mob/zone_sel.dmi', "[selecting]")

/obj/screen/intent
	name = "intent"
	icon = 'icons/mob/screen1_White.dmi'
	icon_state = "intent_help"
	screen_loc = ui_acti
	var/intent = I_HELP

/obj/screen/intent/Click(var/location, var/control, var/params)
	var/list/P = params2list(params)
	var/icon_x = text2num(P["icon-x"])
	var/icon_y = text2num(P["icon-y"])
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
							to_chat(C, "<span class='notice'>You are not wearing a suitable mask or helmet.</span>")
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
							if(istype(C.back,/obj/item/weapon/rig))
								var/obj/item/weapon/rig/rig = C.back
								if(rig.air_supply)
									from = "in"
									nicename |= "hardsuit"
									tankcheck |= rig.air_supply

							for(var/i=1, i<tankcheck.len+1, ++i)
								if(istype(tankcheck[i], /obj/item/weapon/tank))
									var/obj/item/weapon/tank/t = tankcheck[i]
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
							for(var/i=1, i <  contents.len + 1 , ++i)
								if(!contents[i])
									continue
								if(contents[i] > bestcontents)
									best = i
									bestcontents = contents[i]


							//We've determined the best container now we set it as our internals

							if(best)
								C.set_internals(tankcheck[best], "\the [tankcheck[best]] [from] your [nicename[best]]")

							if(!C.internal)
								to_chat(C, "<span class='notice'>You don't have \a [breathes] tank.</span>")
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

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!usr.canClick())
		return 1
	if(usr.incapacitated())
		return 1
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
	return 1
