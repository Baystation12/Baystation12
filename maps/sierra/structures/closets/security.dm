/*
 * Sierra Security
*/

/singleton/closet_appearance/secure_closet/sierra/security
	color = COLOR_GUNMETAL
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/singleton/closet_appearance/secure_closet/sierra/security/forensics
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"forensics" = COLOR_NT_RED
	)

/singleton/closet_appearance/secure_closet/sierra/security/warden
	color = COLOR_WALL_GUNMETAL
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/singleton/closet_appearance/secure_closet/sierra/security/hos
	color = COLOR_WALL_GUNMETAL
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_mid_full" = COLOR_GOLD,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_GOLD
	)




/obj/structure/closet/secure_closet/hos/sierra
	name = "head of security's cabinet"
	req_access = list(access_hos)
	icon_state = "hos"


/obj/structure/closet/secure_closet/hos/sierra/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/medium/nt,
		/obj/item/clothing/suit/storage/hoscoat,
		/obj/item/clothing/suit/armor/hos,
		/obj/item/clothing/head/helmet/nt,
		/obj/item/clothing/head/HoS/dermal,
		/obj/item/device/radio/headset/heads/hos,
		/obj/item/device/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/taperoll/police,
		/obj/item/handcuffs,
		/obj/item/storage/belt/holster/security,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun/secure,
		/obj/item/melee/telebaton,
		/obj/item/device/taperecorder,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/device/remote_device/head_of_security,
		/obj/item/device/hailer,
		/obj/item/device/holowarrant,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/maglight,
		/obj/item/crowbar/prybar,
		/obj/item/device/radio/off,
		/obj/item/clothing/mask/gas/half,
		/obj/item/storage/firstaid/combat
	)

/obj/structure/closet/secure_closet/warden/sierra
	name = "warden's locker"
	req_access = list(access_warden)
	icon_state = "warden"

/obj/structure/closet/secure_closet/warden/sierra/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/medium/nt,
		/obj/item/clothing/head/helmet/nt,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/clothing/head/beret/sec/navy/warden,
		/obj/item/clothing/under/rank/warden/corp/alt,
		/obj/item/clothing/under/rank/warden/navyblue,
		/obj/item/clothing/under/rank/warden/navyblue/alt,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/taperoll/police,
		/obj/item/storage/belt/holster/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun/secure,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/gun/energy/taser,
		/obj/item/handcuffs,
		/obj/item/device/hailer,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/hand_labeler,
		/obj/item/device/holowarrant,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/maglight,
		/obj/item/crowbar/prybar,
		/obj/item/device/radio/off,
		/obj/item/clothing/mask/gas/half,
		/obj/item/storage/firstaid/regular
	)

/obj/structure/closet/secure_closet/cabinet/forensics
	name = "forensics technician's locker"
	req_access = list(access_forensics_lockers)
	icon_state = "cabinet"


/obj/structure/closet/secure_closet/cabinet/forensics/WillContain()
	return list(
		/obj/item/clothing/gloves/forensic,
		/obj/item/clothing/head/helmet/nt,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/storage/belt/holster/forensic,
		/obj/item/storage/belt/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/clothing/suit/armor/pcarrier/medium/nt,
		/obj/item/gun/energy/gun/small/secure,
		/obj/item/device/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/taperoll/police,
		/obj/item/storage/box/evidence,
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/gloves,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/holowarrant,
		/obj/item/device/flashlight/maglight,
		/obj/item/crowbar/prybar,
		/obj/item/device/radio/off,
		/obj/item/clothing/mask/gas/half,
		/obj/item/storage/firstaid/regular
	)

/obj/structure/closet/secure_closet/security/sierra
	name = "security guard's locker"
	req_access = list(access_guard)
	icon_state = "sec"

/obj/structure/closet/secure_closet/security/sierra/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/medium/nt,
		/obj/item/clothing/head/helmet/nt,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/storage/belt/holster/security,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/grenade/chem_grenade/teargas,
		/obj/item/melee/baton/loaded,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/gun/energy/gun/secure,
		/obj/item/device/megaphone,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/holowarrant,
		/obj/item/device/flashlight/maglight,
		/obj/item/crowbar/prybar,
		/obj/item/device/radio/off,
		/obj/item/clothing/mask/gas/half,
		/obj/item/storage/firstaid/regular
	)

/obj/structure/closet/secure_closet/security/sierra/cadet
	name = "cadet's locker"
	req_access = list(access_security)
	icon_state = "sec"

/obj/structure/closet/secure_closet/security/sierra/cadet/WillContain()
	return list(
		/obj/item/device/flash,
		/obj/item/device/radio/off,
		/obj/item/device/flashlight/maglight,
		/obj/item/device/holowarrant,
		/obj/item/device/hailer,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/radio/headset/headset_sec/alt,
		/obj/item/taperoll/police,
		/obj/item/storage/belt/holster/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/crowbar/prybar,
		/obj/item/gun/energy/confuseray,
		/obj/item/clothing/glasses/hud/security
	)

/obj/structure/closet/secure_closet/brig/WillContain()
	return list(
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/shoes/orange,
		/obj/item/modular_computer/pda,
		/obj/item/device/radio/headset
	)

/obj/structure/closet/wardrobe/orange/New()
	..()
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
