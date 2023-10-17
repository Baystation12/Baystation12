/obj/item/storage/fancy/smokable
	abstract_type = /obj/item/storage/fancy/smokable
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	open_sound = 'sound/effects/storage/smallbox.ogg'
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	throwforce = 2
	slot_flags = SLOT_BELT
	key_type = list(/obj/item/clothing/mask/smokable/cigarette)
	atom_flags = ATOM_FLAG_NO_REACT | ATOM_FLAG_OPEN_CONTAINER

	/// A map? of reagents to add to this container on initialization.
	var/list/datum/reagent/initial_reagents


/obj/item/storage/fancy/smokable/Initialize()
	. = ..()
	UpdateReagents()
	if (reagents)
		for (var/datum/reagent/reagent as anything in initial_reagents)
			reagents.add_reagent(reagent, initial_reagents[reagent], safety = TRUE)
	initial_reagents = null


/obj/item/storage/fancy/smokable/handle_item_insertion(obj/item/item, prevent_warning, NoUpdate)
	. = ..()
	if (.)
		UpdateReagents()


/obj/item/storage/fancy/smokable/remove_from_storage(obj/item/item, atom/into, NoUpdate)
	. = ..()
	if (. && istype(item, key_type))
		reagents.trans_to_obj(item, reagents.total_volume / (key_type_count + 1))
		UpdateReagents()


/obj/item/storage/fancy/smokable/use_after(mob/living/carbon/target, mob/living/carbon/user)
	if (user != target || !istype(user))
		return FALSE

	if (!opened)
		opened = !opened
		playsound(src.loc, src.open_sound, 50, 0, -5)
		queue_icon_update()
	var/obj/item/clothing/mask/smokable/smokable = locate() in contents
	if (!smokable)
		to_chat(user, SPAN_WARNING("\The [src] has nothing smokable left inside."))
		return TRUE
	if (user.wear_mask)
		to_chat(user, SPAN_WARNING("Your [user.wear_mask.name] is in the way."))
		return TRUE
	if (!smokable.mob_can_equip(user, slot_wear_mask))
		return TRUE
	remove_from_storage(smokable, user.loc)
	update_icon()
	if (!user.equip_to_slot_if_possible(smokable, slot_wear_mask))
		to_chat(user, SPAN_WARNING("\The [smokable] falls from you. Oh no."))
		return TRUE
	to_chat(user, SPAN_NOTICE("You take \a [smokable] from \the [src]."))
	return TRUE


/obj/item/storage/fancy/smokable/proc/UpdateReagents()
	var/obj/item/clothing/mask/smokable/key_type_path = key_type
	var/size = initial(key_type_path.chem_volume) * key_type_count
	if (!size)
		qdel(reagents)
	else if (!reagents)
		create_reagents(size)
	else
		reagents.Resize(size)
