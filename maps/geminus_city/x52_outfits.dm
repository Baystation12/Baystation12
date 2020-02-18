/decl/hierarchy/outfit/job/geminus_x52
	name = "X52 Researcher"

	head = /obj/item/clothing/head/helmet/x52hood
	glasses = null
	mask = /obj/item/clothing/mask/x52/x52shemagh
	suit = /obj/item/clothing/suit/storage/toggle/x52vest
	uniform = /obj/item/clothing/under/x52/x52jumpsuit
	shoes = /obj/item/clothing/shoes/x52boots
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/x52/x52gloves
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/geminus_x52/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Colonist"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/geminus_x52_rd
	name = "X52 Research Director"

	head = /obj/item/clothing/head/helmet/x52hood
	glasses = null
	mask = /obj/item/clothing/mask/x52/x52shemagh
	suit = /obj/item/clothing/suit/storage/toggle/x52vest/jacket
	uniform = /obj/item/clothing/under/x52/x52RDjumpsuit
	shoes = /obj/item/clothing/shoes/x52boots
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/x52/x52gloves
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/geminus_x52_rd/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Colonist"
	H.set_id_info(C)