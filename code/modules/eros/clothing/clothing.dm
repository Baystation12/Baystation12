//Here goes the partials that complement the clothes of eros.

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Down Clothes"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rolldown_status()
	if(rolled_down == -1)
		usr << "<span class='notice'>You cannot roll down [src]!</span>"
	if((rolled_sleeves == 1) && !(rolled_down))
		rolled_sleeves = 0
		return

	rolled_down = !rolled_down
	if(rolled_down)
		body_parts_covered &= LOWER_TORSO|LEGS|FEET
		item_state_slots[slot_w_uniform_str] = "[worn_state]_d"
		show_boobs = 1
	else
		body_parts_covered = initial(body_parts_covered)
		item_state_slots[slot_w_uniform_str] = "[worn_state]"
		show_boobs = 0
	update_clothing_icon()

/obj/item/clothing/suit/storage/toggle
	var/icon_open
	var/icon_closed
	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(icon_state == icon_open) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
			icon_state = icon_closed
			to_chat(usr, "You button up the coat.")
			show_boobs = 0
		else if(icon_state == icon_closed)
			icon_state = icon_open
			to_chat(usr, "You unbutton the coat.")
			show_boobs = 1
		else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
			to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how silly you are.")
			return
		update_clothing_icon()	//so our overlays update
