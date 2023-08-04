/obj/item/storage/fancy
	item_state = "syringe_kit"
	var/sealed = TRUE

	/// The item type this container cares about for behaviors like icon generation.
	var/obj/item/key_type
	var/obj/item/key_type_2

	/// A cached count of key_type currently in this container.
	var/key_type_count
	var/key_type_count_2

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
	if (sealed)
		to_chat(user, "It is sealed and brand new.")
		return
	if (!opened)
		to_chat(user, "It is closed.")
		return
	var/display_message
	switch (key_type_count)
		if (0)
			display_message = "are no [initial(key_type.pluralname) ? initial(key_type.pluralname) : initial(key_type.name)]\s"
		if (1)
			display_message = "is 1 [initial(key_type.name)]"
		else
			display_message = "are [key_type_count] [initial(key_type.pluralname) ? initial(key_type.pluralname) : initial(key_type.name)]\s"
	to_chat(user, "There [display_message] left in \the [src].")
	switch (key_type_count_2)
		if (0)
			display_message = null
		if (1)
			display_message = "is 1 [initial(key_type_2.name)]"
		else
			display_message = "are [key_type_count_2] [initial(key_type_2.pluralname) ? initial(key_type_2.pluralname) : initial(key_type_2.name)]\s"
	if (display_message)
		to_chat(user, "There [display_message] in \the [src].")
	switch (other_type_count)
		if (0)
			display_message = null
		if (1)
			display_message = "Something[key_type_count ? " else" : ""] is"
		else
			display_message = "Some[key_type_count ? " other" : ""] things are"
	if (display_message)
		to_chat(user, "[display_message] inside[key_type_count ? " as well" : ""].")

/obj/item/storage/fancy/attack_self(mob/user)
	. = ..()
	opened = !opened
	playsound(loc, open_sound, 50, 0, -5)
	if (sealed)
		to_chat(user, "You unseal and open \the [src].")
		sealed = FALSE
	else
		to_chat(user, "You [opened? "open" : "close"] \the [src]")
	queue_icon_update()

/obj/item/storage/fancy/open(mob/user as mob)
	if(sealed)
		to_chat(user, "You need to unseal \the [src] first!")
		return
	..()


/obj/item/storage/fancy/proc/UpdateTypeCounts()
	key_type_count = count_by_type(contents, key_type)
	key_type_count_2 = count_by_type(contents, key_type_2)
	other_type_count = length(contents) - key_type_count - key_type_count_2
