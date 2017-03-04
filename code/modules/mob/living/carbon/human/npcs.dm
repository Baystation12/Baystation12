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