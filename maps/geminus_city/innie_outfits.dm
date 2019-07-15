
/decl/hierarchy/outfit/job/geminus_innie
	name = "Insurrectionist"

	head = /obj/item/clothing/head/helmet/tactical
	glasses = /obj/item/clothing/glasses/hud/tactical
	mask = /obj/item/clothing/mask/balaclava/tactical
	suit = /obj/item/clothing/suit/storage/vest/tactical
	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/tactical
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/tactical
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/geminus_innie/equip_id(mob/living/carbon/human/H, rank, assignment)
	. = ..()

	var/obj/item/weapon/card/id/W = .
	if(W)
		W.rank = "Colonist"
		W.assignment = "Colonist"
		W.update_name()

/decl/hierarchy/outfit/job/geminus_innie_leader
	name = "Insurrectionist Captain"

	head = /obj/item/clothing/head/helmet/tactical/mirania
	glasses =/obj/item/clothing/glasses/hud/tactical
	mask = /obj/item/clothing/mask/balaclava/tactical
	suit = /obj/item/clothing/suit/storage/vest/tactical/mirania
	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/tactical
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/tactical
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/geminus_innie_leader/equip_id(mob/living/carbon/human/H, rank, assignment)
	. = ..()

	var/obj/item/weapon/card/id/W = .
	if(W)
		W.rank = "Colonist"
		W.assignment = "Colonist"
		W.update_name()

/decl/hierarchy/outfit/job/colonist/geminus_innie
	l_ear = /obj/item/device/radio/headset/insurrection
