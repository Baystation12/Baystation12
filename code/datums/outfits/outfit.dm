var/list/outfits_decls_
var/list/outfits_decls_root_
var/list/outfits_decls_by_type_

/proc/outfit_by_type(var/outfit_type)
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_by_type_[outfit_type]

/proc/outfits()
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_

/proc/init_outfit_decls()
	if(outfits_decls_root_)
		return
	outfits_decls_ = list()
	outfits_decls_by_type_ = list()
	outfits_decls_root_ = decls_repository.get_decl(/decl/hierarchy/outfit)

/decl/hierarchy/outfit
	name = "Naked"

	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/l_ear = null
	var/r_ear = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/r_hand = null
	var/l_hand = null
	var/holster = null
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format

	var/id_types
	var/id_desc
	var/id_slot

	var/pda_type
	var/pda_slot

	var/id_pda_assignment

	var/list/backpack_overrides
	var/flags = OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/New()
	..()
	backpack_overrides = backpack_overrides || list()

	if(is_hidden_category())
		return
	outfits_decls_by_type_[type] = src
	dd_insertObjectList(outfits_decls_, src)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_RESET_EQUIPMENT)
		H.delete_inventory(TRUE)

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/J = locate(/obj/item/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

// A proc for non-human species, specially Unathi, since they e.g.
// can't normally wear gloves as humans. Correct this issue by trying again, but
// apply some changes to the said item.
//
// Currently checks for gloves
//
// If you want to add more items that has species restriction, consider follow-
// ing the same format as the gloves shown in the code below. Thanks.
/decl/hierarchy/outfit/proc/check_and_try_equip_xeno(mob/living/carbon/human/H)
	var/datum/species/S = H.species
	if (!S || istype(S, /datum/species/human)) // null failcheck & get out here you damn humans
		return

	// Gloves
	if (gloves && !H.get_equipped_item(slot_gloves)) // does mob not have gloves, despite the outfit has one specified?
		var/obj/item/clothing/gloves/G = new gloves(H) // we've no use of a null object, instantize one
		if (S.get_bodytype(H) in G.species_restricted) // what was the problem?
			if ("exclude" in G.species_restricted) // are they excluded?
				G.cut_fingertops()
				// I could optimize this bit when we are trying to apply the gloves to e.g. Vox, a species still restricted despite G.cut_fingertops(). But who cares if this is codebase is like a plate of spaghetti twice over the brim, right? RIGHT?
				H.equip_to_slot_or_del(G,slot_gloves) // try again
		else
			qdel(G)
	// end Gloves

// end of check_and_try_equip_xeno

/decl/hierarchy/outfit/proc/equip(mob/living/carbon/human/H, rank, assignment, equip_adjustments)
	equip_base(H, equip_adjustments)

	rank = id_pda_assignment || rank
	assignment = id_pda_assignment || assignment || rank
	var/list/id_cards = equip_ids(H, rank, assignment, equip_adjustments)
	if(length(id_cards))
		var/obj/item/card/id/W = id_cards[1]
		rank = W.rank
		assignment = W.assignment
	equip_pda(H, rank, assignment, equip_adjustments)

	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_store_or_drop(new path(H), slot_in_backpack)

	if(!(OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP & equip_adjustments))
		post_equip(H)
	H.update_icons()

	// We set ID info last to ensure the ID photo is as correct as possible.
	for(var/id_card in id_cards)
		H.set_id_info(id_card)
	return TRUE

/decl/hierarchy/outfit/proc/equip_base(mob/living/carbon/human/H, var/equip_adjustments)
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(new uniform(H),slot_w_uniform)
	if(holster && H.w_uniform)
		var/obj/item/clothing/w_uniform = H.w_uniform
		if (istype(w_uniform))
			var/obj/item/clothing/accessory/equip_holster = new holster
			if (!w_uniform.attempt_attach_accessory(equip_holster, H))
				qdel(equip_holster)
	if(suit)
		H.equip_to_slot_or_del(new suit(H),slot_wear_suit)
	if(back)
		H.equip_to_slot_or_del(new back(H),slot_back)
	if(belt)
		H.equip_to_slot_or_del(new belt(H),slot_belt)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),slot_gloves)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),slot_shoes)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),slot_wear_mask)
	if(head)
		H.equip_to_slot_or_del(new head(H),slot_head)
	if(l_ear)
		var/l_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(l_ear, /obj/item/device/radio/headset) ? /obj/item/device/radio/headset : l_ear
		H.equip_to_slot_or_del(new l_ear_path(H),slot_l_ear)
	if(r_ear)
		var/r_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(r_ear, /obj/item/device/radio/headset) ? /obj/item/device/radio/headset : r_ear
		H.equip_to_slot_or_del(new r_ear_path(H),slot_r_ear)
	if(glasses)
		H.equip_to_slot_or_del(new glasses(H),slot_glasses)
	if(id)
		H.equip_to_slot_or_del(new id(H),slot_wear_id)
	if(l_pocket)
		H.equip_to_slot_or_del(new l_pocket(H),slot_l_store)
	if(r_pocket)
		H.equip_to_slot_or_del(new r_pocket(H),slot_r_store)
	if(suit_store)
		H.equip_to_slot_or_del(new suit_store(H),slot_s_store)
	if(l_hand)
		H.put_in_l_hand(new l_hand(H))
	if(r_hand)
		H.put_in_r_hand(new r_hand(H))

	if((flags & OUTFIT_HAS_BACKPACK) && !(OUTFIT_ADJUSTMENT_SKIP_BACKPACK & equip_adjustments))
		var/decl/backpack_outfit/bo
		var/metadata

		if(H.backpack_setup)
			bo = H.backpack_setup.backpack
			metadata = H.backpack_setup.metadata
		else
			bo = get_default_outfit_backpack()

		var/override_type = backpack_overrides[bo.type]
		var/backpack = bo.spawn_backpack(H, metadata, override_type)

		if(backpack)
			if(back)
				if(!H.put_in_hands(backpack))
					H.equip_to_appropriate_slot(backpack)
			else
				H.equip_to_slot_or_del(backpack, slot_back)

	if(H.species && !(OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR & equip_adjustments))
		H.species.equip_survival_gear(H, flags&OUTFIT_EXTENDED_SURVIVAL)
	check_and_try_equip_xeno(H)

/decl/hierarchy/outfit/proc/equip_ids(mob/living/carbon/human/H, rank, assignment, equip_adjustments)
	if(!id_slot || !length(id_types))
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/created_cards = list()
	for(var/id_type in id_types)
		var/obj/item/card/id/W = new id_type(H)
		if(id_desc)
			W.desc = id_desc
		if(rank)
			W.rank = rank
		if(assignment)
			W.assignment = assignment

		if((flags & OUTFIT_USES_ACCOUNT) && H.mind?.initial_account)
			W.associated_account_number = H.mind.initial_account.account_number
		if((flags & OUTFIT_USES_EMAIL) && H.mind?.initial_email_login)
			W.associated_email_login = H.mind.initial_email_login.Copy()

		var/item_slot = id_types[id_type] || id_slot
		H.equip_to_slot_or_store_or_drop(W, item_slot)
		created_cards += W
	return created_cards

/decl/hierarchy/outfit/proc/equip_pda(var/mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	if(!pda_slot || !pda_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/modular_computer/pda/pda = new pda_type(H)
	if(H.equip_to_slot_or_store_or_drop(pda, pda_slot))
		return pda

/decl/hierarchy/outfit/dd_SortValue()
	return name
