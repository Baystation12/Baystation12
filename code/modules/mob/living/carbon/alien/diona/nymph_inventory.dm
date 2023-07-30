/mob/living/carbon/alien/diona/drop_from_inventory(obj/item/I)
	. = ..()
	if (I == holding_item)
		holding_item = null
	else if (I == hat)
		hat = null
		update_icons()

/mob/living/carbon/alien/diona/put_in_hands(obj/item/W) // No hands. Use mouth.
	if (can_collect(W))
		collect(W)
	else
		W.forceMove(get_turf(src))
	return 1

/mob/living/carbon/alien/diona/proc/wear_hat(obj/item/clothing/head/new_hat)
	if (hat || !istype(new_hat) || holding_item == new_hat)
		return FALSE
	hat = new_hat
	hat.forceMove(src)
	hat.equipped(src)
	hat.screen_loc = DIONA_SCREEN_LOC_HAT
	update_icons()
	return TRUE

/mob/living/carbon/alien/diona/hotkey_drop()
	if (holding_item || hat)
		drop_item()
	else
		to_chat(usr, SPAN_WARNING("You have nothing to drop."))

/mob/living/carbon/alien/diona/proc/can_collect(obj/item/collecting)
	return (!holding_item && \
		istype(collecting) && \
		collecting != hat && \
		collecting.loc != src && \
		!collecting.anchored && \
		collecting.simulated && \
		collecting.w_class <= can_pull_size \
	)

/mob/living/carbon/alien/diona/proc/collect(obj/item/collecting)
	collecting.forceMove(src)
	holding_item = collecting
	visible_message(SPAN_NOTICE("\The [src] engulfs \the [holding_item]."))

	// This means dionaea can hoover up beakers as a kind of impromptu chem disposal
	// technique, so long as they're okay with the reagents reacting inside them.
	if (holding_item.reagents && holding_item.reagents.total_volume)
		holding_item.reagents.trans_to_mob(src, holding_item.reagents.total_volume, CHEM_INGEST)

	// It also means they can do the old school cartoon schtick of eating an entire sandwich
	// and spitting up an empty plate. Ptooie.
	if (istype(holding_item, /obj/item/reagent_containers/food))
		var/obj/item/reagent_containers/food/food = holding_item
		holding_item = null
		if (istype(holding_item, /obj/item/reagent_containers/food/snacks))
			var/obj/item/reagent_containers/food/snacks/snack = food
			if (snack.trash)
				holding_item = new snack.trash(src)
		qdel(food)

	if (!QDELETED(holding_item))
		holding_item.equipped(src)
		holding_item.screen_loc = DIONA_SCREEN_LOC_HELD

/mob/living/carbon/alien/diona/verb/drop_item_verb()
	set name = "Drop Held Item"
	set desc = "Drop the item you are currently holding inside."
	set category = "IC"
	set src = usr
	drop_item()

/mob/living/carbon/alien/diona/drop_item()
	if (holding_item && unEquip(holding_item))
		visible_message(SPAN_NOTICE("\The [src] regurgitates \the [holding_item]."))
	else if (hat && unEquip(hat))
		visible_message(SPAN_NOTICE("\The [src] wriggles out from under \the [hat]."))
		update_icons()
	else
		. = ..()
