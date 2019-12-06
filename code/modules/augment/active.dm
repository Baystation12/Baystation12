//Toggleable embedded module
/obj/item/organ/internal/augment/active
	action_button_name = "Activate"
	var/obj/item/organ/external/limb

/obj/item/organ/internal/augment/active/proc/activate()

//Give verbs on install
/obj/item/organ/internal/augment/active/onInstall()
	limb = owner.get_organ(parent_organ)

/obj/item/organ/internal/augment/active/onRemove()
	limb = null

/obj/item/organ/internal/augment/active/proc/can_activate()
	if(!owner || owner.incapacitated() || !is_usable())
		to_chat(owner, SPAN_WARNING("You can't do that now!"))
		return FALSE

	return TRUE


/obj/item/organ/internal/augment/active/attack_self()
	. = ..()
	if(.)
		activate()

//Need to change icon?
/obj/item/organ/internal/augment/active/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = icon_state
		if(action.button) action.button.UpdateIcon()


/obj/item/organ/internal/augment/active/Destroy()
	limb = null
	. = ..()