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

	examine(mob/user)
		..(user)
		var/state = "disabled"
		if(src.flags&NOSLIP)
			state = "enabled"
		user << "Its mag-pulse traction system appears to be [state]."

/obj/item/clothing/shoes/magboots/can_stomp()
	if(!magpulse)
		return 0

/obj/item/clothing/shoes/magboots/handle_stomp(var/mob/living/carbon/human/target, var/mob/living/carbon/human/user, var/datum/organ/external/affecting)

	if(!(target.lying) || !(user.canmove))
		return 0

	visible_message("\red [user] raises one of \his magboots over [target]'s [affecting.display_name]...")

	user.attack_move = 1

	if(do_after(user, 20))
		if(user.canmove && !user.lying && target.Adjacent(user) && target.lying)
			visible_message("\red <B>[user] stomps \his magboot down on [target]'s [affecting.display_name] with full force!</B>")
			target.apply_damage(rand(20,30), BRUTE, affecting, target.run_armor_check(affecting, "melee"))
			playsound(loc, 'sound/weapons/genhit3.ogg', 25, 1, -1)
			user.attack_move = 0

			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Magboot-stomped [target.name] ([target.ckey])</font>")
			target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been magboot-stomped by [user.name] ([user.ckey])</font>")
			msg_admin_attack("[key_name(user)] magboot-stomped [key_name(target)]")
			return 1
	return 0