/***********
* Implants *
***********/
/datum/uplink_item/item/implants
	category = /datum/uplink_category/implants

/datum/uplink_item/item/implants/imp_freedom
	name = "Freedom Implant"
	item_cost = 24
	path = /obj/item/weapon/storage/box/syndie_kit/imp_freedom

/datum/uplink_item/item/implants/imp_compress
	name = "Compressed Matter Implant"
	item_cost = 32
	path = /obj/item/weapon/storage/box/syndie_kit/imp_compress

/datum/uplink_item/item/implants/imp_explosive
	name = "Explosive Implant (DANGER!)"
	item_cost = 40
	path = /obj/item/weapon/storage/box/syndie_kit/imp_explosive

/datum/uplink_item/item/implants/imp_uplink
	name = "Uplink Implant"
	path = /obj/item/weapon/storage/box/syndie_kit/imp_uplink

/datum/uplink_item/item/implants/imp_uplink/New()
	..()
	item_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)
	desc = "Contains [round((DEFAULT_TELECRYSTAL_AMOUNT / 2) * 0.8)] Telecrystal\s"

/datum/uplink_item/item/implants/imp_imprinting
	name = "Neural Imprinting Implant"
	desc = "Use on someone who is under influence of Mindbreaker to give them laws-like set of instructions. Kit comes with a dose of mindbreaker."
	item_cost = 20
	path = /obj/item/weapon/storage/box/syndie_kit/imp_imprinting