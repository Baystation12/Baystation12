/*
 * Torch Engineering
 */

/decl/closet_appearance/secure_closet/torch/engineering
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_WARM_YELLOW,
		"exped" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/torch/engineering/atmos
	extra_decals = list(
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_mid_full" = COLOR_CYAN_BLUE,
		"atmos_upper" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/torch/engineering/se
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"exped" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/torch/engineering/ce
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"exped" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/engineering_chief_torch
	name = "chief engineer's locker"
	req_access = list(access_ce)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/engineering/ce

/obj/structure/closet/secure_closet/engineering_chief_torch/WillContain()
	return list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/blueprints,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/insulated,
		/obj/item/clothing/gloves/thick/duty/solgov/eng,
		/obj/item/device/radio/headset/heads/ce,
		/obj/item/device/radio/headset/heads/ce/alt,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/weapon/storage/belt/general,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/device/multitool,
		/obj/item/device/flash,
		/obj/item/weapon/gun/energy/confuseray,
		/obj/item/taperoll/engineering,
		/obj/item/device/megaphone,
		/obj/item/weapon/crowbar/brace_jack,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/weapon/material/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/weapon/storage/box/armband/engine,
		/obj/item/weapon/storage/box/secret_project_disks,
		/obj/item/weapon/material/knife/folding/swiss/officer,
		/obj/item/clothing/head/hardhat/damage_control/White,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel/eng)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/eng, /obj/item/weapon/storage/backpack/messenger/engi))
	)

/obj/structure/closet/secure_closet/engineering_torch
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/engineering

/obj/structure/closet/secure_closet/engineering_torch/WillContain()
	return list(
		/obj/item/clothing/under/hazard,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/device/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/taperoll/engineering,
		/obj/item/device/flashlight,
		/obj/item/taperoll/atmos,
		/obj/item/clothing/gloves/insulated,
		/obj/item/clothing/gloves/thick/duty/solgov/eng,
		/obj/item/weapon/material/knife/folding/swiss/engineer,
		/obj/item/clothing/head/hardhat/damage_control,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel/eng)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/eng, /obj/item/weapon/storage/backpack/messenger/engi))
	)

/obj/structure/closet/secure_closet/engineering_senior
	name = "senior engineer's locker"
	req_access = list(access_seneng)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/engineering/se

/obj/structure/closet/secure_closet/engineering_senior/WillContain()
	return list(
		/obj/item/clothing/under/hazard,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/device/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/clothing/glasses/meson,
		/obj/item/taperoll/engineering,
		/obj/item/taperoll/atmos,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/device/flash,
		/obj/item/device/flashlight,
		/obj/item/device/megaphone,
		/obj/item/clothing/gloves/insulated,
		/obj/item/clothing/gloves/thick/duty/solgov/eng,
		/obj/item/weapon/material/knife/folding/swiss/engineer,
		/obj/item/clothing/head/hardhat/damage_control/Yellow,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel/eng)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/eng, /obj/item/weapon/storage/backpack/messenger/engi))
	)

/obj/structure/closet/secure_closet/atmos_torch
	name = "atmospherics equipment locker"
	req_access = list(access_atmospherics)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/engineering/atmos

/obj/structure/closet/secure_closet/atmos_torch/WillContain()
	return list(
		/obj/item/clothing/under/hazard,
		/obj/item/weapon/storage/backpack/dufflebag/firefighter,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/device/flashlight,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/device/radio/headset/headset_eng/alt,
		/obj/item/weapon/tank/emergency/oxygen/double,
		/obj/item/clothing/mask/gas,
		/obj/item/taperoll/atmos,
		/obj/item/device/scanner/gas
	)
