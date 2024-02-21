/obj/structure/closet/secure_closet/guncabinet/sierra_armory
	name = "armory guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/smg
	name = "submachine gun guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/smg/WillContain()
	return list(/obj/item/gun/projectile/automatic/sec_smg = 2,
				/obj/item/ammo_magazine/smg_top/rubber = 4,
				/obj/item/ammo_magazine/smg_top = 4)

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/shotgun
	name = "shotgun guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/shotgun/WillContain()
	return list(/obj/item/gun/projectile/shotgun/pump/combat = 2,
				/obj/item/clothing/accessory/storage/bandolier = 2,
				/obj/item/storage/box/ammo/beanbags = 2,
				/obj/item/storage/box/ammo/practiceshells = 2,
				/obj/item/storage/box/ammo/manstoppershells = 2)

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/laser
	name = "laser guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/laser/WillContain()
	return list(/obj/item/gun/energy/laser/secure = 6)

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/stun
	name = "stun guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/stun/WillContain()
	return list(/obj/item/gun/energy/stunrevolver/rifle = 2,
				/obj/item/gun/energy/taser/carbine = 2,
				/obj/item/gun/energy/taser = 4)

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/ion
	name = "ion guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/ion/WillContain()
	return list(/obj/item/gun/energy/ionrifle = 2,
	/obj/item/gun/energy/ionrifle/small/sec = 1)

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/egun
	name = "energy guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/egun/WillContain()
	return list(/obj/item/gun/energy/gun/secure = 3)

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/launcher
	name = "grenade launcher guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/launcher/WillContain()
	return list(/obj/item/gun/launcher/grenade = 1,
				/obj/item/storage/box/smokes = 1,
				/obj/item/storage/box/flashbangs = 2,
				/obj/item/storage/box/emps = 1,
				/obj/item/storage/box/teargas = 1)

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/militia
	name = "militia guncabinet"

/obj/structure/closet/secure_closet/guncabinet/sierra_armory/militia/WillContain()
	return list(/obj/item/gun/energy/gun/small/secure = 4,
				/obj/item/clothing/accessory/armband = 4)

/obj/structure/closet/secure_closet/guncabinet/sierra_emergency
	name = "emergency smartgun guncabinet"
	req_access = list(access_security) //even adjutant/guard can open

/obj/structure/closet/secure_closet/guncabinet/sierra_emergency/WillContain()
	return list(/obj/item/gun/energy/gun/small/secure = 3)
