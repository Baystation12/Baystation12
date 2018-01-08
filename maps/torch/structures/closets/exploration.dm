/*
 * Torch Exploration
 */


/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder's locker"
	req_access = list(access_pathfinder)
	icon_state = "pathsecure1"
	icon_closed = "pathsecure"
	icon_locked = "pathsecure1"
	icon_opened = "pathsecureopen"
	icon_off = "pathsecureoff"

/obj/structure/closet/secure_closet/pathfinder/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/weapon/pen,
		/obj/item/device/tape/random,
		/obj/item/device/gps,
		/obj/item/device/beacon_locator,
		/obj/item/device/radio/beacon,
		/obj/item/clothing/glasses/science,
		/obj/item/taperoll/research,
		/obj/item/weapon/material/hatchet/machete/deluxe,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/weapon/storage/plants,
		/obj/item/device/spaceflare,
		/obj/item/clothing/gloves/thick/botany,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/taperecorder,
		/obj/item/device/analyzer,
		/obj/item/device/slime_scanner,
		/obj/item/device/flash,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder/blue,
		/obj/item/device/radio/headset/pathfinder,
		/obj/item/weapon/storage/box/encryptionkey/exploration,
		/obj/item/device/binoculars,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack, /obj/item/weapon/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag, /obj/item/weapon/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/glowstick/random))
	)

/obj/structure/closet/secure_closet/explorer
	name = "explorer's locker"
	req_access = list(access_explorer)
	icon_state = "exp1"
	icon_closed = "exp"
	icon_locked = "exp1"
	icon_opened = "expopen"
	icon_off = "expoff"

/obj/structure/closet/secure_closet/explorer/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/weapon/pen,
		/obj/item/device/gps,
		/obj/item/device/beacon_locator,
		/obj/item/device/radio/beacon,
		/obj/item/clothing/glasses/science,
		/obj/item/taperoll/research,
		/obj/item/weapon/material/hatchet/machete,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/device/spaceflare,
		/obj/item/clothing/gloves/thick/botany,
		/obj/item/weapon/storage/plants,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/analyzer,
		/obj/item/device/slime_scanner,
		/obj/item/device/radio/headset/exploration,
		/obj/item/device/binoculars,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack, /obj/item/weapon/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag, /obj/item/weapon/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/glowstick/random))
	)
