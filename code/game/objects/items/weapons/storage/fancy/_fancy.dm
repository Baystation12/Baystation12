/obj/item/storage/fancy
	item_state = "syringe_kit"
	var/sealed = TRUE

	/// The item type(s) this container cares about for behaviors like icon generation.
	var/list/key_type = list()

	/// A cached count of key_type(s) currently in this container.
	var/list/key_type_count = list()
	var/total_keys = 0

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
	icon_state = "[initial(icon_state)][opened ? total_keys : ""]"


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
	if (!length(contents))
		to_chat(user, "\The [src] is empty.")
		return

	var/display_message
	for (var/obj/item/key as anything in key_type)
		switch (key_type_count[key])
			if (0)
				display_message = null
			if (1)
				display_message = "is 1 [initial(key.name)]"
			else
				display_message = "are [key_type_count[key]] [initial(key.pluralname) ? initial(key.pluralname) : initial(key.name)]\s"
		if (display_message)
			to_chat(user, "There [display_message] left in \the [src].")

	switch (other_type_count)
		if (0)
			display_message = null
		if (1)
			display_message = "Something[total_keys ? " else" : ""] is"
		else
			display_message = "Some[total_keys ? " other" : ""] things are"
	if (display_message)
		to_chat(user, "[display_message] inside[total_keys ? " as well" : ""].")

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
		to_chat(user, SPAN_WARNING("You need to unseal \the [src] first!"))
		return
	..()

/obj/item/storage/fancy/can_be_inserted(obj/item/item, mob/user, stop_messages)
	if (!istype(item))
		return FALSE
	if (sealed)
		to_chat(user, SPAN_WARNING("You need to unseal \the [src] first!"))
		return FALSE
	return ..()


/obj/item/storage/fancy/proc/UpdateTypeCounts()
	total_keys = 0
	for (var/key as anything in key_type)
		var/key_amt = count_by_type(contents, key)
		key_type_count[key] = key_amt
		total_keys += key_amt

	other_type_count = length(contents) - total_keys
