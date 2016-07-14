/decl/hierarchy/outfit/job
	name = "Standard Gear"
	hierarchy_type = /decl/hierarchy/outfit/job

	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack
	shoes = /obj/item/clothing/shoes/black

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian
	pda_slot = slot_belt
	pda_type = /obj/item/device/pda

	var/backpack = /obj/item/weapon/storage/backpack
	var/satchel_one  = /obj/item/weapon/storage/backpack/satchel_norm
	var/satchel_two  = /obj/item/weapon/storage/backpack/satchel

/decl/hierarchy/outfit/job/pre_equip(mob/living/carbon/human/H)
	..()
	switch(H.backbag)
		if(2) back = backpack
		if(3) back = satchel_one
		if(4) back = satchel_two
		else back = null

/decl/hierarchy/outfit/job/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	if(H.mind)
		if(H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number
	return C
