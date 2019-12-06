/decl/hierarchy/outfit/job
	name = "Standard Gear"
	hierarchy_type = /decl/hierarchy/outfit/job

	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian
	pda_slot = slot_belt
	pda_type = /obj/item/modular_computer/pda

	flags = OUTFIT_HAS_BACKPACK

/decl/hierarchy/outfit/job/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	if(!C)
		return
	if(H.mind)
		if(H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number
		if(H.mind.initial_email_login)
			C.associated_email_login = H.mind.initial_email_login.Copy()
	return C
