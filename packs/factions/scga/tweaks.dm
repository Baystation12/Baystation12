/obj/item/storage/wallet/Initialize()
	. = ..()
	contents_allowed |= list(
		/obj/item/clothing/accessory/scga_badge,
		/obj/item/clothing/accessory/scga_rank
	)
