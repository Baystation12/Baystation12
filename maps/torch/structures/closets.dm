/*
 * Torch Excavation
 */

/obj/structure/closet/toolcloset/excavation
	name = "excavation equipment closet"
	desc = "It's a storage unit for excavation equipment."
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/toolcloset/excavation/WillContain()
	return list(
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation,
		/obj/item/device/flashlight/lantern,
		/obj/item/device/ano_scanner,
		/obj/item/device/depth_scanner,
		/obj/item/device/core_sampler,
		/obj/item/device/gps,
		/obj/item/pinpointer/radio,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/science,
		/obj/item/pickaxe,
		/obj/item/device/measuring_tape,
		/obj/item/pickaxe/xeno/hand,
		/obj/item/storage/bag/fossils,
		/obj/item/hand_labeler,
		/obj/item/taperoll/research,
		/obj/item/device/spaceflare
	)

/obj/structure/closet/wardrobe/ptgear
	name = "pt gear wardrobe"
	closet_appearance = /singleton/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/ptgear/WillContain()
	return list(
		/obj/item/clothing/under/solgov/pt/expeditionary = 4,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/shoes/black = 2)

/obj/random/torchcloset //Random closets taking into account torch-specific ones
	name = "random closet"
	desc = "This is a random closet."

/obj/random/torchcloset/spawn_choices()
	return list(/obj/structure/closet,
				/obj/structure/closet/firecloset,
				/obj/structure/closet/emcloset,
				/obj/structure/closet/jcloset_torch,
				/obj/structure/closet/athletic_mixed,
				/obj/structure/closet/toolcloset,
				/obj/structure/closet/toolcloset/excavation,
				/obj/structure/closet/l3closet/general,
				/obj/structure/closet/cabinet,
				/obj/structure/closet/crate,
				/obj/structure/closet/crate/freezer,
				/obj/structure/closet/crate/freezer/rations,
				/obj/structure/closet/crate/internals,
				/obj/structure/closet/crate/trashcart,
				/obj/structure/closet/crate/medical,
				/obj/structure/closet/boxinggloves,
				/obj/structure/closet/secure_closet/crew,
				/obj/structure/closet/secure_closet/crew/research,
				/obj/structure/closet/secure_closet/guncabinet,
				/obj/structure/largecrate,
				/obj/structure/closet/wardrobe/xenos,
				/obj/structure/closet/wardrobe/mixed,
				/obj/structure/closet/wardrobe/suit)

/obj/structure/closet/secure_closet/brig/WillContain()
	return null

///Ninja equipment loadouts. Placed here because it relies on Torch evil.
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
		/obj/item/clothing/mask/gas/syndicate
	)
