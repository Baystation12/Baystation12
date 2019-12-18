
/obj/item/weapon/storage/firstaid/erk
	name = "emergency response kit"
	desc = "A hull breach kit for UNSC first responders. It appears to be bulkier than general medical kits."
	icon = 'code/modules/halo/misc/halohumanmisc.dmi'
	icon_state = "erk"

	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 20

	startswith = list(
		/obj/item/weapon/crowbar,
		/obj/item/device/flashlight/unsc,
		/obj/item/weapon/storage/pill_bottle/dexalin,
		/obj/item/weapon/tank/emergency/oxygen/unsc,
		/obj/item/clothing/mask/gas/unsc,
		/obj/item/clothing/head/helmet/space/emergency,
		/obj/item/clothing/suit/space/emergency
		)

/obj/item/weapon/storage/firstaid/unsc
	name = "UNSC medkit"
	desc = "A general medical kit for UNSC personnel and installations."
	icon = 'code/modules/halo/misc/halohumanmisc.dmi'
	icon_state = "medkit"
	item_state = "medkit"

	startswith = list(
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/weapon/storage/pill_bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/syringe/biofoam,
		/obj/item/weapon/reagent_containers/syringe/biofoam,
		/obj/item/weapon/storage/pill_bottle/iron,
		/obj/item/weapon/storage/pill_bottle/tramadol,
		/obj/item/device/healthanalyzer
		)

/obj/item/weapon/storage/firstaid/combat/unsc
	name = "field trauma kit"
	desc = "Contains emergency medicine for use in the field"
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

	max_storage_space = 2 * DEFAULT_BOX_STORAGE

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat = 3,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/painkiller = 3,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/antibiotic = 2,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/necrosis,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/otomax,
		/obj/item/stack/medical/compression,
		/obj/item/stack/medical/splint,
		/obj/item/device/healthanalyzer
		)