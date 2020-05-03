/*
 * Site 51 Security
 */
/decl/closet_appearance/secure_closet/security/weapons/empty
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BLUE_GRAY,
		"gun" = COLOR_BLUE_GRAY
	)

/obj/structure/closet/secure_closet/security/weapons/empty
	name = "weapons locker"
//	req_access = list(TBA)
	closet_appearance = /decl/closet_appearance/secure_closet/security/weapons/empty

/obj/structure/closet/secure_closet/security/weapons/empty/WillContain()
	return list()

/obj/structure/closet/secure_closet/security/maa/armoryofficer
	name = "armory officer's locker"
//	req_access = list(TBA)
//	closet_appearance = /decl/closet_appearance/secure_closet/security/weapons/empty

/obj/structure/closet/secure_closet/security/maa/armoryofficer/WillContain()
	return list()

/obj/structure/closet/secure_closet/security/maa
	name = "master at arms' locker"
//	req_access = list(TBA)
//	closet_appearance = /decl/closet_appearance/secure_closet/security/weapons/empty

/obj/structure/closet/secure_closet/security/maa/WillContain()
	return list()