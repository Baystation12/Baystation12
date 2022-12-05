/singleton/hierarchy/outfit/scg
	name = "SCG"
	uniform = /obj/item/clothing/under/solgov

/singleton/hierarchy/outfit/scg/troops
	name = "Inf - SCG MarineHolder"
	head = /obj/item/clothing/head/helmet/marine
	mask = /obj/item/clothing/mask/gas/half
	l_ear = /obj/item/device/radio/headset/specops
	suit = /obj/item/clothing/suit/armor/pcarrier/troops/heavy
	suit_store = /obj/item/gun/projectile/automatic/sec_smg
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/storage/belt/holster/security/tactical
	uniform = /obj/item/clothing/under/solgov/utility/army/urban
	l_pocket = /obj/item/device/flashlight/maglight
	shoes = /obj/item/clothing/shoes/combat
	id_slot = slot_wear_id
	id_desc = "An ID of SCG marine trooper."
	id_types = list(/obj/item/card/id/security)

	back = /obj/item/storage/backpack/satchel/leather/black
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/combat =1)
	flags = OUTFIT_HAS_BACKPACK

/singleton/hierarchy/outfit/scg/troops/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/badge/solgov/tags/tag = new()
		tag.stored_name = H.real_name
		tag.name = "[initial(tag.name)] ([tag.stored_name])"
		if(uniform.can_attach_accessory(tag))
			uniform.attach_accessory(null, tag)
		else
			qdel(tag)

/singleton/hierarchy/outfit/scg/troops/standart
	name = "Inf - SCG Marine Standart"
	id_pda_assignment = "Marine Trooper"

/singleton/hierarchy/outfit/scg/troops/standart/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/solgov/rank/army/enlisted/e2/rank = new()
		if(uniform.can_attach_accessory(rank))
			uniform.attach_accessory(null, rank)
		else
			qdel(rank)

/singleton/hierarchy/outfit/scg/troops/engineer
	name = "Inf - SCG Marine Combat Engineer"
	glasses = /obj/item/clothing/glasses/welding
	gloves = /obj/item/clothing/gloves/thick/swat
	back = /obj/item/storage/backpack/satchel/eng
	belt = /obj/item/storage/belt/utility
	id_pda_assignment = "Marine Combat Engineer"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/plastique = 3)

/singleton/hierarchy/outfit/scg/troops/engineer/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/singleton/hierarchy/outfit/scg/troops/engineer/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/solgov/rank/army/enlisted/e3/rank = new()
		if(uniform.can_attach_accessory(rank))
			uniform.attach_accessory(null, rank)
		else
			qdel(rank)

/singleton/hierarchy/outfit/scg/troops/medic
	name = "Inf - SCG Marine Corpsman"
	glasses = /obj/item/clothing/glasses/hud/health
	back = /obj/item/storage/backpack/satchel/med
	suit = /obj/item/clothing/suit/armor/pcarrier/troops
	belt = /obj/item/storage/belt/medical/emt
	id_pda_assignment = "Marine Corpsman"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/storage/firstaid/surgery = 1)

/singleton/hierarchy/outfit/scg/troops/medic/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/singleton/hierarchy/outfit/scg/troops/medic/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/solgov/rank/army/enlisted/e4/rank = new()
		if(uniform.can_attach_accessory(rank))
			uniform.attach_accessory(null, rank)
		else
			qdel(rank)

/singleton/hierarchy/outfit/scg/troops/sergeant
	name = "Inf - SCG Marine Sergeant"
	back = /obj/item/storage/backpack/security
	id_types = list(/obj/item/card/id/security/head)
	id_pda_assignment = "Marine Squad Leader"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/combat = 1)

/singleton/hierarchy/outfit/scg/troops/sergeant/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/singleton/hierarchy/outfit/scg/troops/sergeant/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/solgov/rank/army/enlisted/e5/rank = new()
		if(uniform.can_attach_accessory(rank))
			uniform.attach_accessory(null, rank)
		else
			qdel(rank)

/singleton/hierarchy/outfit/marshal
	name = "Inf - OCIE tracker"
	shoes = /obj/item/clothing/shoes/jackboots
	uniform = /obj/item/clothing/under/rank/security/navyblue
	suit = /obj/item/clothing/suit/armor/pcarrier/light/sol
	l_ear = /obj/item/device/radio/headset/headset_sec
	belt = /obj/item/storage/belt/holster/security
	r_hand = /obj/item/clothing/accessory/badge/tracker
	l_hand = /obj/item/gun/energy/taser
	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/security)
	id_desc = "An ID of SCG OCEI tracker."
	id_pda_assignment = "OCEI tracker"
