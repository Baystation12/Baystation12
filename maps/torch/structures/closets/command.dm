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
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/CO/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/radio/headset/heads/torchcaptain,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/weapon/gun/energy/revolver/secure,
		/obj/item/device/radio/headset/heads/torchcaptain/alt,
		/obj/item/weapon/storage/belt/holster/general,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/storage/box/ids,
		/obj/item/weapon/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/weapon/folder/blue,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/captain, /obj/item/weapon/storage/backpack/satchel/cap)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/captain, /obj/item/weapon/storage/backpack/messenger/com))
	)

/obj/structure/closet/secure_closet/XO
	name = "executive officer's locker"
	req_access = list(access_hop)
	icon_state = "twosolsecure1"
	icon_closed = "twosolsecure"
	icon_locked = "twosolsecure1"
	icon_opened = "twosolsecureopen"
	icon_off = "twosolsecureoff"

/obj/structure/closet/secure_closet/XO/WillContain()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/radio/headset/heads/torchxo,
		/obj/item/weapon/storage/belt/holster/general,
		/obj/item/weapon/gun/energy/revolver/secure,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/storage/box/headset,
		/obj/item/device/radio/headset/heads/torchxo/alt,
		/obj/item/weapon/storage/box/radiokeys,
		/obj/item/weapon/storage/box/large/ids,
		/obj/item/weapon/storage/box/PDAs,
		/obj/item/weapon/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/weapon/folder/blue,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/captain, /obj/item/weapon/storage/backpack/satchel/cap)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/captain, /obj/item/weapon/storage/backpack/messenger/com)),
		/obj/item/weapon/storage/box/imprinting
	)

/obj/structure/closet/secure_closet/sea
	name = "senior enlisted advisor's locker"
	req_access = list(access_senadv)
	icon_state = "sol1"
	icon_closed = "sol"
	icon_locked = "sol1"
	icon_opened = "solopen"
	icon_off = "soloff"

/obj/structure/closet/secure_closet/sea/WillContain()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/radio/headset/heads/torchxo,
		/obj/item/device/radio/headset/heads/torchxo/alt,
		/obj/item/weapon/gun/energy/gun/secure,
		/obj/item/weapon/storage/belt/holster/general,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/weapon/folder/blue,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack, /obj/item/weapon/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag, /obj/item/weapon/storage/backpack/messenger))
	)

/obj/structure/closet/secure_closet/bridgeofficer
	name = "bridge officer's locker"
	req_access = list(access_bridge)
	icon_state = "sol1"
	icon_closed = "sol"
	icon_locked = "sol1"
	icon_opened = "solopen"
	icon_off = "soloff"

/obj/structure/closet/secure_closet/bridgeofficer/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/weapon/pen,
		/obj/item/device/tape/random,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/taperecorder,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder/blue,
		/obj/item/modular_computer/tablet/lease/preset/command,
		/obj/item/device/radio/headset/bridgeofficer,
		/obj/item/device/radio/headset/bridgeofficer/alt,
		/obj/item/weapon/storage/belt/general,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack, /obj/item/weapon/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag, /obj/item/weapon/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)
