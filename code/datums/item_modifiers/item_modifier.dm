/singleton/item_modifier
	var/name
	var/list/type_setups

/singleton/item_modifier/proc/RefitItem(obj/item/I)
	if(!istype(I))
		return FALSE

	var/item_type = get_ispath_key(type_setups, I.type)
	if(!item_type)
		return FALSE

	var/type_setup = type_setups[item_type]
	if(!type_setup)
		return FALSE

	I.SetName(type_setup[SETUP_NAME])
	I.icon = type_setup[SETUP_OBJ_SHEET]
	I.item_icons = type_setup[SETUP_ONMOB_SHEET]
	I.icon_state = type_setup[SETUP_ICON_STATE]
	I.sprite_sheets_obj = type_setup[SETUP_SPECIES_OBJ]
	I.sprite_sheets = type_setup[SETUP_SPECIES_ONMOB]
	I.item_state = type_setup[SETUP_ITEM_STATE]
	I.item_state_slots = type_setup[SETUP_ITEM_STATE_SLOTS]

	return TRUE
