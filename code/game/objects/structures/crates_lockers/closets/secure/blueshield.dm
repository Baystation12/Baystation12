/obj/structure/closet/secure_closet/blueshield
	name = "Blueshield Agent's Locker"
	req_access = list(access_blueshield)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		..()
		sleep(2)

		new /obj/item/weapon/storage/backpack/satchel_sec(src)
		new /obj/item/clothing/suit/armor/vest/fluff/deus_blueshield(src)
//		new /obj/item/weapon/cartridge/security(src)
		new /obj/item/device/radio/headset/blueshield(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/reagent_containers/spray/pepper(src)
		new /obj/item/weapon/grenade/flashbang(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/mask/balaclava/tactical(src)
		return