
/obj/item/weapon/storage/pocketstore
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_POCKET | SLOT_BELT
	allow_pocket_use = 1

/obj/item/weapon/storage/pocketstore/magnetic_holster
	name = "Magnetic Holster Set (Guns)"
	desc = "Lightweight magnetic holsters intended to hold a weapon to positions they are attached to. Holds smaller and normal sized guns such as the m6d and the m7 smg"
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	storage_slots = 1
	can_hold = list(/obj/item/weapon/gun)

/obj/item/weapon/storage/pocketstore/magnetic_holster/melee
	name = "Magnetic Holster Set (Melee)"
	desc = "Lightweight magnetic holsters intended to hold a weapon to positions they are attached to. Holds large melee weapons in place."
	max_w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/weapon/melee)


//HARDCASES//

/obj/item/weapon/storage/pocketstore/hardcase
	name = "Tactical Hardcase"
	desc = "A reinforced storage box, clipped near your pockets. Multiple variants exist for varying different storage options."
	icon = 'code/modules/halo/icons/objs/pocketstorage.dmi'
	icon_state = "hardcase_generic"
	max_w_class = ITEM_SIZE_NORMAL //We're using restrictive lists to allow only certain items
	storage_slots = 3

/obj/item/weapon/storage/pocketstore/hardcase/magazine
	name = "Tactical Hardcase (Magazines)"
	icon_state = "hardcase_mags"
	storage_slots = 4
	can_hold = list(/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/ammo_box)

/obj/item/weapon/storage/pocketstore/hardcase/magazine/cov
	icon_state = "hardcase_cov_mags"

/obj/item/weapon/storage/pocketstore/hardcase/bullets
	name = "Tactical Hardcase (Individual Rounds)"
	icon_state = "hardcase_bullets"
	storage_slots = 6
	can_hold = list(/obj/item/ammo_casing)

/obj/item/weapon/storage/pocketstore/hardcase/bullets/cov
	icon_state = "hardcase_cov_bullets"

/obj/item/weapon/storage/pocketstore/hardcase/grenade
	name = "Tactical Hardcase (Explosives)"
	icon_state = "hardcase_grenades"
	storage_slots = 5
	can_hold = list(/obj/item/weapon/grenade,/obj/item/weapon/plastique)
	cant_hold = list()

/obj/item/weapon/storage/pocketstore/hardcase/grenade/cov
	icon_state = "hardcase_cov_grenades"

/obj/item/weapon/storage/pocketstore/hardcase/medbottles
	name = "Tactical Hardcase (Medical Bottles)"
	desc = "A reinforced storage box, clipped near your pockets. Holds pill and chemical bottles."
	icon_state = "hardcase_medical"
	can_hold = list(\
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/reagent_containers/glass/beaker/vial,
		/obj/item/weapon/storage/pill_bottle
	)
/obj/item/weapon/storage/pocketstore/hardcase/medbottles/cov
	icon_state = "hardcase_cov_medical"

/obj/item/weapon/storage/pocketstore/hardcase/hypos
	name = "Tactical Hardcase (Syringes)"
	icon_state = "hardcase_medical"
	storage_slots = 4
	can_hold = list(
	/obj/item/weapon/reagent_containers/hypospray,
	/obj/item/weapon/reagent_containers/syringe
	)

/obj/item/weapon/storage/pocketstore/hardcase/hypos/cov
	icon_state = "hardcase_cov_medical"

/obj/item/weapon/storage/pocketstore/hardcase/materials
	name = "Tactical Hardcase (Construction Materials)"
	desc = "A reinforced storage box, clipped near your pockets. Holds a variety of construction materials."
	storage_slots = 2
	max_w_class = ITEM_SIZE_LARGE
	can_hold = list(/obj/item/stack/material)

/obj/item/weapon/storage/pocketstore/hardcase/materials/cov
	icon_state = "hardcase_cov_generic"

/obj/item/weapon/storage/pocketstore/hardcase/tools
	name = "Tactical Hardcase (Tools)"
	can_hold = list(
		/obj/item/weapon/crowbar,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/wrench,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/device/robotanalyzer
	)

/obj/item/weapon/storage/pocketstore/hardcase/tools/cov
	icon_state = "hardcase_cov_generic"

/obj/item/weapon/storage/pocketstore/hardcase/rockets
	name = "102mm HEAT SPNKr Hardcase"
	desc = "A belt-clippable hardcase capable of holding up to 2 M41 rocket tubes."
	icon = 'code/modules/halo/icons/objs/halohumanmisc.dmi'
	icon_state = "ssrcrate"
	storage_slots = 2
	can_hold = list(/obj/item/ammo_magazine/spnkr)
	max_w_class = ITEM_SIZE_LARGE

/obj/item/weapon/storage/pocketstore/hardcase/armorkits
	name = "Tactical Hardcase (Armour Kits)"
	desc = "A reinforced storage box, clipped near your pockets. Created to hold armour repair kits in a convenient location."
	icon_state = "hardcase_generic"
	storage_slots = 3
	can_hold = list(/obj/item/weapon/armor_patch)

/obj/item/weapon/storage/pocketstore/hardcase/armorkits/cov
	icon_state = "hardcase_cov_generic"