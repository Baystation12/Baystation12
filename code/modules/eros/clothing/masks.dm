
/obj/item/clothing/mask/bandana
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining."
	w_class = 1
	flags_inv = HIDEFACE
	slot_flags = SLOT_MASK
	icon_state = "bandblack"
	item_state_slots = list(slot_r_hand_str = "bandblack", slot_l_hand_str = "bandblack")
	var/tied = 0

/obj/item/clothing/mask/bandana/proc/adjust_bandana(mob/user)
	if(usr.canmove && !usr.stat)
		src.tied = !src.tied
		if (src.tied)
			flags_inv = flags_inv & ~HIDEFACE
			slot_flags = SLOT_HEAD
			icon_state = "[icon_state]_up"
			usr << "You tie the bandana so that it can be worn on the head."
		else
			flags_inv = initial(flags_inv)
			slot_flags = initial(slot_flags)
			icon_state = initial(icon_state)
			usr << "You tie the bandana so that it can be worn on the face."

/obj/item/clothing/mask/bandana/verb/toggle()
	set category = "Object"
	set name = "Tie bandana"
	set src in usr

	adjust_bandana(usr)
	update_icon()

/obj/item/clothing/mask/bandana/black
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining."
	icon_state = "bandblack"
	item_state_slots = list(slot_r_hand_str = "bandblack", slot_l_hand_str = "bandblack")

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	desc = "A fine red bandana with nanotech lining."
	icon_state = "bandred"
	item_state_slots = list(slot_r_hand_str = "bandred", slot_l_hand_str = "bandred")

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	desc = "A fine blue bandana with nanotech lining."
	icon_state = "bandblue"
	item_state_slots = list(slot_r_hand_str = "bandblue", slot_l_hand_str = "bandblue")

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	desc = "A fine green bandana with nanotech lining."
	icon_state = "bandgreen"
	item_state_slots = list(slot_r_hand_str = "bandgreen", slot_l_hand_str = "bandgreen")

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	desc = "A fine gold bandana with nanotech lining."
	icon_state = "bandgold"
	item_state_slots = list(slot_r_hand_str = "bandgold", slot_l_hand_str = "bandgold")

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem."
	icon_state = "bandskull"
	item_state_slots = list(slot_r_hand_str = "bandskull", slot_l_hand_str = "bandskull")