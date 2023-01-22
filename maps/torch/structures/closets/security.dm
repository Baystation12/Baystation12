/*
 * Torch Security
 */

/decl/closet_appearance/secure_closet/torch/security
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/torch/security/forensics
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"forensics" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/torch/security/warden
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/torch/security/hos
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/security_torch
	name = "master at arms' locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/security

/obj/structure/closet/secure_closet/security_torch/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/medium/security,
		/obj/item/clothing/head/helmet/solgov/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/storage/belt/holster/security/full,
		/obj/item/grenade/chem_grenade/teargas,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/taperoll/police,
		//rubay code,
		/obj/item/storage/firstaid/individual/military,
		/obj/item/cell/guncell/medium,
		/obj/item/cell/guncell/medium,
		//rubay code end,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/device/megaphone,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/belt/security,
		/obj/item/material/knife/folding/swiss/sec,
		/obj/item/storage/backpack/dufflebag/sec,
		/obj/item/gun/energy/gun/small/secure
	)


/obj/structure/closet/secure_closet/cos
	name = "chief of security's locker"
	req_access = list(access_hos)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/security/hos

/obj/structure/closet/secure_closet/cos/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/medium/command/security,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/device/radio/headset/heads/cos,
		/obj/item/device/radio/headset/heads/cos/alt,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/taperoll/police,
		//rubay code,
		/obj/item/storage/firstaid/individual/military,
		//rubay code end,
		/obj/item/handcuffs,
		/obj/item/storage/belt/holster/security/full,
		/obj/item/storage/belt/security,
		/obj/item/device/megaphone,
		/obj/item/gun/energy/gun/secure/preauthorized,
		/obj/item/melee/telebaton,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/device/hailer,
		//proxima code start,
		/obj/item/device/remote_device/head_of_security,
		//proxima code end,
		/obj/item/material/clipboard,
		/obj/item/folder/red,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/taperecorder,
		/obj/item/material/knife/folding/swiss/officer,
		/obj/item/device/personal_shield,
		/obj/item/storage/backpack/dufflebag/sec
	)

/obj/structure/closet/secure_closet/brigchief
	name = "brig chief's locker"
	req_access = list(access_armory)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/security/warden

/obj/structure/closet/secure_closet/brigchief/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/medium/security,
		/obj/item/clothing/head/helmet/solgov/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/taperoll/police,
		//rubay code,
		/obj/item/storage/firstaid/individual/military,
		//rubay code end,
		/obj/item/storage/belt/holster/security,
		/obj/item/storage/belt/security,
		/obj/item/gun/energy/gun/secure/preauthorized,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/handcuffs,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/hand_labeler,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/maglight,
		/obj/item/material/knife/folding/swiss/sec,
		/obj/item/storage/backpack/dufflebag/sec
	)

/obj/structure/closet/secure_closet/forensics
	name = "forensics technician's locker"
	req_access = list(access_forensics_lockers)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/security/forensics

/obj/structure/closet/secure_closet/forensics/WillContain()
	return list(
		/obj/item/clothing/gloves/forensic,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/clothing/head/helmet/solgov/security,
		/obj/item/clothing/suit/armor/pcarrier/medium/security,
		/obj/item/gun/energy/gun/small/secure,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/taperoll/police,
		//rubay code,
		/obj/item/storage/firstaid/individual/military,
		//rubay code end,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/device/tape/random = 3,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/device/holowarrant,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/belt/holster/forensic,
		/obj/item/storage/belt/forensic,
		/obj/item/storage/belt/holster/security,
		/obj/item/storage/belt/security,
		/obj/item/clothing/gloves/thick,
		/obj/item/material/knife/folding/swiss/sec,
		/obj/item/storage/backpack/dufflebag/sec
	)

/obj/structure/closet/bombclosetsecurity/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit/security,
		/obj/item/clothing/head/bomb_hood/security
	)
