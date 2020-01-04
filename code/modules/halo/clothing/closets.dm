/obj/structure/closet/secure_closet/bertels_mp
	name = "naval security locker"
	desc = "It's a storage unit for naval security gear."
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"
	req_access = list(308)

/obj/structure/closet/secure_closet/bertels_mp/New()
	. = ..()
	new /obj/item/clothing/under/unsc/tactical(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/clothing/suit/storage/marine/military_police(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/weapon/melee/baton/humbler(src)
	new /obj/item/weapon/gun/projectile/m7_smg/rubber(src)
	new /obj/item/ammo_magazine/m5/rubber(src)
	new /obj/item/ammo_magazine/m5/rubber(src)
	new /obj/item/ammo_magazine/m5/rubber(src)