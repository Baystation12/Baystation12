/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	force = 3
	var/magpulse = 0
	var/icon_base = "magboots"
	icon_action_button = "action_blank"
	action_button_name = "Toggle the magboots"

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		flags &= ~NOSLIP
		slowdown = SHOES_SLOWDOWN
		magpulse = 0
		force = 3
		if(icon_base) icon_state = "[icon_base]0"
		user << "You disable the mag-pulse traction system."
	else
		flags |= NOSLIP
		slowdown = 2
		magpulse = 1
		force = 5
		if(icon_base) icon_state = "[icon_base]1"
		user << "You enable the mag-pulse traction system."
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..(user)
	var/state = "disabled"
	if(src.flags&NOSLIP)
		state = "enabled"
	user << "Its mag-pulse traction system appears to be [state]."