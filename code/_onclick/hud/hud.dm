/*
	The global hud:
	Uses the same visual objects for all players.
*/
var/datum/global_hud/global_hud = new()

/datum/hud/var/obj/screen/grab_intent
/datum/hud/var/obj/screen/hurt_intent
/datum/hud/var/obj/screen/disarm_intent
/datum/hud/var/obj/screen/help_intent

/datum/global_hud
	var/obj/screen/druggy
	var/obj/screen/blurry
	var/list/vimpaired
	var/list/darkMask
	var/obj/screen/nvg
	var/list/nview
	var/list/sview
	var/list/eview
	var/list/wview
	var/list/rnview
	var/list/rsview
	var/list/review
	var/list/rwview

/datum/global_hud/New()
	//420erryday psychedellic colours screen overlay for when you are high
	druggy = new /obj/screen()
	druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	druggy.icon_state = "druggy"
	druggy.layer = 17
	druggy.mouse_opacity = 0

	//that white blurry effect you get when you eyes are damaged
	blurry = new /obj/screen()
	blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	blurry.icon_state = "blurry"
	blurry.layer = 17
	blurry.mouse_opacity = 0

	nvg = new /obj/screen()
	nvg.screen_loc = "1,1"
	nvg.icon = 'icons/obj/nvg_hud_full.dmi'
	nvg.icon_state = "nvg_hud"
	nvg.layer = 17
	nvg.mouse_opacity = 0

	var/obj/screen/O
	var/i
	//that nasty looking dither you  get when you're short-sighted
	vimpaired = newlist(/obj/screen,/obj/screen,/obj/screen,/obj/screen)
	O = vimpaired[1]
	O.screen_loc = "1,1 to 5,15"
	O = vimpaired[2]
	O.screen_loc = "5,1 to 10,5"
	O = vimpaired[3]
	O.screen_loc = "6,11 to 10,15"
	O = vimpaired[4]
	O.screen_loc = "11,1 to 15,15"

	//welding mask overlay black/dither
	darkMask = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = darkMask[1]
	O.screen_loc = "3,3 to 5,13"
	O = darkMask[2]
	O.screen_loc = "5,3 to 10,5"
	O = darkMask[3]
	O.screen_loc = "6,11 to 10,13"
	O = darkMask[4]
	O.screen_loc = "11,3 to 13,13"
	O = darkMask[5]
	O.screen_loc = "1,1 to 15,2"
	O = darkMask[6]
	O.screen_loc = "1,3 to 2,15"
	O = darkMask[7]
	O.screen_loc = "14,3 to 15,15"
	O = darkMask[8]
	O.screen_loc = "3,14 to 13,15"

	for(i = 1, i <= 4, i++)
		O = vimpaired[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = darkMask[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

	for(i = 5, i <= 8, i++)
		O = darkMask[i]
		O.icon_state = "black"
		O.layer = 17
		O.mouse_opacity = 0

//Stu's Limited visability
	//Look north overlay
	nview = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen,/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = nview[1]
	O.screen_loc = "1,1 to 15,5"
	O = nview[2]
	O.screen_loc = "1,6 to 6,6"
	O = nview[3]
	O.screen_loc = "10,6 to 15,6"
	O = nview[4]
	O.screen_loc = "1,7 to 4,8"
	O = nview[5]
	O.screen_loc = "12,7 to 15,8"
	O = nview[6]
	O.screen_loc = "1,9 to 2,9"
	O = nview[7]
	O.screen_loc = "14,9 to 15,9"
	O = nview[8]
	O.screen_loc = "5,6 to 7,8"
	O = nview[9]
	O.screen_loc = "8,6 to 8,7"
	O = nview[10]
	O.screen_loc = "9,6 to 11,8"

	//Look south Overlay
	sview = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen,/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = sview[1]
	O.screen_loc = "1,11 to 15,15"
	O = sview[2]
	O.screen_loc = "1,10 to 6,10"
	O = sview[3]
	O.screen_loc = "10,10 to 15,10"
	O = sview[4]
	O.screen_loc = "1,8 to 4,9"
	O = sview[5]
	O.screen_loc = "12,8 to 15,9"
	O = sview[6]
	O.screen_loc = "1,7 to 2,7"
	O = sview[7]
	O.screen_loc = "14,7 to 15,7"
	O = sview[8]
	O.screen_loc = "5,8 to 7,10"
	O = sview[9]
	O.screen_loc = "8,9 to 8,10"
	O = sview[10]
	O.screen_loc = "9,8 to 11,10"

	//Look East Overlay
	eview = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen,/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = eview[1]
	O.screen_loc = "1,1 to 5,15"
	O = eview[2]
	O.screen_loc = "6,1 to 6,6"
	O = eview[3]
	O.screen_loc = "6,10 to 6,15"
	O = eview[4]
	O.screen_loc = "7,1 to 8,4"
	O = eview[5]
	O.screen_loc = "7,12 to 8,15"
	O = eview[6]
	O.screen_loc = "9,1 to 9,2"
	O = eview[7]
	O.screen_loc = "9,14 to 9,15"
	O = eview[8]
	O.screen_loc = "6,5 to 8,7"
	O = eview[9]
	O.screen_loc = "6,8 to 7,8"
	O = eview[10]
	O.screen_loc = "6,9 to 8,11"

	//Look West Overlay
	wview = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen,/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = wview[1]
	O.screen_loc = "11,1 to 15,15"
	O = wview[2]
	O.screen_loc = "10,1 to 10,6"
	O = wview[3]
	O.screen_loc = "10,10 to 10,15"
	O = wview[4]
	O.screen_loc = "8,1 to 9,4"
	O = wview[5]
	O.screen_loc = "8,12 to 9,15"
	O = wview[6]
	O.screen_loc = "7,1 to 7,2"
	O = wview[7]
	O.screen_loc = "7,14 to 7,15"
	O = wview[8]
	O.screen_loc = "8,5 to 10,7"
	O = wview[9]
	O.screen_loc = "9,8 to 10,8"
	O = wview[10]
	O.screen_loc = "8,9 to 10,11"

	for(i = 1, i <= 5, i++)
		O = nview[i]
		O.icon_state = "black"
		O.layer = 18
		O.mouse_opacity = 0

		O = sview[i]
		O.icon_state = "black"
		O.layer = 18
		O.mouse_opacity = 0

		O = eview[i]
		O.icon_state = "black"
		O.layer = 18
		O.mouse_opacity = 0

		O = wview[i]
		O.icon_state = "black"
		O.layer = 18
		O.mouse_opacity = 0

	for(i = 6, i <= 10, i++)
		O = nview[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = sview[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = eview[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = wview[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

	//Robot Look North Overlay
	rnview = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = rnview[1]
	O.screen_loc = "1,1 to 15,7"
	O = rnview[2]
	O.screen_loc = "1,8 to 2,9"
	O = rnview[3]
	O.screen_loc = "3,8 to 5,8"
	O = rnview[4]
	O.screen_loc = "14,8 to 15,9"
	O = rnview[5]
	O.screen_loc = "11,8 to 13,8"

	//Robot Look South Overlay
	rsview = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = rsview[1]
	O.screen_loc = "1,9 to 15,15"
	O = rsview[2]
	O.screen_loc = "1,7 to 2,8"
	O = rsview[3]
	O.screen_loc = "14,7 to 15,8"
	O = rsview[4]
	O.screen_loc = "3,8 to 5,8"
	O = rsview[5]
	O.screen_loc = "11,8 to 13,8"

	//Robot Look East Overlay
	review = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = review[1]
	O.screen_loc = "1,1 to 7,15"
	O = review[2]
	O.screen_loc = "8,1 to 9,2"
	O = review[3]
	O.screen_loc = "8,14 to 9,15"
	O = review[4]
	O.screen_loc = "8,3 to 8,5"
	O = review[5]
	O.screen_loc = "8,11 to 8,13"


	//Robot Look West Overlay
	rwview = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = rwview[1]
	O.screen_loc = "9,1 to 15,15"
	O = rwview[2]
	O.screen_loc = "7,1 to 8,2"
	O = rwview[3]
	O.screen_loc = "7,14 to 8,15"
	O = rwview[4]
	O.screen_loc = "8,3 to 8,5"
	O = rwview[5]
	O.screen_loc = "8,11 to 8,13"

	for(i = 1, i <= 5, i++)
		O = rnview[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = rsview[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = review[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = rwview[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0


/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob

	var/hud_shown = 1			//Used for the HUD toggle (F12)
	var/inventory_shown = 1		//the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/lingchemdisplay
	var/obj/screen/blobpwrdisplay
	var/obj/screen/blobhealthdisplay
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/action_intent
	var/obj/screen/move_intent

	var/list/adding
	var/list/other
	var/list/obj/screen/hotkeybuttons

	var/list/obj/screen/item_action/item_action_list = list()	//Used for the item action ui buttons.


datum/hud/New(mob/owner)
	mymob = owner
	instantiate()
	..()


/datum/hud/proc/hidden_inventory_update()
	if(!mymob) return
	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(inventory_shown && hud_shown)
			if(H.shoes)		H.shoes.screen_loc = ui_shoes
			if(H.gloves)	H.gloves.screen_loc = ui_gloves
			if(H.l_ear)		H.l_ear.screen_loc = ui_l_ear
			if(H.r_ear)		H.r_ear.screen_loc = ui_r_ear
			if(H.glasses)	H.glasses.screen_loc = ui_glasses
			if(H.w_uniform)	H.w_uniform.screen_loc = ui_iclothing
			if(H.wear_suit)	H.wear_suit.screen_loc = ui_oclothing
			if(H.wear_mask)	H.wear_mask.screen_loc = ui_mask
			if(H.head)		H.head.screen_loc = ui_head
		else
			if(H.shoes)		H.shoes.screen_loc = null
			if(H.gloves)	H.gloves.screen_loc = null
			if(H.l_ear)		H.l_ear.screen_loc = null
			if(H.r_ear)		H.r_ear.screen_loc = null
			if(H.glasses)	H.glasses.screen_loc = null
			if(H.w_uniform)	H.w_uniform.screen_loc = null
			if(H.wear_suit)	H.wear_suit.screen_loc = null
			if(H.wear_mask)	H.wear_mask.screen_loc = null
			if(H.head)		H.head.screen_loc = null


/datum/hud/proc/persistant_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(hud_shown)
			if(H.s_store)	H.s_store.screen_loc = ui_sstore1
			if(H.wear_id)	H.wear_id.screen_loc = ui_id
			if(H.belt)		H.belt.screen_loc = ui_belt
			if(H.back)		H.back.screen_loc = ui_back
			if(H.l_store)	H.l_store.screen_loc = ui_storage1
			if(H.r_store)	H.r_store.screen_loc = ui_storage2
		else
			if(H.s_store)	H.s_store.screen_loc = null
			if(H.wear_id)	H.wear_id.screen_loc = null
			if(H.belt)		H.belt.screen_loc = null
			if(H.back)		H.back.screen_loc = null
			if(H.l_store)	H.l_store.screen_loc = null
			if(H.r_store)	H.r_store.screen_loc = null


/datum/hud/proc/instantiate()
	if(!ismob(mymob)) return 0
	if(!mymob.client) return 0
	var/ui_style = ui_style2icon(mymob.client.prefs.UI_style)
	var/ui_color = mymob.client.prefs.UI_style_color
	var/ui_alpha = mymob.client.prefs.UI_style_alpha

	if(ishuman(mymob))
		human_hud(ui_style, ui_color, ui_alpha) // Pass the player the UI style chosen in preferences
	else if(ismonkey(mymob))
		monkey_hud(ui_style)
	else if(isbrain(mymob))
		brain_hud(ui_style)
	else if(islarva(mymob))
		larva_hud()
	else if(isalien(mymob))
		alien_hud()
	else if(isAI(mymob))
		ai_hud()
	else if(isrobot(mymob))
		robot_hud()
	else if(isobserver(mymob))
		ghost_hud()


//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12(var/full = 0 as null)
	set name = "F12"
	set hidden = 1

	if(hud_used)
		if(ishuman(src))
			if(!client) return
			if(client.view != world.view)
				return
			if(hud_used.hud_shown)
				hud_used.hud_shown = 0
				if(src.hud_used.adding)
					src.client.screen -= src.hud_used.adding
				if(src.hud_used.other)
					src.client.screen -= src.hud_used.other
				if(src.hud_used.hotkeybuttons)
					src.client.screen -= src.hud_used.hotkeybuttons
				if(src.hud_used.item_action_list)
					src.client.screen -= src.hud_used.item_action_list

				//Due to some poor coding some things need special treatment:
				//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
				if(!full)
					src.client.screen += src.hud_used.l_hand_hud_object	//we want the hands to be visible
					src.client.screen += src.hud_used.r_hand_hud_object	//we want the hands to be visible
					src.client.screen += src.hud_used.action_intent		//we want the intent swticher visible
					src.hud_used.action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.
				else
					src.client.screen -= src.healths
					src.client.screen -= src.internals
					src.client.screen -= src.gun_setting_icon

				//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
				src.client.screen -= src.zone_sel	//zone_sel is a mob variable for some reason.

			else
				hud_used.hud_shown = 1
				if(src.hud_used.adding)
					src.client.screen += src.hud_used.adding
				if(src.hud_used.other && src.hud_used.inventory_shown)
					src.client.screen += src.hud_used.other
				if(src.hud_used.hotkeybuttons && !src.hud_used.hotkey_ui_hidden)
					src.client.screen += src.hud_used.hotkeybuttons
				if(src.healths)
					src.client.screen |= src.healths
				if(src.internals)
					src.client.screen |= src.internals
				if(src.gun_setting_icon)
					src.client.screen |= src.gun_setting_icon

				src.hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
				src.client.screen += src.zone_sel				//This one is a special snowflake

			hud_used.hidden_inventory_update()
			hud_used.persistant_inventory_update()
			update_action_buttons()
		else
			usr << "\red Inventory hiding is currently only supported for human mobs, sorry."
	else
		usr << "\red This mob type does not use a HUD."
