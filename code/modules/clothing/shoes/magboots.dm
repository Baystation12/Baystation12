/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	var/magpulse = 0
	icon_action_button = "action_blank"
	action_button_name = "Toggle the magboots"
//	flags = NOSLIP //disabled by default

	attack_self(mob/user)
		if(magpulse)
			flags &= ~NOSLIP
			slowdown = SHOES_SLOWDOWN
			magpulse = 0
			icon_state = "magboots0"
			user << "You disable the mag-pulse traction system."
		else
			flags |= NOSLIP
			slowdown = 2
			magpulse = 1
			icon_state = "magboots1"
			user << "You enable the mag-pulse traction system."
		user.update_inv_shoes()	//so our mob-overlays update
	
	examine()
		set src in view()
		..()
		var/state = "disabled"
		if(src.flags&NOSLIP)
			state = "enabled"
		usr << "Its mag-pulse traction system appears to be [state]."