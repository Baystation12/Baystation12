
/decl/hierarchy/outfit/unggoy
	name = "Unggoy"

	l_ear = /obj/item/device/radio/headset/covenant
	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness
	belt = /obj/item/weapon/gun/energy/plasmapistol
	mask = /obj/item/clothing/mask/rebreather
	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma

/decl/hierarchy/outfit/unggoy/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.internal = H.back

/decl/hierarchy/outfit/unggoy/major
	name = "Unggoy (Major)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/major
	suit_store = /obj/item/weapon/gun/energy/plasmapistol
	belt = /obj/item/weapon/gun/energy/plasmapistol
	mask = /obj/item/clothing/mask/rebreather
	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma

/decl/hierarchy/outfit/unggoy/ultra
	name = "Unggoy (Ultra)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/ultra
	suit_store = /obj/item/weapon/gun/energy/plasmapistol
	belt = /obj/item/weapon/gun/energy/plasmapistol
	mask = /obj/item/clothing/mask/rebreather
	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma

/decl/hierarchy/outfit/unggoy/specops
	name = "Unggoy (Spec-Ops)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/specops
	suit_store = /obj/item/weapon/gun/projectile/type51carbine
	belt = /obj/item/weapon/gun/energy/plasmapistol
	mask = /obj/item/clothing/mask/rebreather/unggoy_spec_ops
	l_pocket = /obj/item/ammo_magazine/type51mag
	r_pocket = /obj/item/ammo_magazine/type51mag

/decl/hierarchy/outfit/unggoy/deacon
	name = "Unggoy (Deacon)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/deacon
	suit_store = /obj/item/weapon/gun/energy/plasmapistol
	belt = /obj/item/weapon/gun/energy/plasmapistol
	mask = /obj/item/clothing/mask/rebreather/unggoy_deacon
	l_pocket = /obj/item/weapon/grenade/plasma/heavy_plasma
	r_pocket = /obj/item/weapon/grenade/plasma
