/*
 * Torch Command
 */


/obj/structure/closet/secure_closet/CO
	name = "commanding officer's locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	will_contain = list(
		/obj/item/clothing/suit/storage/vest/solgov/command,
		/obj/item/weapon/cartridge/captain,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/radio/headset/heads/torchcaptain,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/accessory/holster/thigh,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/storage/box/ids,
		/obj/item/weapon/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/weapon/folder/blue,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/captain, /obj/item/weapon/storage/backpack/satchel_cap)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/captain, /obj/item/weapon/storage/backpack/messenger/com))
	)

/obj/structure/closet/secure_closet/XO
	name = "executive officer's locker"
	req_access = list(access_hop)
	icon_state = "twosolsecure1"
	icon_closed = "twosolsecure"
	icon_locked = "twosolsecure1"
	icon_opened = "twosolsecureopen"
	icon_broken = "twosolsecurebroken"
	icon_off = "twosolsecureoff"

	will_contain = list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/weapon/cartridge/hop,
		/obj/item/clothing/suit/storage/vest/solgov/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/radio/headset/heads/torchxo,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/accessory/holster/thigh,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/storage/box/headset,
		/obj/item/weapon/storage/box/headset/torchxo,
		/obj/item/weapon/storage/box/ids = 2,
		/obj/item/weapon/storage/box/PDAs,
		/obj/item/weapon/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/weapon/folder/blue,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/captain, /obj/item/weapon/storage/backpack/satchel_cap)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/captain, /obj/item/weapon/storage/backpack/messenger/com))
	)

/obj/structure/closet/secure_closet/sea
	name = "senior enlisted advisor's locker"
	req_access = list(access_senadv)
	icon_state = "sol1"
	icon_closed = "sol"
	icon_locked = "sol1"
	icon_opened = "solopen"
	icon_broken = "solbroken"
	icon_off = "soloff"

	will_contain = list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/weapon/cartridge/hop,
		/obj/item/clothing/suit/storage/vest/solgov/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/radio/headset/heads/torchxo,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/accessory/holster/thigh,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/weapon/folder/blue,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack, /obj/item/weapon/storage/backpack/satchel_norm)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag, /obj/item/weapon/storage/backpack/messenger))
	)
