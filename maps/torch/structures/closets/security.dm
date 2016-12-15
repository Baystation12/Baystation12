/*
 * Torch Security
 */

/obj/structure/closet/secure_closet/security_torch
	name = "master at arms' locker"
	req_access = list(access_brig)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	will_contain = list(
		/obj/item/clothing/suit/storage/vest/solgov/security,
		/obj/item/clothing/head/helmet/solgov/security,
		/obj/item/weapon/cartridge/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/weapon/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/grenade/chem_grenade/teargas,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/clothing/glasses/sunglasses/sechud/goggles,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/device/megaphone,
		/obj/item/clothing/accessory/holster/thigh
	)

/obj/structure/closet/secure_closet/security_torch/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_sec(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag/sec(src)
