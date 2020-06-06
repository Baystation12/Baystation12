

/obj/structure/closet/secure_closet/ks7_cov
	name = "Covenant Supply Crate"
	desc = "Contains supplies for armoring and arming yourself. Looks like this one is missing a lot of items."
	icon = 'code/modules/halo/covenant/structures_machines/crate_tall.dmi'
	icon_state = "closed"
	icon_opened = "open"
	icon_closed = "closed"
	icon_broken = "closed"
	icon_off = "closed"
	icon_locked ="closed"

/obj/structure/closet/secure_closet/ks7_cov/WillContain()
	return list(\
	/obj/item/clothing/under/kigyar,
	/obj/item/clothing/under/kigyar/armless,
	/obj/item/clothing/head/helmet/kigyar/first_contact,
	/obj/item/clothing/suit/armor/kigyar/first_contact,
	/obj/item/clothing/gloves/shield_gauntlet/kigyar/first_contact,
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol/fastfire,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/device/radio/headset/covenant,
	/obj/item/weapon/storage/wallet/random,
	/obj/item/language_learner/kigyar_to_common,
	/obj/item/weapon/melee/baton/humbler/covenant
	)

/obj/structure/closet/secure_closet/ks7_cov/unggoy/WillContain()
	return list(\
	/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmapistol/fastfire,
	/obj/item/weapon/storage/backpack/sangheili,
	/obj/item/weapon/storage/belt/covenant_ammo,
	/obj/item/language_learner/kigyar_to_common,
	/obj/item/weapon/melee/baton/humbler
	)
