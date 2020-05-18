
/obj/item/weapon/storage/firstaid/fire/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purplefireaid"

/obj/item/weapon/storage/firstaid/fire/covenant/New()
	. = ..()
	icon_state = "purplefireaid"

/obj/item/weapon/storage/firstaid/toxin/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletoxaid"

/obj/item/weapon/storage/firstaid/toxin/covenant/New()
	. = ..()
	icon_state = "purpletoxaid"

/obj/item/weapon/storage/firstaid/toxin/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletoxaid"

/obj/item/weapon/storage/firstaid/regular/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purplefirstaid"

/obj/item/weapon/storage/firstaid/o2/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpleo2aid"

/obj/item/weapon/storage/firstaid/combat/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletraumakit"
	startswith = list(
		/obj/item/weapon/storage/pill_bottle/bicaridine,
		/obj/item/weapon/storage/pill_bottle/dermaline,
		/obj/item/weapon/storage/pill_bottle/dexalin_plus,
		/obj/item/weapon/storage/pill_bottle/dylovene,
		/obj/item/weapon/storage/pill_bottle/tramadol,
		/obj/item/weapon/storage/pill_bottle/spaceacillin,
		/obj/item/stack/medical/splint/covenant,
		)

/obj/item/weapon/storage/firstaid/surgery/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "purpletraumakit2"
	startswith = list(
		/obj/item/weapon/bonesetter/covenant,
		/obj/item/weapon/cautery/covenant,
		/obj/item/weapon/circular_saw/covenant,
		/obj/item/weapon/hemostat/covenant,
		/obj/item/weapon/retractor/covenant,
		/obj/item/weapon/scalpel/covenant,
		/obj/item/weapon/surgicaldrill/covenant,
		/obj/item/weapon/bonegel,
		/obj/item/weapon/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		)
