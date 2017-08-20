/mob/living/carbon/alien/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	adult_form = /mob/living/carbon/human
	can_namepick_as_adult = 1
	adult_name = "diona gestalt"
	speak_emote = list("chirrups")
	icon_state = "nymph"
	item_state = "nymph"
	language = LANGUAGE_ROOTLOCAL
	species_language = LANGUAGE_ROOTLOCAL
	only_species_language = 1
	death_msg = "expires with a pitiful chirrup..."
	universal_understand = 0
	universal_speak = 0      // Dionaea do not need to speak to people other than other dionaea.

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/weapon/holder/diona
	possession_candidate = 1

	var/obj/item/hat
	var/obj/item/holding_item
	var/mob/living/carbon/alien/diona/next_nymph
	var/mob/living/carbon/alien/diona/last_nymph

/mob/living/carbon/alien/diona/examine(mob/user)
	. = ..()
	if(holding_item)
		to_chat(user, "<span class='notice'>It is holding \icon[holding_item] \a [holding_item].</span>")
	if(hat)
		to_chat(user, "<span class='notice'>It is wearing \icon[hat] \a [hat].</span>")

/mob/living/carbon/alien/diona/drop_from_inventory(var/obj/item/W, var/atom/Target = null)
	. = ..()
	if(W == hat)
		hat = null
		update_icons()
	else if(W == holding_item)
		holding_item = null

/mob/living/carbon/alien/diona/IsAdvancedToolUser()
	return FALSE

/mob/living/carbon/alien/diona/New()

	..()
	species = all_species[SPECIES_DIONA]
	add_language(LANGUAGE_ROOTGLOBAL)
	add_language(LANGUAGE_GALCOM)
	verbs += /mob/living/carbon/alien/diona/proc/merge

/mob/living/carbon/alien/diona/put_in_hands(var/obj/item/W) // No hands. Use mouth.
	if(can_collect(W))
		collect(W)
	else
		W.forceMove(get_turf(src))
	return 1

/mob/living/carbon/alien/diona/proc/wear_hat(var/obj/item/clothing/head/new_hat)
	if(hat || !istype(new_hat))
		return FALSE
	hat = new_hat
	new_hat.forceMove(src)
	update_icons()
	return TRUE

/mob/living/carbon/alien/diona/proc/handle_npc(var/mob/living/carbon/alien/diona/D)
	if(D.stat != CONSCIOUS)
		return
	if(prob(33) && D.canmove && isturf(D.loc) && !D.pulledby) //won't move if being pulled
		step(D, pick(GLOB.cardinal))
	if(prob(1))
		D.emote(pick("scratch","jump","chirp","tail"))

/mob/living/carbon/alien/diona/hotkey_drop()
	if(holding_item || hat)
		drop_item()
	else
		to_chat(usr, "<span class='warning'>You have nothing to drop.</span>")

/mob/living/carbon/alien/diona/UnarmedAttack(atom/A)
	if(wear_hat(A))
		return 1
	if(!can_collect(A))
		return ..()
	collect(A)
	return 1

/mob/living/carbon/alien/diona/proc/can_collect(var/obj/item/collecting)
	return (!holding_item && istype(collecting) && !collecting.anchored && collecting.simulated && collecting.w_class <= ITEM_SIZE_SMALL)

/mob/living/carbon/alien/diona/proc/collect(var/obj/item/collecting)
	collecting.forceMove(src)
	holding_item = collecting
	visible_message("<span class='notice'>\The [src] engulfs \the [holding_item].</span>")

	// This means dionaea can hoover up beakers as a kind of impromptu chem disposal
	// technique, so long as they're okay with the reagents reacting inside them.
	if(holding_item.reagents && holding_item.reagents.total_volume)
		holding_item.reagents.trans_to_mob(src, holding_item.reagents.total_volume, CHEM_INGEST)

	// It also means they can do the old school cartoon schtick of eating and entire sandwich
	// and spitting up an empty plate. Ptooie.
	if(istype(holding_item, /obj/item/weapon/reagent_containers/food))
		var/obj/item/weapon/reagent_containers/food/food = holding_item
		holding_item = null
		if(food.trash) holding_item = new food.trash(src)
		qdel(food)

/mob/living/carbon/alien/diona/drop_item()
	if(holding_item)
		visible_message("<span class='notice'>\The [src] regurgitates \the [holding_item].</span>")
		holding_item.forceMove(get_turf(src))
		holding_item = null
	else if(hat)
		visible_message("<span class='notice'>\The [src] wriggles out from under \the [hat].</span>")
		hat.forceMove(get_turf(src))
		hat = null
		update_icons()
	else
		. = ..()