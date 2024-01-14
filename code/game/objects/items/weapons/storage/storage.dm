/obj/item/storage
	name = "storage"
	icon = 'icons/obj/boxes.dmi'
	w_class = ITEM_SIZE_NORMAL

	/** If set, a list of paths this item can hold, disallowing all others.
		May be associative, in which case the value is a limit per path. */
	var/list/contents_allowed

	/** If set, a list of paths this item cannot hold, allowing all others.
		Ignored when contents_allowed is set. */
	var/list/contents_banned

	/// The largest item size that can be stored. Ignored if contents_allowed is set.
	var/max_w_class = ITEM_SIZE_SMALL

	/// The space available in this item. If unset, calculate from storage_slots.
	var/max_storage_space

	/// If set, the number of storage slots available.
	var/storage_slots

	/// If set, this item can use the empty verb to dump its contents.
	var/allow_quick_empty

	/// If set, this item can attempt to collect all items on a turf with a click.
	var/allow_quick_gather

	/// When quick gathering, falsy collects all valid items, truthy collects only one.
	var/quick_gather_single

	///Allows dumping the contents of storage after a duration.
	var/allow_slow_dump

	/// If set, a sound to play when accessing the storage item's UI.
	var/use_sound = "rustle"

	/// If truthy, disallows use of the storage UI.
	var/virtual

	/** An optional map of (path = config) to create on initialize. Config may be a count to
		create or a sublist of (count, ...args), where args is passed to each new instance */
	var/list/startswith


	var/datum/storage_ui/storage_ui = /datum/storage_ui/default

	/// True when this storage item has been opened. Used by storage/fancy.
	var/opened

	/// If set, a sound to play when opening the storage item.
	var/open_sound


/obj/item/storage/Destroy()
	QDEL_NULL(storage_ui)
	return ..()


/obj/item/storage/Initialize()
	. = ..()
	if (!allow_quick_empty)
		verbs -= /obj/item/storage/verb/quick_empty
	if (!allow_quick_gather)
		verbs -= /obj/item/storage/verb/toggle_gathering_mode
	if (!allow_slow_dump)
		verbs -= /obj/item/storage/verb/dump_contents
	if (isnull(max_storage_space) && !isnull(storage_slots))
		max_storage_space = storage_slots*BASE_STORAGE_COST(max_w_class)
	storage_ui = new storage_ui(src)
	prepare_ui()
	if (length(startswith))
		for (var/item_path in startswith)
			var/list/data = startswith[item_path]
			if (islist(data))
				var/qty = data[1]
				var/list/argsl = data.Copy()
				argsl[1] = src
				for (var/i in 1 to qty)
					new item_path (arglist(argsl))
			else
				for (var/i in 1 to data || 1)
					new item_path (src)
		update_icon()


/obj/item/storage/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if ((ishuman(usr) || isrobot(usr) || issmall(usr)) && !usr.incapacitated())
		if(over_object == usr && Adjacent(usr)) // this must come before the screen objects only block
			src.add_fingerprint(usr)
			src.open(usr)
			return TRUE

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		//makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
		if (!usr.contains(src))
			return

		src.add_fingerprint(usr)
		if(usr.unEquip(src))
			switch(over_object.name)
				if(BP_R_HAND)
					usr.put_in_r_hand(src)
				if(BP_L_HAND)
					usr.put_in_l_hand(src)

/obj/item/storage/AltClick(mob/usr)
	if(!canremove)
		return FALSE

	if ((ishuman(usr) || isrobot(usr) || issmall(usr)) && !usr.incapacitated() && Adjacent(usr))
		src.add_fingerprint(usr)
		src.open(usr)
		return TRUE
	return FALSE

/obj/item/storage/proc/return_inv()

	var/list/L = list(  )

	L += src.contents

	for(var/obj/item/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/smallDelivery/parcel in src)
		L += parcel.wrapped
		if (istype(parcel.wrapped, /obj/item/storage))
			L += parcel.wrapped:return_inv()
	return L

/obj/item/storage/proc/show_to(mob/user as mob)
	if(storage_ui)
		storage_ui.show_to(user)

/obj/item/storage/proc/hide_from(mob/user as mob)
	if(storage_ui)
		storage_ui.hide_from(user)

