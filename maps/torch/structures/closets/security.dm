/*
 * Torch Security
 */

/singleton/closet_appearance/secure_closet/torch/security
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/singleton/closet_appearance/secure_closet/torch/security/forensics
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"forensics" = COLOR_NT_RED
	)

/singleton/closet_appearance/secure_closet/torch/security/warden
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/singleton/closet_appearance/secure_closet/torch/security/hos
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/security_torch
	name = "psidi knight's locker"
	req_access = list(access_brig)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/security

/obj/structure/closet/secure_closet/security_torch/WillContain()
	return list(
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/storage/belt/holster/security/full,
		/obj/item/grenade/chem_grenade/teargas,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/device/megaphone,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/belt/security,
		/obj/item/material/knife/folding/swiss/sec,
		/obj/item/storage/backpack/dufflebag/sec,
		/obj/item/clothing/suit/cultrobes,
		/obj/item/clothing/head/culthood,
		/obj/item/reagent_containers/chem_disp_cartridge/hyperzine,
		/obj/item/storage/box/beakers,
		/obj/item/melee/energy/sword = 2,
		/obj/item/melee/energy/sword/pirate = 2,
		/obj/item/material/twohanded/spear = 2,
		/obj/item/storage/firstaid/sleekstab = 2,
		/datum/gear/suit/security_poncho
	)


/obj/structure/closet/secure_closet/cos
	name = "psidi general's locker"
	req_access = list(access_hos)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/security/hos

/obj/structure/closet/secure_closet/cos/WillContain()
	return list(
		/obj/item/device/radio/headset/heads/cos,
		/obj/item/device/radio/headset/heads/cos/alt,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/taperoll/police,
		/obj/item/handcuffs,
		/obj/item/storage/belt/holster/security/full,
		/obj/item/storage/belt/security,
		/obj/item/device/megaphone,
		/obj/item/device/hailer,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/maglight,
		/obj/item/material/knife/folding/swiss/officer,
		/obj/item/device/personal_shield,
		/obj/item/storage/backpack/dufflebag/sec,
		/obj/item/melee/energy/sword/double,
		/obj/item/reagent_containers/chem_disp_cartridge/hyperzine,
		/obj/item/storage/box/beakers,
		/obj/item/clothing/head/culthood/magus,
		/obj/item/clothing/suit/cultrobes/magusred,
		/obj/item/storage/firstaid/sleekstab = 2,
		/datum/gear/suit/security_poncho
	)

/obj/structure/closet/secure_closet/brigchief
	name = "psidi master's locker"
	req_access = list(access_armory)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/security/warden

/obj/structure/closet/secure_closet/brigchief/WillContain()
	return list(
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/storage/belt/holster/security/full,
		/obj/item/storage/belt/security,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/handcuffs,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/device/flashlight/maglight,
		/obj/item/material/knife/folding/swiss/sec,
		/obj/item/storage/backpack/dufflebag/sec,
		/obj/item/gun/energy/pulse_rifle/pistol,
		/obj/item/storage/firstaid/sleekstab = 2,
		/obj/item/reagent_containers/chem_disp_cartridge/hyperzine,
		/obj/item/storage/box/beakers,
		/obj/item/melee/energy/sword = 2,
		/obj/item/melee/energy/sword/pirate = 2,
		/obj/item/material/twohanded/spear = 2,
		/datum/gear/suit/security_poncho
	)

/obj/structure/closet/secure_closet/forensics
	name = "psidi sentinel's locker"
	req_access = list(access_forensics_lockers)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/security/forensics

/obj/structure/closet/secure_closet/forensics/WillContain()
	return list(
		/obj/item/clothing/gloves/forensic,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/glasses/hud/security/prot,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/device/holowarrant,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/belt/holster/forensic,
		/obj/item/storage/belt/holster/security,
		/obj/item/storage/belt/security,
		/obj/item/clothing/gloves/thick,
		/obj/item/material/knife/folding/swiss/sec,
		/obj/item/storage/backpack/dufflebag/sec,
		/obj/item/gun/energy/gun/skrell = 2,
		/obj/item/storage/firstaid/sleekstab = 2,
		/obj/item/reagent_containers/chem_disp_cartridge/hyperzine,
		/obj/item/storage/box/beakers,
		/obj/item/melee/energy/sword = 2,
		/obj/item/melee/energy/sword/pirate = 2,
		/datum/gear/suit/security_poncho
	)

/obj/structure/closet/bombclosetsecurity/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit/security,
		/obj/item/clothing/head/bomb_hood/security
	)
