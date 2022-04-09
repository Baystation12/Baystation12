/obj/structure/closet/secure_closet/chaplain
	name = "chaplain's locker"
	closet_appearance = /decl/closet_appearance/secure_closet/chaplain
	req_access = list(access_chapel_office)

/obj/structure/closet/secure_closet/chaplain/WillContain()
	return list(
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/chaplain_hoodie,
		/obj/item/storage/candle_box = 2,
		/obj/item/storage/candle_box/incense,
		/obj/item/deck/tarot,
		/obj/item/reagent_containers/food/drinks/bottle/holywater,
		/obj/item/nullrod,
		/obj/item/storage/bible,
		/obj/item/storage/belt/general,
		/obj/item/material/urn
	)