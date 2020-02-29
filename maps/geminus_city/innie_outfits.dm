
/decl/hierarchy/outfit/job/geminus_innie
	name = "Insurrectionist"

	head = /obj/item/clothing/head/helmet/innie/medium/brown
	glasses = /obj/item/clothing/glasses/hud/tactical
	mask = /obj/item/clothing/mask/balaclava/tactical
	suit = /obj/item/clothing/suit/storage/innie/medium/brown
	uniform = /obj/item/clothing/under/innie/jumpsuit
	shoes = /obj/item/clothing/shoes/innie_boots/medium/brown
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/x52/x52gloves
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

	head = /obj/item/clothing/head/helmet/innie/heavy/vblue
	glasses =/obj/item/clothing/glasses/hud/tactical
	mask = /obj/item/clothing/mask/balaclava/tactical
	suit = /obj/item/clothing/suit/storage/innie/heavy/blue
	uniform = /obj/item/clothing/under/innie/jumpsuit
	shoes = /obj/item/clothing/shoes/innie_boots/medium/blue
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/x52/x52gloves
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
	name = "Geminus Insurrectionist"
	l_ear = /obj/item/device/radio/headset/insurrection


/decl/hierarchy/outfit/job/colonist/geminus_innie_orion_defector
	name = "Insurrectionist Orion Defector"

	head = /obj/item/clothing/head/helmet/innie/urfdefector
	glasses = /obj/item/clothing/glasses/hud/tactical
	mask = /obj/item/clothing/mask/gas/soebalaclava
	suit = /obj/item/clothing/suit/storage/innie/urfdefector
	uniform = /obj/item/clothing/under/psysuit/theta
	shoes = /obj/item/clothing/shoes/marine/orion
	l_ear = /obj/item/device/radio/headset/insurrection
	gloves = /obj/item/clothing/gloves/marine/orion
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/geminus_innie_orion_defector/equip_id(mob/living/carbon/human/H, rank, assignment)
	. = ..()

	var/obj/item/weapon/card/id/W = .
	if(W)
		W.rank = "Colonist"
		W.assignment = "Colonist"
		W.update_name()