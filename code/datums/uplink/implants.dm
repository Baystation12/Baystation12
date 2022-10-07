/***********
* Implants *
***********/
/datum/uplink_item/item/implants
	category = /datum/uplink_category/implants

/datum/uplink_item/item/implants/imp_freedom
	name = "Freedom Implant"
	desc = "An implant with an emotive trigger that can break you free of restraints. Show Security who has the real upperhand!"
	item_cost = 20
	path = /obj/item/storage/box/syndie_kit/imp_freedom

/datum/uplink_item/item/implants/imp_compress
	name = "Compressed Matter Implant"
	desc = "An implant with an emotive trigger used to hide a handheld item in your body. \
	Activating it materializes the item in your hand."
	item_cost = 30
	path = /obj/item/storage/box/syndie_kit/imp_compress

/datum/uplink_item/item/implants/imp_explosive
	name = "Explosive Implant (DANGER!)"
	desc = "An explosive impant activated with a vocal trigger or radio signal. \
	Use the included pad to adjust the settings before implanting."
	item_cost = 38
	path = /obj/item/storage/box/syndie_kit/imp_explosive

/datum/uplink_item/item/implants/imp_uplink
	name = "Uplink Implant"
	path = /obj/item/storage/box/syndie_kit/imp_uplink

/datum/uplink_item/item/implants/imp_uplink/New()
	..()
	item_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)
	desc = "This implant holds an uplink containing [IMPLANT_TELECRYSTAL_AMOUNT(DEFAULT_TELECRYSTAL_AMOUNT)] telecrystals, \
	activatable with an emotive trigger. You will have access to it, as long as it is still inside of you."

/datum/uplink_item/item/implants/imp_imprinting
	name = "Neural Imprinting Implant"
	desc = "An implant able to be used on someone who is under the influence of Mindbreaker Toxin to give them a \
	set of law-like instructions to follow. This kit contains a dose of Mindbreaker Toxin."
	item_cost = 20
	path = /obj/item/storage/box/syndie_kit/imp_imprinting
	antag_roles = list(MODE_TRAITOR)
