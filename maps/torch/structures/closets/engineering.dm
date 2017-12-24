/*
 * Torch Engineering
 */

/obj/structure/closet/secure_closet/engineering_chief_torch
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"

/obj/structure/closet/secure_closet/engineering_chief_torch/WillContain()
	return list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/blueprints,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/insulated,
		/obj/item/weapon/cartridge/ce,
		/obj/item/device/radio/headset/heads/ce,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/device/multitool,
		/obj/item/device/flash,
		/obj/item/taperoll/engineering,
		/obj/item/device/megaphone,
		/obj/item/weapon/crowbar/brace_jack,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/weapon/gun/projectile/colt/officer,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/clothing/accessory/holster/thigh,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/weapon/clipboard,
		/obj/item/device/flashlight,
		/obj/item/device/holowarrant,
		/obj/item/weapon/folder/yellow,
		/obj/item/weapon/storage/box/armband/engine,
		/obj/item/weapon/storage/box/secret_project_disks,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel_eng)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/eng, /obj/item/weapon/storage/backpack/messenger/engi))
	)

/obj/structure/closet/secure_closet/engineering_torch
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

/obj/structure/closet/secure_closet/engineering_torch/WillContain()
	return list(
		/obj/item/clothing/under/hazard,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/weapon/cartridge/engineering,
		/obj/item/taperoll/engineering,
		/obj/item/weapon/cartridge/atmos,
		/obj/item/device/flashlight,
		/obj/item/taperoll/atmos,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel_eng)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/eng, /obj/item/weapon/storage/backpack/messenger/engi))
	)

/obj/structure/closet/secure_closet/engineering_contractor
	name = "engineering contractor's locker"
	req_access = list(access_engine)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

/obj/structure/closet/secure_closet/engineering_contractor/WillContain()
	return list(
		/obj/item/clothing/under/rank/engineer,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas/half,
		/obj/item/weapon/cartridge/engineering,
		/obj/item/device/flashlight,
		/obj/item/taperoll/engineering,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel_eng)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/eng, /obj/item/weapon/storage/backpack/messenger/engi))
	)

/obj/structure/closet/secure_closet/engineering_senior
	name = "senior engineer's locker"
	req_access = list(access_seneng)
	icon_state = "secureseneng1"
	icon_closed = "secureseneng"
	icon_locked = "secureseneng1"
	icon_opened = "securesenengopen"
	icon_broken = "securesenengbroken"
	icon_off = "securesenengoff"

/obj/structure/closet/secure_closet/engineering_senior/WillContain()
	return list(
		/obj/item/clothing/under/hazard,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/clothing/glasses/meson,
		/obj/item/weapon/cartridge/engineering,
		/obj/item/taperoll/engineering,
		/obj/item/weapon/cartridge/atmos,
		/obj/item/taperoll/atmos,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/device/flash,
		/obj/item/weapon/cartridge/ce,
		/obj/item/device/flashlight,
		/obj/item/device/megaphone,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel_eng)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/eng, /obj/item/weapon/storage/backpack/messenger/engi))
	)

/obj/structure/closet/secure_closet/atmos_torch
	name = "atmospherics equipment locker"
	req_access = list(access_atmospherics)
	icon_state = "secureatm1"
	icon_closed = "secureatm"
	icon_locked = "secureatm1"
	icon_opened = "secureatmopen"
	icon_broken = "secureatmbroken"
	icon_off = "secureatmoff"

/obj/structure/closet/secure_closet/atmos_torch/WillContain()
	return list(
		/obj/item/clothing/under/hazard,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/device/flashlight,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/weapon/extinguisher,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/weapon/tank/emergency/oxygen/double,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/cartridge/atmos,
		/obj/item/taperoll/atmos,
		/obj/item/device/analyzer
	)
