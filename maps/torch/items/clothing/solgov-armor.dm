/obj/item/clothing/suit/storage/vest/solgov
	name = "\improper Sol Central Government heavy armored vest"
	desc = "A synthetic armor vest with PEACEKEEPER printed in distinctive blue lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "solwebvest"
	icon = 'maps/torch/icons/obj/solgov-suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/solgov-suit.dmi')

/obj/item/clothing/suit/storage/vest/solgov/security
	name = "master at arms heavy armored vest"
	desc = "A synthetic armor vest with MASTER AT ARMS printed in silver lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "secwebvest"

/obj/item/clothing/suit/storage/vest/solgov/command
	name = "command heavy armored vest"
	desc = "A synthetic armor vest with SOL CENTRAL GOVERNMENT printed in gold lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "comwebvest"

/obj/item/clothing/suit/armor/pcarrier/blue/sol
	name = "peacekeeper plate carrier"
	desc = "A lightweight plate carrier vest in SCG Peacekeeper colors. It can be equipped with armor plates, but provides no protection of its own."
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches/blue, /obj/item/clothing/accessory/armguards/blue, /obj/item/clothing/accessory/armor/tag/solgov)

/obj/item/clothing/suit/armor/pcarrier/light/sol
	starting_accessories = list(/obj/item/clothing/accessory/armorplate, /obj/item/clothing/accessory/armor/tag/solgov)

/obj/item/clothing/suit/armor/pcarrier/medium/sol
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/solgov)

/obj/item/clothing/suit/armor/pcarrier/medium/security
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/solgov/sec)

/obj/item/clothing/suit/armor/pcarrier/medium/command
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/solgov/com)
