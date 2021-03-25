/mob/living/carbon/alien/diona/drop_from_inventory(var/obj/item/I)
	. = ..()
	if(I == holding_item)
		holding_item = null
	else if(I == hat)
		hat = null
		update_icons()

/mob/living/carbon/alien/diona/put_in_hands(var/obj/item/W) // No hands. Use mouth.
	if(can_collect(W))
		collect(W)
	else
		W.forceMove(get_turf(src))
	return 1

/mob/living/carbon/alien/diona/proc/wear_hat(var/obj/item/clothing/head/new_hat)
	if(hat || !istype(new_hat) || holding_item == new_hat)
		return FALSE
	hat = new_hat
	hat.forceMove(src)
	hat.equipped(src)
	hat.screen_loc = DIONA_SCREEN_LOC_HAT
	update_icons()
	return TRUE

/mob/living/carbon/alien/diona/hotkey_drop()
	if(holding_item || hat)
		drop_item()
	else
		to_chat(usr, "<span class='warning'>You have nothing to drop.</span>")

/mob/living/carbon/alien/diona/proc/can_collect(var/obj/item/collecting)
	return (!holding_item && \
		istype(collecting) && \
		collecting != hat && \
		collecting.loc != src && \
		!collecting.anchored && \
		collecting.simulated && \
		collecting.w_class <= can_pull_size \
	)

/mob/living/carbon/alien/diona/proc/collect(var/obj/item/collecting)
	collecting.forceMove(src)
	holding_item = collecting
	visible_message("<span class='notice'>\The [src] engulfs \the [holding_item].</span>")

	// This means dionaea can hoover up beakers as a kind of impromptu chem disposal
	// technique, so long as they're okay with the reagents reacting inside them.
	if(holding_item.reagents && holding_item.reagents.total_volume)
		holding_item.reagents.trans_to_mob(src, holding_item.reagents.total_volume, CHEM_INGEST)

	// It also means they can do the old school cartoon schtick of eating an entire sandwich
	// and spitting up an empty plate. Ptooie.
	if(istype(holding_item, /obj/item/reagent_containers/food))
		var/obj/item/reagent_containers/food/food = holding_item
		holding_item = null
		if(food.trash) holding_item = new food.trash(src)
		qdel(food)

	if(!QDELETED(holding_item))
		holding_item.equipped(src)
		holding_item.screen_loc = DIONA_SCREEN_LOC_HELD

/mob/living/carbon/alien/diona/verb/drop_item_verb()
	set name = "Drop Held Item"
	set desc = "Drop the item you are currently holding inside."
	set category = "IC"
	set src = usr
	drop_item()

/mob/living/carbon/alien/diona/drop_item()
	if(holding_item && unEquip(holding_item))
		visible_message("<span class='notice'>\The [src] regurgitates \the [holding_item].</span>")
	else if(hat && unEquip(hat))
		visible_message("<span class='notice'>\The [src] wriggles out from under \the [hat].</span>")
		update_icons()
	else
		. = ..()

