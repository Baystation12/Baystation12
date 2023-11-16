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

///Ninja equipment loadouts. Placed here because author overrided them using Torch files. Now we overriding this again for some QoL stuff.
/obj/structure/closet/crate/ninja/sol
	name = "sol equipment crate"
	desc = "A tactical equipment crate."

/obj/structure/closet/crate/ninja/sol/WillContain()
	return list(
		/obj/item/rig/light/ninja/sol,
		/obj/item/gun/projectile/pistol/m22f,
		/obj/item/ammo_magazine/pistol/double = 2,
		/obj/item/clothing/under/scga/utility/urban,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/accessory/scga_rank/e6
	)

/obj/structure/closet/crate/ninja/gcc
	name = "gcc equipment crate"
	desc = "A heavy equipment crate."

/obj/structure/closet/crate/ninja/gcc/WillContain()
	return list(
		/obj/item/rig/light/ninja/gcc,
		/obj/item/gun/projectile/pistol/optimus,
		/obj/item/ammo_magazine/pistol/double = 2,
		/obj/item/ammo_magazine/box/minigun = 2,
		/obj/item/clothing/under/iccgn/utility,
		/obj/item/clothing/shoes/iccgn/utility,
		/obj/item/clothing/accessory/iccgn_rank/or6
	)

/obj/structure/closet/crate/ninja/corpo
	name = "corporate equipment crate"
	desc = "A patented equipment crate."

/obj/structure/closet/crate/ninja/corpo/WillContain()
	return list(
		/obj/item/rig/light/ninja/corpo,
		/obj/item/gun/energy/gun,
		/obj/item/inducer,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/accessory/badge/holo
	)

/obj/structure/closet/crate/ninja/merc
	name = "mercenary equipment crate"
	desc = "A traitorous equipment crate."

/obj/structure/closet/crate/ninja/merc/WillContain()
	return list(
		/obj/item/rig/merc/ninja,
		/obj/item/gun/projectile/revolver/medium,
		/obj/item/ammo_magazine/speedloader = 2,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/storage/backpack/dufflebag/syndie_kit/plastique,
		/obj/item/storage/box/anti_photons,
		/obj/item/card/emag
	)
