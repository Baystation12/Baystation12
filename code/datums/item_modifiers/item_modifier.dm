/decl/item_modifier
	var/name
	var/list/type_setups

/decl/item_modifier/proc/RefitItem(var/obj/item/I)
	if(!istype(I))
		return FALSE

	var/item_type = get_ispath_key(type_setups, I.type)
	if(!item_type)
		return FALSE

	var/type_setup = type_setups[item_type]
	if(!type_setup)
		return FALSE

	I.SetName(type_setup[SETUP_NAME])
	I.icon_state = type_setup[SETUP_ICON_STATE]

	var/item_state = type_setup[SETUP_ITEM_STATE]
	if(item_state)
		I.item_state = item_state

	var/item_state_slots = type_setup[SETUP_ITEM_STATE_SLOTS]
	if(item_state_slots)
		I.item_state_slots = item_state_slots

	return TRUE
