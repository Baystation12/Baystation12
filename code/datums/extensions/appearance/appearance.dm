/datum/extension/appearance
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE // | EXTENSION_FLAG_MULTIPLE_INSTANCES
	var/appearance_handler_type
	var/item_equipment_proc
	var/item_removal_proc

/datum/extension/appearance/New(var/holder)
	var/appearance_handler = appearance_manager.get_appearance_handler(appearance_handler_type)
	if(!appearance_handler)
		CRASH("Unable to acquire the [appearance_handler_type] appearance handler.")

	item_equipped_event.register(holder, appearance_handler, item_equipment_proc)
	item_unequipped_event.register(holder, appearance_handler, item_removal_proc)
	..()

/datum/extension/appearance/Destroy()
	var/appearance_handler = appearance_manager.get_appearance_handler(appearance_handler_type)
	item_equipped_event.unregister(holder, appearance_handler, item_equipment_proc)
	item_unequipped_event.unregister(holder, appearance_handler, item_removal_proc)
	. = ..()
