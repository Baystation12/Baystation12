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
			display_message = "are no [initial(key_type.pluralname) ? initial(key_type.pluralname) : initial(key_type.name)]\s"
		if (1)
			display_message = "is 1 [initial(key_type.name)]"
		else
			display_message = "are [key_type_count] [initial(key_type.pluralname) ? initial(key_type.pluralname) : initial(key_type.name)]\s"
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


///Matchboxes and their associated procs below.

/obj/item/storage/fancy/matches/matchbox
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	max_storage_space = 10
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/flame/match)
	key_type = /obj/item/flame/match
	startswith = list(/obj/item/flame/match = 10)
	var/sprite_key_type_count = 3

/obj/item/storage/fancy/matches/matchbook
	name = "matchbook"
	desc = "A tiny packet of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbook"
	max_storage_space = 3
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	can_hold = list(/obj/item/flame/match)
	key_type = /obj/item/flame/match
	startswith = list(/obj/item/flame/match = 3)


/obj/item/storage/fancy/matches/attackby(obj/item/flame/match/W as obj, mob/user as mob)
	if(istype(W) && !W.lit && !W.burnt)
		W.lit = 1
		W.damtype = INJURY_TYPE_BURN
		W.icon_state = "match_lit"
		START_PROCESSING(SSobj, W)
		playsound(src.loc, 'sound/items/match.ogg', 60, 1, -4)
		user.visible_message(SPAN_NOTICE("[user] strikes the match on the [src]."))
	W.update_icon()
	return

///Exclusive to larger matchboxes; as cigarette boxes and matchbooks have one sprite per removed item while these do not.

/obj/item/storage/fancy/matches/matchbox/UpdateTypeCounts()
	. = ..()
	switch(key_type_count)
		if(0)
			sprite_key_type_count = 0
		if(1 to 3)
			sprite_key_type_count = 1
		if(4 to 7)
			sprite_key_type_count = 2
		if(8 to 10)
			sprite_key_type_count = 3

/obj/item/storage/fancy/matches/matchbox/on_update_icon()
	icon_state = "[initial(icon_state)][opened ? sprite_key_type_count : ""]"
