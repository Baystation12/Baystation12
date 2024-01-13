/obj/item/storage/wallet/Initialize()
	. = ..()
	contents_allowed |= list(
		/obj/item/clothing/accessory/iccgn_badge,
		/obj/item/clothing/accessory/iccgn_patch,
		/obj/item/clothing/accessory/iccgn_rank
	)
