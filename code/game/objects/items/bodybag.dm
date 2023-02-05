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
	closet_appearance = null
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	density = FALSE
	storage_capacity = (MOB_MEDIUM * 2) - 1
	var/contains_body = 0
	/// The body bag's current label
	var/label = null


/obj/structure/closet/body_bag/get_interactions_info()
	. = ..()
	.["Pen"] = "<p>Relabels \the [initial(name)].</p>"
	.[CODEX_INTERACTION_WIRECUTTERS] = "<p>Removes the label, if present.</p>"


/obj/structure/closet/body_bag/use_tool(obj/item/tool, mob/user, list/click_params)
	// Pen - Relabel bag
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What would you like \the [src]'s label to be?", "[name] Label", label) as null|text
		input = sanitizeSafe(input, MAX_DESC_LEN)
		if (!input || input == label)
			return TRUE
		set_label(input)
		user.visible_message(
			SPAN_NOTICE("\The [user] relabels \the [initial(name)]."),
			SPAN_NOTICE("You relabel \the [initial(name)] to '[label].'")
		)
		return TRUE

	// Wirecutters - Remove label
	if (isWirecutter(tool))
		if (!label)
			to_chat(user, SPAN_WARNING("\The [src] has no label to remove."))
		clear_label()
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [src]'s label with \a [tool]."),
			SPAN_NOTICE("You remove \the [src]'s label with \the [tool].")
		)
		return TRUE

	return ..()


/// Sets the body bag's label. Updates name and icon.
/obj/structure/closet/body_bag/proc/set_label(new_label)
	if (!new_label)
		clear_label()
		return
	label = new_label
	SetName("[initial(name)] - [label]")
	update_icon()


/// Removes the body bag's label. Updates name and icon.
/obj/structure/closet/body_bag/proc/clear_label()
	if (!label)
		return
	label = null
	SetName(initial(name))
	update_icon()


/obj/structure/closet/body_bag/on_update_icon()
	if(opened)
		icon_state = "open"
	else
		icon_state = "closed_unlocked"

	src.overlays.Cut()
	if(label)
		src.overlays += image(src.icon, "bodybag_label")

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
