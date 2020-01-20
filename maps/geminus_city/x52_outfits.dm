/decl/hierarchy/outfit/job/geminus_x52
	name = "X52 Researcher"

	head = null
	glasses = null
	mask = null
	suit = null
	uniform = /obj/item/clothing/under/sterile
	shoes = /obj/item/clothing/shoes/white
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = null
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/geminus_x52/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Colonist"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/geminus_x52_rd
	name = "X52 Research Director"

	head = null
	glasses = null
	mask = null
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	uniform = /obj/item/clothing/under/rank/research_director
	shoes = /obj/item/clothing/shoes/brown
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = null
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/geminus_x52_rd/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Colonist"
	H.set_id_info(C)