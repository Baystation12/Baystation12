/obj/item/storage/wallet/Initialize()
	. = ..()
	can_hold |= list(
		/obj/item/clothing/accessory/scga_badge,
		/obj/item/clothing/accessory/scga_rank
	)