/obj/item/storage/proc/open(mob/user as mob)
	if (virtual)
		return
	if (!opened)
		var/sound = open_sound || use_sound
		if (sound)
			playsound(src, open_sound, 50, FALSE, -5)
		to_chat(user, "You open \the [src].")
		queue_icon_update()
		opened = TRUE
	else if (use_sound)
		playsound(src, use_sound, 50, FALSE, -5)
	if (isrobot(user) && user.hud_used)
		var/mob/living/silicon/robot/robot = user
		if (robot.shown_robot_modules)
			robot.hud_used.toggle_show_robot_modules()
	prepare_ui()
	storage_ui.on_open(user)
	storage_ui.show_to(user)

/obj/item/storage/proc/prepare_ui()
	storage_ui.prepare_ui()

/obj/item/storage/proc/close(mob/user as mob)
	hide_from(user)
	if(storage_ui)
		storage_ui.after_close(user)

/obj/item/storage/proc/close_all()
	if(storage_ui)
		storage_ui.close_all()

/obj/item/storage/proc/storage_space_used()
	. = 0
	for(var/obj/item/I in contents)
		. += I.get_storage_cost()

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/storage/proc/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(user && !user.canUnEquip(W))
		return 0

	if(src.loc == W)
		return 0 //Means the item is already in the storage item
	if(storage_slots != null && length(contents) >= storage_slots)
		if(!stop_messages)
			to_chat(user, SPAN_NOTICE("\The [src] is full, make some space."))
		return 0 //Storage item is full

	if(W.anchored)
		return 0

	if (length(contents_allowed))
		if (!is_type_in_list(W, contents_allowed))
			if (!stop_messages && ! istype(W, /obj/item/hand_labeler))
				to_chat(user, SPAN_NOTICE("\The [src] cannot hold \the [W]."))
			return 0
		var/max_instances = contents_allowed[W.type]
		if (max_instances && instances_of_type_in_list(W, contents) >= max_instances)
			if (!stop_messages && !istype(W, /obj/item/hand_labeler))
				to_chat(user, SPAN_NOTICE("\The [src] has no more space specifically for \the [W]."))
			return 0

	//Bypassing storage procedures when not using help intent for labeler/forensic tools.
	if((istype(W, /obj/item/hand_labeler) || istype(W, /obj/item/forensics)) && user.a_intent != I_HELP)
		return FALSE

	// Don't allow insertion of unsafed compressed matter implants
	// Since they are sucking something up now, their use_after will delete the storage
	if(istype(W, /obj/item/implanter/compressed))
		var/obj/item/implanter/compressed/impr = W
		if(!impr.safe)
			stop_messages = 1
			return 0

	if(length(contents_banned) && is_type_in_list(W, contents_banned))
		if(!stop_messages)
			to_chat(user, SPAN_NOTICE("\The [src] cannot hold \the [W]."))
		return 0

	if (max_w_class != null && W.w_class > max_w_class)
		if(!stop_messages)
			to_chat(user, SPAN_NOTICE("\The [W] is too big for this [src.name]."))
		return 0

	var/total_storage_space = W.get_storage_cost()
	if(total_storage_space == ITEM_SIZE_NO_CONTAINER)
		if(!stop_messages)
			to_chat(user, SPAN_NOTICE("\The [W] cannot be placed in [src]."))
		return 0

	total_storage_space += storage_space_used() //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(total_storage_space > max_storage_space)
		if(!stop_messages)
			to_chat(user, SPAN_NOTICE("\The [src] is too full, make some space."))
		return 0

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/storage/proc/handle_item_insertion(obj/item/W, prevent_warning = 0, NoUpdate = 0)
	if(!istype(W))
		return 0
	if(istype(W.loc, /mob))
		var/mob/M = W.loc
		if(!M.unEquip(W))
			return
	W.forceMove(src)
	W.on_enter_storage(src)
	if(usr)
		add_fingerprint(usr)

		if(!prevent_warning)
			for(var/mob/M in viewers(usr, null))
				if (M == usr)
					to_chat(usr, SPAN_NOTICE("You put \the [W] into [src]."))
				else if (M in range(1, src)) //If someone is standing close enough, they can tell what it is... TODO replace with distance check
					M.show_message(SPAN_NOTICE("\The [usr] puts [W] into [src]."), VISIBLE_MESSAGE)
				else if (W && W.w_class >= ITEM_SIZE_NORMAL) //Otherwise they can only see large or normal items from a distance...
					M.show_message(SPAN_NOTICE("\The [usr] puts [W] into [src]."), VISIBLE_MESSAGE)

		if(!NoUpdate)
			update_ui_after_item_insertion()
	update_icon()
	return 1

