/decl/closet_appearance/secure_closet/torch/sol
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"stripe_vertical_mid_full" =  COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/sol/rep
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_OFF_WHITE,
		"stripe_vertical_right_full" =  COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/corporate
	color = COLOR_BOTTLE_GREEN
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_OFF_WHITE
	)

//equipment closets that everyone on the crew or in research can access, for storing things securely

/obj/structure/closet/secure_closet/crew
	name = "crew equipment locker"
	req_access = list(access_solgov_crew)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/sol

/obj/structure/closet/secure_closet/crew/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/crowbar,
		/obj/item/device/flashlight,
		/obj/item/storage/box
	)

/obj/structure/closet/secure_closet/crew/research
	name = "research equipment locker"
	req_access = list(access_nanotrasen)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/corporate


/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "sidearm cabinet"
	req_access = list(list(access_armory,access_emergency_armory,access_hos,access_hop,access_ce,access_cmo,access_rd,access_senadv))

/obj/structure/closet/secure_closet/guncabinet/sidearm/WillContain()
	return list(
			/obj/item/clothing/accessory/storage/holster/thigh = 2,
			/obj/item/gun/energy/gun/secure = 3,
	)

/obj/structure/closet/secure_closet/guncabinet/sidearm/small
	name = "personal sidearm cabinet"

/obj/structure/closet/secure_closet/guncabinet/sidearm/small/WillContain()
	return list(/obj/item/gun/energy/gun/small/secure = 4)

/obj/structure/closet/secure_closet/guncabinet/sidearm/combined
	name = "combined sidearm cabinet"

/obj/structure/closet/secure_closet/guncabinet/sidearm/combined/WillContain()
	return list(
		/obj/item/storage/belt/holster/general = 3,
		/obj/item/gun/energy/gun/secure = 3,
		/obj/item/gun/energy/gun/small/secure = 1,
	)

/obj/structure/closet/secure_closet/guncabinet/PPE
	name = "Bridge PPE cabinet"
	req_access = list(list(access_armory,access_emergency_armory,access_hos,access_hop,access_ce,access_cmo,access_rd,access_senadv))

/obj/structure/closet/secure_closet/guncabinet/PPE/WillContain()
	return list(
		/obj/item/gun/energy/gun/small/secure = 3,
		/obj/item/clothing/suit/armor/pcarrier/medium/command = 3,
		/obj/item/clothing/head/helmet/solgov/command = 3
	)
