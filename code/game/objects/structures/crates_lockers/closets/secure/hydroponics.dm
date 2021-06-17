/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	closet_appearance = /decl/closet_appearance/secure_closet/hydroponics

/obj/structure/closet/secure_closet/hydroponics/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(/obj/item/clothing/suit/apron, /obj/item/clothing/suit/apron/overalls)),
		/obj/item/storage/plants,
		/obj/item/clothing/under/rank/hydroponics,
		/obj/item/device/scanner/plant,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/clothing/mask/bandana/botany,
		/obj/item/clothing/head/bandana/green,
		/obj/item/material/minihoe,
		/obj/item/material/hatchet,
		/obj/item/wirecutters/clippers,
		/obj/item/reagent_containers/spray/plantbgone,
	)