/obj/item/storage/proc/update_ui_after_item_insertion()
	prepare_ui()
	if(storage_ui)
		storage_ui.on_insertion(usr)

/obj/item/storage/proc/update_ui_after_item_removal()
	prepare_ui()
	if(storage_ui)
		storage_ui.on_post_remove(usr)

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/proc/remove_from_storage(obj/item/W as obj, atom/new_location, NoUpdate = 0)
	if(!istype(W)) return 0
	new_location = new_location || get_turf(src)

	if(storage_ui)
		storage_ui.on_pre_remove(usr, W)

	if(ismob(loc))
		W.dropped(usr)
	if(ismob(new_location))
		W.hud_layerise()
	else
		W.reset_plane_and_layer()
	W.forceMove(new_location)

	if(usr && !NoUpdate)
		update_ui_after_item_removal()
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	if(!NoUpdate)
		update_icon()
	return 1

// Only do ui functions for now; the obj is responsible for anything else.
/obj/item/storage/proc/on_item_pre_deletion(obj/item/W)
	if(storage_ui)
		storage_ui.on_pre_remove(null, W) // Supposed to be able to handle null user.

// Only do ui functions for now; the obj is responsible for anything else.
/obj/item/storage/proc/on_item_post_deletion(obj/item/W)
	if(storage_ui)
		update_ui_after_item_removal()
	queue_icon_update()

//Run once after using remove_from_storage with NoUpdate = 1
/obj/item/storage/proc/finish_bulk_removal()
	update_ui_after_item_removal()
	update_icon()

//This proc is called when you want to place an item into the storage item.
/obj/item/storage/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (SSfabrication.try_craft_with(src, W, user))
		return TRUE

	if (isrobot(user) && (W == user.get_active_hand()))
		return //Robots can't store their modules.

	if (!can_be_inserted(W, user))
		return TRUE

	if (handle_item_insertion(W))
		return TRUE

	return ..()

///Eventually should be deleted in favor of use_tool; keeping duplicate until downstream attackbys are replaced.
/obj/item/storage/attackby(obj/item/W, mob/living/user, click_params)
	if (SSfabrication.try_craft_with(src, W, user))
		return TRUE

	if (isrobot(user) && (W == user.get_active_hand()))
		return //Robots can't store their modules.

	if (!can_be_inserted(W, user))
		return TRUE

	if (handle_item_insertion(W))
		return TRUE

	return ..()

