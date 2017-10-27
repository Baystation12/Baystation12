/obj/random_multi/single_item/punitelly
	name = "Multi Point - Warrant Officer Punitelli"
	id = "Punitelli"
	item_path = /mob/living/carbon/human/monkey/punitelli

/mob/living/carbon/human/monkey/punitelli/New()
	..()
	name = "Warrant Officer Punitelli"
	real_name = name
	var/obj/item/clothing/C
	C = new /obj/item/clothing/under/solgov/utility/expeditionary/monkey(src)
	equip_to_appropriate_slot(C)
	put_in_hands(new /obj/item/weapon/clipboard)
	equip_to_appropriate_slot(new /obj/item/clothing/mask/smokable/cigarette/jerichos)