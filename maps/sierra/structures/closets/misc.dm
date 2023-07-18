/*
 * Sierra Misc
 */

/obj/structure/closet/secure_closet/iaa
	name = "\improper Internal Affairs Agent's locker"
	req_access = list(access_iaa)
	closet_appearance = /singleton/closet_appearance/secure_closet/sierra/corporate/iaa

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
	closet_appearance = /singleton/closet_appearance/secure_closet/sierra/crew

/obj/structure/closet/secure_closet/crew/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/crowbar,
		/obj/item/device/flashlight,
		/obj/item/storage/box
	)

/obj/structure/closet/secure_closet/crew/research
	name = "research equipment locker"
	closet_appearance = /singleton/closet_appearance/wardrobe/sierra/research

/obj/structure/closet/white_sierra
	closet_appearance = /singleton/closet_appearance/wardrobe/white

/obj/structure/closet/secure_closet/white_sierra
	closet_appearance = /singleton/closet_appearance/secure_closet/sierra/evidence

/obj/structure/closet/secure_closet/medical2
	closet_appearance = /singleton/closet_appearance/secure_closet/medical

/obj/structure/closet/crate/present
	name = "present crate"
	desc = "Wow, a present!"
