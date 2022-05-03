/obj/item/storage/ore
	name = "mining satchel"
	desc = "This sturdy bag can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT
	max_storage_space = 200
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_LARGE
	can_hold = list(
		/obj/item/ore
	)
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE


/obj/item/storage/evidence
	name = "evidence case"
	desc = "A heavy steel case for storing evidence."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	max_storage_space = 100
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(
		/obj/item/sample,
		/obj/item/evidencebag,
		/obj/item/forensics,
		/obj/item/photo,
		/obj/item/paper,
		/obj/item/paper_bundle
	)
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE


/obj/item/storage/plants
	name = "botanical satchel"
	desc = "This bag can be used to store all kinds of plant products and botanical specimen."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	slot_flags = SLOT_BELT
	max_storage_space = 100
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/seeds
	)
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE


/obj/item/storage/sheetsnatcher
	name = "sheet snatcher"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	desc = "A patented storage system designed for any kind of mineral sheet."
	storage_ui = /datum/storage_ui/default/sheetsnatcher
	w_class = ITEM_SIZE_NORMAL
	storage_slots = 7
	use_to_pickup = TRUE
	virtual = TRUE
	var/max_sheets = 300
	var/cur_sheets = 0


/obj/item/storage/sheetsnatcher/examine(mob/user, distance)
	. = ..()
	if (distance < 2)
		to_chat(user, "It has a capacity of [max_sheets] sheets and current holds [cur_sheets].")


/obj/item/storage/sheetsnatcher/can_be_inserted(obj/item/stack/material/stack, mob/user, silent)
	if (!istype(stack))
		if (!silent)
			to_chat(user, SPAN_WARNING("The snatcher cannot hold \a [stack]."))
		return FALSE
	if (stack.amount > (max_sheets - cur_sheets))
		if (!silent)
			to_chat(user, SPAN_WARNING("The snatcher cannot hold \a [stack]."))
		return FALSE
	return TRUE


/obj/item/storage/sheetsnatcher/handle_item_insertion(obj/item/stack/material/stack, silent)
	if (!can_be_inserted(stack, null, silent))
		return FALSE
	if (!usr?.unEquip(stack, src))
		return FALSE
	cur_sheets += stack.amount
	for (var/obj/item/stack/material/held as anything in contents)
		if (stack.amount < 1)
			break
		if (held.type != stack.type)
			continue
		if (held.amount >= held.max_amount)
			continue
		var/free_space = held.max_amount - held.amount
		if (free_space >= stack.amount)
			held.amount += stack.amount
			qdel(stack)
			break
		else
			held.amount += free_space
			stack.amount -= free_space
	prepare_ui(usr)
	update_icon()
	return TRUE


/obj/item/storage/sheetsnatcher/attack_self(mob/user)
	if (user.stat || !Adjacent(user) || user.restrained())
		to_chat(user, SPAN_WARNING("You're in no condition to do that with \the [src]."))
		return FALSE
	if (cur_sheets < 1)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return FALSE
	to_chat(user, SPAN_ITALIC("You empty out \the [src]."))
	empty()


/obj/item/storage/sheetsnatcher/proc/empty()
	var/turf/turf = get_turf(src)
	if (!turf)
		return
	for(var/obj/item/stack/material/held as anything in contents)
		held.forceMove(turf)
	cur_sheets = 0
	update_icon()


/obj/item/storage/sheetsnatcher/borg
	name = "sheet snatcher 9000"
	desc = ""
	max_sheets = 500
