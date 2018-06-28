/obj/structure/closet/crate/med_crate/trauma
	name = "\improper Trauma crate"
	desc = "A crate with trauma equipment."
	icon_state = "med_red"
	icon_opened = "med_redopen"
	icon_closed = "med_red"

/obj/structure/closet/crate/med_crate/trauma/WillContain()
	return list(
		/obj/item/stack/medical/splint = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 10,
		/obj/item/weapon/reagent_containers/pill/sugariron = 6,
		/obj/item/weapon/storage/pill_bottle/paracetamol = 2,
		/obj/item/weapon/storage/pill_bottle/inaprovaline
		)

/obj/structure/closet/crate/med_crate/burn
	name = "\improper Burn crate"
	desc = "A crate with burn equipment."
	icon_state = "med_orange"
	icon_opened = "med_orangeopen"
	icon_closed = "med_orange"

/obj/structure/closet/crate/med_crate/burn/WillContain()
	return list(
		/obj/item/weapon/defibrillator/loaded,
		/obj/item/stack/medical/advanced/ointment = 10,
		/obj/item/weapon/storage/pill_bottle/kelotane,
		/obj/item/weapon/storage/pill_bottle/tramadol = 2,
		/obj/item/weapon/storage/pill_bottle/spaceacillin
	)

/obj/structure/closet/crate/med_crate/oxyloss
	name = "\improper Low oxygen crate"
	desc = "A crate with low oxygen equipment."
	icon_state = "med_blue"
	icon_opened = "med_blueopen"
	icon_closed = "med_blue"

/obj/structure/closet/crate/med_crate/oxyloss/WillContain()
	return list(
		/obj/item/device/healthanalyzer = 2,
		/obj/item/weapon/storage/pill_bottle/dexalin = 2,
		/obj/item/weapon/storage/pill_bottle/inaprovaline
	)
/obj/structure/closet/crate/med_crate/toxin
	name = "\improper Toxin crate"
	desc = "A crate with toxin equipment."
	icon_state = "med_green"
	icon_opened = "med_greenopen"
	icon_closed = "med_green"

/obj/structure/closet/crate/med_crate/toxin/WillContain()
	return list(
		/obj/item/weapon/storage/firstaid/surgery,
		/obj/item/weapon/storage/pill_bottle/dylovene = 2,
		/obj/item/weapon/reagent_containers/pill/hyronalin = 12
			)
