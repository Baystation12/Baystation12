

/decl/hierarchy/outfit/job/unsc_achlys/CO
	name = "Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/SL
	name = "Squad Leader"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/marine
	name = "Marine"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/operative
	name = "Operative"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	r_pocket = /obj/item/weapon/paper/crumpled/orders
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/operative/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Marine"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/unsc_achlys/pilot
	name = "Pilot"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/pilot
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/prisoner
	name = "Prisoner"

	l_ear = null
	r_ear = /obj/item/device/flashlight/pen/bright
	uniform = /obj/item/clothing/under/color/orange
	shoes = /obj/item/clothing/shoes/orange
	pda_slot = null
	id = null
	id_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/prisoner/proc/equip_special(mob/living/carbon/human/H)
	var/l_hand_item = /obj/item/weapon/crowbar/red
	var/r_hand_item = null
	var/belt_item = null
	if(prob(25))
		r_hand_item = /obj/item/weapon/scalpel/achlys
	else if(prob(10))
		r_hand_item = /obj/item/weapon/material/hatchet/achlys
	else if(prob(10))
		l_hand_item = /obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/achlys
		r_hand_item = /obj/item/ammo_box/shotgun
		belt_item = /obj/item/weapon/crowbar/red
	else if(prob(10))
		belt_item = /obj/item/weapon/gun/projectile/m6d_magnum/civilian/achlys
		r_hand_item = /obj/item/device/flashlight/maglight
	else if(prob(25))
		r_hand_item = /obj/item/weapon/material/twohanded/fireaxe
	if(l_hand_item)
		H.equip_to_slot_or_del(new l_hand_item (H.loc),slot_l_hand)
	if(r_hand_item)
		H.equip_to_slot_or_del(new r_hand_item (H.loc),slot_r_hand)
	if(belt_item)
		H.equip_to_slot_or_del(new belt_item (H.loc),slot_belt)

/decl/hierarchy/outfit/job/unsc_achlys/prisoner/equip_base(mob/living/carbon/human/H)
	. = ..()
	equip_special(H)

/decl/hierarchy/outfit/job/unsc_achlys/sangheili
	name = "Sangheili Prisoner"

	r_ear = /obj/item/device/flashlight/pen/bright
	uniform = /obj/item/clothing/under/covenant/sangheili
	suit = null
	back = null
	gloves = null
	head = null
	id = null
	id_slot = null
	shoes = null
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/sangheili/proc/equip_special(mob/living/carbon/human/H)
	var/l_hand_item = null
	var/r_hand_item = null
	var/belt_item = null
	if(prob(25))
		l_hand_item = /obj/item/weapon/material/twohanded/fireaxe
	else if(prob(25))
		l_hand_item = /obj/item/weapon/material/twohanded/baseballbat/achlys
	else if(prob(10))
		l_hand_item = /obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/achlys
		r_hand_item = /obj/item/ammo_box/shotgun
	else if(prob(10))
		belt_item = /obj/item/weapon/gun/projectile/m6d_magnum/civilian/achlys
		r_hand_item = /obj/item/device/flashlight/maglight
	if(l_hand_item)
		H.equip_to_slot_or_del(new l_hand_item (H.loc),slot_l_hand)
	if(r_hand_item)
		H.equip_to_slot_or_del(new r_hand_item (H.loc),slot_r_hand)
	if(belt_item)
		H.equip_to_slot_or_del(new belt_item (H.loc),slot_belt)
