/obj/item/storage/fancy
	item_state = "syringe_kit"

	/// The item type this container cares about for behaviors like icon generation.
	var/obj/item/key_type

	/// A cached count of key_type currently in this container.
	var/key_type_count

	/// A cached count of things currently in this container that are not of key_type.
	var/other_type_count


/obj/item/storage/fancy/Initialize()
	. = ..()
	UpdateTypeCounts()


/obj/item/storage/fancy/update_ui_after_item_insertion()
	UpdateTypeCounts()
	..()


/obj/item/storage/fancy/update_ui_after_item_removal()
	UpdateTypeCounts()
	..()


/obj/item/storage/fancy/on_update_icon()
	icon_state = "[initial(icon_state)][opened ? key_type_count : ""]"


/obj/item/storage/fancy/examine(mob/user, distance)
	. = ..()
	if (distance > 2)
		return
	if (!opened)
		to_chat(user, "It is sealed.")
		return
	var/display_message
	switch (key_type_count)
		if (0)
			display_message = "are no [initial(key_type.name)]\s"
		if (1)
			display_message = "is 1 [initial(key_type.name)]"
		else
			display_message = "are [key_type_count] [initial(key_type.name)]\s"
	to_chat(user, "There [display_message] left in \the [src].")
	switch (other_type_count)
		if (0)
			display_message = null
		if (1)
			display_message = "Something[key_type_count ? " else" : ""] is"
		else
			display_message = "Some[key_type_count ? " other" : ""] things are"
	if (display_message)
		to_chat(user, "[display_message] inside[key_type_count ? " as well" : ""].")


/obj/item/storage/fancy/proc/UpdateTypeCounts()
	key_type_count = count_by_type(contents, key_type)
	other_type_count = length(contents) - key_type_count
