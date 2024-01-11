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
		/obj/item/clothing/accessory/scga_rank/e6,
		/obj/item/device/encryptionkey/away_scg_patrol
	)

/obj/structure/closet/crate/ninja/gcc
	name = "gcc equipment crate"
	desc = "A heavy equipment crate."

/obj/structure/closet/crate/ninja/gcc/WillContain()
	return list(
		/obj/item/rig/light/ninja/gcc,
		/obj/item/rig_module/mounted/power_fist,
		/obj/item/gun/projectile/pistol/optimus,
		/obj/item/ammo_magazine/pistol/double = 2,
		/obj/item/ammo_magazine/box/minigun = 2,
		/obj/item/clothing/under/iccgn/utility,
		/obj/item/clothing/shoes/iccgn/utility,
		/obj/item/clothing/accessory/iccgn_rank/or6,
		/obj/item/device/encryptionkey/iccgn
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
		/obj/item/clothing/accessory/badge/holo,
		/obj/item/storage/box/syndie_kit/jaunter
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
		/obj/item/device/encryptionkey/syndicate,
		/obj/item/card/emag
	)
