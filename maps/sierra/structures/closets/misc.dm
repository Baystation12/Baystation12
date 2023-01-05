/*
 * Sierra Misc
 */

/singleton/closet_appearance/secure_closet/sierra/crew
	color = COLOR_GUNMETAL
	extra_decals = list(
		"stripe_vertical_mid_full" =  COLOR_OFF_WHITE
	)

/singleton/closet_appearance/secure_closet/sierra/corporate
	color = COLOR_GUNMETAL
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_OFF_WHITE
	)

/singleton/closet_appearance/secure_closet/sierra/corporate/iaa
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_OFF_WHITE,
		"stripe_vertical_right_full" = COLOR_OFF_WHITE,
		"command" = COLOR_OFF_WHITE
	)

/singleton/closet_appearance/crate/present
	color = COLOR_RED_GRAY
	extra_decals = list(
		"crate_bracing" = COLOR_RED_GRAY,
		"lid_stripes" = COLOR_GREEN_GRAY,
		"crate_stripe_left" = COLOR_GREEN_GRAY,
		"crate_stripe_right" = COLOR_GREEN_GRAY
	)


/obj/structure/closet/secure_closet/iaa
	name = "\improper Internal Affairs Agent's locker"
	req_access = list(access_iaa)
	icon_state = "iaa"

/obj/structure/closet/secure_closet/iaa/WillContain()
	return list(
		/obj/item/device/flash,
		/obj/item/hand_labeler,
		/obj/item/device/camera,
		/obj/item/device/camera_film = 2,
		/obj/item/material/clipboard,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/gun/energy/gun/small/secure,
		/obj/item/storage/secure/briefcase,
		/obj/item/clothing/shoes/laceup,
		/obj/item/storage/belt/holster/general,
		/obj/item/clothing/under/rank/internalaffairs,
		/obj/item/clothing/suit/storage/toggle/suit/black,
		/obj/item/clothing/glasses/sunglasses/big,
		/obj/item/clothing/suit/armor/pcarrier/light,
		/obj/item/device/radio/headset/heads,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel)),
		new /datum/atom_creator/simple(/obj/item/storage/backpack/messenger, 50),
		/obj/item/storage/fakebook
	)

//equipment closets that everyone on the crew or in research can access, for storing things securely

/obj/structure/closet/secure_closet/crew
	name = "crew equipment locker"
	icon_state = "secure"

/obj/structure/closet/secure_closet/crew/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/crowbar,
		/obj/item/device/flashlight,
		/obj/item/storage/box
	)

/obj/structure/closet/secure_closet/crew/research
	name = "research equipment locker"
	icon_state = "science"

/obj/structure/closet/white_sierra

/obj/structure/closet/secure_closet/white_sierra


/obj/structure/closet/secure_closet/personal/patient


/obj/structure/closet/secure_closet/medical2


/obj/structure/closet/crate/present
	name = "present crate"
	desc = "Wow, a present!"
