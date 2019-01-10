
/datum/trade_item/plasma_pistol
	name = "Type-25 Directed Energy Pistol"
	item_type = /obj/item/weapon/gun/energy/plasmapistol
	quantity = 10
	value = 50
	trader_weight = 20
	category = "weapon_cov"

/datum/trade_item/needler
	name = "Type-33 Guided Munitions Launcher"
	item_type = /obj/item/weapon/gun/projectile/needler
	quantity = 10
	value = 50
	bonus_items = list(/obj/item/ammo_magazine/needles)
	trader_weight = 20
	category = "weapon_cov"

/datum/trade_item/needler_ammo
	name = "Needles"
	item_type = /obj/item/ammo_magazine/needles
	quantity = 10
	value = 50
	trader_weight = 20
	category = "weapon_cov"

/datum/trade_item/plasma_grenade
	name = "Type-1 Antipersonnel Grenade"
	item_type = /obj/item/weapon/grenade/plasma
	quantity = 10
	value = 100
	trader_weight = 15
	category = "weapon_cov"

/datum/trade_item/plasma_rifle
	name = "Type-25 Directed Energy Rifle"
	item_type = /obj/item/weapon/gun/energy/plasmarifle
	quantity = 6
	value = 3000
	trader_weight = 5
	category = "weapon_cov"

/datum/trade_item/carbine
	name = "Type-51 Carbine"
	item_type = /obj/item/weapon/gun/projectile/type51carbine
	quantity = 3
	value = 6000
	bonus_items = list(/obj/item/ammo_magazine/type51mag)
	trader_weight = 5
	category = "weapon_cov"

/datum/trade_item/carbine_ammo
	name = "Type-51 Carbine magazine"
	item_type = /obj/item/ammo_magazine/type51mag
	quantity = 3
	value = 100
	trader_weight = 5
	category = "weapon_cov"

/datum/trade_item/beam_rifle
	name = "Type-27 Special Application Sniper Rifle"
	item_type = /obj/item/weapon/gun/energy/beam_rifle
	quantity = 1
	value = 20000
	trader_weight = 1
	category = "weapon_cov"
