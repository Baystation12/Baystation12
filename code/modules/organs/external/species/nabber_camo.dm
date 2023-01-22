/obj/item/organ/external/groin/insectoid/nabber
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"
	action_button_name = "Toggle Active Camo"
	cavity_max_w_class = ITEM_SIZE_LARGE

/obj/item/organ/external/groin/insectoid/nabber/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "nabber-cloak-[owner && owner.is_cloaked_by(species) ? 1 : 0]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/groin/insectoid/nabber/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(owner.is_cloaked_by(species))
			owner.remove_cloaking_source(species)
		else
			owner.add_cloaking_source(species)
			owner.apply_effect(2, EFFECT_STUN, 0)
		refresh_action_button()
