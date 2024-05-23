/datum/extension/appearance/cardborg
	expected_type = /obj/item
	appearance_handler_type = /singleton/appearance_handler/cardborg
	item_equipment_proc = TYPE_PROC_REF(/singleton/appearance_handler/cardborg, item_equipped)
	item_removal_proc = TYPE_PROC_REF(/singleton/appearance_handler/cardborg, item_removed)