/obj/item/storage/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == src && !H.get_active_hand())	//Prevents opening if it's in a pocket.
			H.put_in_hands(src)
			H.l_store = null
			return
		if(H.r_store == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.r_store = null
			return

	if (src.loc == user)
		src.open(user)
	else
		..()
		if (storage_ui)
			storage_ui.on_hand_attack(user)
	src.add_fingerprint(user)
	return

/obj/item/storage/proc/gather_all(turf/T, mob/user)
	var/success = 0
	var/failure = 0

	for(var/obj/item/I in T)
		if(!can_be_inserted(I, user, 0))	// Note can_be_inserted still makes noise when the answer is no
			failure = 1
			continue
		success = 1
		handle_item_insertion(I, 1, 1) // First 1 is no messages, second 1 is no ui updates
	if(success && !failure)
		to_chat(user, SPAN_NOTICE("You put everything into \the [src]."))
		update_ui_after_item_insertion()
	else if(success)
		to_chat(user, SPAN_NOTICE("You put some things into \the [src]."))
		update_ui_after_item_insertion()
	else
		to_chat(user, SPAN_NOTICE("You fail to pick anything up with \the [src]."))


/obj/item/storage/verb/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"
	set src in usr
	quick_gather_single = !quick_gather_single
	if (quick_gather_single)
		to_chat(usr, "\The [src] now picks up one item at a time.")
	else
		to_chat(usr, "\The [src] now picks up all items in a tile.")


/obj/item/storage/proc/DoQuickEmpty()
	var/turf/into = get_turf(src)
	if (!into)
		return
	for(var/atom/movable/movable in contents)
		remove_from_storage(movable, into, TRUE)
	finish_bulk_removal()


/obj/item/storage/verb/quick_empty()
	set name = "Empty Contents"
	set category = "Object"
	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return
	hide_from(usr)
	DoQuickEmpty()


/obj/item/storage/verb/dump_contents()
	set name = "Dump Contents"
	set category = "Object"

	if ((!ishuman(usr) && (loc != usr)) || usr.stat || usr.restrained())
		return

	if (usr.IsHolding(src) && usr.HasFreeHand())
		if (length(contents) == 0)
			to_chat(usr, SPAN_WARNING("\The [src] is already empty."))
			return

		var/turf/T = get_turf(src)
		hide_from(usr)
		usr.visible_message(SPAN_NOTICE("\The [usr] starts dumping out the contents of \the [src]."), SPAN_NOTICE("You begin dumping out the contents of \the [src]."))
		if (do_after(usr, max(3 SECONDS, 1 SECONDS * length(contents)), src, DO_PUBLIC_UNIQUE))
			for(var/obj/item/I in contents)
				remove_from_storage(I, T, 1)
			finish_bulk_removal()
			playsound(loc, use_sound, 50, 0, -5)
			usr.visible_message(SPAN_WARNING("\The [usr] dumps out the contents of \the [src]!"), SPAN_WARNING("You dump out the contents of \the [src]!"))

	else
		to_chat(usr, SPAN_WARNING("You need to be holding \the [src] and have an empty hand to dump its contents!"))


/obj/item/storage/get_mechanics_info()
	. = ..()

	if (allow_slow_dump)
		. += "<p>The contents of \the [src] can be dumped out onto the ground. \
			Dumping the contents requires you to stand still briefly, but will then place all the items within \the [src] onto the ground where you're standing. \
			It can be slower than removing a few items manually, however can be convenient if there are a large quantity of items that may be tedious to remove.</p>\
			<p>To dump out \the [src]:</p>\
			<ol>\
				<li>Equip \the [src] in one of your hands, while having your other hand remain empty.</li>\
				<li>Activate \the [src] by clicking it or using the hotkey in your active hand on HARM intent, or selecting the verb from \the [src]'s right-click menu or Object tab.</li>\
				<li>Remain still for a short warm-up, which scales with the amount of items within \the [src].</li>\
			</ol>"

/obj/item/storage/emp_act(severity)
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()

/obj/item/storage/attack_self(mob/user as mob)
	//Clicking on itself will empty it, if it has the verb to do that.
	if(user.get_active_hand() == src)
		if(src.verbs.Find(/obj/item/storage/verb/quick_empty))
			src.quick_empty()
			return 1

		if (verbs.Find(/obj/item/storage/verb/dump_contents) && user.a_intent == I_HURT)
			dump_contents()
			return 1

/obj/item/storage/proc/make_exact_fit()
	storage_slots = length(contents)
	contents_allowed = list()
	max_w_class = 0
	max_storage_space = 0
	for(var/obj/item/I in src)
		contents_allowed[I.type]++
		max_w_class = max(I.w_class, max_w_class)
		max_storage_space += I.get_storage_cost()


/**
 * Determines the storage depth of an atom. This is the number of storage items (`/obj/item/storage`) the atom is
 * contained in before reaching `container`.
 *
 * **Parameters**:
 * - `container` - The top level container to stop at. If this is never encountered during the loop, the proc will
 * return `-1`.
 *
 * Returns integer or `-1` if the atom was not found in the container.
 */
/atom/proc/storage_depth(atom/container)
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !(cur_atom in container.contents))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.

	return depth

/**
 * Determines the storage depth of an atom. This is the number of storage items (`/obj/item/storage`) the atom is
 * contained in before reaching the turf.
 *
 * Returns integer or `-1` if the atom was not found in a turf.
 */
/atom/proc/storage_depth_turf()
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !isturf(cur_atom))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.

	return depth

/obj/item/proc/get_storage_cost()
	//If you want to prevent stuff above a certain w_class from being stored, use max_w_class
	return BASE_STORAGE_COST(w_class)
