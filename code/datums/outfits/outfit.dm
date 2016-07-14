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
	outfits_decls_root_ = new/decl/hierarchy/outfit()

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
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format

	var/id_type
	var/id_desc
	var/id_slot

	var/pda_type
	var/pda_slot

	var/id_pda_assignment

	var/flags // Specific flags

/decl/hierarchy/outfit/New()
	..()

	if(is_hidden_category())
		return
	outfits_decls_by_type_[type] = src
	dd_insertObjectList(outfits_decls_, src)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/H)
	//to be overriden for customization depending on client prefs,species etc
	return

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/weapon/tank/jetpack/J = locate(/obj/item/weapon/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/decl/hierarchy/outfit/proc/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	equip_base(H)

	rank = id_pda_assignment ? id_pda_assignment : rank
	assignment = id_pda_assignment ? id_pda_assignment : (assignment ? assignment : rank)
	var/obj/item/weapon/card/id/W = equip_id(H, rank, assignment)
	if(W)
		rank = W.rank
		assignment = W.assignment
	equip_pda(H, rank, assignment)

	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_del(new path(H), slot_in_backpack)

	post_equip(H)
	H.regenerate_icons()
	return 1

/decl/hierarchy/outfit/proc/equip_base(mob/living/carbon/human/H)
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(new uniform(H),slot_w_uniform)
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
	if(head)
		H.equip_to_slot_or_del(new head(H),slot_head)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),slot_wear_mask)
	if(l_ear)
		H.equip_to_slot_or_del(new l_ear(H),slot_l_ear)
	if(r_ear)
		H.equip_to_slot_or_del(new r_ear(H),slot_r_ear)
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
	if(H.species)
		H.species.equip_survival_gear(H, flags&OUTFIT_EXTENDED_SURVIVAL)

/decl/hierarchy/outfit/proc/equip_id(mob/living/carbon/human/H, rank, assignment)
	if(!id_slot)
		return
	var/obj/item/weapon/card/id/W = new id_type(H)
	if(id_desc)
		W.desc = id_desc
	if(rank)
		W.rank = rank
	if(assignment)
		W.assignment = assignment
	H.set_id_info(W)
	if(H.equip_to_slot_or_del(W, id_slot))
		return W

/decl/hierarchy/outfit/proc/equip_pda(mob/living/carbon/human/H, rank, assignment)
	if(!pda_slot)
		return
	var/obj/item/device/pda/heads/pda = new pda_type(H)
	pda.set_owner_rank_job(H.real_name, rank, assignment)
	if(H.equip_to_slot_or_del(pda, pda_slot))
		return pda

/decl/hierarchy/outfit/dd_SortValue()
	return name
