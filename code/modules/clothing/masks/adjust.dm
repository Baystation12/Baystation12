/obj/item/clothing/mask/adjust
	w_class = 2
	siemens_coefficient = 0.9
	body_parts_covered = FACE
	flags_inv = HIDEFACE
	var/adjust_state
	var/no_adjust_state
	var/hanging = 0
	verb/toggle()
		set category = null
		set name = "Toggle"
		set src in usr
		adjust_mask(usr)

/obj/item/clothing/mask/adjust/proc/adjust_mask(mob/user)
	if(user.canmove && !user.stat)
		if(!src.hanging)
			src.hanging = !src.hanging
			body_parts_covered = 0
			icon_state = adjust_state
			flags_inv = null
			user << "Your mask is now hanging on your head."

		else
			src.hanging = !src.hanging
			body_parts_covered = initial(body_parts_covered)
			icon_state = no_adjust_state
			flags_inv = HIDEFACE
			user << "You pull the mask up to cover your face."
		update_clothing_icon()


/obj/item/clothing/mask/adjust
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining."
	icon_state = "bandblack"
	item_state = "bandblack"
	adjust_state = "bandblack_up"
	no_adjust_state = "bandblack"



//	/obj/item/clothing/mask/adjust/red_bandana