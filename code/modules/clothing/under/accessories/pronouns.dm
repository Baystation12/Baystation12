/obj/item/clothing/accessory/pronouns
	name = "base pronouns badge"
	icon_state = "pronounpin"
	item_state = "pronouns"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_INSIGNIA
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY


/obj/item/clothing/accessory/pronouns/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/accessory/pronouns)


/obj/item/clothing/accessory/pronouns/they
	name = "they/them pronouns badge"
	desc = "A badge showing the wearer's pronouns: they, them and theirs."


/obj/item/clothing/accessory/pronouns/hehim
	name = "he/him pronouns badge"
	desc = "A badge showing the wearer's pronouns: he, him and his."


/obj/item/clothing/accessory/pronouns/sheher
	name = "she/her pronouns badge"
	desc = "A badge showing the wearer's pronouns: she, her and hers."


/obj/item/clothing/accessory/pronouns/hethey
	name = "he/they pronouns badge"
	desc = "A badge showing the wearer's pronouns: he, him and his or they, them and theirs."


/obj/item/clothing/accessory/pronouns/shethey
	name = "she/they pronouns badge"
	desc = "A badge showing the wearer's pronouns: she, her and hers or they, them and theirs."

/obj/item/clothing/accessory/pronouns/heshe
	name = "he/she pronouns badge"
	desc = "A badge showing the wearer's pronouns: he, him and his or she, her and hers."


/obj/item/clothing/accessory/pronouns/zehir
	name = "ze/hir pronouns badge"
	desc = "A badge showing the wearer's pronouns: ze, hir and hirs."


/obj/item/clothing/accessory/pronouns/ask
	name = "ask my pronouns badge"
	desc = "A badge asking others to ask for the wearer's pronouns."
