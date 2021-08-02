/obj/item/storage/wallet/Initialize()
	. = ..()
	can_hold |= list(
		/obj/item/clothing/accessory/iccgn_badge,
		/obj/item/clothing/accessory/iccgn_patch,
		/obj/item/clothing/accessory/iccgn_rank
	)
