/obj/structure/closet/malf/suits
	desc = "It's a storage unit for operational gear."
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/malf/suits/WillContain()
	return list(
		/obj/item/weapon/tank/jetpack/void,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/cell,
		/obj/item/device/multitool)
