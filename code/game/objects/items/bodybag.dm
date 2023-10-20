//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEM_SIZE_SMALL

/obj/item/bodybag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
	R.add_fingerprint(user)
	qdel(src)


/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	icon_state = "bodybags"
	startswith = list(/obj/item/bodybag = 7)


/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	icon_state = "closed"
	closet_appearance = null
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	density = FALSE
	storage_capacity = (MOB_MEDIUM * 2) - 1
	var/contains_body = 0
	/// String. The body bag's label, if set.
	var/label = null


/obj/structure/closet/body_bag/use_tool(obj/item/tool, mob/user, list/click_params)
	// Pen - Set label
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What would you like the label to be?", name, label) as text|null
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!input || input == label || !user.use_sanity_check(src, tool))
			return TRUE
		set_label(input)
		user.visible_message(
			SPAN_NOTICE("\The [user] labels \the [src] with \a [tool]."),
			SPAN_NOTICE("You set \the [src]'s label with \the [tool] to: [SPAN_INFO("'[label]'")]")
		)
		return TRUE

	// Wirecutters - Remove label
	if (isWirecutter(tool))
		if (!label)
			USE_FEEDBACK_FAILURE("\The [src] has no label to remove.")
			return TRUE
		set_label(null)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [src]'s label with \a [tool]."),
			SPAN_NOTICE("You remove \the [src]'s label with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/closet/body_bag/proc/set_label(new_label)
	label = new_label
	name = initial(name)
	if (label)
		name += " - [label]"
	update_icon()


/obj/structure/closet/body_bag/on_update_icon()
	if(opened)
		icon_state = "open"
	else
		icon_state = "closed"

	ClearOverlays()
	if(label)
		AddOverlays("bodybag_label")

/obj/structure/closet/body_bag/store_mobs(stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/body_bag/close()
	if(..())
		set_density(0)
		return 1
	return 0

/obj/structure/closet/body_bag/proc/fold(user)
	if(!(ishuman(user) || isrobot(user)))
		to_chat(user, SPAN_NOTICE("You lack the dexterity to close \the [name]."))
		return FALSE

	if(opened)
		to_chat(user, SPAN_NOTICE("You must close \the [name] before it can be folded."))
		return FALSE

	if(length(contents))
		to_chat(user, SPAN_NOTICE("You can't fold \the [name] while it has something inside it."))
		return FALSE

	visible_message("[user] folds up the [name]")
	. = new item_path(get_turf(src))
	qdel(src)

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		fold(usr)

/obj/item/robot_rack/body_bag
	name = "stasis bag rack"
	desc = "A rack for carrying folded stasis bags and body bags."
	icon = 'icons/obj/closets/cryobag.dmi'
	icon_state = "bodybag_folded"
	object_type = /obj/item/bodybag
	interact_type = /obj/structure/closet/body_bag
	capacity = 3
