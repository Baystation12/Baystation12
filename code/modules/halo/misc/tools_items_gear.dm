
/obj/item/weapon/tank/oxygen/unsc
	icon_state = "unsc"

/obj/item/weapon/tank/emergency/oxygen/unsc
	icon_state = "unsc_em"

/obj/item/clothing/mask/gas/unsc
	icon_state = "unsc_gasmask"
	item_state = "unsc_gasmask"

/obj/item/weapon/storage/firstaid/erk
	name = "emergency response kit"
	desc = "A hull breach kit for UNSC first responders. It appears to be bulkier than general medical kits."
	icon_state = "emergency_response_kit"
	item_state = "firstaid-o2"
	max_w_class = ITEM_SIZE_NORMAL
	//max_storage_space = DEFAULT_LARGEBOX_STORAGE

	startswith = list(
		/obj/item/weapon/storage/pill_bottle/dexalin,
		/obj/item/weapon/tank/emergency/oxygen/unsc,
		/obj/item/clothing/mask/gas/unsc
		)

/obj/item/weapon/storage/firstaid/erk/eng
	startswith = list(
		/obj/item/weapon/crowbar,
		/obj/item/device/flashlight/unsc
		)


/obj/item/weapon/storage/firstaid/unsc
	name = "UNSC medkit"
	desc = "A general medical kit for UNSC personnel and installations."
	icon_state = "unsc_medkit"
	item_state = "firstaid-unsc"

	startswith = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/weapon/storage/pill_bottle/kelotane,
		/obj/item/weapon/storage/pill_bottle/inaprovaline,
		/obj/item/weapon/storage/pill_bottle/bicaridine,
		/obj/item/weapon/storage/pill_bottle/dexalin,
		/obj/item/device/healthanalyzer
		)

/obj/item/device/flashlight/unsc
	name = "UNSC flashlight"
	desc = "Standard issue flashlight for UNSC personnel and installations"
	icon = 'code/modules/halo/misc/halohumanmisc.dmi'
	icon_state = "flashlight"
	item_state = "flashlight-unsc"
