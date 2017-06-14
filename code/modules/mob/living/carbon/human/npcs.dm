/mob/living/carbon/human/monkey/punpun/New()
	..()
	name = "Pun Pun"
	real_name = name
	var/obj/item/clothing/C
	if(prob(50))
		C = new /obj/item/clothing/under/punpun(src)
		equip_to_appropriate_slot(C)
	else
		C = new /obj/item/clothing/under/punpants(src)
		C.attach_accessory(null, new/obj/item/clothing/accessory/toggleable/hawaii/random(src))
		equip_to_appropriate_slot(C)
		if(prob(10))
			C = new/obj/item/clothing/head/collectable/petehat(src)
			equip_to_appropriate_slot(C)

/obj/random_multi/single_item/punitelly
	name = "Multi Point - Warrant Officer Punitelli"
	id = "Punitelli"
	item_path = /mob/living/carbon/human/monkey/punitelli

/mob/living/carbon/human/monkey/punitelli/New()
	..()
	name = "Warrant Officer Punitelli"
	real_name = name
	var/obj/item/clothing/C
	C = new /obj/item/clothing/under/utility/expeditionary/monkey(src)
	equip_to_appropriate_slot(C)
	if(prob(50))
		C = new /obj/item/clothing/head/beret/sol/expedition(src)
	else
		C = new /obj/item/clothing/head/soft/sol/expedition
	equip_to_appropriate_slot(C)
	put_in_hands(new /obj/item/weapon/clipboard)
	equip_to_appropriate_slot(new /obj/item/clothing/mask/smokable/cigarette/jerichos)

/decl/hierarchy/outfit/blank_subject
	name = "Test Subject"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/white
	head = /obj/item/clothing/head/helmet/facecover
	mask = /obj/item/clothing/mask/muzzle
	suit = /obj/item/clothing/suit/straight_jacket

/decl/hierarchy/outfit/blank_subject/post_equip(mob/living/carbon/human/H)
	var/obj/item/clothing/under/color/white/C = locate() in H
	if(C)
		C.has_sensor = 2 //For the crew computer 2 = unable to change mode
		C.sensor_mode = 0

/mob/living/carbon/human/blank/New(var/new_loc)
	..(new_loc, "Vat-Grown Human")
	var/number = "[pick(possible_changeling_IDs)]-[rand(1,30)]"
	fully_replace_character_name("Subject [number]")
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/blank_subject)
	outfit.equip(src)
	var/obj/item/clothing/head/helmet/facecover/F = locate() in src
	if(F)
		F.name = "[F.name] ([number])"

/mob/living/carbon/human/blank/ssd_check()
	return FALSE